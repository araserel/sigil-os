---
name: sprint-planner
description: Organizes tasks into time-boxed sprints based on team capacity. Invoke when user requests sprint planning, mentions Scrum, or needs capacity-based scheduling.
version: 1.0.0
category: workflow
chainable: true
invokes: []
invoked_by: [task-planner, orchestrator]
tools: Read, Write, Glob
---

# Skill: Sprint Planner

## Purpose

Organize Sigil OS tasks or user stories into time-boxed sprints for teams using Scrum or sprint-based workflows. Handles capacity planning, dependency ordering, and sprint goal definition.

## When to Invoke

- User requests "sprint planning" or "organize into sprints"
- User mentions Scrum, sprints, or iterations
- Feature spans multiple weeks of work
- Task Planner identifies sprint-based workflow
- Enterprise track requires formal sprint planning

## Inputs

**Required:**
- `tasks_path`: string — Path to tasks.md or stories.md

**Optional:**
- `sprint_length`: number — Days per sprint (default: 14)
- `team_capacity`: number — Points or hours per sprint (default: 20 points)
- `capacity_unit`: string — "points" | "hours" (default: "points")
- `start_date`: string — Sprint 1 start date (default: next Monday)
- `buffer_percent`: number — Reserved capacity buffer (default: 10)
- `max_sprints`: number — Planning horizon limit (default: 6)
- `spec_path`: string — For feature context

**Auto-loaded:**
- `project_context`: string — `/memory/project-context.md`

## Process

### Step 1: Load and Analyze Work

```
1. Read tasks/stories from source file
2. Calculate total work (points or hours)
3. Map dependencies between items
4. Identify critical path
5. Note parallelization opportunities
```

### Step 2: Capacity Calculation

```
Effective Capacity = Team Capacity × (1 - Buffer Percent)

Example:
  Team Capacity: 20 points
  Buffer: 10%
  Effective: 20 × 0.9 = 18 points/sprint
```

### Step 3: Sprint Allocation

Algorithm:

```
1. Start with Sprint 1
2. Add items respecting:
   a. Dependencies (blockers must be in earlier sprint)
   b. Capacity limits (don't exceed effective capacity)
   c. Logical grouping (related items together)
3. When sprint full, advance to next sprint
4. Repeat until all items allocated
```

### Step 4: Dependency Validation

```
For each sprint:
  1. Verify no item depends on items in same or later sprint
  2. If violation found:
     - Move dependency to earlier sprint
     - Rebalance affected sprints
  3. Flag items that force rebalancing
```

### Step 5: Sprint Goal Definition

For each sprint, derive a goal:

```
1. Identify the primary deliverable
2. Express as user-facing outcome
3. Keep to one sentence
4. Avoid listing tasks—focus on value
```

**Examples:**
- ✓ "Users can log in and manage their sessions"
- ✓ "Checkout flow is complete and payments work"
- ✗ "Complete T001, T002, T003, T004"

### Step 6: Risk Assessment

Identify risks per sprint:

```
- Tight coupling (delay in X blocks Y)
- Single point of failure (one critical item)
- External dependencies (API, third-party)
- Uncertainty (items needing research)
- Overcommitment (>90% capacity)
```

### Step 7: Generate Output

Write sprint plan to spec directory.

## Outputs

### Sprint Plan Document

```markdown
# Sprint Plan: [Feature Name]

## Configuration

| Setting | Value |
|---------|-------|
| Sprint Length | 2 weeks |
| Team Capacity | 20 points/sprint |
| Buffer | 10% (2 points) |
| Effective Capacity | 18 points/sprint |
| Start Date | 2026-01-27 |

## Summary

| Sprint | Dates | Points | Utilization | Goal |
|--------|-------|--------|-------------|------|
| 1 | Jan 27 - Feb 9 | 17 | 94% | Auth infrastructure complete |
| 2 | Feb 10 - Feb 23 | 16 | 89% | Login and registration working |
| 3 | Feb 24 - Mar 9 | 12 | 67% | Password management and polish |

**Total:** 45 points across 3 sprints
**Buffer Used:** 6 points (11% of capacity)
**Completion Date:** March 9, 2026

---

## Sprint 1: Foundation

**Dates:** January 27 - February 9, 2026
**Capacity:** 17/18 points (94%)

**Sprint Goal:**
> Authentication infrastructure is complete and ready for UI integration.

### Committed Items

| ID | Description | Points | Depends On | Status |
|----|-------------|--------|------------|--------|
| T001 | Set up auth module structure | 2 | — | ⬜ |
| T002 | Create User model and migration | 3 | — | ⬜ |
| T003 | Implement password hashing | 2 | T002 | ⬜ |
| T004 | Create session management | 3 | T002 | ⬜ |
| T005 | Build auth API routes | 5 | T003, T004 | ⬜ |
| T006 | Add rate limiting | 2 | T005 | ⬜ |

### Parallelization

```
Week 1: T001 ─────────────────┐
        T002 ─────────────────┤
                              ├──> T005 (Week 2)
        T003 (after T002) ────┤
        T004 (after T002) ────┘

Week 2: T005 ─────────────────┬──> T006
```

### Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| T005 is blocking (5 pts) | High | Start early, pair if needed |
| Rate limiting unfamiliar | Medium | Research before sprint starts |

### Sprint 1 Deliverable

By end of sprint, the following should be true:
- [ ] User model exists with password hashing
- [ ] Sessions can be created and validated
- [ ] Auth API endpoints respond correctly
- [ ] Rate limiting prevents brute force

---

## Sprint 2: Core Flows

**Dates:** February 10 - February 23, 2026
**Capacity:** 16/18 points (89%)

**Sprint Goal:**
> Users can register, log in, and log out successfully.

### Committed Items

| ID | Description | Points | Depends On | Status |
|----|-------------|--------|------------|--------|
| T007 | Login form component | 3 | T005 | ⬜ |
| T008 | Registration form component | 3 | T005 | ⬜ |
| T009 | Auth state management | 2 | T007 | ⬜ |
| T010 | Protected route wrapper | 2 | T009 | ⬜ |
| T011 | Logout functionality | 1 | T009 | ⬜ |
| T012 | Error handling UI | 2 | T007, T008 | ⬜ |
| T013 | Form validation | 3 | T007, T008 | ⬜ |

### Parallelization

```
T007 (Login) ────┬──> T009 ──> T010
                 │         └──> T011
T008 (Register) ─┤
                 └──> T012
                 └──> T013
```

### Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Form components share patterns | Low | Build login first, reuse for registration |

### Sprint 2 Deliverable

By end of sprint, the following should be true:
- [ ] Users can register with email/password
- [ ] Users can log in and see authenticated state
- [ ] Users can log out
- [ ] Invalid inputs show appropriate errors

---

## Sprint 3: Polish

**Dates:** February 24 - March 9, 2026
**Capacity:** 12/18 points (67%)

**Sprint Goal:**
> Password management is complete and auth system is production-ready.

### Committed Items

| ID | Description | Points | Depends On | Status |
|----|-------------|--------|------------|--------|
| T014 | Forgot password flow | 5 | T005 | ⬜ |
| T015 | Password reset page | 3 | T014 | ⬜ |
| T016 | Email verification | 2 | T005 | ⬜ |
| T017 | Security audit | 2 | All | ⬜ |

### Buffer Available

6 points available for:
- Bug fixes from Sprint 2
- Additional polish
- Unexpected complexity

### Sprint 3 Deliverable

By end of sprint, the following should be true:
- [ ] Users can reset forgotten passwords
- [ ] Emails are verified before full access
- [ ] Security review completed
- [ ] Ready for production deployment

---

## Critical Path

```
T002 → T003 → T005 → T007 → T009 → T010
       └────→ T004 ─┘
```

**Critical items:** T002, T005, T009 — delays here delay the entire feature.

---

## Velocity Tracking

| Sprint | Planned | Completed | Velocity |
|--------|---------|-----------|----------|
| 1 | 17 | — | — |
| 2 | 16 | — | — |
| 3 | 12 | — | — |

*Update as sprints complete*

---

## Adjustments Log

| Date | Change | Reason |
|------|--------|--------|
| — | — | — |

*Log scope changes, rebalancing, and velocity adjustments*
```

### Handoff Data

```json
{
  "sprint_plan_path": "/specs/001-feature/sprint-plan.md",
  "tasks_path": "/specs/001-feature/tasks.md",
  "configuration": {
    "sprint_length_days": 14,
    "team_capacity": 20,
    "capacity_unit": "points",
    "buffer_percent": 10,
    "start_date": "2026-01-27"
  },
  "summary": {
    "total_sprints": 3,
    "total_points": 45,
    "completion_date": "2026-03-09",
    "average_utilization": 83
  },
  "sprints": [
    {
      "number": 1,
      "goal": "Auth infrastructure complete",
      "points": 17,
      "items": ["T001", "T002", "T003", "T004", "T005", "T006"],
      "start_date": "2026-01-27",
      "end_date": "2026-02-09"
    }
  ],
  "critical_path": ["T002", "T005", "T009"],
  "risks": [
    {
      "sprint": 1,
      "risk": "T005 is blocking",
      "impact": "high"
    }
  ]
}
```

## Capacity Guidelines

### Points-Based (Recommended)

| Team Size | Suggested Capacity/Sprint |
|-----------|--------------------------|
| 1 developer | 8-12 points |
| 2 developers | 16-24 points |
| 3 developers | 24-36 points |
| Team (4+) | 40+ points |

### Hours-Based

| Sprint Length | Hours/Person (80% allocation) |
|---------------|-------------------------------|
| 1 week | 32 hours |
| 2 weeks | 64 hours |

## Sprint Configuration Options

| Option | Values | Default | Notes |
|--------|--------|---------|-------|
| Sprint length | 7-28 days | 14 | Standard is 2 weeks |
| Capacity unit | points, hours | points | Points preferred for estimation |
| Buffer | 0-30% | 10% | Higher for new teams |
| Max sprints | 1-12 | 6 | Longer horizons less accurate |

## Rebalancing Rules

When items don't fit cleanly:

1. **Prefer earlier completion** — Don't stretch to fill sprints
2. **Respect dependencies** — Never put dependency after dependant
3. **Maintain slack** — Keep buffer for unknowns
4. **Group related work** — Better to complete features than split them

## Human Checkpoints

- **Tier:** Review (user reviews sprint plan before committing)
- User confirms capacity assumptions
- User approves sprint goals
- Team reviews before sprint starts

## Error Handling

| Error | Resolution |
|-------|------------|
| Total work exceeds max sprints | Warn about long timeline, suggest phasing |
| Circular dependencies | Flag and request clarification |
| Single item > sprint capacity | Suggest breaking down the item |
| No capacity specified | Use default (20 points/2 weeks) |

## Example Invocations

**Basic sprint planning:**
```
User: Plan sprints for these tasks

→ sprint-planner uses defaults (2-week sprints, 20 points)
→ Generates sprint plan with goals and assignments
→ Returns completion date estimate
```

**Custom capacity:**
```
User: Create sprint plan with 30 points capacity and 1-week sprints

→ sprint-planner applies custom settings
→ Adjusts sprint count accordingly
→ Notes higher velocity assumptions
```

**With start date:**
```
User: Plan sprints starting February 1st

→ sprint-planner calculates all sprint dates
→ Aligns with provided start date
→ Shows calendar-based completion
```

## Integration Points

- **Invoked by:** `task-planner` for Scrum teams
- **Receives from:** `task-decomposer` or `story-preparer`
- **Works with:** `story-preparer` for story-based sprints
- **Outputs to:** Sprint tracking, team calendars

## Notes

- Sprint plans are estimates—adjust as you learn velocity
- First sprint is often slower (learning, setup)
- Track actual vs. planned for future accuracy
- Review and adjust after each sprint

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-25 | Initial release - full implementation |
| 0.1.0-stub | 2026-01-16 | Stub created |
