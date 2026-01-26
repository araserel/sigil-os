# Skill: Knowledge Search

> **Status:** NOT YET IMPLEMENTED
>
> This skill is planned but not yet functional. References exist in:
> - `CLAUDE.md` (Section 6: Skills - Research category)

---

## Purpose

Search the project's accumulated knowledge base to find relevant context, past decisions, and existing patterns before starting new work.

---

## Intended Behavior

### When Invoked

Any agent may invoke this skill when:
- Starting work on a new feature that may relate to existing work
- Checking for established patterns before proposing new ones
- Looking up past decisions that might apply
- Finding reusable components or approaches

### Expected Capabilities

1. **Specification Search**
   - Search completed specifications for similar features
   - Find related user scenarios
   - Identify overlapping requirements

2. **Decision Search**
   - Search ADRs for relevant past decisions
   - Find constitution articles that apply
   - Locate clarification answers that set precedent

3. **Pattern Search**
   - Find established code patterns in the project
   - Identify reusable components
   - Locate similar implementations

4. **Context Assembly**
   - Compile relevant findings into actionable context
   - Rank results by relevance
   - Summarize key points for agent use

---

## Planned Input

```markdown
**Query:** [What to search for]
**Scope:** [specs | decisions | code | all]
**Feature Context:** [Current feature being worked on]
**Agent:** [Who is asking]
```

---

## Planned Output

```markdown
## Knowledge Search Results

**Query:** [Original query]
**Scope:** [What was searched]
**Results Found:** [Count]

---

### Relevant Specifications

#### /specs/002-payment-processing/spec.md (85% relevant)
- **Summary:** Handles payment submission and verification
- **Relevant Section:** "Error Handling" (lines 45-67)
- **Why Relevant:** Similar validation pattern needed

#### /specs/001-user-auth/spec.md (70% relevant)
- **Summary:** User authentication feature
- **Relevant Section:** "Security Requirements"
- **Why Relevant:** Same security tier

---

### Relevant Decisions

#### ADR-G002: Validation Library Choice (95% relevant)
- **Decision:** Use Zod for all validation
- **Applies Because:** Current feature needs validation
- **Implication:** Must use Zod, not Yup or custom

#### Constitution Article 4 (80% relevant)
- **Content:** Error messages must be user-friendly
- **Applies Because:** Feature has user-facing errors

---

### Relevant Patterns

#### /src/lib/validators/payment.ts (90% relevant)
- **Pattern:** Zod schema with custom error messages
- **Reusable:** Yes, same approach applicable
- **Lines:** 12-45

---

### Summary for [Agent]

Based on this search, when working on [current feature]:
1. Use Zod for validation (ADR-G002)
2. Follow error message pattern from payment validator
3. Review auth spec security section for consistency

**Confidence:** High (multiple corroborating sources)
```

---

## Search Locations

| Scope | Searches |
|-------|----------|
| specs | `/specs/**/*.md` |
| decisions | `/specs/**/adr/*.md`, `/memory/constitution.md` |
| code | `/src/**/*.{ts,tsx,js,jsx}` |
| docs | `/docs/**/*.md` |
| all | All of the above |

---

## Implementation Notes

When implemented, this skill should:
- Use semantic search where possible (not just keyword)
- Cache recent searches for efficiency
- Provide relevance scoring with explanations
- Integrate with researcher skill for web context
- Respect project boundaries (don't search outside project)

---

## Related Components

- **Invoked by:** Any agent needing context
- **Works with:** researcher (for external knowledge)
- **Outputs to:** Requesting agent's context

---

*Stub created: 2026-01-16*
*Implementation pending*
