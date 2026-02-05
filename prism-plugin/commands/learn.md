---
description: View, search, or review project learnings
argument-hint: [--review | --search <query> | (empty to view)]
---

# Project Learnings

You manage the project's learning repository — patterns, gotchas, decisions, and feature notes accumulated during development.

## User Input

```text
$ARGUMENTS
```

## Route by Arguments

### No arguments: `/learn`

Display current learnings summary.

**Process:**
1. Read `/memory/learnings/active/patterns.md`
2. Read `/memory/learnings/active/gotchas.md`
3. Read `/memory/learnings/active/decisions.md`
4. Count items in each category

**Output format:**
```
Project Learnings
=================

Patterns (X/30):
  • Always use RLS policies for user-scoped queries
  • Add loading states to all async UI components
  • Validate email format server-side
  ...

Gotchas (Y/30):
  • Supabase storage has 50MB default upload limit
  • Next.js middleware can't access Node APIs
  ...

Recent Decisions (Z/20):
  • [Jan 15] Auth: Chose JWT over sessions
  • [Jan 12] UI: Using Tailwind, not styled-components
  ...

Active Features: N
  • 001-user-auth (5 notes)
  • 002-product-catalog (3 notes)

Run '/learn --review' to prune and promote.
Run '/learn --search <query>' to search.
```

### `--review`: `/learn --review`

Invoke the `learning-review` skill for interactive review.

**Process:**
1. Invoke `learning-review` skill
2. Follow its interactive prompts
3. Report summary when complete

### `--search <query>`: `/learn --search auth`

Search across all learnings.

**Process:**
1. Read all files in `/memory/learnings/active/`
2. Search for query term (case-insensitive)
3. Return matching entries with source

**Output format:**
```
Search: "auth"

Results (5 matches):

[Pattern] Use RLS policies for user-scoped queries
  → patterns.md

[Decision] Chose JWT over sessions (Jan 15)
  → decisions.md

[Gotcha] Supabase auth.signUp() doesn't auto-confirm in dev
  → gotchas.md

[Note] Task 2: Registration endpoint needed email toggle
  → features/001-user-auth.md

[Note] Task 5: Added refresh token rotation
  → features/001-user-auth.md
```

## File Locations

| File | Purpose | Always Loaded |
|------|---------|---------------|
| `/memory/learnings/active/patterns.md` | Validated rules | Yes |
| `/memory/learnings/active/gotchas.md` | Traps to avoid | Yes |
| `/memory/learnings/active/decisions.md` | Architectural choices | On demand |
| `/memory/learnings/active/features/*.md` | Per-feature notes | Current only |
| `/memory/learnings/archived/*.md` | Historical | Never |

## Token Budget

Display budget status in summary:

```
Token Budget:
  Patterns:   12/30  [████████░░░░░░]
  Gotchas:     8/30  [█████░░░░░░░░░]
  Decisions:   5/20  [████░░░░░░░░░░]

  Total: ~2,400 tokens (~3% of context)
```

If any category exceeds 80% of limit:
```
⚠️  Gotchas at 85% capacity. Consider running /learn --review
```

## Empty State

If no learnings exist yet:

```
Project Learnings
=================

No learnings captured yet.

Learnings are automatically recorded as you complete tasks:
  • Patterns — Reusable rules discovered during development
  • Gotchas — Traps and pitfalls to avoid
  • Decisions — Architectural choices and their rationale

Start building features with /prism to begin capturing learnings.
```

## Related Commands

- `/prism` — Main entry point, uses learnings automatically
- `/prism-status` — Shows workflow status
- `/constitution` — Project principles (different from learnings)

## Skills Invoked

- `learning-review` — When `--review` flag used
