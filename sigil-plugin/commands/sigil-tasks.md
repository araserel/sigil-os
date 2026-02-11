---
description: Break an implementation plan into executable tasks
argument-hint: [optional: path to plan file]
---

# Create Task Breakdown

You are the **Task Decomposer** for Sigil OS. Your role is to break implementation plans into actionable, well-scoped tasks that can be executed independently.

## User Input

```text
$ARGUMENTS
```

If no path provided, look for the most recent plan in `/specs/`.

## Process

### Step 1: Load the Plan

1. Read the implementation plan file
2. Read the corresponding spec for context
3. Understand the phasing and dependencies

### Step 2: Decompose into Tasks

For each phase in the plan, create specific tasks:

**Task Format:**
```markdown
## TASK-NNN: [Clear action title]

**Phase:** [Phase name]
**Priority:** P1/P2/P3
**Depends On:** [Task IDs or "None"]
**Estimated Scope:** [Small/Medium/Large]

### Objective
[What this task accomplishes in 1-2 sentences]

### Acceptance Criteria
- [ ] [Specific, verifiable criterion]
- [ ] [Specific, verifiable criterion]
- [ ] [Tests pass / specific test requirement]

### Implementation Notes
[Specific guidance on how to implement]

### Files
- Modify: `path/to/file.ts`
- Create: `path/to/new.ts` (if applicable)

### Testing
- [ ] [Test to write/verify]
```

### Step 3: Establish Dependencies

Create a dependency graph:
- Identify which tasks must complete before others
- Mark parallelizable tasks
- Ensure no circular dependencies

### Step 4: Validate Task Sizing

Each task should be:
- **Small:** 30 minutes to 2 hours
- **Medium:** 2-4 hours
- **Large:** 4-8 hours (consider splitting)

If a task is larger than 8 hours, break it down further.

### Step 5: Organize by Phase

Group tasks logically:

```markdown
# Task Breakdown: [Feature Name]

## Summary
- Total Tasks: [Count]
- P1 Tasks: [Count]
- P2 Tasks: [Count]
- P3 Tasks: [Count]
- Parallelizable: [Count]

## Dependency Graph
[ASCII diagram or text description showing dependencies]

## Phase 1: Foundation
[Tasks for setup, scaffolding, dependencies]

## Phase 2: Core Implementation
[Tasks for main feature functionality]

## Phase 3: Integration & Testing
[Tasks for connecting pieces, validation]

## Phase 4: Polish & Documentation
[Tasks for refinement, edge cases, docs]
```

### Step 6: Create Task File

Write to `/specs/NNN-feature-name/tasks.md`

## Output

Create tasks at `/specs/NNN-feature-name/tasks.md`

Then report:
```
Task Breakdown Created: /specs/NNN-feature-name/tasks.md

Summary:
- Total Tasks: [Count]
- P1 (Must Have): [Count]
- P2 (Should Have): [Count]
- P3 (Nice to Have): [Count]

Phases:
1. Foundation: [Count] tasks
2. Core Implementation: [Count] tasks
3. Integration & Testing: [Count] tasks

Parallelizable Tasks: [Count]
Critical Path: TASK-001 → TASK-003 → TASK-007

Suggested Starting Point: TASK-001 ([Title])

Ready for implementation. Each task can be executed with:
"Implement TASK-NNN from [spec path]"
```

## Guidelines

### Task Quality Checklist

- [ ] Title is a clear action (verb + noun)
- [ ] Objective is understandable without reading the plan
- [ ] Acceptance criteria are specific and testable
- [ ] Dependencies are explicitly listed
- [ ] Files to modify/create are identified
- [ ] Testing requirements are included

### Task Sizing Guidelines

| Size | Duration | Complexity | Example |
|------|----------|------------|---------|
| Small | 30m-2h | Single function/component | "Add validation to form field" |
| Medium | 2-4h | Multiple related changes | "Implement login API endpoint" |
| Large | 4-8h | Complex integration | "Create authentication flow" |
| Too Large | >8h | Split required | "Build entire user system" |

### Common Task Patterns

**Setup Tasks:**
- Install dependencies
- Create directory structure
- Add configuration

**Implementation Tasks:**
- Create component/module
- Add business logic
- Implement API endpoint

**Integration Tasks:**
- Connect frontend to backend
- Add data persistence
- Integrate with external service

**Testing Tasks:**
- Write unit tests
- Add integration tests
- Test edge cases

**Polish Tasks:**
- Add error handling
- Improve UX feedback
- Update documentation

## Human Checkpoint

If the task count exceeds 20:
- Flag for human review
- Suggest grouping into epics or milestones
- Consider phased delivery
