---
description: Load project context and prepare for a development session
argument-hint: [optional: feature ID or focus area]
---

# Prime Session

You are the **Context Primer** for Prism OS. Your role is to load relevant project context at the start of a session, ensuring the AI has the information needed to work effectively.

## User Input

```text
$ARGUMENTS
```

## Process

### Step 1: Load Core Context

Always load:
1. `/memory/constitution.md` - Project principles
2. `/memory/project-context.md` - Current state
3. `CLAUDE.md` - Prism OS instructions (if exists)

### Step 2: Determine Focus

Based on arguments:
- **Feature ID (e.g., "001"):** Load that specific feature's context
- **Focus area (e.g., "frontend", "api"):** Load relevant patterns
- **No arguments:** Load overview of all active work

### Step 3: Load Feature Context (if specified)

For a specific feature:
1. `/specs/NNN-feature-name/spec.md`
2. `/specs/NNN-feature-name/plan.md` (if exists)
3. `/specs/NNN-feature-name/tasks.md` (if exists)
4. `/specs/NNN-feature-name/clarifications.md` (if exists)
5. Recent QA reports (if any)

### Step 4: Load Focus Area Context (if specified)

For focus areas, scan codebase for:
- **frontend:** UI components, styles, state management
- **backend/api:** Routes, controllers, services
- **database:** Models, migrations, queries
- **testing:** Test patterns, fixtures, utilities
- **security:** Auth, validation, permissions

### Step 5: Analyze Current State

Determine:
- What phase is active work in?
- What was the last action taken?
- What's the next logical step?
- Are there any blockers?

### Step 6: Generate Session Brief

```markdown
## Session Prime: [Focus]

**Primed at:** [Timestamp]
**Focus:** [Feature/Area/General]

---

### Project Overview

**Name:** [Project name from constitution]
**Stack:** [Technology stack]
**Status:** [Count] active features

---

### Constitution Summary

Key principles in effect:
- [Key principle 1]
- [Key principle 2]
- [Key principle 3]

---

### Current Focus: [Feature/Area]

**Status:** [Phase]
**Progress:** [X/Y tasks complete]

**Recent Activity:**
- [Last action]
- [Previous action]

**Current Task:**
[Details of what's in progress]

**Next Steps:**
1. [Immediate next action]
2. [Following action]

---

### Key Files

Files most likely relevant to current work:
- `path/to/file1.ts` - [Why relevant]
- `path/to/file2.ts` - [Why relevant]
- `path/to/file3.ts` - [Why relevant]

---

### Patterns to Follow

Based on codebase analysis:
- [Pattern 1]: [Where to find example]
- [Pattern 2]: [Where to find example]

---

### Ready to Work

You are now primed to work on [focus area].

Quick actions:
- Continue implementation: "Implement TASK-NNN"
- Check status: /status
- Validate work: /validate
```

## Output

Display the session brief, then:
```
Session primed and ready.

Context loaded:
- Constitution: [X] articles
- Active features: [Count]
- Current focus: [Feature/Area]

What would you like to work on?
```

## Focus Area Patterns

| Focus | What to Load | Example Files |
|-------|-------------|---------------|
| frontend | UI components, hooks, stores | `src/components/`, `src/hooks/` |
| backend | API routes, services, middleware | `src/api/`, `src/services/` |
| database | Models, migrations, repositories | `src/models/`, `migrations/` |
| testing | Test utilities, fixtures, patterns | `tests/`, `__tests__/` |
| auth | Authentication, authorization | `src/auth/`, `middleware/` |
| all | Everything above (lighter load each) | Key files from each area |

## Guidelines

- Load only what's relevant to avoid context overload
- Highlight patterns the user should follow
- Identify any blockers or issues upfront
- Suggest logical next steps based on current state
- Keep the brief scannable - details on request

## Re-Priming

If context seems stale during a session:
```
Run /prime to refresh context.
Your current work will be preserved.
```
