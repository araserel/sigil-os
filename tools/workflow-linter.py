#!/usr/bin/env python3
"""
Prism OS Workflow Linter

Validates internal consistency of the Prism OS system by checking:
1. Agent → Skill references (do referenced skills exist?)
2. Skill → Template references (do referenced templates exist?)
3. Chain → Skill references (do chained skills exist?)
4. CLAUDE.md → Component mappings (do routes point to real files?)
5. Cross-references between documentation files

Usage:
    python tools/workflow-linter.py [--verbose] [--fix-suggestions]

Exit codes:
    0 - All checks passed
    1 - Errors found
    2 - Script error

Change Management:
    When adding new agents, skills, chains, or templates, the linter
    automatically discovers them. However, if you change the reference
    patterns (e.g., how skills reference templates), update the regex
    patterns in this file. See /docs/contributing.md for details.
"""

import os
import re
import sys
import argparse
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Set, Dict, Optional
from enum import Enum

# =============================================================================
# Configuration
# =============================================================================

class Severity(Enum):
    ERROR = "ERROR"      # Broken reference, will cause runtime failure
    WARNING = "WARNING"  # Potential issue, may cause problems
    INFO = "INFO"        # Suggestion or minor inconsistency

@dataclass
class Issue:
    severity: Severity
    file: str
    line: Optional[int]
    message: str
    suggestion: Optional[str] = None

@dataclass
class LintResult:
    issues: List[Issue] = field(default_factory=list)
    files_checked: int = 0
    
    def add(self, severity: Severity, file: str, line: Optional[int], 
            message: str, suggestion: Optional[str] = None):
        self.issues.append(Issue(severity, file, line, message, suggestion))
    
    def error(self, file: str, line: Optional[int], message: str, suggestion: Optional[str] = None):
        self.add(Severity.ERROR, file, line, message, suggestion)
    
    def warning(self, file: str, line: Optional[int], message: str, suggestion: Optional[str] = None):
        self.add(Severity.WARNING, file, line, message, suggestion)
    
    def info(self, file: str, line: Optional[int], message: str, suggestion: Optional[str] = None):
        self.add(Severity.INFO, file, line, message, suggestion)
    
    @property
    def has_errors(self) -> bool:
        return any(i.severity == Severity.ERROR for i in self.issues)
    
    @property
    def error_count(self) -> int:
        return sum(1 for i in self.issues if i.severity == Severity.ERROR)
    
    @property
    def warning_count(self) -> int:
        return sum(1 for i in self.issues if i.severity == Severity.WARNING)

# =============================================================================
# File Discovery
# =============================================================================

def find_project_root() -> Path:
    """Find Prism OS project root by looking for CLAUDE.md"""
    current = Path.cwd()
    while current != current.parent:
        if (current / "CLAUDE.md").exists():
            return current
        current = current.parent
    # Fallback: assume we're in the project root
    return Path.cwd()

def discover_files(root: Path) -> Dict[str, List[Path]]:
    """Discover all Prism OS system files"""
    files = {
        "agents": [],
        "skills": [],
        "chains": [],
        "templates": [],
        "docs": [],
        "prompts": [],
    }
    
    # Agents
    agents_dir = root / ".claude" / "agents"
    if agents_dir.exists():
        files["agents"] = list(agents_dir.glob("*.md"))
    
    # Skills (recursive)
    skills_dir = root / ".claude" / "skills"
    if skills_dir.exists():
        files["skills"] = list(skills_dir.rglob("*.md"))
    
    # Chains
    chains_dir = root / ".claude" / "chains"
    if chains_dir.exists():
        files["chains"] = list(chains_dir.glob("*.md"))
    
    # Templates (recursive)
    templates_dir = root / "templates"
    if templates_dir.exists():
        files["templates"] = list(templates_dir.rglob("*.md"))
    
    # Docs
    docs_dir = root / "docs"
    if docs_dir.exists():
        files["docs"] = list(docs_dir.rglob("*.md"))
    
    # Prompts
    prompts_dir = root / "prompts"
    if prompts_dir.exists():
        files["prompts"] = list(prompts_dir.glob("*.md"))
    
    return files

# =============================================================================
# Reference Extraction
# =============================================================================

# Patterns for extracting references from markdown files
PATTERNS = {
    # Skill references in agent files: `.claude/skills/workflow/spec-writer.md`
    "skill_path": re.compile(r'[`"\']?\.claude/skills/([a-zA-Z0-9_\-/]+\.md)[`"\']?'),
    
    # Template references: `/templates/spec-template.md`
    "template_path": re.compile(r'[`"\']?/?templates/([a-zA-Z0-9_\-/]+\.md)[`"\']?'),
    
    # Agent references: `.claude/agents/orchestrator.md`
    "agent_path": re.compile(r'[`"\']?\.claude/agents/([a-zA-Z0-9_\-]+\.md)[`"\']?'),
    
    # Chain references: `.claude/chains/full-pipeline.md`
    "chain_path": re.compile(r'[`"\']?\.claude/chains/([a-zA-Z0-9_\-]+\.md)[`"\']?'),
    
    # Skill names (without path): `spec-writer`, `clarifier`
    # Only match explicit patterns to avoid false positives:
    # - Backtick-wrapped: `skill-name`
    # - Explicit invocation: invoke: skill-name, calls: skill-name
    "skill_name": re.compile(r'(?:invoke|calls?)\s*[:\-]\s*[`"\']?([a-zA-Z][a-zA-Z0-9_\-]{2,})[`"\']?', re.IGNORECASE),

    # Backtick-wrapped skill references (more reliable)
    "skill_name_backtick": re.compile(r'`([a-zA-Z][a-zA-Z0-9_\-]{2,}(?:-(?:writer|reader|validator|fixer|planner|assessor|packager|reporter|reviewer|checker|decomposer|preparer|analyzer|search))?)`'),
    
    # Doc references: `/docs/error-handling.md`
    "doc_path": re.compile(r'[`"\']?/?docs/([a-zA-Z0-9_\-/]+\.md)[`"\']?'),
}

def extract_references(content: str, pattern_name: str) -> List[tuple]:
    """Extract references matching a pattern, with line numbers"""
    pattern = PATTERNS.get(pattern_name)
    if not pattern:
        return []
    
    results = []
    for i, line in enumerate(content.split('\n'), 1):
        for match in pattern.finditer(line):
            results.append((match.group(1), i))
    return results

def read_file_content(path: Path) -> str:
    """Read file content, handling encoding issues"""
    try:
        return path.read_text(encoding='utf-8')
    except UnicodeDecodeError:
        return path.read_text(encoding='latin-1')

# =============================================================================
# Validation Checks
# =============================================================================

def check_agent_skill_references(root: Path, files: Dict[str, List[Path]], result: LintResult):
    """Check that agents reference skills that exist"""
    skill_paths = {str(p.relative_to(root)): p for p in files["skills"]}
    skill_names = {p.stem: p for p in files["skills"]}
    
    for agent_file in files["agents"]:
        content = read_file_content(agent_file)
        rel_path = str(agent_file.relative_to(root))
        
        # Check full path references
        for ref, line in extract_references(content, "skill_path"):
            full_ref = f".claude/skills/{ref}"
            if full_ref not in skill_paths:
                result.error(
                    rel_path, line,
                    f"References non-existent skill: {full_ref}",
                    f"Create the skill file or fix the reference"
                )
        
        # Check skill name references (explicit invocation patterns)
        for ref, line in extract_references(content, "skill_name"):
            # Skip single-char and very short matches (likely false positives)
            if len(ref) < 3:
                continue
            # Skip common false positives
            if ref.lower() in ['the', 'a', 'an', 'this', 'that', 'skill', 'agent', 'with', 'from', 'into']:
                continue
            if ref not in skill_names and f"{ref}.md" not in [p.name for p in files["skills"]]:
                # Only warn, since skill names can be informal references
                result.warning(
                    rel_path, line,
                    f"References skill name '{ref}' - verify this skill exists",
                    f"Check .claude/skills/ for matching file"
                )

        # Check backtick-wrapped skill references (more reliable pattern)
        for ref, line in extract_references(content, "skill_name_backtick"):
            # Only check names that look like skill names (have common suffixes)
            skill_suffixes = ['writer', 'reader', 'validator', 'fixer', 'planner',
                             'assessor', 'packager', 'reporter', 'reviewer', 'checker',
                             'decomposer', 'preparer', 'analyzer', 'search', 'clarifier']
            if any(ref.endswith(f'-{suffix}') or ref == suffix for suffix in skill_suffixes):
                if ref not in skill_names and f"{ref}.md" not in [p.name for p in files["skills"]]:
                    result.warning(
                        rel_path, line,
                        f"References skill name '{ref}' - verify this skill exists",
                        f"Check .claude/skills/ for matching file"
                    )

def check_skill_template_references(root: Path, files: Dict[str, List[Path]], result: LintResult):
    """Check that skills reference templates that exist"""
    template_paths = {str(p.relative_to(root)): p for p in files["templates"]}
    
    for skill_file in files["skills"]:
        content = read_file_content(skill_file)
        rel_path = str(skill_file.relative_to(root))
        
        for ref, line in extract_references(content, "template_path"):
            full_ref = f"templates/{ref}"
            if full_ref not in template_paths:
                result.error(
                    rel_path, line,
                    f"References non-existent template: {full_ref}",
                    f"Create the template file or fix the reference"
                )

def check_chain_skill_references(root: Path, files: Dict[str, List[Path]], result: LintResult):
    """Check that chains reference skills that exist"""
    skill_names = {p.stem: p for p in files["skills"]}
    
    for chain_file in files["chains"]:
        content = read_file_content(chain_file)
        rel_path = str(chain_file.relative_to(root))
        
        # Check full path references
        for ref, line in extract_references(content, "skill_path"):
            full_ref = f".claude/skills/{ref}"
            if not (root / full_ref.lstrip('.')).exists():
                result.error(
                    rel_path, line,
                    f"Chain references non-existent skill: {full_ref}",
                    f"Create the skill file or remove from chain"
                )

def check_claude_md_references(root: Path, files: Dict[str, List[Path]], result: LintResult):
    """Check CLAUDE.md references all components correctly"""
    claude_md = root / "CLAUDE.md"
    if not claude_md.exists():
        result.error(".", None, "CLAUDE.md not found in project root", "Create CLAUDE.md")
        return
    
    content = read_file_content(claude_md)
    rel_path = "CLAUDE.md"
    
    # Check agent references
    for ref, line in extract_references(content, "agent_path"):
        full_ref = f".claude/agents/{ref}"
        if not (root / full_ref.lstrip('.')).exists():
            result.error(
                rel_path, line,
                f"References non-existent agent: {full_ref}",
                f"Create the agent file or fix the reference"
            )
    
    # Check skill references
    for ref, line in extract_references(content, "skill_path"):
        full_ref = f".claude/skills/{ref}"
        if not (root / full_ref.lstrip('.')).exists():
            result.error(
                rel_path, line,
                f"References non-existent skill: {full_ref}",
                f"Create the skill file or fix the reference"
            )
    
    # Check template references
    for ref, line in extract_references(content, "template_path"):
        full_ref = f"templates/{ref}"
        if not (root / full_ref).exists():
            result.error(
                rel_path, line,
                f"References non-existent template: {full_ref}",
                f"Create the template file or fix the reference"
            )

def check_doc_cross_references(root: Path, files: Dict[str, List[Path]], result: LintResult):
    """Check that documentation files reference each other correctly"""
    doc_paths = {str(p.relative_to(root)): p for p in files["docs"]}
    
    for doc_file in files["docs"]:
        content = read_file_content(doc_file)
        rel_path = str(doc_file.relative_to(root))
        
        for ref, line in extract_references(content, "doc_path"):
            full_ref = f"docs/{ref}"
            if full_ref not in doc_paths:
                result.warning(
                    rel_path, line,
                    f"References non-existent doc: {full_ref}",
                    f"Create the doc file or fix the reference"
                )

def check_required_files(root: Path, result: LintResult):
    """Check that required system files exist"""
    required = [
        ("CLAUDE.md", "Main system configuration"),
        ("memory/constitution.md", "Project constitution"),
        ("memory/project-context.md", "Session state template"),
        (".claude/agents/orchestrator.md", "Central routing agent"),
    ]
    
    for path, description in required:
        if not (root / path).exists():
            result.error(
                ".", None,
                f"Required file missing: {path} ({description})",
                f"Create {path}"
            )

def check_skill_metadata(root: Path, files: Dict[str, List[Path]], result: LintResult):
    """Check that skills have required metadata sections"""
    # Section aliases: primary name -> list of acceptable alternatives
    section_aliases = {
        "Purpose": ["Purpose", "Intended Purpose"],
        "Workflow": ["Workflow", "Process", "Intended Behavior"],
        "Input": ["Input", "Planned Input", "Expected Input"],
        "Output": ["Output", "Planned Output", "Expected Output"],
    }

    for skill_file in files["skills"]:
        content = read_file_content(skill_file)
        rel_path = str(skill_file.relative_to(root))

        # Skip README files
        if skill_file.name.lower() == "readme.md":
            continue

        for section, aliases in section_aliases.items():
            # Build pattern to match any of the aliases
            alias_pattern = '|'.join(re.escape(a) for a in aliases)
            # Look for ## Section or **Section** patterns (any alias)
            if not re.search(rf'(?:^##\s*(?:{alias_pattern})|^\*\*(?:{alias_pattern})\*\*)', content, re.MULTILINE | re.IGNORECASE):
                result.warning(
                    rel_path, None,
                    f"Missing recommended section: {section}",
                    f"Add '## {section}' section to skill definition"
                )

def check_agent_metadata(root: Path, files: Dict[str, List[Path]], result: LintResult):
    """Check that agents have required metadata sections"""
    # Section aliases: primary name -> list of acceptable alternatives
    section_aliases = {
        "Role": ["Role", "Identity", "Agent Role", "Purpose", "Core Responsibilities"],
        "Triggers": ["Triggers", "Activation", "When to Invoke", "Activation Triggers", "When Invoked", "Trigger Words"],
        "Skills": ["Skills", "Available Skills", "Tools", "Capabilities", "Skills Invoked"],
    }

    for agent_file in files["agents"]:
        content = read_file_content(agent_file)
        rel_path = str(agent_file.relative_to(root))

        # Skip README files
        if agent_file.name.lower() == "readme.md":
            continue

        for section, aliases in section_aliases.items():
            # Build pattern to match any of the aliases
            alias_pattern = '|'.join(re.escape(a) for a in aliases)
            # Look for ## Section or **Section** patterns (any alias)
            if not re.search(rf'(?:^##\s*(?:{alias_pattern})|^\*\*(?:{alias_pattern})\*\*)', content, re.MULTILINE | re.IGNORECASE):
                result.warning(
                    rel_path, None,
                    f"Missing recommended section: {section}",
                    f"Add '## {section}' section to agent definition"
                )

# =============================================================================
# Reporting
# =============================================================================

def print_results(result: LintResult, verbose: bool = False, show_suggestions: bool = False):
    """Print lint results to console"""
    
    # Group by severity
    errors = [i for i in result.issues if i.severity == Severity.ERROR]
    warnings = [i for i in result.issues if i.severity == Severity.WARNING]
    infos = [i for i in result.issues if i.severity == Severity.INFO]
    
    if not result.issues:
        print("✓ All checks passed!")
        print(f"  Files checked: {result.files_checked}")
        return
    
    # Print errors first
    if errors:
        print(f"\n{'='*60}")
        print(f"ERRORS ({len(errors)})")
        print('='*60)
        for issue in errors:
            loc = f"{issue.file}:{issue.line}" if issue.line else issue.file
            print(f"\n  ✗ {loc}")
            print(f"    {issue.message}")
            if show_suggestions and issue.suggestion:
                print(f"    → {issue.suggestion}")
    
    # Print warnings
    if warnings and verbose:
        print(f"\n{'='*60}")
        print(f"WARNINGS ({len(warnings)})")
        print('='*60)
        for issue in warnings:
            loc = f"{issue.file}:{issue.line}" if issue.line else issue.file
            print(f"\n  ⚠ {loc}")
            print(f"    {issue.message}")
            if show_suggestions and issue.suggestion:
                print(f"    → {issue.suggestion}")
    
    # Print info
    if infos and verbose:
        print(f"\n{'='*60}")
        print(f"INFO ({len(infos)})")
        print('='*60)
        for issue in infos:
            loc = f"{issue.file}:{issue.line}" if issue.line else issue.file
            print(f"\n  ℹ {loc}")
            print(f"    {issue.message}")
    
    # Summary
    print(f"\n{'='*60}")
    print("SUMMARY")
    print('='*60)
    print(f"  Files checked: {result.files_checked}")
    print(f"  Errors:   {result.error_count}")
    print(f"  Warnings: {result.warning_count}")
    if not verbose and warnings:
        print(f"\n  Run with --verbose to see warnings")

# =============================================================================
# Main
# =============================================================================

def main():
    parser = argparse.ArgumentParser(
        description="Validate Prism OS workflow system internal consistency"
    )
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Show warnings and info messages (not just errors)"
    )
    parser.add_argument(
        "--fix-suggestions", "-f",
        action="store_true", 
        help="Show suggestions for how to fix issues"
    )
    parser.add_argument(
        "--project-root", "-p",
        type=Path,
        help="Path to Prism OS project root (default: auto-detect)"
    )
    args = parser.parse_args()
    
    # Find project root
    root = args.project_root or find_project_root()
    if not (root / "CLAUDE.md").exists():
        print(f"Error: Could not find Prism OS project at {root}")
        print("Make sure you're in a Prism OS project directory or use --project-root")
        sys.exit(2)
    
    print(f"Linting Prism OS project at: {root}")
    print("-" * 60)
    
    # Discover files
    files = discover_files(root)
    result = LintResult()
    result.files_checked = sum(len(f) for f in files.values()) + 1  # +1 for CLAUDE.md
    
    # Run checks
    check_required_files(root, result)
    check_claude_md_references(root, files, result)
    check_agent_skill_references(root, files, result)
    check_skill_template_references(root, files, result)
    check_chain_skill_references(root, files, result)
    check_doc_cross_references(root, files, result)
    check_skill_metadata(root, files, result)
    check_agent_metadata(root, files, result)
    
    # Print results
    print_results(result, args.verbose, args.fix_suggestions)
    
    # Exit code
    sys.exit(1 if result.has_errors else 0)

if __name__ == "__main__":
    main()
