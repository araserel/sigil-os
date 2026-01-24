## Task: Dry-Run Workflow Test

Execute a simulated workflow to verify agent routing and handoffs WITHOUT building any actual code. This is a test of the orchestration system itself.

### Test Mode Rules

1. **No actual implementation** — Agents describe what they WOULD do, not do it
2. **Create simulation artifacts** — Write markdown files documenting the simulated workflow
3. **Track all handoffs** — Log every agent transition with timestamps
4. **Output to test directory** — All artifacts go to `/test-runs/flow-test-001/`

### Test Input

Feature request to simulate:
```
"I want a feature that allows users to reset their password via email"
```

### Expected Flow to Verify
```
Orchestrator → Business Analyst → Architect → Task Planner → [STOP]
```

Stop after Task Planner — do not proceed to Developer/implementation.

### What Each Agent Should Output (Simulation Mode)

#### Orchestrator
Create: `/test-runs/flow-test-001/00-orchestrator-routing.md`
```markdown
# Orchestrator Routing Decision

**Input:** [The feature request]
**Timestamp:** [ISO timestamp]

## Analysis
- Trigger words detected: [list]
- Current phase: [None/Assessment]
- Track assessment: [Quick/Standard/Enterprise]

## Routing Decision
- **Target Agent:** Business Analyst
- **Reason:** [Why this agent was selected]
- **Phase entering:** Specify

## Handoff Initiated
Passing to Business Analyst with context...
```

#### Business Analyst
Create: `/test-runs/flow-test-001/01-business-analyst-specify.md`
```markdown
# Business Analyst: Specify Phase (Simulation)

**Received from:** Orchestrator
**Timestamp:** [ISO timestamp]

## What I Would Do
1. Invoke `spec-writer` skill with the feature description
2. Create specification document at `/specs/###-password-reset/spec.md`
3. Identify ambiguities requiring clarification

## Simulated Spec Outline
- **Summary:** Password reset via email functionality
- **P1 Scenarios:** [List 2-3 key scenarios I would document]
- **Key Requirements:** [List 3-5 requirements I would capture]
- **Ambiguities Detected:** [List questions I would ask]

## Simulated Clarification (Skip for Test)
[Assume clarifications resolved]

## Handoff to Architect
- **Artifacts I would pass:** spec.md, clarifications.md
- **Context:** Track assignment, ambiguity level, user priorities
```

#### Architect
Create: `/test-runs/flow-test-001/02-architect-plan.md`
```markdown
# Architect: Plan Phase (Simulation)

**Received from:** Business Analyst
**Timestamp:** [ISO timestamp]

## What I Would Do
1. Review specification
2. Check constitution for constraints
3. Research if needed (e.g., email service options)
4. Invoke `technical-planner` skill
5. Create implementation plan
6. Document any ADRs

## Simulated Plan Outline
- **Approach:** [1-2 sentence technical approach]
- **Files to create/modify:** [List 5-7 files]
- **Dependencies:** [Any new packages needed]
- **Risk assessment:** [Low/Medium/High + reason]

## Constitution Gate Check
- [ ] Article 5 (Anti-Abstraction): [Pass/Concern]
- [ ] Article 6 (Simplicity): [Pass/Concern]
- [ ] Article 7 (Accessibility): [Pass/Concern]

## Handoff to Task Planner
- **Artifacts I would pass:** plan.md, any ADRs
- **Context:** Risk level, key decisions, dependencies
```

#### Task Planner
Create: `/test-runs/flow-test-001/03-task-planner-tasks.md`
```markdown
# Task Planner: Tasks Phase (Simulation)

**Received from:** Architect
**Timestamp:** [ISO timestamp]

## What I Would Do
1. Invoke `task-decomposer` skill
2. Break plan into phases (Setup, Foundation, Feature, Testing)
3. Identify dependencies
4. Mark parallelization opportunities

## Simulated Task Breakdown
- **Total tasks:** [Estimated count]
- **Phases:**
  - Setup: [N] tasks
  - Foundation: [N] tasks
  - Feature: [N] tasks
  - Testing: [N] tasks
- **Parallelizable:** [List task pairs that could run together]
- **Critical path:** [Longest dependency chain]

## Sample Tasks (First 3)
| ID | Task | Phase | Dependencies |
|----|------|-------|--------------|
| T001 | [Task name] | Setup | None |
| T002 | [Task name] | Setup | None |
| T003 | [Task name] | Foundation | T001 |

## Handoff to Developer (NOT EXECUTED)
- **Would pass:** tasks.md, first task briefing
- **Test stops here**
```

### Final Output

Create: `/test-runs/flow-test-001/TEST-SUMMARY.md`
```markdown
# Flow Test Summary

**Test ID:** flow-test-001
**Date:** [ISO date]
**Input:** "I want a feature that allows users to reset their password via email"

## Flow Verification

| Step | Agent | Phase | Status | Artifact |
|------|-------|-------|--------|----------|
| 1 | Orchestrator | Assessment | ✅ | 00-orchestrator-routing.md |
| 2 | Business Analyst | Specify | ✅ | 01-business-analyst-specify.md |
| 3 | Business Analyst | Clarify | ⏭️ Skipped | (simulated inline) |
| 4 | Architect | Plan | ✅ | 02-architect-plan.md |
| 5 | Task Planner | Tasks | ✅ | 03-task-planner-tasks.md |
| 6 | Developer | Implement | 🛑 Stopped | (per test design) |

## Routing Accuracy
- [ ] Orchestrator correctly identified "feature" + "I want" triggers
- [ ] Business Analyst activated for Specify phase
- [ ] Handoff to Architect occurred after spec complete
- [ ] Handoff to Task Planner occurred after plan complete

## Issues Found
[List any routing errors, missing handoffs, or unexpected behavior]

## Test Result: [PASS/FAIL]
```

### Execution Instructions

1. Create the test directory: `/test-runs/flow-test-001/`
2. Process the feature request through each agent in sequence
3. Each agent creates its simulation artifact
4. Do NOT create actual spec.md, plan.md, or tasks.md — only the test artifacts
5. Do NOT invoke Developer agent or write any code
6. Generate TEST-SUMMARY.md as final output

### Success Criteria

- All 4 agent simulation files created
- Handoffs documented with timestamps
- No actual code or real specs generated
- Summary shows correct flow sequence
```
