# Handoff Template

> Standard format for agent-to-agent work transitions.

---

## Handoff: [Source Agent] → [Target Agent]

**Feature:** [Feature name]
**Timestamp:** [Date/time]
**Workflow Track:** [Quick | Standard | Enterprise]
**Phase Transition:** [Source Phase] → [Target Phase]

---

### Completed

Summary of work completed by source agent:

- [Work item 1]
- [Work item 2]
- [Work item 3]

---

### Artifacts

Files and documents created or modified:

| Artifact | Path | Status |
|----------|------|--------|
| [Name] | `/path/to/file` | Created/Modified |
| [Name] | `/path/to/file` | Created/Modified |

---

### For Your Action

Specific tasks for the receiving agent:

1. [ ] [First action item]
2. [ ] [Second action item]
3. [ ] [Third action item]

**Priority:** [What's most important]

---

### Context

Relevant information for the receiving agent:

#### Decisions Made
- [Decision 1]: [Rationale]
- [Decision 2]: [Rationale]

#### Constraints
- [Constraint from constitution or spec]
- [Constraint from previous phase]

#### Open Questions
- [Any unresolved items to be aware of]

#### Concerns
- [Potential issues to watch for]

---

### State Transfer

```json
{
  "chain_id": "[Unique workflow ID]",
  "spec_path": "[Path to spec]",
  "track": "[Quick | Standard | Enterprise]",
  "iteration_counts": {
    "clarifier": 0,
    "qa_fixer": 0
  },
  "approvals": {
    "spec": true,
    "plan": false
  },
  "blocking_issues": [],
  "qa_fix_metadata": {
    "implementation_modified": false,
    "files_changed_classified": {},
    "fix_loop_summary": ""
  },
  "error_state": {
    "has_error": false,
    "current_error": null,
    "errors_resolved": []
  }
}
```

#### Error State Fields

When errors occur, populate the error state:

```json
{
  "error_state": {
    "has_error": true,
    "current_error": {
      "error_code": "[CATEGORY]-[NUMBER]",
      "error_category": "soft | hard | blocking",
      "error_source": "[Agent or Skill]",
      "error_summary": "[Brief description]",
      "recovery_needed": "[What must happen to proceed]"
    },
    "errors_resolved": [
      {
        "error_code": "[Code]",
        "resolution": "[How it was resolved]",
        "resolved_at": "[Timestamp]"
      }
    ]
  }
}
```

See [Error Handling Protocol](/docs/error-handling.md) for full error taxonomy.

---

## Handoff Types

### Specify → Clarify
```markdown
## Handoff: Business Analyst → Business Analyst (Clarify Mode)

### Completed
- Initial specification created

### Artifacts
- /specs/###-feature/spec.md

### For Your Action
- Resolve [N] identified ambiguities
- Update spec with clarifications

### Context
- Ambiguities: [List of flagged items]
```

### Clarify → Plan
```markdown
## Handoff: Business Analyst → Architect

### Completed
- Specification finalized
- [N] clarifications resolved

### Artifacts
- /specs/###-feature/spec.md
- /specs/###-feature/clarifications.md

### For Your Action
- Create implementation plan
- Research any technical unknowns
- Identify ADR-worthy decisions

### Context
- Track: [Track]
- User priorities: [Key priorities]
```

### Plan → Tasks
```markdown
## Handoff: Architect → Task Planner

### Completed
- Implementation plan created
- Constitution gates passed
- [N] ADRs documented

### Artifacts
- /specs/###-feature/plan.md
- /specs/###-feature/research.md (if applicable)
- /specs/###-feature/adr/ (if applicable)

### For Your Action
- Break plan into executable tasks
- Identify dependencies
- Mark parallelization opportunities

### Context
- Risk level: [Low | Medium | High]
- Key decisions: [Brief list]
```

### Tasks → Implement
```markdown
## Handoff: Task Planner → Developer

### Completed
- [N] tasks created
- Dependencies identified
- First task prepared

### Artifacts
- /specs/###-feature/tasks.md

### For Your Action
- Execute T001: [Task name]
- Follow test-first pattern
- Mark complete when criteria met

### Context
- First task: T001 [details]
- Parallelizable: [P] tasks [list]
```

### Implement → Validate
```markdown
## Handoff: Developer → QA Engineer

### Completed
- Task T### implemented
- [N] files changed
- [N] tests added

### Artifacts
- [List of changed files]

### For Your Action
- Run validation checks
- Verify acceptance criteria
- Report any issues

### Context
- Acceptance criteria: [List]
- Test coverage: [What's tested]
```

### Validate → Review
```markdown
## Handoff: QA Engineer → Security / Code Reviewer

### Completed
- All tasks validated
- [N] fix cycles completed
- Quality gates passed

### Artifacts
- /qa/feature-validation.md
- All implementation files

### For Your Action
- Complete code review
- Security scan (if applicable)
- Final approval

### Context
- Track: [Track]
- Risk level: [Level]
- Sensitive: [Yes/No]
- Implementation modified by QA: [Yes/No]
```

---

## Handoff Validation

Receiving agent should verify:

- [ ] All listed artifacts exist and are accessible
- [ ] Context is sufficient to proceed
- [ ] No blocking issues prevent continuation
- [ ] Handoff format is complete

If validation fails, return to source agent with specific issues.

---

## Audit Trail

Each handoff is logged:

```
[Timestamp] Handoff: [Source] → [Target]
  Feature: [Name]
  Phase: [Source Phase] → [Target Phase]
  Artifacts: [Count]
  Status: [Accepted | Rejected]
```

Handoff history stored in workflow state for debugging and process improvement.
