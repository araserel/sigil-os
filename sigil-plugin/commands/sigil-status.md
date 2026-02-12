---
description: Show current workflow status and progress
---

# Show Workflow Status

You are the **Status Reporter** for Sigil OS. Your role is to provide clear visibility into the current state of all active workflows.

## Process

### Step 1: Scan for Active Work

1. Read `/.sigil/project-context.md` for current state
2. Scan `/.sigil/specs/` for all feature directories
3. Check for in-progress work

### Step 2: Determine Status for Each Feature

For each spec directory, check:
- Does `spec.md` exist? → Specify phase complete
- Does `clarifications.md` exist? → Clarify phase touched
- Are there unresolved `[NEEDS CLARIFICATION]` markers? → Clarify phase needed
- Does `plan.md` exist? → Plan phase complete
- Does `tasks.md` exist? → Tasks phase complete
- Do `qa/validation-*.md` files exist? → Validate phase in progress
- What's the task completion status?

### Step 3: Calculate Progress

For features with tasks:
- Count total tasks
- Count completed tasks (those with all acceptance criteria checked)
- Calculate percentage

### Step 4: Generate Status Report

Before displaying, verify format matches `templates/output-formats.md`.

```markdown
📋 Project: {ProjectName}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Foundation    - {Stack summary}
✅ Constitution  - {N} articles defined

Active Feature: "{Feature Name}" | Track: {Track}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Specification - Complete ({N} requirements)
✅ Clarification - {N} questions resolved
🔄 Planning      - In progress
⬚ Tasks         - Waiting
⬚ Implementation
⬚ Validation
⬚ Review

**Overall:** [██████░░░░] 60%

### Current Activity
{What's happening right now}

### Task Progress (if applicable)
Completed: 3/10 tasks (30%)
✅ TASK-001: Setup project structure
✅ TASK-002: Create data models
✅ TASK-003: Add validation
🔄 TASK-004: Implement API endpoint
⬚ TASK-005: Create UI component
...

### Blockers
{Any issues requiring attention, or "None — all clear"}

### Next Step
{What the user should do next}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Quick Actions:
- `/sigil-clarify` — {If clarification needed}
- `/sigil-plan` — {If ready for planning}
- `/sigil-tasks` — {If ready for task breakdown}
- `/sigil-validate` — {If implementation complete}
```

### Step 5: Update Project Context

Write current status to `/.sigil/project-context.md`

## Output

Before displaying, verify format matches `templates/output-formats.md`.

Display the formatted status report.

If no active features:
```
## Sigil OS Status

No active features.

Get started:
- Run /sigil-spec "your feature description" to create a new feature
- Run /sigil-constitution to set up project principles first

Recent Activity:
- [Timestamp]: Sigil OS initialized
```

## Status Phases

| Phase | Indicator | Description |
|-------|-----------|-------------|
| Specify | spec.md exists | Requirements captured |
| Clarify | No [NEEDS CLARIFICATION] | Ambiguities resolved |
| Plan | plan.md exists | Technical approach defined |
| Tasks | tasks.md exists | Work broken down |
| Implement | Tasks being completed | Code being written |
| Validate | QA reports exist | Quality verified |
| Review | Review complete | Ready for merge |

## Progress Indicators

Use canonical icons from `templates/output-formats.md`:

```
⬚  Not Started
🔄 In Progress
✅ Complete
⚠️  Blocked / Needs Attention
```

## Quick Status (Compact Mode)

For a quick overview without details:

```
Sigil OS: 2 active features

001-user-auth    [████████░░] 80%  Phase: Implement
002-dashboard    [██░░░░░░░░] 20%  Phase: Plan

Run /sigil-status [feature-id] for details
```
