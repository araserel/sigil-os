---
name: adr-writer
version: 0.1.0-stub
status: NOT_IMPLEMENTED
description: Architecture Decision Record writer (stub)
invoked_by: [technical-planner, architect]
tools: [Read, Write]
---

# Skill: ADR Writer

> **Status:** NOT YET IMPLEMENTED
>
> This skill is planned but not yet functional. References exist in:
> - `.claude/agents/architect.md`
> - `.claude/chains/full-pipeline.md`
> - `CLAUDE.md` (Section 6: Skills)

---

## Purpose

Create Architecture Decision Records (ADRs) to document significant technical decisions made during the planning phase.

---

## Intended Behavior

### When Invoked

The Architect invokes this skill when:
- A significant technical choice must be made (database, framework, pattern)
- Multiple valid approaches exist with meaningful trade-offs
- The decision has long-term implications
- Enterprise track features require formal decision documentation

### Expected Capabilities

1. **Decision Documentation**
   - Capture context (why this decision is needed)
   - Document options considered
   - Record trade-offs for each option
   - State the decision and rationale

2. **ADR Formatting**
   - Follow standard ADR format (context, decision, consequences)
   - Assign ADR numbers sequentially
   - Link to related specifications and plans
   - Include status (proposed, accepted, deprecated, superseded)

3. **Integration with Planning**
   - Output ADRs to `/specs/{feature}/adr/` directory
   - Reference ADRs in implementation plan
   - Track which decisions are pending human approval

---

## Planned Input

```markdown
**Decision Needed:** [Short description]
**Context:** [Why this decision must be made]
**Options:**
- Option A: [Description]
- Option B: [Description]
- Option C: [Description]
**Constraints:** [Any limiting factors]
**Recommendation:** [If any]
```

---

## Planned Output

```markdown
# ADR-NNN: [Decision Title]

## Status

[Proposed | Accepted | Deprecated | Superseded]

## Context

[Why this decision is necessary. What forces are at play.]

## Decision

We will [decision statement].

## Options Considered

### Option A: [Name]
- **Description:** [What this means]
- **Pros:** [Benefits]
- **Cons:** [Drawbacks]

### Option B: [Name]
- **Description:** [What this means]
- **Pros:** [Benefits]
- **Cons:** [Drawbacks]

### Option C: [Name]
[Same structure]

## Consequences

### Positive
- [Good outcome]
- [Good outcome]

### Negative
- [Trade-off or downside]
- [Trade-off or downside]

### Neutral
- [Neither good nor bad, just different]

## Related

- **Specification:** /specs/{feature}/spec.md
- **Plan:** /specs/{feature}/plan.md
- **Supersedes:** [Previous ADR if applicable]

---

*Decision made: [Date]*
*Decision maker: [Human who approved]*
```

---

## ADR Numbering

ADRs are numbered sequentially per feature:
- `ADR-001`: First decision for this feature
- `ADR-002`: Second decision for this feature

Global project ADRs (cross-feature) use prefix `G`:
- `ADR-G001`: First global architecture decision

---

## Human Checkpoint

ADRs require human approval before implementation proceeds:
- **Tier:** Review (for Standard track)
- **Tier:** Approve (for Enterprise track)

The Architect presents the ADR with a recommendation and awaits user decision.

---

## Implementation Notes

When implemented, this skill should:
- Follow the template at `/templates/adr-template.md` (to be created)
- Create ADR files in the appropriate directory
- Update the implementation plan to reference decisions
- Track pending vs. accepted decisions in context

---

## Related Components

- **Invoked by:** Architect
- **Works with:** technical-planner
- **Outputs to:** `/specs/{feature}/adr/` directory
- **Human checkpoint:** Required before implementation

---

*Stub created: 2026-01-16*
*Implementation pending*
