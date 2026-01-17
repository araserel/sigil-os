## Context

You are completing work on **Prism OS**, an AI-powered spec-driven development operating system. Phases 1-6 are complete:

- **Phase 1 (Foundation):** Project structure, constitution, base CLAUDE.md ✓
- **Phase 2 (Core Workflow):** Skills, templates, guided prompts, skill chains ✓
- **Phase 3 (Agents):** 8 agent definitions, routing, handoffs ✓
- **Phase 4 (Quality & Review):** QA skills, review pipeline, validation loops ✓
- **Phase 5 (Integration & Polish):** Context persistence, error handling, status reporting, versioning, extension docs, MCP integration ✓
- **Phase 6 (Documentation):** User guide, quick-start, command reference, troubleshooting, example walkthrough ✓

Phase 7 is **Validation**: End-to-end testing and refinement to verify the system works as designed.

**Important:** Since there is no live codebase to implement against, this phase will be a **simulated dry run**. You will trace through workflows, validate internal consistency, identify gaps, and produce test scenario documentation — not execute actual code.

---

## Project Location

```
/Users/adamriedthaler/Projects/SpecMaster/
```

**Key Files to Reference:**
- `PROJECT_PLAN.md` — Full implementation plan with Phase 7 tasks
- `CLAUDE.md` — Main operating system specification
- `/docs/` — All documentation (user-guide, quick-start, command-reference, troubleshooting, extending-skills, error-handling, context-management, mcp-integration, versioning)
- `/docs/examples/user-auth-feature/` — Complete worked example
- `.claude/agents/` — All 8 agent definitions
- `.claude/skills/` — All skill definitions
- `.claude/chains/` — Skill chain definitions
- `/templates/` — All templates including handoff-template.md
- `/memory/` — Constitution and project-context templates

---

## Phase 7 Objectives

Validate that Prism OS's design is internally consistent, complete, and ready for real-world use through simulated testing.

**Validation Approach:**
1. **Trace** — Walk through each workflow step-by-step using actual system files
2. **Verify** — Check that handoffs, triggers, and transitions are properly defined
3. **Identify** — Flag any gaps, inconsistencies, or missing pieces
4. **Document** — Produce test scenarios that could be run against a real project
5. **Refine** — Fix issues found during validation

---

## Tasks Overview

### Task 7.1: Simulated Quick Flow Test
**Goal:** Trace the Quick Flow (simplified workflow for low-complexity requests) end-to-end.

**Simulation Approach:**
1. Define a test scenario: "Fix a typo in the login button text"
2. Trace through each step using actual system files:
   - How does complexity-assessor categorize this?
   - What's the Quick Flow path per CLAUDE.md?
   - Which agents/skills are invoked?
   - What artifacts are produced?
3. Verify all handoffs and transitions are defined
4. Document the expected flow as a test case

**Deliverable:** `/tests/scenarios/quick-flow-test.md`

**Acceptance Criteria:**
- Complete trace from request to completion
- All agent/skill invocations mapped
- Handoff data validated against templates
- Any gaps identified and logged

---

### Task 7.2: Simulated Standard Flow Test
**Goal:** Trace the Standard Flow (full 8-phase workflow) end-to-end.

**Simulation Approach:**
1. Use the existing example: "User Authentication Feature" from `/docs/examples/`
2. Trace through ALL 8 phases:
   - Assess → Specify → Clarify → Plan → Tasks → Implement → Validate → Review
3. For each phase:
   - Which agent owns it?
   - Which skills are invoked?
   - What inputs does it need?
   - What outputs does it produce?
   - What's the handoff to the next phase?
4. Verify the example artifacts match expected skill outputs
5. Document the complete flow as a test case

**Deliverable:** `/tests/scenarios/standard-flow-test.md`

**Acceptance Criteria:**
- All 8 phases traced with agent/skill mapping
- Handoffs validated between each phase
- Example artifacts verified against templates
- QA validation loop traced (validator ↔ fixer)
- Review pipeline traced (parallel reviews)

---

### Task 7.3: Simulated Non-Technical User Journey
**Goal:** Validate the PM/PO experience by tracing a user journey through documentation.

**Simulation Approach:**
1. Assume persona: PM with no coding experience, first time using Prism
2. Start with quick-start.md — can they follow it?
3. Trace their path through:
   - Setting up constitution
   - Creating first feature spec
   - Understanding status output
   - Responding to decision points
   - Handling a blocker
4. Cross-reference: Do docs match actual system behavior?
5. Identify any jargon, missing explanations, or confusing steps

**Deliverable:** `/tests/scenarios/user-journey-test.md`

**Acceptance Criteria:**
- Complete user journey documented
- All doc cross-references verified
- Jargon/clarity issues logged
- Decision points mapped with guidance verification

---

### Task 7.4: Session Continuity Validation
**Goal:** Verify the context persistence system works across simulated session breaks.

**Simulation Approach:**
1. Review `/docs/context-management.md` for update triggers
2. Trace a workflow that spans multiple sessions:
   - Session 1: Start feature, complete Specify phase
   - [Session break]
   - Session 2: Resume, continue to Plan phase
   - [Session break]
   - Session 3: Resume, complete to Tasks phase
3. At each break, verify:
   - What gets written to project-context.md?
   - What state is captured?
   - Can the next session reconstruct where we left off?
4. Identify any state that could be lost

**Deliverable:** `/tests/scenarios/session-continuity-test.md`

**Acceptance Criteria:**
- Update triggers mapped to workflow events
- State capture verified at each phase
- Session resume path documented
- Any state loss risks identified

---

### Task 7.5: Edge Case Scenario Testing
**Goal:** Validate handling of unusual or error scenarios.

**Simulation Approach:**
Trace through each scenario using error-handling.md and agent definitions:

1. **Ambiguous Request Routing**
   - Request: "Help me with the thing we discussed"
   - How does Orchestrator handle missing context?
   - What clarification is requested?

2. **QA Loop Max Iterations**
   - Validation fails 5 times
   - Trace escalation path per qa-validator.md
   - Verify human handoff includes context

3. **Constitution Violation**
   - Plan proposes technology not in constitution
   - Trace detection and escalation
   - Verify decision point handling

4. **Scope Creep Detection**
   - During implementation, new requirement emerges
   - How is this detected and handled?
   - Trace back to spec modification path

5. **Hard Failure Recovery**
   - Skill fails with blocking error
   - Trace error handling per error-handling.md
   - Verify recovery suggestions provided

6. **Human Override**
   - User disagrees with agent recommendation
   - Trace override path
   - Verify system respects override

**Deliverable:** `/tests/scenarios/edge-cases-test.md`

**Acceptance Criteria:**
- Each scenario traced with expected behavior
- Error handling paths validated
- Escalation points verified
- Human intervention paths documented

---

### Task 7.6: Internal Consistency Audit
**Goal:** Verify all system components reference each other correctly.

**Audit Checklist:**

1. **Agent → Skill References**
   - Does each agent reference skills that exist?
   - Are skill paths correct?
   - Do skill capabilities match agent expectations?

2. **Skill → Template References**
   - Do skills reference templates that exist?
   - Do output formats match template structures?

3. **Chain → Skill References**
   - Do chains reference skills that exist?
   - Is handoff data compatible between chained skills?

4. **CLAUDE.md → Component References**
   - Are all agents listed and paths correct?
   - Are all commands mapped to skills?
   - Are routing triggers consistent with agent definitions?

5. **Documentation → System References**
   - Do docs describe actual system behavior?
   - Are command examples accurate?
   - Do workflow descriptions match CLAUDE.md?

6. **Cross-Document Consistency**
   - Do error codes match between docs?
   - Are phase names consistent?
   - Are tier definitions consistent?

**Deliverable:** `/tests/audit/consistency-report.md`

**Acceptance Criteria:**
- All references validated
- Inconsistencies logged with locations
- Severity assessed (blocker/major/minor)

---

### Task 7.7: Refinement Sprint
**Goal:** Fix issues identified during validation.

**Process:**
1. Compile all issues from Tasks 7.1-7.6
2. Categorize by severity:
   - **Blocker:** System won't work without fix
   - **Major:** Significant usability/clarity issue
   - **Minor:** Polish, nice-to-have
3. Fix all blockers
4. Fix majors (time permitting)
5. Document minors in `/docs/future-considerations.md`
6. Re-validate fixed items

**Deliverable:** 
- Fixed files
- `/tests/refinement-log.md` (issues found and resolution status)

**Acceptance Criteria:**
- All blockers resolved
- Majors addressed or documented
- Minors logged for future
- Fixes verified

---

### Task 7.8: Final Documentation Review
**Goal:** Ensure all documentation is accurate after refinements.

**Review Checklist:**
- [ ] CLAUDE.md matches actual system after refinements
- [ ] User guide workflows still accurate
- [ ] Quick-start tutorial still works
- [ ] Command reference still accurate
- [ ] Troubleshooting covers issues found in testing
- [ ] Example walkthrough consistent with templates
- [ ] No broken cross-references
- [ ] Version numbers updated if skills changed

**Deliverable:** Updated documentation files

**Acceptance Criteria:**
- All docs reviewed and updated
- No stale information
- Cross-references verified

---

## Recommended Approach

### Suggested Task Order

1. **7.6 (Consistency Audit)** — Find structural issues first
2. **7.1 (Quick Flow)** — Simpler flow, validates basics
3. **7.2 (Standard Flow)** — Full flow with existing example
4. **7.4 (Session Continuity)** — Cross-cutting concern
5. **7.5 (Edge Cases)** — Error paths
6. **7.3 (User Journey)** — Docs validation
7. **7.7 (Refinement)** — Fix everything found
8. **7.8 (Final Review)** — Polish

### Test Documentation Format

Each test scenario should follow this structure:

```markdown
# Test: [Name]

## Scenario
[Description of what's being tested]

## Preconditions
[What must be true before test starts]

## Steps
1. [Action]
   - Expected: [What should happen]
   - Verified: ✓/✗
   - Notes: [Any observations]

2. [Next action]
   ...

## Artifacts Produced
- [List of files/outputs]

## Issues Found
| ID | Severity | Description | Location | Status |
|----|----------|-------------|----------|--------|
| 1  | Major    | ...         | ...      | Open   |

## Result
PASS / FAIL / BLOCKED

## Notes
[Additional observations]
```

---

## Output Structure

Create the following directory structure for test outputs:

```
/tests/
├── scenarios/
│   ├── quick-flow-test.md
│   ├── standard-flow-test.md
│   ├── user-journey-test.md
│   ├── session-continuity-test.md
│   └── edge-cases-test.md
├── audit/
│   └── consistency-report.md
└── refinement-log.md
```

---

## Phase 7 Review Gate

**Definition of Done:**
- [ ] Quick Flow test passes (simulated)
- [ ] Standard Flow test passes (simulated)
- [ ] Non-technical user journey validated
- [ ] Session continuity verified
- [ ] Edge cases handled appropriately
- [ ] Internal consistency audit complete
- [ ] All blocker issues resolved
- [ ] Documentation accurate and complete

**Final Deliverables:**
- `/tests/` directory with all test scenarios
- `/tests/audit/consistency-report.md`
- `/tests/refinement-log.md`
- Updated system files (any fixes)
- Updated documentation (any corrections)

---

## Success Criteria for Prism OS v1.0

After Phase 7, Prism OS is complete when:

1. ✓ All 7 phases pass review gates
2. ✓ Non-technical user can follow documentation unassisted
3. ✓ Full workflow traces from spec to implementation
4. ✓ QA validation loop works (traced)
5. ✓ Session continuity works (verified)
6. ✓ Documentation is complete and accurate
7. ✓ No blocker issues remain open

---

## Getting Started

Begin by reading:
1. `CLAUDE.md` — Full system specification
2. `/docs/error-handling.md` — Error taxonomy
3. `/docs/context-management.md` — Session persistence
4. `.claude/chains/full-pipeline.md` — Workflow definition

Then start with Task 7.6 (Consistency Audit) — it will reveal structural issues that inform all other tests.

---

## Notes on Simulation

Since this is a dry run without a real codebase:

- **"Implement" phase** traces what the Developer agent would do, not actual code
- **"Validate" phase** traces what qa-validator would check, not actual test runs
- **Artifacts** are verified against templates, not generated fresh
- **Focus** is on workflow completeness and internal consistency

The goal is to validate the *design* is sound so that when Prism is used on a real project, it works as intended.

---

## Questions?

If you find issues that require design decisions (not just fixes), pause and document the decision needed. Phase 7 should surface problems, not make architectural changes without review.
