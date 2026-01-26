---
description: Create a technical implementation plan from a clarified specification
argument-hint: [optional: path to spec file]
---

# Create Implementation Plan

You are the **Technical Planner** for Prism OS. Your role is to transform clarified specifications into actionable technical plans that developers (or AI agents) can execute.

## User Input

```text
$ARGUMENTS
```

If no path provided, look for the most recently modified spec in `/specs/`.

## Process

### Step 1: Load Context

1. Read the spec file and any clarifications
2. Read `/memory/constitution.md` for technical constraints
3. Read `/memory/project-context.md` for existing architecture
4. Scan the codebase for relevant existing patterns

### Step 2: Verify Spec Readiness

Check that:
- No unresolved `[NEEDS CLARIFICATION]` markers
- All P1 requirements have acceptance criteria
- Success criteria are defined

If not ready, suggest running `/clarify` first.

### Step 3: Research Phase

Analyze the codebase to understand:
- Existing patterns and conventions
- Similar features already implemented
- Integration points
- Testing patterns in use
- Dependencies and constraints

### Step 4: Design Technical Approach

For each requirement, determine:
- **Implementation Strategy:** How to build it
- **Files Affected:** Which files to modify/create
- **Dependencies:** What needs to exist first
- **Risks:** Potential challenges
- **Alternatives:** Other approaches considered

### Step 5: Create Implementation Plan

Using `/templates/plan-template.md`, create a plan with:

```markdown
# Implementation Plan: [Feature Name]

## Overview
[Brief technical summary]

## Requirements Mapping
| Requirement | Implementation Approach |
|-------------|------------------------|
| FR-001 | [How to implement] |
| FR-002 | [How to implement] |

## Technical Design

### Architecture
[How this fits into the existing system]

### Data Model
[Any new entities or changes to existing ones]

### API/Interface Changes
[New endpoints, UI components, etc.]

## Implementation Phases

### Phase 1: Foundation
- [Task 1]: [Description]
- [Task 2]: [Description]

### Phase 2: Core Implementation
- [Task 3]: [Description]
- [Task 4]: [Description]

### Phase 3: Integration & Testing
- [Task 5]: [Description]
- [Task 6]: [Description]

## Files to Modify
- `path/to/file.ts` - [What changes]
- `path/to/other.ts` - [What changes]

## New Files to Create
- `path/to/new.ts` - [Purpose]

## Dependencies
- [External library or feature this depends on]

## Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk] | [Impact level] | [How to address] |

## Testing Strategy
- Unit tests for [components]
- Integration tests for [workflows]
- Edge cases: [list]

## Constitution Compliance
- [How each article is addressed]
```

### Step 6: Validate Plan

Check against constitution gates:
- Simplicity: Is this the simplest solution?
- Security: Are security requirements met?
- Accessibility: Are accessibility requirements addressed?
- Testing: Is the testing strategy adequate?

### Step 7: Document Decisions

If significant architectural decisions were made, create ADR:
- `/specs/NNN-feature-name/adr/ADR-001-[decision].md`

## Output

Create the plan at `/specs/NNN-feature-name/plan.md`

Then report:
```
Implementation Plan Created: /specs/NNN-feature-name/plan.md

Phases: [Count]
Total Tasks: [Count]
Files Affected: [Count]
New Files: [Count]

Key Decisions:
- [Decision 1]
- [Decision 2]

Risks Identified: [Count]
- [Major risk, if any]

Next Steps:
- Review the plan
- Run /tasks to create task breakdown
```

## Guidelines

- Plans should be executable by developers unfamiliar with the project
- Include enough context for each task to be worked independently
- Reference specific file paths and code patterns
- Consider test-first development approach
- Don't over-engineer - match complexity to requirements
- Flag any constitution violations for discussion

## Human Checkpoint

The plan should be reviewed before proceeding to task breakdown.
User confirms approach before running `/tasks`.
