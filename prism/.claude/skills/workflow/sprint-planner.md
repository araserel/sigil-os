---
name: sprint-planner
version: 0.1.0-stub
status: NOT_IMPLEMENTED
description: Sprint planning and capacity allocation (stub)
invoked_by: [task-planner, orchestrator]
tools: [Read, Write]
---

# Skill: Sprint Planner

> **Status:** NOT YET IMPLEMENTED
>
> This skill is planned but not yet functional. References exist in:
> - `.claude/agents/task-planner.md`

---

## Purpose

Organize Prism OS tasks into time-boxed sprints for teams using Scrum or sprint-based workflows.

---

## Intended Behavior

### When Invoked

The Task Planner invokes this skill when:
- User requests sprint-based organization
- Team uses Scrum methodology
- Feature spans multiple sprints
- Enterprise track requires sprint planning

### Expected Capabilities

1. **Sprint Organization**
   - Group tasks into sprints based on capacity
   - Respect task dependencies across sprints
   - Balance sprint workloads

2. **Capacity Planning**
   - Accept team velocity/capacity input
   - Calculate sprint capacity utilization
   - Flag over-committed sprints

3. **Sprint Boundaries**
   - Ensure sprints have achievable goals
   - Identify sprint milestones
   - Define sprint deliverables

---

## Planned Input

```markdown
**Tasks:** [List from task-decomposer]
**Sprint Length:** [1 week | 2 weeks | etc.]
**Team Capacity:** [Points per sprint OR hours per sprint]
**Start Date:** [Optional]
**Constraints:** [Any fixed deadlines or dependencies]
```

---

## Planned Output

```markdown
## Sprint Plan: [Feature Name]

### Configuration
- **Sprint Length:** 2 weeks
- **Team Capacity:** 20 points/sprint
- **Start Date:** 2025-01-20

---

### Sprint 1: Foundation
**Dates:** Jan 20 - Feb 2
**Capacity:** 18/20 points (90%)

**Goal:** Complete authentication infrastructure

**Tasks:**
| ID | Description | Points | Depends On |
|----|-------------|--------|------------|
| T001 | NextAuth configuration | 3 | — |
| T002 | Database schema | 5 | — |
| T003 | Run migration | 2 | T002 |
| T004 | Validation schemas | 3 | — |
| T005 | API route setup | 5 | T001 |

**Deliverable:** Auth infrastructure ready for UI work

---

### Sprint 2: Core Features
**Dates:** Feb 3 - Feb 16
**Capacity:** 19/20 points (95%)

**Goal:** Complete login and registration flows

**Tasks:**
[Similar table]

**Deliverable:** Users can register and log in

---

### Sprint 3: [Name]
[Same structure]

---

## Summary

| Sprint | Points | Tasks | Key Deliverable |
|--------|--------|-------|-----------------|
| 1 | 18 | 5 | Auth infrastructure |
| 2 | 19 | 6 | Login/registration |
| 3 | 15 | 4 | Password management |

**Total:** 52 points across 3 sprints
**Buffer:** 7 points unused (12% buffer)

---

## Risks

- Sprint 2 has tight coupling — delay in T005 blocks 3 tasks
- Consider splitting T008 if it exceeds estimate
```

---

## Sprint Configuration Options

| Option | Values | Default |
|--------|--------|---------|
| Sprint length | 1-4 weeks | 2 weeks |
| Capacity unit | Points or hours | Points |
| Buffer percentage | 0-30% | 10% |
| Planning horizon | 1-6 sprints | All needed |

---

## Implementation Notes

When implemented, this skill should:
- Integrate with story-preparer for story-based sprints
- Support re-planning when tasks slip
- Maintain alignment with Prism OS task IDs
- Export to calendar or project management tools

---

## Related Components

- **Invoked by:** Task Planner
- **Works with:** task-decomposer, story-preparer
- **Outputs to:** Sprint plan (inline or exported)

---

*Stub created: 2026-01-16*
*Implementation pending*
