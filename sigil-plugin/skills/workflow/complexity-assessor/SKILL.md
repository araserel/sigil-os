---
name: complexity-assessor
description: Determines appropriate workflow track based on request complexity. Invoke at the start of any feature request to route to Quick Flow, Standard, or Enterprise track.
version: 1.1.0
category: workflow
chainable: true
invokes: []
invoked_by: [orchestrator]
tools: Read, Glob, Grep
---

# Skill: Complexity Assessor

## Purpose

Analyze incoming requests to determine the appropriate workflow track. Ensures methodology overhead matches the work size.

## When to Invoke

- New feature request received
- User starts describing work
- Orchestrator receives any implementation request
- User asks "how should we approach this"

## Inputs

**Required:**
- `request_description`: string — User's description of what they want

**Optional:**
- `existing_context`: string — Any additional context provided
- `force_track`: string — User override for track selection
- `ticket_metadata`: object — From ticket-loader when input is a ticket key. Contains `category`, `priority`, `story_points`, `labels`, `type`, `related_ticket_count`

**Auto-loaded:**
- `project_context`: string — `/.sigil/project-context.md`
- `specs_directory`: string — `/.sigil/specs/` (scan for existing features)

## Process

### Step 1: Request Analysis

Extract signals from the request:

```
1. Keywords indicating scope
2. Number of distinct capabilities mentioned
3. Integration points referenced
4. Risk indicators (security, data, production)
5. Ambiguity level
```

### Step 2: Codebase Scan

If project has existing code:

```
1. Estimate files potentially affected
2. Check for existing related features
3. Identify integration complexity
4. Note any breaking change signals
```

### Step 3: Complexity Scoring

Score across dimensions:

| Dimension | Low (1) | Medium (2) | High (3) |
|-----------|---------|------------|----------|
| **Scope** | Single capability | Multiple related | System-wide |
| **Files** | 1-5 files | 5-15 files | 15+ files |
| **Dependencies** | None new | 1-2 new | 3+ new |
| **Data Changes** | None | Minor schema | Major migration |
| **Integration** | Internal only | 1 external | Multiple external |
| **Risk** | Easily reversible | Some risk | Production/security |
| **Ambiguity** | Clear requirements | Some questions | Many unknowns |

#### Ticket Metadata Scoring Adjustments

When `ticket_metadata` is provided, use it to refine dimension scores:

| Ticket Field | Affects Dimension | Rule |
|-------------|-------------------|------|
| `story_points` ≤ 3 | Scope | Cap at Low (1) unless other signals override |
| `story_points` ≥ 8 | Scope | Minimum Medium (2) |
| `story_points` ≥ 13 | Scope | Set High (3) |
| `labels` contain external service names | Integration | Minimum Medium (2) |
| `related_ticket_count` ≥ 3 | Dependencies | Minimum Medium (2) |
| `related_ticket_count` ≥ 5 | Dependencies | Set High (3) |

### Step 4: Track Determination

```
Total Score: Sum of all dimensions (7-21)

7-10  → Quick Flow
11-16 → Standard
17-21 → Enterprise
```

**Override Triggers:**
- Security-related → Minimum Standard
- Database migration → Minimum Standard
- Production deployment → Minimum Standard
- New service/system → Minimum Enterprise
- Compliance requirements → Enterprise

**Ticket Category Overrides** (when `ticket_metadata` is provided):
- `category: maintenance` → Force Quick Flow (skip remaining assessment)
- `category: bug` without security-related labels → Cap at Standard (never Enterprise)
- `category: feature` → No override (full assessment)
- `category: enhancement` → No override (full assessment)

### Step 5: Recommendation

Generate recommendation with rationale:

```markdown
## Complexity Assessment

**Request:** [Summary]
**Recommended Track:** [Quick Flow | Standard | Enterprise]

### Scoring
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Scope | [1-3] | [Why] |
| Files | [1-3] | [Why] |
| ... | ... | ... |

**Total:** [N]/21

### Track Rationale
[Why this track is appropriate]

### Alternative
[When user might choose differently]
```

### Step 6: User Confirmation

Present recommendation and ask for confirmation:

```
Based on your request, I recommend the [Track] workflow.

This means:
- [What happens in this track]
- [Expected touchpoints]
- [When you'll review]

Would you like to proceed with [Track], or would you prefer [Alternative]?
```

## Outputs

**Handoff Data:**
```json
{
  "recommended_track": "standard",
  "confidence": "high",
  "total_score": 14,
  "dimension_scores": {
    "scope": 2,
    "files": 2,
    "dependencies": 2,
    "data_changes": 2,
    "integration": 2,
    "risk": 2,
    "ambiguity": 2
  },
  "override_triggers": [],
  "user_confirmed": true,
  "rationale": "Multiple related capabilities, moderate file changes, some integration work"
}
```

## Track Definitions

### Quick Flow
**For:** Bug fixes, small tweaks, well-understood changes

**Workflow:**
```
Request → Quick Spec → Tasks → Implement → Validate → Done
```

**Characteristics:**
- Skip detailed spec/clarification
- Minimal planning documentation
- Fast iteration
- 1-5 tasks typically

**When to Use:**
- "Fix this bug"
- "Add this small feature"
- "Update this text"
- Scope is crystal clear

### Standard Track
**For:** Features, enhancements, moderate complexity

**Workflow:**
```
Request → Specify → Clarify → Plan → Tasks → Implement → Validate → Review → Done
```

**Characteristics:**
- Full specification process
- Clarification phase
- Documented plan
- 5-20 tasks typically

**When to Use:**
- New features
- Significant enhancements
- Some unknowns to resolve
- Multiple components involved

### Enterprise Track
**For:** New systems, architectural changes, compliance work

**Workflow:**
```
Request → Research → Specify → Clarify → Architecture → Plan → Tasks → Implement → Validate → Review → Done
```

**Characteristics:**
- Research phase before spec
- Architecture documentation
- ADRs required
- 20+ tasks typically
- Multiple review gates

**When to Use:**
- New services or systems
- Major refactoring
- Compliance requirements
- Cross-team impact

## Human Checkpoints

- **Auto Tier:** Assessment and recommendation
- **Review Tier:** User confirms track selection
- User can override recommendation

## Error Handling

| Error | Resolution |
|-------|------------|
| Request too vague | Ask for more detail before assessing |
| Conflicting signals | Present options, let user decide |
| No clear track | Default to Standard (safest middle ground) |

## Example Assessments

**Quick Flow:**
```
Request: "Fix the typo on the login page where it says 'Pasword'"

Assessment:
- Scope: 1 (single file, single change)
- Files: 1 (one file)
- Dependencies: 1 (none)
- Data Changes: 1 (none)
- Integration: 1 (none)
- Risk: 1 (easily reversible)
- Ambiguity: 1 (crystal clear)

Total: 7/21 → Quick Flow
```

**Standard:**
```
Request: "Add user authentication with email/password login"

Assessment:
- Scope: 2 (multiple capabilities: login, logout, session)
- Files: 2 (10-15 files estimated)
- Dependencies: 2 (auth library needed)
- Data Changes: 2 (user table changes)
- Integration: 2 (session management)
- Risk: 2 (security-related)
- Ambiguity: 2 (some questions to resolve)

Total: 14/21 → Standard
```

**Enterprise:**
```
Request: "Build a multi-tenant SaaS platform with billing integration"

Assessment:
- Scope: 3 (system-wide)
- Files: 3 (50+ files)
- Dependencies: 3 (multiple new: billing, auth, multi-tenancy)
- Data Changes: 3 (major schema design)
- Integration: 3 (billing provider, auth provider)
- Risk: 3 (production, financial)
- Ambiguity: 3 (many decisions needed)

Total: 21/21 → Enterprise
```

## Integration Points

- **Invoked by:** `orchestrator` at start of any request
- **Hands off to:** Track-specific workflow chain

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.1.0 | 2026-02-20 | S4-104: Ticket metadata input — story points → scope, labels → integration, related tickets → dependencies scoring. Category overrides: maintenance → Quick Flow, bug → cap Standard. |
| 1.0.0 | 2026-01-20 | Initial release |
