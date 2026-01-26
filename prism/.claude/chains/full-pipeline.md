---
name: full-pipeline
description: Complete spec-to-implementation workflow for Standard and Enterprise tracks.
version: 1.0.0
track: standard, enterprise
entry_skill: complexity-assessor
---

# Chain: Full Pipeline

## Overview

The full pipeline is the standard workflow for features that need proper specification, planning, and validation. Used for Standard and Enterprise track requests.

## When to Use

- Complexity assessment returns "Standard" or "Enterprise"
- New features with moderate to high complexity
- Work involving multiple files, dependencies, or data changes
- User explicitly requests full workflow

## Chain Sequence

```
┌─────────────────────┐
│ complexity-assessor │ ← Entry point
└─────────────────────┘
         │
         │ [If Standard/Enterprise]
         ▼
┌─────────────────────┐
│ constitution-writer │ ← Only if no constitution exists
└─────────────────────┘
         │
         ▼
┌─────────────────────┐
│    spec-writer      │
└─────────────────────┘
         │
         │ [If ambiguities detected]
         ▼
┌─────────────────────┐
│     clarifier       │ ← Loop until resolved (max 3 rounds)
└─────────────────────┘
         │
         │ [If Enterprise track]
         ▼
┌─────────────────────┐
│     researcher      │ ← Parallel research tasks
└─────────────────────┘
         │
         ▼
┌─────────────────────┐
│ technical-planner   │
└─────────────────────┘
         │
         │ [If ADRs needed]
         ▼
┌─────────────────────┐
│    adr-writer       │ ← For significant decisions
└─────────────────────┘
         │
         ▼
┌─────────────────────┐
│  task-decomposer    │
└─────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│          Per-Task Loop               │
│                                      │
│  ┌─────────────────────────────┐    │
│  │    Developer Agent          │    │
│  │    (Implementation)         │    │
│  └─────────────────────────────┘    │
│              │                       │
│              ▼                       │
│  ┌─────────────────────────────┐    │
│  │      qa-validator           │    │
│  └─────────────────────────────┘    │
│              │                       │
│      [If issues found]               │
│              ▼                       │
│  ┌─────────────────────────────┐    │
│  │       qa-fixer              │    │
│  └─────────────────────────────┘    │
│              │                       │
│      [Loop max 5 times]              │
│              │                       │
│  [Escalate to human if still failing]│
└──────────────────────────────────────┘
         │
         ▼
┌─────────────────────┐
│   code-reviewer     │ ← Final code review
└─────────────────────┘
         │
         │ [If security-related]
         ▼
┌─────────────────────┐
│  security-reviewer  │
└─────────────────────┘
         │
         ▼
      Complete
```

## State Transitions

### complexity-assessor → spec-writer
**Trigger:** Track confirmed as Standard or Enterprise
**Condition:** User confirms recommended track
**Data Passed:** `{ track, confidence, rationale }`

### spec-writer → clarifier
**Trigger:** Ambiguities detected
**Condition:** `requires_clarification: true`
**Data Passed:** `{ spec_path, ambiguity_flags }`

### clarifier → spec-writer
**Trigger:** Clarifications provided but new ambiguities found
**Condition:** `iteration < max_iterations AND new_ambiguities`
**Data Passed:** Updated spec with clarifications

### clarifier → technical-planner
**Trigger:** All ambiguities resolved
**Condition:** `all_resolved: true`
**Data Passed:** `{ spec_path, clarifications_path }`

### spec-writer → technical-planner (direct)
**Trigger:** No ambiguities in spec
**Condition:** `requires_clarification: false`
**Data Passed:** `{ spec_path }`

### technical-planner → researcher
**Trigger:** Unknown technologies or approaches
**Condition:** Enterprise track OR research_needed flag
**Data Passed:** `{ research_questions, context }`

### technical-planner → task-decomposer
**Trigger:** Plan approved
**Condition:** Human approval received
**Data Passed:** `{ plan_path, spec_path }`

### task-decomposer → Developer
**Trigger:** Tasks ready
**Condition:** Task list generated
**Data Passed:** `{ first_task, tasks_path }`

### Developer → qa-validator
**Trigger:** Task implementation complete
**Condition:** Developer marks task done
**Data Passed:** `{ task_id, files_changed }`

### qa-validator → qa-fixer
**Trigger:** Validation failures
**Condition:** `validation_passed: false AND iteration < 5`
**Data Passed:** `{ issues, files_to_fix }`

### qa-fixer → qa-validator
**Trigger:** Fixes applied
**Condition:** Fix attempt complete
**Data Passed:** `{ fixes_applied, iteration }`

### qa-validator → code-reviewer
**Trigger:** All tasks validated
**Condition:** All tasks pass validation
**Data Passed:** `{ spec_path, changed_files }`

## Human Checkpoints

| Checkpoint | Tier | Condition |
|------------|------|-----------|
| Track selection | Review | After complexity assessment |
| Spec review | Review | After spec generation |
| Clarification answers | Auto | User provides answers |
| Plan approval | Review | After plan generation |
| ADR approval | Review | For each ADR |
| QA escalation | Review | After 5 failed fix attempts |
| Code review | Review | Before completion |
| Security review | Approve | If security-related changes |

## Error Handling

### Clarification Loop Exceeded
```
If iteration >= 3 AND ambiguities remain:
  1. Generate summary of unresolved items
  2. Escalate to human with full context
  3. Human decides: resolve now OR proceed with unknowns
```

### QA Loop Exceeded
```
If qa_iteration >= 5 AND issues remain:
  1. Generate summary of persistent issues
  2. Categorize as: code problem vs. test problem vs. environment
  3. Escalate to human with recommendations
```

### Constitution Not Found
```
If constitution check fails:
  1. Prompt user to create constitution
  2. Invoke constitution-writer
  3. Resume chain after constitution created
```

## Context Preservation

Between skills, preserve:
- `chain_id`: Unique identifier for this chain execution
- `spec_path`: Current spec location
- `track`: Selected workflow track
- `iteration_counts`: Loop counters for clarifier and QA

## Example Execution

```
User: "Add user authentication with email and password"

1. complexity-assessor
   → Scores 14/21 → Standard track
   → User confirms

2. spec-writer
   → Creates /specs/001-user-auth/spec.md
   → Flags: "Session vs JWT unclear", "Password rules unspecified"

3. clarifier
   → Round 1: 4 questions asked
   → User answers
   → All resolved

4. technical-planner
   → Creates /specs/001-user-auth/plan.md
   → Recommends jose library for JWT
   → User approves

5. task-decomposer
   → Creates 12 tasks in 4 phases
   → First task: T001 - Setup auth module

6. Developer (per task)
   → Implements T001
   → qa-validator checks
   → Passes, moves to T002
   → ... continues ...

7. code-reviewer
   → Reviews all changes
   → Approves

8. Complete
```

## Variants

### Enterprise Extension
For Enterprise track, insert before technical-planner:
- `researcher` with comprehensive research questions
- Extended planning with architecture documentation
- Additional ADR requirements

### Shortened Standard
If user requests "quick planning":
- Combine clarifier rounds (all questions at once)
- Simplified plan (no research phase)
- Still maintains spec → plan → tasks → implement flow
