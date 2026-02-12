---
name: adr-writer
description: Creates Architecture Decision Records to document significant technical decisions. Invoke when meaningful trade-offs exist between options.
version: 1.0.0
category: engineering
chainable: true
invokes: []
invoked_by: [technical-planner, architect]
tools: Read, Write, Glob
---

# Skill: ADR Writer

## Purpose

Document significant technical decisions using Architecture Decision Records (ADRs). Captures context, options, rationale, and consequences for decisions that have long-term implications.

## When to Invoke

- Technical choice between multiple valid approaches
- Decision has long-term or cross-feature implications
- Trade-offs exist that should be documented for future reference
- Architect identifies "ADR-worthy" decision during planning
- Enterprise track requires formal decision documentation
- User asks "why did we choose X over Y"

## Decision Triggers

Create an ADR when:

| Trigger | Example |
|---------|---------|
| Framework/library choice | "Use NextAuth vs. custom auth" |
| Architecture pattern | "Monolith vs. microservices" |
| Data model design | "Denormalize for performance" |
| API design | "REST vs. GraphQL" |
| Infrastructure choice | "Self-hosted vs. managed service" |
| Security approach | "JWT vs. session tokens" |
| Performance trade-off | "Cache aggressively vs. real-time" |

**Don't create ADRs for:**
- Obvious choices with no alternatives
- Minor implementation details
- Temporary workarounds
- Decisions already made in constitution

## Inputs

**Required:**
- `decision_title`: string — Short description of the decision
- `context`: string — Why this decision is needed

**Optional:**
- `options`: object[] — List of options with pros/cons
- `recommendation`: string — Preferred option with rationale
- `spec_path`: string — Related specification for linking
- `constraints`: string[] — Limiting factors
- `decision_drivers`: string[] — Criteria for evaluation

**Auto-loaded:**
- `constitution`: string — `/.sigil/constitution.md` (for constraint alignment)
- `existing_adrs`: string[] — Previous ADRs for numbering and linking

## Process

### Step 1: Determine ADR Number

```
1. Scan /.sigil/specs/{feature}/adr/ for existing ADRs
2. Get highest number, increment by 1
3. For global decisions, use G prefix and scan global ADRs
4. Format: ADR-001, ADR-002, or ADR-G001
```

### Step 2: Structure Context

Document the context clearly:

```
1. What problem needs solving?
2. Why is this decision needed now?
3. What constraints apply?
4. What prior decisions inform this one?
5. What decision drivers matter most?
```

### Step 3: Document Options

For each option:

```
1. Clear description of what the option means
2. Pros (benefits, strengths)
3. Cons (drawbacks, risks)
4. Effort level (Low/Medium/High)
5. Risk level (Low/Medium/High)
```

**Minimum options:** 2 (if only one option, no decision needed)
**Maximum options:** 4-5 (too many becomes overwhelming)

### Step 4: Evaluate Against Drivers

For each decision driver, assess how well each option satisfies it:

```
| Driver | Option A | Option B | Option C |
|--------|----------|----------|----------|
| Performance | ++ | + | +++ |
| Maintainability | +++ | ++ | + |
| Cost | + | ++ | + |
```

### Step 5: State Decision and Rationale

```
1. Clearly state the chosen option
2. Explain why it was chosen
3. Reference decision drivers
4. Acknowledge trade-offs being accepted
5. Note any conditions or caveats
```

### Step 6: Document Consequences

```
1. Positive consequences (what we gain)
2. Negative consequences (what we accept)
3. Neutral consequences (changes without value judgment)
```

### Step 7: Add Implementation Guidance

```
1. Affected areas of the codebase
2. Migration path (if changing existing behavior)
3. Rollback plan (if decision fails)
4. Success criteria (how we'll know it worked)
```

### Step 8: Create ADR File

```
1. Load template from /templates/adr-template.md
2. Fill in all sections
3. Write to /.sigil/specs/{feature}/adr/ADR-###-{slug}.md
4. Update plan.md to reference new ADR
```

## Outputs

### ADR Document

```markdown
# ADR-001: Use NextAuth for Authentication

> **Status:** Accepted
> **Date:** 2026-01-25
> **Decision Makers:** Product Team
> **Feature:** User Authentication

---

## Context

The application needs user authentication. We need to decide between building custom authentication or using an established library.

### Background

This is a new application with no existing auth. The team has experience with both approaches.

### Constraints

- Must support email/password login
- OAuth providers needed later (Google, GitHub)
- Session management required
- Must integrate with PostgreSQL

---

## Decision Drivers

1. **Time to market:** Need working auth within sprint
2. **Security:** Must follow best practices
3. **Extensibility:** OAuth providers coming in Phase 2
4. **Maintainability:** Team must understand the code

---

## Options Considered

### Option 1: NextAuth

**Description:** Use NextAuth.js library with credentials provider

**Pros:**
- Battle-tested security
- Built-in session management
- Easy OAuth addition later
- Large community support

**Cons:**
- Learning curve for customization
- Some magic/abstraction
- Upgrade dependencies periodically

**Effort:** Low
**Risk:** Low

---

### Option 2: Custom Implementation

**Description:** Build authentication from scratch using bcrypt, JWT

**Pros:**
- Full control over behavior
- No external dependencies
- Team learns deeply

**Cons:**
- Higher security risk
- Longer development time
- OAuth implementation complex

**Effort:** High
**Risk:** Medium

---

## Decision

**We will use Option 1: NextAuth**

### Rationale

NextAuth satisfies our time-to-market driver while maintaining security. The built-in OAuth support aligns with our Phase 2 plans. While custom auth offers more control, the security risks and development time outweigh the benefits for our use case.

### Trade-offs Accepted

- Accepting some abstraction in exchange for security
- Dependent on external library updates
- Must learn NextAuth patterns

---

## Consequences

### Positive

- Faster time to working auth
- Proven security model
- Easy OAuth expansion

### Negative

- Team less familiar with auth internals
- Locked into NextAuth patterns

### Neutral

- Standard session-based auth (neither better nor worse than JWT for our case)

---

## Implementation

### Affected Areas

| Area | Impact | Notes |
|------|--------|-------|
| /src/lib/auth | High | New NextAuth configuration |
| /src/pages/api/auth | High | Auth API routes |
| Database | Medium | Session table needed |

### Success Criteria

- [ ] Users can log in with email/password
- [ ] Sessions persist across browser restarts
- [ ] No security vulnerabilities in audit

### Review Date

**Scheduled Review:** After OAuth implementation (Phase 2)

---

## Related

- **Specification:** /.sigil/specs/001-user-auth/spec.md
- **Plan:** /.sigil/specs/001-user-auth/plan.md

---

*Created: 2026-01-25*
```

### Handoff Data

```json
{
  "adr_path": "/.sigil/specs/001-user-auth/adr/ADR-001-nextauth.md",
  "adr_number": "ADR-001",
  "decision_title": "Use NextAuth for Authentication",
  "status": "accepted",
  "chosen_option": "NextAuth",
  "options_count": 2,
  "decision_drivers": [
    "Time to market",
    "Security",
    "Extensibility",
    "Maintainability"
  ],
  "consequences": {
    "positive": 3,
    "negative": 2,
    "neutral": 1
  },
  "requires_approval": false,
  "related_spec": "/.sigil/specs/001-user-auth/spec.md",
  "review_date": "2026-03-01"
}
```

## ADR Status Lifecycle

```
Proposed → Accepted → [Active]
                   ↓
              Deprecated → Superseded
```

| Status | Meaning |
|--------|---------|
| **Proposed** | Decision documented but awaiting approval |
| **Accepted** | Decision approved and active |
| **Deprecated** | Decision no longer recommended |
| **Superseded** | Replaced by newer decision (link to new ADR) |

## ADR Numbering

### Feature ADRs

Sequential per feature:
- `ADR-001` — First decision for feature
- `ADR-002` — Second decision for feature

### Global ADRs

Cross-feature decisions use `G` prefix:
- `ADR-G001` — First project-wide decision
- `ADR-G002` — Second project-wide decision

### File Naming

```
ADR-{number}-{slug}.md

Examples:
ADR-001-use-nextauth.md
ADR-002-postgresql-schema-design.md
ADR-G001-typescript-strict-mode.md
```

## Human Checkpoints

| Track | Tier | Behavior |
|-------|------|----------|
| Quick Flow | N/A | ADRs rarely needed |
| Standard | Review | User reviews ADR, can approve or request changes |
| Enterprise | Approve | User must explicitly approve before proceeding |

## Presenting Decisions to Users

When recommending an option, present clearly:

```markdown
## Decision Needed: [Topic]

**Context:** [Why this matters, in plain language]

### Recommendation: Option A (NextAuth)

**Why:** [Brief rationale]
**Trade-off:** [What we're accepting]

### Alternative: Option B (Custom)

**Why you might prefer this:** [When it makes sense]
**Trade-off:** [What you'd accept]

**My recommendation is Option A. Would you like to proceed, or would you prefer to discuss further?**
```

## Error Handling

| Error | Resolution |
|-------|------------|
| No options provided | Cannot create ADR without alternatives |
| Single option | Ask if there are truly no alternatives |
| Directory doesn't exist | Create /.sigil/specs/{feature}/adr/ directory |
| Conflicting ADR number | Increment to next available |
| Constitution conflict | Flag the conflict, may need constitution update |

## Integration Points

- **Invoked by:** `architect` agent, `technical-planner` skill
- **Outputs to:** `/.sigil/specs/{feature}/adr/` directory
- **Referenced by:** Implementation plan
- **Updates:** Project context with pending decisions

## Best Practices

1. **Be specific** — "Use NextAuth" not "Use a library"
2. **Document honestly** — Include real cons, not just pros
3. **State trade-offs** — What are we accepting?
4. **Link related items** — Specs, plans, other ADRs
5. **Set review dates** — Decisions should be revisited
6. **Keep it scannable** — Busy people need quick understanding

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-25 | Initial release - full implementation |
| 0.1.0-stub | 2026-01-16 | Stub created |
