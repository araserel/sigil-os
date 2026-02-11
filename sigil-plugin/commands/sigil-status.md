---
description: Show current workflow status and progress
---

# Show Workflow Status

You are the **Status Reporter** for Sigil OS. Your role is to provide clear visibility into the current state of all active workflows.

## Process

### Step 1: Scan for Active Work

1. Read `/memory/project-context.md` for current state
2. Scan `/specs/` for all feature directories
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

```markdown
## Sigil OS Status

**Last Updated:** [Timestamp]
**Active Features:** [Count]

---

### [Feature Name] (ID: NNN)

**Track:** [Quick/Standard/Enterprise]
**Phase:** [Current Phase]

#### Progress
- [x] Specify — Complete
- [x] Clarify — Complete (3 questions resolved)
- [ ] Plan — In Progress (70%)
- [ ] Tasks — Pending
- [ ] Implement — Pending
- [ ] Validate — Pending
- [ ] Review — Pending

#### Current Activity
[What's happening right now]

#### Task Progress (if applicable)
Completed: 3/10 tasks (30%)
- [x] TASK-001: Setup project structure
- [x] TASK-002: Create data models
- [x] TASK-003: Add validation
- [ ] TASK-004: Implement API endpoint (IN PROGRESS)
- [ ] TASK-005: Create UI component
...

#### Blockers
[Any issues requiring attention, or "None"]

#### Next Human Touchpoint
[What the user will need to review/approve next]

---

### [Another Feature]
...

---

## Quick Actions

Based on current status:
- `/clarify` - [If clarification needed]
- `/sigil-plan` - [If ready for planning]
- `/sigil-tasks` - [If ready for task breakdown]
- `/validate` - [If implementation complete]

## Recent Activity

- [Timestamp]: [Action taken]
- [Timestamp]: [Action taken]
```

### Step 5: Update Project Context

Write current status to `/memory/project-context.md`

## Output

Display the formatted status report.

If no active features:
```
## Sigil OS Status

No active features.

Get started:
- Run /spec "your feature description" to create a new feature
- Run /constitution to set up project principles first

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

```
[ ] Pending     - Not started
[~] In Progress - Currently active
[x] Complete    - Finished
[!] Blocked     - Needs attention
```

## Quick Status (Compact Mode)

For a quick overview without details:

```
Sigil OS: 2 active features

001-user-auth    [████████░░] 80%  Phase: Implement
002-dashboard    [██░░░░░░░░] 20%  Phase: Plan

Run /sigil-status [feature-id] for details
```
