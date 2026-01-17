---
name: researcher
description: Conducts technical research for planning decisions. Invoke when planning requires information about unfamiliar technologies, patterns, or approaches.
version: 1.0.0
category: research
chainable: true
invokes: []
invoked_by: [technical-planner, architect]
tools: Read, Glob, Grep, WebFetch, WebSearch
---

# Skill: Researcher

## Purpose

Gather information needed for informed technical decisions. Searches internal codebase, external documentation, and web resources.

## When to Invoke

- Planning encounters unfamiliar technology
- Need to evaluate multiple approaches
- Best practices research required
- Integration documentation needed
- User requests "research [topic]"

## Inputs

**Required:**
- `research_questions`: string[] — Specific questions to answer

**Optional:**
- `context`: string — Why this research is needed
- `time_constraint`: string — Urgency level
- `sources_preference`: string — "internal" | "external" | "both"

**Auto-loaded:**
- `constitution`: string — Technology constraints from constitution

## Process

### Step 1: Question Analysis

For each research question:

```
1. Identify question type (how-to, comparison, best-practice, documentation)
2. Determine relevant sources
3. Identify key search terms
4. Note constitution constraints that apply
```

### Step 2: Internal Research

Search internal codebase first:

```
1. Search for existing implementations
2. Look for similar patterns
3. Check for documentation
4. Find relevant tests/examples
```

**Search Patterns:**
- Glob for file patterns
- Grep for code patterns
- Read relevant files
- Check /docs/ directory

### Step 3: External Research

If internal insufficient or external needed:

```
1. Search official documentation
2. Look for tutorials/guides
3. Check for security advisories
4. Find community best practices
```

**Source Priority:**
1. Official documentation
2. GitHub repos (popular, maintained)
3. Stack Overflow (high-voted)
4. Blog posts (recent, reputable)

### Step 4: Information Synthesis

For each question:

```
1. Compile relevant findings
2. Note source reliability
3. Identify consensus vs. debate
4. Flag outdated information
5. Extract actionable recommendations
```

### Step 5: Constitution Alignment

Check findings against constitution:

```
1. Do recommendations fit tech stack?
2. Any security concerns?
3. Complexity appropriate?
4. Dependencies acceptable?
```

### Step 6: Generate Report

```
1. Answer each question directly
2. Provide supporting evidence
3. Include source links
4. Note confidence level
5. Highlight risks or concerns
```

## Outputs

**Artifact:**
- `/specs/###-feature/research.md` — Research findings

**Handoff Data:**
```json
{
  "research_path": "/specs/001-feature/research.md",
  "questions_answered": 3,
  "questions_total": 3,
  "confidence_levels": {
    "Q1": "high",
    "Q2": "medium",
    "Q3": "high"
  },
  "sources_consulted": 12,
  "internal_sources": 3,
  "external_sources": 9,
  "recommendations": [
    "Use jose library for JWT handling",
    "Store refresh tokens in httpOnly cookies",
    "Implement token rotation for security"
  ],
  "risks_identified": [
    "Library X has known vulnerability in older versions"
  ],
  "constitution_conflicts": []
}
```

## Research Report Format

```markdown
# Research: [Topic]

> **Feature:** [/specs/###-feature/]
> **Requested By:** [technical-planner]
> **Date:** [DATE]

---

## Research Questions

1. [Question 1]
2. [Question 2]
3. [Question 3]

---

## Findings

### Q1: [Question]

**Answer:** [Direct answer]

**Evidence:**
- [Finding 1] — Source: [link]
- [Finding 2] — Source: [link]

**Confidence:** [High | Medium | Low]

**Notes:** [Any caveats or concerns]

---

### Q2: [Question]
...

---

## Recommendations

Based on research findings:

1. **[Recommendation 1]**
   - Rationale: [Why]
   - Risk: [Low | Medium | High]

2. **[Recommendation 2]**
   - Rationale: [Why]
   - Risk: [Low | Medium | High]

---

## Risks & Concerns

| Risk | Severity | Mitigation |
|------|----------|------------|
| [Risk] | [Low/Med/High] | [How to address] |

---

## Sources Consulted

### Internal
- [File/doc path] — [What it provided]

### External
- [URL] — [Title] — [Relevance]

---

## Constitution Alignment

- [x] Fits technology stack
- [x] No security concerns
- [x] Complexity appropriate
- [ ] [Any conflicts noted]
```

## Research Question Types

### How-To
"How do I implement [X] in [framework]?"

**Approach:**
1. Search official docs
2. Find tutorials
3. Look for examples in codebase

### Comparison
"Should we use [A] or [B]?"

**Approach:**
1. List criteria (from constitution)
2. Evaluate each option
3. Check community consensus
4. Consider maintenance burden

### Best Practice
"What's the recommended way to [X]?"

**Approach:**
1. Official recommendations
2. Security considerations
3. Performance implications
4. Community patterns

### Documentation
"How does [API/service] work?"

**Approach:**
1. Official API docs
2. SDK documentation
3. Integration examples
4. Rate limits/constraints

## Human Checkpoints

- **Auto Tier:** Research execution
- Findings reported to invoking skill
- High-risk findings flagged for review

## Error Handling

| Error | Resolution |
|-------|------------|
| No internal results | Proceed to external research |
| Conflicting information | Note conflict, present options |
| Outdated sources | Flag date, look for newer info |
| No clear answer | Document uncertainty, recommend investigation |

## Example Research Session

**Input:**
```json
{
  "research_questions": [
    "What's the best JWT library for Node.js/TypeScript?",
    "How should refresh tokens be stored securely?",
    "What's the recommended token expiration strategy?"
  ],
  "context": "Planning authentication feature"
}
```

**Output Summary:**
```
Q1: Recommend 'jose' library - modern, maintained, TypeScript-native
Q2: Store refresh tokens in httpOnly secure cookies, not localStorage
Q3: Short access token (15min), longer refresh (7 days), with rotation

Sources: Official OWASP guidelines, jose documentation, Auth0 best practices
Confidence: High for all questions
```

## Integration Points

- **Invoked by:** `technical-planner`, `architect`
- **Parallel execution:** Can research multiple questions simultaneously
- **Hands off to:** Invoking skill with findings

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-01-15 | Initial release |
