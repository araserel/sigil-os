---
name: learning-reader
description: Loads relevant learnings before task execution. Provides patterns to follow and gotchas to avoid. Loads shared learnings first (if connected), then local learnings on top.
version: 1.3.0
category: learning
chainable: false
invokes: [shared-context-sync]
invoked_by: [developer, business-analyst, architect, qa-engineer]
tools: Read
model: haiku
---

# Skill: Learning Reader

## Purpose

Load relevant past learnings before starting work. This ensures validated patterns are followed and known gotchas are avoided.

## When to Invoke

**Automatically** by the Orchestrator before routing to any implementation agent, OR by the Developer agent before starting a task.

## Inputs

**Auto-loaded:**
- Current feature ID from `/.sigil/project-context.md`
- Current task context (what's about to be done)

## Process

### Step 0: Load Shared Learnings (if connected)

Check if shared context is active using `shared-context-sync` sentinel detection:
- Read `~/.sigil/registry.json` and look up the current project

**If shared context is active**, load from `~/.sigil/cache/shared/learnings/`:

1. **Shared Patterns** — all `*/patterns.md` files in the cache (from all repos)
2. **Shared Gotchas** — all `*/gotchas.md` files in the cache (from all repos)
3. **Shared Decisions** — all `*/decisions.md` files (only if Step 3 criteria met)

Shared learnings load **first** — they represent the organizational baseline. Label shared entries with their source repo when surfacing them:

```markdown
**Relevant Learnings:**
- [Shared Pattern — api-server] Always validate JWT expiry server-side
- [Pattern] Use RLS policies for all user-scoped queries
```

**If shared context is not active** (no sentinel, or project not in registry), skip this step entirely. No error, no message.

**If cache is empty** (connected but no pull yet), skip silently.

### Step 1: Always Load Core Files

These files are always loaded when they exist:

1. **Patterns** — `/.sigil/learnings/active/patterns.md`
   - Validated rules that must be followed
   - Highest priority learnings

2. **Gotchas** — `/.sigil/learnings/active/gotchas.md`
   - Project-specific traps to avoid
   - Common mistakes already encountered

3. **Waivers** — `/.sigil/waivers.md` (critical: load before constitution checks)
   - Constitution violations waived by human decision
   - Must be loaded early so constitution checks respect existing waivers

4. **Tech Debt** — `/.sigil/tech-debt.md` (contextual: load during review phase)
   - Non-blocking suggestions from past code reviews
   - Load when entering the review phase to avoid re-flagging known items

### Step 2: Load Feature-Specific Notes

Check `/.sigil/project-context.md` for current feature ID.

If working on an existing feature:
- Read `/.sigil/learnings/active/features/[feature-id].md`
- This provides context from earlier tasks in the same feature

**Do NOT** read feature files for other features (reduces noise).

### Step 3: Conditionally Load Decisions

Only read `/.sigil/learnings/active/decisions.md` if the current task involves:
- Architecture or design choices
- Technology selection
- Integration approaches
- Database schema changes

For routine implementation tasks, skip decisions to save context.

### Step 4: Summarize Internally

Create an internal summary (not shown to user):

```
Learnings loaded:
- Patterns: X rules to follow
- Gotchas: Y traps to avoid
- Feature notes: Z relevant items
- Decisions: [loaded/skipped]
```

### Step 5: Surface Critical Items

If any loaded learning is directly relevant to the current task, surface it in the task context:

```markdown
**Relevant Learnings:**
- [Pattern] Use RLS policies for all user-scoped queries
- [Gotcha] Supabase storage has 50MB default upload limit
```

Only surface 1-3 most relevant items. Don't overwhelm with the full list.

## Token Budget

Shared and local learnings share a combined budget of ~5,500 tokens. Shared learnings load first; local learnings fill remaining capacity.

| File | Max Items | Est. Tokens | Source |
|------|-----------|-------------|--------|
| Shared patterns (all repos) | 15 | ~450 | `~/.sigil/cache/shared/learnings/` |
| Shared gotchas (all repos) | 15 | ~450 | `~/.sigil/cache/shared/learnings/` |
| Local patterns.md | 30 | ~900 | `/.sigil/learnings/active/` |
| Local gotchas.md | 30 | ~900 | `/.sigil/learnings/active/` |
| decisions.md | 20 | ~800 | Local (+ shared if architecture task) |
| Feature notes | 20 | ~600 | Local only |
| waivers.md | 20 | ~800 | Local only |
| tech-debt.md | 50 | ~1,500 | Local only |

**Without shared context:** ~2,400 typical / ~5,500 max (unchanged from v1.1)
**With shared context:** ~3,300 typical / ~5,500 max (shared items count toward same ceiling)

If the combined total approaches the budget, prioritize:
1. Local patterns and gotchas (most relevant to current project)
2. Shared patterns and gotchas (organizational baseline)
3. Feature notes, waivers, decisions, tech-debt (contextual)

This represents ~4% of context window.

## Loading Rules

1. **Never read from `/.sigil/learnings/archived/`**
   - Archived items are historical, not active guidance

2. **Don't read other features' notes**
   - Only load notes for the current feature
   - Cross-feature patterns belong in patterns.md

3. **If files don't exist, proceed without them**
   - New projects won't have learnings yet
   - Don't error, just skip

4. **Prefer recent items**
   - If a file is large, prioritize recent entries
   - Older items may be outdated

5. **Load waivers before constitution checks**
   - Waivers must be available before any constitution compliance step
   - If a waiver applies to the current feature, surface it prominently

6. **Load tech-debt contextually**
   - Only load during the review phase (to avoid re-flagging known items)
   - Skip during implement, validate, and other phases

## Outputs

**Context enrichment:**
- Patterns available for reference during implementation
- Gotchas flagged for awareness
- Feature context loaded

**No files modified** — This is read-only.

**Handoff data (to Developer):**
```json
{
  "shared_context_active": true,
  "shared_patterns_loaded": 8,
  "shared_gotchas_loaded": 5,
  "patterns_loaded": 12,
  "gotchas_loaded": 8,
  "feature_notes_loaded": 5,
  "decisions_loaded": false,
  "relevant_highlights": [
    "[Shared Pattern — api-server] Always validate JWT expiry server-side",
    "[Pattern] Always validate email format server-side",
    "[Gotcha] NextAuth session callback runs on every request"
  ],
  "waivers_loaded": 2,
  "tech_debt_loaded": false
}
```

## Integration with Developer Agent

When the Developer agent receives a task, learning-reader runs first:

```
1. Developer receives task
2. → learning-reader loads context
3. Developer sees relevant learnings
4. Developer implements with awareness
5. → learning-capture records new learnings
6. Developer marks task complete
```

## Error Handling

| Error | Resolution |
|-------|------------|
| File not found | Skip silently, proceed |
| File empty | Skip silently, proceed |
| Parse error | Log warning, skip file |
| Too many items | Load most recent N items |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-23 | Initial release |
| 1.1.0 | 2026-02-09 | SX-001/SX-002: Added waivers.md and tech-debt.md to loading pipeline with contextual rules |
| 1.3.0 | 2026-02-10 | Audit: Expanded invoked_by to include business-analyst, architect, qa-engineer |
| 1.2.0 | 2026-02-09 | S2-101: Added Step 0 — load shared learnings from cache before local. Shared budget combined with local (~5,500 total). |
