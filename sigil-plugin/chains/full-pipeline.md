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
         │ [If feature has UI components]
         ▼
┌─────────────────────┐
│   uiux-designer     │ ← Component design, framework selection, accessibility
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
│ technical-planner   │ ← Receives UI framework as constraint
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
│              │                       │
│      [If fix loop resolved with      │
│       iterations > 1 AND Major+]     │
│              ▼                       │
│  ┌─────────────────────────────┐    │
│  │  learning-capture (review)  │    │
│  │  (silent, non-blocking)     │    │
│  └─────────────────────────────┘    │
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
         │ [If findings at Medium+ resolved]
         ▼
┌──────────────────────────┐
│ learning-capture (review)│ ← Capture security learnings
│ (silent, non-blocking)   │
└──────────────────────────┘
         │
         ▼
      Complete
```

## Implementation Note

The per-task loop (Developer -> QA Engineer [qa-validator -> qa-fixer] -> next task) is
orchestrated by the `/sigil` command's Step 4b (Implementation Loop). Code review
runs once after all tasks complete, not per-task. This chain
file documents the sequence and state transitions; the `/sigil` command executes them.

When `/sigil continue` is invoked with `Current Phase: implement`, the sigil command
reads the task list and resumes the implementation loop at the current task.

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

### clarifier → uiux-designer
**Trigger:** All ambiguities resolved AND feature has UI components
**Condition:** `all_resolved: true AND has_ui: true`
**Data Passed:** `{ spec_path, clarifications_path, visual_assets }`

### clarifier → technical-planner (direct, non-UI)
**Trigger:** All ambiguities resolved AND no UI components
**Condition:** `all_resolved: true AND has_ui: false`
**Data Passed:** `{ spec_path, clarifications_path }`

### spec-writer → uiux-designer (direct, UI feature)
**Trigger:** No ambiguities in spec AND feature has UI
**Condition:** `requires_clarification: false AND has_ui: true`
**Data Passed:** `{ spec_path }`

### spec-writer → technical-planner (direct, non-UI)
**Trigger:** No ambiguities in spec AND no UI
**Condition:** `requires_clarification: false AND has_ui: false`
**Data Passed:** `{ spec_path }`

### uiux-designer → technical-planner
**Trigger:** Design approved
**Condition:** User approves component design
**Data Passed:** `{ spec_path, design_path, framework, accessibility_path }`

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

### Developer → QA Engineer (qa-validator)
**Trigger:** Task implementation complete
**Condition:** Developer marks task done (per-task handoff, not after all tasks)
**Data Passed:** `{ task_id, files_changed }`

### qa-validator → qa-fixer
**Trigger:** Validation failures
**Condition:** `validation_passed: false AND iteration < 5`
**Data Passed:** `{ issues, files_to_fix }`

### qa-fixer → qa-validator
**Trigger:** Fixes applied
**Condition:** Fix attempt complete
**Data Passed:** `{ fixes_applied, iteration }`

### qa-fixer → learning-capture (review findings)
**Trigger:** Fix loop resolves after multiple iterations with substantive issues
**Condition:** `iterations > 1 AND any issue severity in [Major, Critical]`
**Data Passed:** `{ mode: "review-findings", source: "qa-fix-loop", feature_id, task_id, findings: [filtered Major/Critical issues with resolutions], iterations }`

### security-reviewer → learning-capture (review findings)
**Trigger:** Security review completes with remediated findings
**Condition:** `any finding severity in [Medium, High, Critical]`
**Data Passed:** `{ mode: "review-findings", source: "security-review", feature_id, task_id, findings: [resolved findings with OWASP categories] }`

### qa-validator (final task) → code-reviewer
**Trigger:** Last task passes validation
**Condition:** All tasks individually validated and complete
**Data Passed:** `{ spec_path, changed_files, implementation_modified, files_changed_classified, fix_loop_summary }`

## Human Checkpoints

| Checkpoint | Tier | Condition |
|------------|------|-----------|
| Track selection | Review | After complexity assessment |
| Spec review | Review | After spec generation |
| Clarification answers | Auto | User provides answers |
| Design review | Review | After UI/UX design (if UI feature) |
| Framework selection | Review | If no framework in constitution |
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
- `has_ui`: Whether feature has UI components
- `framework`: UI framework (if selected by uiux-designer)
- `design_path`: Path to design artifacts (if UI feature)
- `implementation_modified`: Whether QA fixes touched implementation files (S2-003)
- `files_changed_classified`: File categorization from qa-fixer (test/implementation/config/other)
- `fix_loop_summary`: Structured summary of QA fix loop activity

## Example Execution

```
User: "Add user authentication with email and password"

1. complexity-assessor
   → Scores 14/21 → Standard track
   → User confirms

2. spec-writer
   → Creates /specs/001-user-auth/spec.md
   → Flags: "Session vs JWT unclear", "Password rules unspecified"
   → Detects UI components (login form, password reset)

3. clarifier
   → Round 1: 4 questions asked
   → User answers
   → All resolved

4. uiux-designer (feature has UI)
   → Checks constitution for framework → None found
   → Presents framework options (React recommended)
   → User confirms React
   → Designs login form components
   → Creates accessibility requirements
   → User approves design

5. technical-planner
   → Creates /specs/001-user-auth/plan.md
   → React framework is now a constraint
   → Recommends jose library for JWT
   → User approves

6. task-decomposer
   → Creates 12 tasks in 4 phases
   → First task: T001 - Setup auth module

7. Developer (per task)
   → Implements T001
   → Uses react-ui skill for components
   → qa-validator checks (includes accessibility)
   → Passes, moves to T002
   → ... continues ...

8. code-reviewer
   → Reviews all changes
   → Approves

9. Complete
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
