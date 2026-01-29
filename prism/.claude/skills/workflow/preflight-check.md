---
name: preflight-check
description: Verifies global Prism OS installation integrity. Creates PRISM.md with enforcement rules and adds a pointer to the project's CLAUDE.md.
version: 1.1.0
category: workflow
chainable: true
invoked_by: [orchestrator]
tools: Bash, Read, Write, Edit, Glob
---

# Skill: Preflight Check

## Purpose

Verify that the global Prism OS installation is intact before running any workflow. Create a standalone `PRISM.md` file with mandatory enforcement rules and ensure the project's `CLAUDE.md` contains a lightweight pointer to it.

## Constants

```
ENFORCEMENT_VERSION: 1.0.0
```

**Versioning:** `ENFORCEMENT_VERSION` tracks independently from the Prism OS product version in `STATUS.md`. Bump it only when the enforcement section content changes (new rules, modified instructions). Product releases that don't change enforcement content leave this version unchanged.

## When to Invoke

- Automatically at the start of every `/prism` command (Step 0)
- Before any workflow chain begins

## Process

### Part A: Verify Global Installation

Run these checks via Bash. Evaluate results using the severity table below.

| # | Check | Command | Severity |
|---|-------|---------|----------|
| 1 | Critical directories exist | `ls -d ~/.claude/agents/ ~/.claude/skills/ ~/.claude/chains/ 2>/dev/null` | BLOCK if any missing |
| 2 | Critical files present | `ls ~/.claude/agents/orchestrator.md ~/.claude/skills/workflow/spec-writer.md ~/.claude/chains/full-pipeline.md 2>/dev/null` | WARN if any missing |
| 3 | Version file readable | `cat ~/.claude/.prism-version 2>/dev/null` | WARN if missing |
| 4 | Agent count (expect 9+) | `find ~/.claude/agents/ -name "*.md" ! -name "README.md" 2>/dev/null \| wc -l` | WARN if < 9 |
| 5 | Skill count (expect 30+) | `find ~/.claude/skills/ -name "*.md" ! -name "README.md" 2>/dev/null \| wc -l` | WARN if < 30 |

#### Severity Behavior

- **BLOCK (NOT_INSTALLED):** Missing critical directories means Prism is not installed. Print the following and STOP — do not proceed with any workflow:

```
Prism OS is not installed globally.

To install:
  git clone https://github.com/araserel/prism-os.git ~/.prism-os
  ~/.prism-os/install-global.sh

Then try /prism again.
```

- **WARN:** Print a single-line warning and continue. Example:

```
Warning: Prism installation may be incomplete (found 7/9 agents). Run /prism-update to repair.
```

### Part B: Create/Update PRISM.md and Add Pointer to CLAUDE.md

After installation is verified, ensure a standalone `./PRISM.md` exists with enforcement rules and that `./CLAUDE.md` contains a pointer to it.

#### Logic

1. Read `./CLAUDE.md` from the project root.
2. **Dev repo guard:** If the file contains the string `Prism OS Development Environment`, skip entirely. This is the Prism development repository — enforcement rules are not appropriate here. Report nothing.
3. **Check/create PRISM.md:**
   - If `./PRISM.md` exists, check for version marker `<!-- PRISM-OS v1.0.0 -->` on the first line.
     - Same version as `ENFORCEMENT_VERSION` → skip (already current).
     - Older version or missing version → overwrite with current PRISM.md content. Report: `Updated PRISM.md enforcement rules to v1.0.0.`
   - If `./PRISM.md` does not exist → create it with current content. Report: `Created PRISM.md with Prism enforcement rules (v1.0.0).`
4. **Check CLAUDE.md for pointer:**
   - Look for `<!-- Project: Check for ./PRISM.md and follow all rules if present -->`.
   - If found → done (pointer already present).
   - If legacy `<!-- PRISM-OS-ENFORCEMENT-START` block found → remove the entire block (from `<!-- PRISM-OS-ENFORCEMENT-START` through `<!-- PRISM-OS-ENFORCEMENT-END -->`), then add the pointer. Report: `Migrated legacy enforcement block to PRISM.md.`
   - If no pointer and no legacy block → add the pointer as the **first line** of the file (or after any frontmatter/YAML header). Report: `Added PRISM.md pointer to ./CLAUDE.md.`
   - If no `./CLAUDE.md` exists → create it with only the pointer line. Report: `Created ./CLAUDE.md with PRISM.md pointer.`

#### Pointer Line

Use this exact content as the pointer:

```
<!-- Project: Check for ./PRISM.md and follow all rules if present -->
```

#### Report

Only print a message if something changed:
- Created PRISM.md: `Created PRISM.md with Prism enforcement rules (v1.0.0).`
- Updated PRISM.md version: `Updated PRISM.md enforcement rules to v1.0.0.`
- Created CLAUDE.md: `Created ./CLAUDE.md with PRISM.md pointer.`
- Added pointer to existing CLAUDE.md: `Added PRISM.md pointer to ./CLAUDE.md.`
- Migrated legacy block: `Migrated legacy enforcement block to PRISM.md.`
- Skipped (current version and pointer present, or dev repo): Print nothing.

## PRISM.md Content

The following is the canonical PRISM.md content. Use this exact content (substituting the current `ENFORCEMENT_VERSION` into the version marker) when creating or updating the file.

```markdown
<!-- PRISM-OS v1.0.0 -->
# Prism OS — Enforcement Rules

These rules are MANDATORY. They override default Claude Code behavior for all workflow actions.

## Component Locations

Prism OS components are installed globally:
- **Agents:** `~/.claude/agents/` (9 specialist agents)
- **Skills:** `~/.claude/skills/` (workflow, design, QA, review, research, learning)
- **Chains:** `~/.claude/chains/` (pipeline definitions)
- **Commands:** `~/.claude/commands/` (slash command definitions)

## Mandatory Skill Invocation

When performing workflow actions, you MUST use the Skill tool with the exact skill name. NEVER perform these actions inline or by writing files directly.

| Action | MUST call | NEVER do instead |
|--------|-----------|------------------|
| Write a specification | `Skill(skill: "spec")` | Write a spec.md file yourself |
| Clarify ambiguities | `Skill(skill: "clarify")` | Ask clarification questions ad-hoc |
| Create implementation plan | `Skill(skill: "plan")` | Write a plan.md file yourself |
| Break plan into tasks | `Skill(skill: "tasks")` | Create tasks with TaskCreate directly |
| Run QA validation | `Skill(skill: "validate")` | Review code yourself without the skill |
| Run code review | `Skill(skill: "review")` | Review code yourself without the skill |
| View/edit constitution | `Skill(skill: "constitution")` | Edit constitution.md directly |
| Capture learnings | `Skill(skill: "learn")` | Write to learnings files directly |
| Load project context | `Skill(skill: "prime")` | Read context files ad-hoc |
| Show workflow status | `Skill(skill: "status")` | Summarize status yourself |

**Note:** Design skills (`ui-designer`, `accessibility`, `ux-patterns`, etc.) are invoked by the UI/UX Designer agent during the Plan phase, not listed here. They are called through agent delegation, not direct user commands.

## Mandatory Chain Following

Before executing a multi-phase workflow, you MUST:
1. Read the appropriate chain file from `~/.claude/chains/` (e.g., `full-pipeline.md`, `quick-flow.md`)
2. Follow the chain's defined sequence of skills — do NOT skip phases
3. Execute handoffs between phases using the chain's transition rules

## Mandatory Agent Behavior

Before implementing code, you MUST:
1. Read `~/.claude/agents/developer.md` and follow its protocols (test-first, learning capture, constitution compliance)
2. Before QA validation, read `~/.claude/agents/qa-engineer.md` and follow its validation checklist

When delegating to specialist agents via the Task tool, you MUST set `subagent_type` to the matching agent name (e.g., `subagent_type: "developer"`, `subagent_type: "qa-engineer"`).

## Mandatory Context Loading

At the start of any workflow, you MUST read these files (if they exist):
1. `memory/constitution.md` — Project principles (NEVER violate these)
2. `memory/project-context.md` — Current workflow state
3. `memory/learnings/active/patterns.md` — Validated patterns to follow
4. `memory/learnings/active/gotchas.md` — Known traps to avoid

## Mandatory State Updates

After each phase transition (e.g., spec complete -> planning), you MUST update `memory/project-context.md` with:
- Current phase name
- Feature being worked on
- Spec path
- Timestamp of transition

## Automatic Workflow Handoffs

When these artifacts are created during a /prism workflow, the next phase begins automatically:

| After Creating | Next Phase | How |
|----------------|-----------|-----|
| `spec.md` | Clarification | Auto-continue to clarifier |
| `clarifications.md` | Planning | Auto-continue to technical-planner |
| `plan.md` | Task Breakdown | Auto-continue to task-decomposer |
| `tasks.md` | Implementation | Auto-continue to Developer agent |
| Task code changes | Validation | Invoke qa-validator |
| All tasks validated | Code Review | Invoke `Skill(skill: "review")` |

## Implementation Loop Rule

After `tasks.md` is created, the develop/validate loop runs automatically:
1. Pick the first unblocked incomplete task
2. Implement it (following developer.md protocol)
3. Validate it (following qa-engineer.md protocol)
4. If validation fails, fix and re-validate (max 5 attempts)
5. Move to the next task
6. After all tasks pass validation, run `Skill(skill: "review")` on all changed files

Do NOT wait for user input between tasks. The loop continues until all tasks are complete or a blocker requires human decision.

## Correct vs Incorrect Examples

CORRECT: Call `Skill(skill: "spec")` to create a specification.
INCORRECT: Write a `spec.md` file directly without invoking the spec skill.

CORRECT: Read `~/.claude/chains/full-pipeline.md` then follow each phase in order.
INCORRECT: Jump directly to implementation after the user describes a feature.

CORRECT: Read `~/.claude/agents/developer.md` before writing code.
INCORRECT: Start writing code using default Claude Code behavior.

CORRECT: Use `Skill(skill: "validate")` to run QA checks.
INCORRECT: Review the code yourself and declare it "looks good."
```

## Outputs

- **Status:** `PASS` (all checks pass or only warnings), `BLOCK` (not installed)
- **Side effect:** `PRISM.md` may be created or updated; `CLAUDE.md` may have pointer added or legacy block removed
- **Console:** Warnings and creation/update status (single line each, only if something changed)
