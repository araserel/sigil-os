---
description: Load project context and prepare for a development session
argument-hint: [optional: feature ID or focus area]
---

# Prime Session

You are the **Context Primer** for Sigil OS. Your role is to load relevant project context at the start of a session, ensuring the AI has the information needed to work effectively.

## User Input

```text
$ARGUMENTS
```

## Process

### Step 1: Load Core Context

Always load:
1. `/memory/constitution.md` - Project principles
2. `/memory/project-context.md` - Current state
3. `CLAUDE.md` - Sigil OS instructions (if exists)

### Step 1b: Pull Shared Context (if connected)

Check if shared context is active:
1. Read `~/.sigil/registry.json` — look up current project
2. If not active → skip to Step 1c (no shared context UI)

If active, invoke the `shared-context-sync` pull protocol:
1. Pull latest shared learnings from shared repo via MCP
2. Cache updated locally at `~/.sigil/cache/shared/`
3. Drain offline queue (retry any pending writes)
4. Compute "what's new" since last session

**Display "What's New" (FR-017):**

If new shared learnings exist since last sync:
```
Shared Context: 3 new learnings since last session
  - [patterns/api-server] Use connection pooling for database queries
  - [gotchas/web-app] Next.js middleware can't access Node crypto
  - [decisions/api-server] Chose Redis for session storage

Queued syncs: 0 pending
```

If nothing new:
```
Shared Context: Up to date (araserel/platform-context)
```

If MCP unavailable (graceful fallback):
```
Shared Context: Offline — using cached data
  Last sync: 2026-02-09 14:30
  Queued: 1 learning pending sync
```

### Step 1c: Expand @inherit Markers

If `/memory/constitution.md` contains `<!-- @inherit: ... -->` markers and shared context is active:

1. For each `@inherit` marker, extract the referenced path (e.g., `shared-standards/security-standards.md`)
2. Fetch the referenced file from shared repo via MCP:
   ```
   mcp__github__get_file_contents(owner, repo, path=referenced_path)
   ```
3. Replace the `<!-- @inherit: ... -->` marker with the fetched content (inline expansion)
4. If fetch fails, check cache at `~/.sigil/cache/shared/{referenced_path}`
5. If cache also unavailable, leave marker in place with warning comment:
   ```
   <!-- @inherit: shared-standards/security-standards.md — UNAVAILABLE, using local constitution only -->
   ```

**Important:** Expansion is in-memory only for agent consumption. Do NOT modify the actual constitution file on disk.

### Step 1d: Load Project Profiles

Load project profile data for agent context:

1. Read `memory/project-profile.yaml` — if exists, inject full profile into agent context
2. If connected and profile exists:
   a. Run profile change detection via `shared-context-sync`:
      - Compute SHA256 of local profile
      - Compare with cached hash in `~/.sigil/cache/shared/profile-hashes.json`
      - If different → trigger Profile Push to republish, then update cache
   b. Load sibling profiles from `~/.sigil/cache/shared/profiles/` (pulled during Step 1b)
   c. For each sibling profile, inject summary into agent context (name, description, exposes, tech_stack only)
3. If not connected → skip sibling profile loading (local profile still loads)

**Display in Session Brief (Step 6):**

If profile exists:
```
Tech Stack: TypeScript, Next.js 14, React 18
Consumes: api-server (REST API), shared-components (package)
Sibling profiles: 3 loaded (api-server, mobile-app, shared-components)
```

If profile exists but not connected:
```
Tech Stack: TypeScript, Next.js 14, React 18
Sibling profiles: Not connected — run /connect to enable
```

If no profile:
```
Project profile: Not configured — run /profile to set up
```

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
- Check status: /sigil-status
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
- Shared context: [Connected / Not configured]

What would you like to work on?
```

If shared context is active, include the "What's New" summary from Step 1b between the Session Brief and the "Context loaded" summary. If shared context is not active, omit all shared context lines.

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
