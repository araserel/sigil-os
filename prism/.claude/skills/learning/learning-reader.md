---
name: learning-reader
description: Loads relevant learnings before task execution. Provides patterns to follow and gotchas to avoid.
version: 1.0.0
category: learning
chainable: false
invokes: []
invoked_by: [orchestrator, developer]
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
- Current feature ID from `/memory/project-context.md`
- Current task context (what's about to be done)

## Process

### Step 1: Always Load Core Files

These files are always loaded when they exist:

1. **Patterns** — `/memory/learnings/active/patterns.md`
   - Validated rules that must be followed
   - Highest priority learnings

2. **Gotchas** — `/memory/learnings/active/gotchas.md`
   - Project-specific traps to avoid
   - Common mistakes already encountered

### Step 2: Load Feature-Specific Notes

Check `/memory/project-context.md` for current feature ID.

If working on an existing feature:
- Read `/memory/learnings/active/features/[feature-id].md`
- This provides context from earlier tasks in the same feature

**Do NOT** read feature files for other features (reduces noise).

### Step 3: Conditionally Load Decisions

Only read `/memory/learnings/active/decisions.md` if the current task involves:
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

Approximate load per file:

| File | Max Items | Est. Tokens |
|------|-----------|-------------|
| patterns.md | 30 | ~900 |
| gotchas.md | 30 | ~900 |
| decisions.md | 20 | ~800 |
| Feature notes | 20 | ~600 |

**Typical load:** ~2,400 tokens (patterns + gotchas + current feature)
**Maximum load:** ~3,200 tokens (all files)

This represents ~4% of context window.

## Loading Rules

1. **Never read from `/memory/learnings/archived/`**
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

## Outputs

**Context enrichment:**
- Patterns available for reference during implementation
- Gotchas flagged for awareness
- Feature context loaded

**No files modified** — This is read-only.

**Handoff data (to Developer):**
```json
{
  "patterns_loaded": 12,
  "gotchas_loaded": 8,
  "feature_notes_loaded": 5,
  "decisions_loaded": false,
  "relevant_highlights": [
    "[Pattern] Always validate email format server-side",
    "[Gotcha] NextAuth session callback runs on every request"
  ]
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
