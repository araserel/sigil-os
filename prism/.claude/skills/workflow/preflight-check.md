---
name: preflight-check
description: Verifies global Prism OS installation integrity and ensures enforcement rules exist in the project's CLAUDE.md.
version: 1.0.0
category: workflow
chainable: true
invoked_by: [orchestrator]
tools: Bash, Read, Write, Edit, Glob
---

# Skill: Preflight Check

## Purpose

Verify that the global Prism OS installation is intact before running any workflow, and ensure the project's CLAUDE.md contains mandatory enforcement rules that instruct Claude Code to use Prism's agents and skills via the correct tools.

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

### Part B: Check/Inject Enforcement Section in Project CLAUDE.md

After installation is verified, ensure the project's `./CLAUDE.md` contains the enforcement section.

#### Logic

1. Read `./CLAUDE.md` from the project root.
2. **Dev repo guard:** If the file contains the string `Prism OS Development Environment`, skip injection entirely. This is the Prism development repository — enforcement rules are not appropriate here. Report nothing.
3. **No CLAUDE.md exists:** Create `./CLAUDE.md` with only the enforcement section (wrapped in markers).
4. **CLAUDE.md exists, no markers found:** Append the enforcement section (with a blank line separator) to the end of the file.
5. **Markers found, check version:** Extract the version from the start marker (`<!-- PRISM-OS-ENFORCEMENT-START v1.0.0 -->`).
   - Same version as `ENFORCEMENT_VERSION` → Skip. Report nothing.
   - Older version → Replace everything between (and including) the start and end markers with the current enforcement section. Report: `Updated Prism enforcement rules to v1.0.0.`
6. **Markers found, no version or unparseable:** Treat as older version — replace.

#### Report

Only print a message if something changed:
- Created CLAUDE.md: `Created ./CLAUDE.md with Prism enforcement rules (v1.0.0).`
- Appended to existing: `Added Prism enforcement rules (v1.0.0) to ./CLAUDE.md.`
- Updated version: `Updated Prism enforcement rules to v1.0.0.`
- Skipped (current or dev repo): Print nothing.

## Enforcement Section Content

The following is the canonical enforcement section. Use this exact content (substituting the current `ENFORCEMENT_VERSION` into the marker) when injecting into a project's CLAUDE.md.

```markdown
<!-- PRISM-OS-ENFORCEMENT-START v1.0.0 -->
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

After each phase transition (e.g., spec complete → planning), you MUST update `memory/project-context.md` with:
- Current phase name
- Feature being worked on
- Spec path
- Timestamp of transition

## Correct vs Incorrect Examples

CORRECT: Call `Skill(skill: "spec")` to create a specification.
INCORRECT: Write a `spec.md` file directly without invoking the spec skill.

CORRECT: Read `~/.claude/chains/full-pipeline.md` then follow each phase in order.
INCORRECT: Jump directly to implementation after the user describes a feature.

CORRECT: Read `~/.claude/agents/developer.md` before writing code.
INCORRECT: Start writing code using default Claude Code behavior.

CORRECT: Use `Skill(skill: "validate")` to run QA checks.
INCORRECT: Review the code yourself and declare it "looks good."
<!-- PRISM-OS-ENFORCEMENT-END -->
```

## Outputs

- **Status:** `PASS` (all checks pass or only warnings), `BLOCK` (not installed)
- **Side effect:** CLAUDE.md may be created or modified with enforcement section
- **Console:** Warnings and injection status (single line each, only if something changed)
