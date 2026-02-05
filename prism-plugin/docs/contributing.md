# Contributing to Prism OS

Guidelines for maintaining and extending the Prism OS system.

---

## Table of Contents

1. [Change Management Overview](#change-management-overview)
2. [Adding New Components](#adding-new-components)
3. [Modifying Existing Components](#modifying-existing-components)
4. [Workflow Linter Maintenance](#workflow-linter-maintenance)
5. [Documentation Standards](#documentation-standards)
6. [Testing Changes](#testing-changes)

---

## Change Management Overview

Prism OS is a system of interconnected markdown files. Changes to one component can affect others. Follow this checklist for any modification:

### Pre-Change Checklist

- [ ] Identify all files that reference the component you're changing
- [ ] Run the workflow linter: `python tools/workflow-linter.py --verbose`
- [ ] Review the change against relevant sections of this guide

### Post-Change Checklist

- [ ] Run the workflow linter again to catch broken references
- [ ] Update documentation if behavior changed
- [ ] Update `future-considerations.md` if you deferred anything
- [ ] Test the affected workflow paths (trace manually if no live project)

---

## Adding New Components

### Adding a New Skill

1. **Create the skill file** in the appropriate subdirectory:
   ```
   .claude/skills/
   ├── workflow/     # Spec, plan, task skills
   ├── engineering/  # Code-related skills
   ├── qa/           # Quality assurance skills
   ├── review/       # Review and validation skills
   └── research/     # Research and discovery skills
   ```

2. **Follow the skill template** at `/templates/skill-template.md`

3. **Required sections:**
   - Purpose (what the skill does)
   - Workflow (step-by-step process)
   - Input (what it receives, with schema)
   - Output (what it produces, with schema)
   - Human Oversight Tier (Auto/Review/Approve)
   - Version History

4. **Register the skill:**
   - Add to the owning agent's "Skills" section
   - Add to `docs/extending-skills.md` skill categories table if it's a core workflow skill
   - Add to relevant chain files if it participates in chains

5. **Run linter:** `python tools/workflow-linter.py`

### Adding a New Agent

1. **Create the agent file** at `.claude/agents/{agent-name}.md`

2. **Required sections:**
   - Role (what the agent is responsible for)
   - Triggers (keywords that route requests to this agent)
   - Skills (list of skills this agent can invoke)
   - Handoff Protocol (what it produces for the next agent)
   - Human Oversight Tier

3. **Register the agent:**
   - Add to orchestrator agent file (`.claude/agents/orchestrator.md`)
   - Add trigger words to routing table
   - Define handoff relationships with adjacent agents

4. **Update Orchestrator** if this agent participates in the main workflow

5. **Run linter:** `python tools/workflow-linter.py`

### Adding a New Template

1. **Create the template** at `/templates/{template-name}.md`

2. **Include guidance comments** explaining each section

3. **Reference from skills** that produce this artifact type

4. **Add example** to `/docs/examples/` if it's user-facing

5. **Run linter:** `python tools/workflow-linter.py`

### Adding a New Chain

1. **Create the chain file** at `.claude/chains/{chain-name}.md`

2. **Define:**
   - Purpose (what workflow this chain supports)
   - Skills (ordered list of skills in the chain)
   - Handoff data (what passes between skills)
   - Exit conditions (when the chain completes or fails)

3. **Register in `docs/extending-skills.md`** skill chain overview section

4. **Run linter:** `python tools/workflow-linter.py`

---

## Modifying Existing Components

### Renaming a Component

Renaming is high-risk because references exist in multiple files.

1. **Before renaming**, find all references:
   ```bash
   grep -r "old-name" --include="*.md" .
   ```

2. **Update all references** in:
   - Agent files that reference the component
   - Skill files that reference the component
   - Chain files
   - Documentation
   - Templates

3. **Rename the file**

4. **Run linter** to catch any missed references

### Changing Handoff Schemas

Handoff schemas define what data passes between components. Changes can break downstream consumers.

1. **Identify consumers:**
   - Which skills/agents receive this handoff?
   - Check chain definitions for dependencies

2. **Options for breaking changes:**
   - **Additive:** Add new fields (safe, old consumers ignore them)
   - **Deprecation:** Mark old fields deprecated, add new ones, remove old after transition
   - **Breaking:** Update all consumers simultaneously (risky)

3. **Document the change** in the component's Version History

4. **Update handoff-template.md** if the base schema changed

### Changing Human Oversight Tiers

Tier changes affect when humans are prompted for input.

1. **Understand the tiers:**
   - **Auto:** Proceeds without human input
   - **Review:** Human sees output, can modify before proceeding
   - **Approve:** Human must explicitly approve to proceed

2. **Consider security implications:**
   - Production deployments should remain Approve
   - Security findings should remain Approve
   - Scope changes should remain Review minimum

3. **Update both** the skill/agent file AND `docs/user-guide.md` approval tiers table

---

## Workflow Linter Maintenance

The workflow linter (`/tools/workflow-linter.py`) validates system consistency. It needs updates when:

### When to Update the Linter

| Change | Linter Update Needed? |
|--------|----------------------|
| Add new skill/agent/template | No (auto-discovered) |
| Add new directory for skills | Yes (update `discover_files()`) |
| Change reference pattern in markdown | Yes (update `PATTERNS`) |
| Add new metadata requirement | Yes (add to `check_*_metadata()`) |
| Add new required file | Yes (update `check_required_files()`) |
| Add new cross-reference type | Yes (add new `check_*()` function) |

### Updating Reference Patterns

The linter uses regex patterns to extract references. If you change how references are written in markdown, update the `PATTERNS` dict:

```python
PATTERNS = {
    # Example: skill references like `.claude/skills/workflow/spec-writer.md`
    "skill_path": re.compile(r'[`"\']?\.claude/skills/([a-zA-Z0-9_\-/]+\.md)[`"\']?'),
    
    # Add new patterns here following the same format
}
```

### Adding New Checks

To add a new validation check:

1. Create a function following the pattern:
   ```python
   def check_something(root: Path, files: Dict[str, List[Path]], result: LintResult):
       """Description of what this checks"""
       for file in files["relevant_type"]:
           content = read_file_content(file)
           # ... validation logic ...
           if problem_found:
               result.error(file, line, "Message", "Suggestion")
   ```

2. Add the call to `main()`:
   ```python
   check_something(root, files, result)
   ```

### Testing Linter Changes

After modifying the linter:

1. Run it on the current project:
   ```bash
   python tools/workflow-linter.py --verbose --fix-suggestions
   ```

2. Verify it catches known issues (if any exist in test files)

3. Verify it doesn't produce false positives

---

## Documentation Standards

### For Non-Technical Users (User Guide, Quick-Start, Troubleshooting)

- No unexplained jargon
- Active voice ("Click the button" not "The button should be clicked")
- Concrete examples, not abstract descriptions
- Short sentences
- Numbered steps for procedures

### For Technical Users (Extending Skills, Contributing)

- Precise terminology is acceptable
- Include code examples
- Reference specific files and line numbers where helpful
- Explain the "why" not just the "what"

### For System Files (Agents, Skills)

- Consistent section structure
- Complete metadata
- Version history maintained
- Examples of expected input/output

---

## Testing Changes

### Manual Testing (Dry Run)

Without a live project, trace the workflow manually:

1. Identify the workflow path your change affects
2. Walk through each step using the actual file content
3. Verify handoffs contain expected data
4. Check error paths and escalations

### Linter Testing

The linter is your automated test suite:

```bash
# Basic check (errors only)
python tools/workflow-linter.py

# Full check (errors + warnings)
python tools/workflow-linter.py --verbose

# With fix suggestions
python tools/workflow-linter.py --verbose --fix-suggestions
```

### Documentation Testing

For doc changes:

1. Read as if you're the target audience
2. Follow any procedures step-by-step
3. Verify cross-references link to real files
4. Check that examples match current system behavior

---

## Quick Reference

### File Locations

| Component | Location |
|-----------|----------|
| Documentation | `docs/*.md` |
| Agents | `.claude/agents/*.md` |
| Skills | `.claude/skills/{category}/*.md` |
| Chains | `.claude/chains/*.md` |
| Templates | `/templates/*.md` |
| User docs | `/docs/*.md` |
| Technical docs | `/docs/*.md` |
| Examples | `/docs/examples/` |
| Memory/State | `/memory/*.md` |
| Tests | `/tests/` |
| Tools | `/tools/` |

### Commands

```bash
# Run linter
python tools/workflow-linter.py

# Find references to a component
grep -r "component-name" --include="*.md" .

# List all skills
ls -la .claude/skills/**/*.md

# List all agents
ls -la .claude/agents/*.md
```

---

## Getting Help

If you're unsure about a change:

1. Check if similar changes exist in git history
2. Review the relevant section of this guide
3. Run the linter to catch obvious issues
4. When in doubt, make the change additive (don't remove/rename)
