---
name: preflight-check
description: Creates PRISM.md with enforcement rules and adds a pointer to the project's CLAUDE.md. Now invoked automatically via SessionStart hook.
version: 2.0.0
category: workflow
chainable: true
invoked_by: [hook:SessionStart]
tools: Read, Write, Edit
---

# Skill: Preflight Check

## Purpose

Create a standalone `PRISM.md` file with mandatory enforcement rules and ensure the project's `CLAUDE.md` contains a lightweight pointer to it.

**Note:** In Prism OS v2.0+, this skill is invoked automatically by the `SessionStart` hook (`hooks/preflight-check.sh`). The hook runs checks and outputs JSON instructions; Claude then uses this skill's content to create/update files as needed.

## Constants

```
ENFORCEMENT_VERSION: 2.1.0
```

**Versioning:** `ENFORCEMENT_VERSION` tracks independently from the Prism OS plugin version in `plugin.json`. Bump it only when the enforcement section content changes (new rules, modified instructions). Plugin releases that don't change enforcement content leave this version unchanged.

## When to Invoke

- Automatically via SessionStart hook at the start of every `/prism` command
- When the hook output indicates PRISM.md needs to be created or updated

## Process

### Part A: Installation Verification (Handled by Hook)

The SessionStart hook (`hooks/preflight-check.sh`) handles installation verification. Since Prism OS is now a Claude Code plugin, installation status is managed by the plugin system.

### Part B: Create/Update PRISM.md and Add Pointer to CLAUDE.md

The hook outputs JSON with instructions. Follow these steps based on the hook output:

#### Logic

1. Read `./CLAUDE.md` from the project root.
2. **Dev repo guard:** If the file contains the string `Prism OS Development Environment`, skip entirely. This is the Prism development repository — enforcement rules are not appropriate here. Report nothing.
3. **Check/create PRISM.md:**
   - If hook indicates `prism_md_action: "create"` → create PRISM.md with content below. Report: `Created PRISM.md with Prism enforcement rules (v2.1.0).`
   - If hook indicates `prism_md_action: "update"` → overwrite PRISM.md with content below. Report: `Updated PRISM.md enforcement rules to v2.1.0.`
   - If hook indicates `prism_md_action: "none"` → skip (already current).
4. **Check CLAUDE.md for pointer:**
   - If hook indicates `needs_pointer: true`:
     - If `has_legacy_block: true` → remove the entire legacy block (from `<!-- PRISM-OS-ENFORCEMENT-START` through `<!-- PRISM-OS-ENFORCEMENT-END -->`), then add the pointer. Report: `Migrated legacy enforcement block to PRISM.md.`
     - Otherwise → add the pointer as the **first line** of the file (or after any frontmatter/YAML header). Report: `Added PRISM.md pointer to ./CLAUDE.md.`
   - If no `./CLAUDE.md` exists → create it with only the pointer line. Report: `Created ./CLAUDE.md with PRISM.md pointer.`

#### Pointer Line

Use this exact content as the pointer:

```
<!-- Project: Check for ./PRISM.md and follow all rules if present -->
```

#### Report

Only print a message if something changed:
- Created PRISM.md: `Created PRISM.md with Prism enforcement rules (v2.1.0).`
- Updated PRISM.md version: `Updated PRISM.md enforcement rules to v2.1.0.`
- Created CLAUDE.md: `Created ./CLAUDE.md with PRISM.md pointer.`
- Added pointer to existing CLAUDE.md: `Added PRISM.md pointer to ./CLAUDE.md.`
- Migrated legacy block: `Migrated legacy enforcement block to PRISM.md.`
- Skipped (current version and pointer present, or dev repo): Print nothing.

## PRISM.md Content

The following is the canonical PRISM.md content. Use this exact content (substituting the current `ENFORCEMENT_VERSION` into the version marker) when creating or updating the file.

```markdown
<!-- PRISM-OS v2.1.0 -->
# Prism OS — Enforcement Rules

These rules are MANDATORY. They override default Claude Code behavior for all workflow actions.

## Component Locations

Prism OS components are provided by the **prism-os plugin**:
- **Agents:** 9 specialist agents (orchestrator, architect, developer, qa-engineer, security, uiux-designer, business-analyst, task-planner, devops)
- **Skills:** Organized by category (workflow, design, QA, review, research, learning, ui, engineering, specification)
- **Chains:** Pipeline definitions (full-pipeline, quick-flow, discovery-chain)
- **Commands:** Slash command definitions (prism, spec, clarify, validate, review, etc.)

All components are automatically available when the prism-os plugin is installed.

## Mandatory Skill Invocation

When performing workflow actions, you MUST use the Skill tool with the exact skill name. NEVER perform these actions inline or by writing files directly.

| Action | MUST call | NEVER do instead |
|--------|-----------|------------------|
| Write a specification | `Skill(skill: "spec")` | Write a spec.md file yourself |
| Clarify ambiguities | `Skill(skill: "clarify")` | Ask clarification questions ad-hoc |
| Create implementation plan | `Skill(skill: "prism-plan")` | Write a plan.md file yourself |
| Break plan into tasks | `Skill(skill: "prism-tasks")` | Create tasks with TaskCreate directly |
| Run QA validation | `Skill(skill: "validate")` | Review code yourself without the skill |
| Run code review | `Skill(skill: "review")` | Review code yourself without the skill |
| View/edit constitution | `Skill(skill: "constitution")` | Edit constitution.md directly |
| Capture learnings | `Skill(skill: "learn")` | Write to learnings files directly |
| Load project context | `Skill(skill: "prime")` | Read context files ad-hoc |
| Show workflow status | `Skill(skill: "prism-status")` | Summarize status yourself |

**Note:** Design skills (`ui-designer`, `accessibility`, `ux-patterns`, etc.) are invoked by the UI/UX Designer agent during the Plan phase, not listed here. They are called through agent delegation, not direct user commands.

## Mandatory Chain Following

Before executing a multi-phase workflow, you MUST:
1. Read the appropriate chain definition (e.g., `full-pipeline`, `quick-flow`)
2. Follow the chain's defined sequence of skills — do NOT skip phases
3. Execute handoffs between phases using the chain's transition rules

## Mandatory Agent Behavior

Before implementing code, you MUST:
1. Read the `developer` agent definition and follow its protocols (test-first, learning capture, constitution compliance)
2. Before QA validation, read the `qa-engineer` agent definition and follow its validation checklist

When delegating to specialist agents via the Task tool, you MUST set `subagent_type` to the matching agent name (e.g., `subagent_type: "developer"`, `subagent_type: "qa-engineer"`).

## Mandatory Context Loading

At the start of any workflow, you MUST read these files (if they exist):
1. `memory/constitution.md` — Project principles (NEVER violate these)
2. `memory/project-context.md` — Current workflow state
3. `memory/learnings/active/patterns.md` — Validated patterns to follow
4. `memory/learnings/active/gotchas.md` — Known traps to avoid
5. `memory/waivers.md` — Constitution waivers (load before constitution checks)
6. `memory/tech-debt.md` — Non-blocking review suggestions (load during review phase)

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
2. Implement it (following developer agent protocol)
3. Validate it (following qa-engineer agent protocol)
4. If validation fails, fix and re-validate (max 5 attempts)
5. Move to the next task
6. After all tasks pass validation, run `Skill(skill: "review")` on all changed files

Do NOT wait for user input between tasks. The loop continues until all tasks are complete or a blocker requires human decision.

## Correct vs Incorrect Examples

CORRECT: Call `Skill(skill: "spec")` to create a specification.
INCORRECT: Write a `spec.md` file directly without invoking the spec skill.

CORRECT: Read the chain definition then follow each phase in order.
INCORRECT: Jump directly to implementation after the user describes a feature.

CORRECT: Read the developer agent definition before writing code.
INCORRECT: Start writing code using default Claude Code behavior.

CORRECT: Use `Skill(skill: "validate")` to run QA checks.
INCORRECT: Review the code yourself and declare it "looks good."
```

## Outputs

- **Status:** `PASS` (hook check passed), `SKIP` (dev repo)
- **Side effect:** `PRISM.md` may be created or updated; `CLAUDE.md` may have pointer added or legacy block removed
- **Console:** Creation/update status (single line each, only if something changed)
