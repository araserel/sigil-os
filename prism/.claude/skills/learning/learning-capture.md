---
name: learning-capture
description: Captures learnings after task completion. Records gotchas, decisions, patterns, and task notes for future reference.
version: 1.0.0
category: learning
chainable: false
invokes: []
invoked_by: [developer]
tools: Read, Write, Edit
model: haiku
---

# Skill: Learning Capture

## Purpose

Record what was learned during task completion. This builds institutional memory that helps avoid repeating mistakes and surfaces validated patterns.

## When to Invoke

**Automatically** by the Developer agent before marking a task `[x]` complete.

Do NOT invoke:
- For trivial tasks (documentation-only, config tweaks, formatting)
- If task is marked `[no-learn]` in tasks.md
- If the same learning was already captured this session

## Inputs

**Auto-loaded:**
- Current feature ID from `/memory/project-context.md`
- Task just completed (from context)

**Context available:**
- What was implemented
- Any issues encountered
- Decisions made

## Process

### Step 1: Identify Current Feature

Read `/memory/project-context.md` to get:
- Current feature ID (e.g., `001-user-auth`)
- Feature name

If no active feature, skip capture.

### Step 2: Determine What to Capture

Ask yourself:

| Question | If Yes → Category |
|----------|-------------------|
| Did I encounter something unexpected? | **Gotcha** |
| Did I make an architectural choice? | **Decision** |
| Did I discover a reusable rule? | **Pattern candidate** |
| What did I actually do? | **Task note** |

Most task completions produce a task note. Gotchas, decisions, and pattern candidates are less common.

### Step 3: Check for Duplicates

Before writing, read the target file and check if a similar learning already exists:
- Same concept, different wording = duplicate
- Related but distinct = not a duplicate

If duplicate exists, skip capture.

### Step 4: Write to Appropriate File

**For task notes** → `/memory/learnings/active/features/[feature-id].md`

```markdown
## [Feature Name]

### Task Notes

- **[Task ID]** Brief description of what was done
  - Gotcha: Any surprise encountered (optional)
  - Note: Any other relevant detail (optional)
```

**For gotchas** → `/memory/learnings/active/gotchas.md`

```markdown
- **[Short description of the trap]**
  - Context: When this happens
  - Solution: How to avoid or fix
  - Feature: [feature-id]
  - Added: [YYYY-MM-DD]
```

**For decisions** → `/memory/learnings/active/decisions.md`

```markdown
- **[YYYY-MM-DD] [Decision title]**
  - Choice: What was chosen
  - Rationale: Why
  - Alternatives: What else was considered
  - Feature: [feature-id]
```

**For pattern candidates** → Add to task note with `[PATTERN?]` prefix

```markdown
- **[Task ID]** Built password reset flow
  - [PATTERN?] Always add expires_at column to token tables
```

### Step 5: Confirm Capture (Silent)

Do NOT tell the user about the capture unless there's an error. Learning capture should be invisible during normal operation.

## Token Budget Limits

Enforce these limits when writing:

| File | Max Items | Action on Exceed |
|------|-----------|------------------|
| patterns.md | 30 | Warn user, suggest `/learn --review` |
| gotchas.md | 30 | Warn user, suggest `/learn --review` |
| decisions.md | 20 | Warn user, allow overflow |
| Feature notes | 20 per feature | Summarize older entries |

If a file exceeds its limit:
```
Note: [file] has reached its limit (X items).
Run `/learn --review` to prune and promote learnings.
```

## Writing Guidelines

### Keep Entries Concise
- 1-2 sentences max per item
- Focus on actionable information
- Use specific terms, not vague descriptions

### Good Examples

```markdown
- **T003** Added JWT refresh token flow
  - Gotcha: Access tokens must be shorter-lived than refresh tokens
  - [PATTERN?] Store refresh tokens in httpOnly cookies, not localStorage
```

```markdown
- **Supabase RLS policies require explicit user_id checks**
  - Context: Queries fail silently when RLS blocks access
  - Solution: Always add `.eq('user_id', userId)` to queries
  - Feature: 001-user-auth
  - Added: 2026-01-23
```

### Bad Examples

```markdown
- Did some stuff with auth  # Too vague
- This was really hard to figure out  # Not actionable
- Always use best practices  # Meaningless
```

## Outputs

**Files modified:**
- `/memory/learnings/active/features/[feature-id].md` (task notes)
- `/memory/learnings/active/gotchas.md` (if gotcha found)
- `/memory/learnings/active/decisions.md` (if decision made)

**No handoff data** — This skill completes silently.

## Error Handling

| Error | Resolution |
|-------|------------|
| Feature file doesn't exist | Create it with header |
| learnings directory doesn't exist | Create full path |
| Duplicate detected | Skip silently |
| File exceeds limit | Warn user, still write |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-23 | Initial release |
