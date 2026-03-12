# Knowledge Search: Scoring Algorithm

> **Referenced by:** `knowledge-search` SKILL.md — used to rank search results by relevance.

## Purpose

Define how knowledge-search scores and ranks results from multiple knowledge sources to return the most relevant matches.

## Knowledge Sources (Search Order)

1. **Learnings** — `/.sigil/learnings/` (session learnings, cross-project learnings)
2. **Specs** — `/.sigil/specs/` (feature specifications, plans, tasks)
3. **Constitution** — `/.sigil/constitution.md` (project principles and constraints)
4. **ADRs** — `/.sigil/specs/*/adr/` (architecture decision records)
5. **Tech Debt** — `/.sigil/tech-debt.md` (known issues and suggestions)
6. **Foundation** — `/.sigil/project-foundation.md` (discovery phase output)
7. **Reviews** — `/.sigil/specs/*/reviews/` (code and security review reports)

## Scoring Formula

Each result gets a composite score from 0–100:

```
score = (keyword_match × 40) + (recency × 25) + (source_weight × 20) + (context_relevance × 15)
```

### Keyword Match (0–40 points)

| Match Type | Points |
|-----------|--------|
| Exact phrase match in title/heading | 40 |
| All keywords present in same section | 30 |
| All keywords present in same file | 20 |
| Partial keyword match (>50% of terms) | 10 |
| Single keyword match | 5 |

### Recency (0–25 points)

| Age | Points |
|-----|--------|
| Created/modified today | 25 |
| Within last 7 days | 20 |
| Within last 30 days | 15 |
| Within last 90 days | 10 |
| Older than 90 days | 5 |

### Source Weight (0–20 points)

| Source | Points | Rationale |
|--------|--------|-----------|
| Learnings | 20 | Distilled experience, highest signal |
| ADRs | 18 | Explicit decisions with rationale |
| Constitution | 16 | Active project constraints |
| Specs | 14 | Feature context |
| Tech Debt | 12 | Known issues and patterns |
| Foundation | 10 | Background context |
| Reviews | 8 | Historical findings |

### Context Relevance (0–15 points)

| Relevance Signal | Points |
|-----------------|--------|
| Same feature as current active workflow | 15 |
| Related technology/framework mentioned | 10 |
| Same file paths referenced | 10 |
| Related concept (semantic similarity) | 5 |
| No clear context match | 0 |

## Result Ranking

1. Sort results by composite score (descending)
2. De-duplicate: if multiple results from the same file, keep the highest-scoring section
3. Return top N results (default N=5, configurable)
4. Include score and source metadata with each result

## Result Format

```markdown
### Result [rank]: [Title or Heading]
**Source:** [file path]
**Score:** [composite score]/100
**Match:** [brief explanation of why this matched]

> [Relevant excerpt — 2-5 lines of context]
```

## Threshold Behavior

| Score Range | Behavior |
|-------------|----------|
| 70–100 | High confidence — present as direct answer |
| 40–69 | Medium confidence — present as "related context" |
| 20–39 | Low confidence — mention only if no better results |
| 0–19 | Below threshold — do not include in results |

## No Results Behavior

If no results score above 20:

```
No relevant knowledge found for "[query]".

This might mean:
- This is a new topic for this project
- Try different search terms
- The relevant context may be in code rather than knowledge files
```
