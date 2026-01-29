# ADR-023: PRISM.md Enforcement Pattern

## Status

Accepted

## Context

ADR-021 (D021) introduced enforcement rules injected directly into each project's `CLAUDE.md`. While the concept of enforcement was sound, the implementation had issues:

1. **Bloat:** 75+ lines of enforcement content injected into every project's `CLAUDE.md`, mixed with the project's own instructions.
2. **Multi-developer friction:** Multiple developers sharing a project would see merge conflicts in `CLAUDE.md` due to the injected block.
3. **Version management complexity:** Detecting and replacing versioned blocks inside an existing file required fragile marker-based parsing.
4. **Missing handoff enforcement:** The enforcement rules covered skill invocation and chain following, but did not address the critical gap: automatic workflow handoffs. After `tasks.md` was created, the workflow stopped — no developer agent was invoked, and the per-task implementation loop never started.

## Decision

Replace the CLAUDE.md injection approach with a two-part pattern:

### Part 1: Lightweight pointer in CLAUDE.md

Add a single HTML comment as the first line of the project's `CLAUDE.md`:

```
<!-- Project: Check for ./PRISM.md and follow all rules if present -->
```

This is a minimal, conflict-free directive. It does not alter the project's instructions in any meaningful way.

### Part 2: Standalone PRISM.md

Create a `PRISM.md` file in the project root containing all enforcement rules:

- Component locations
- Mandatory skill invocation table
- Mandatory chain following
- Mandatory agent behavior
- Mandatory context loading
- Mandatory state updates
- **NEW: Automatic workflow handoffs table** — defines what happens after each artifact is created
- **NEW: Implementation loop rule** — defines the per-task develop/validate cycle that runs after `tasks.md` is created

The file has a version marker (`<!-- PRISM-OS v1.0.0 -->`) on the first line for idempotent updates.

### Legacy migration

When the preflight check encounters a legacy `<!-- PRISM-OS-ENFORCEMENT-START ... -->` block in `CLAUDE.md`, it removes the entire block and replaces it with the pointer line, then creates `PRISM.md`.

## Consequences

### Positive

- **Minimal footprint in CLAUDE.md:** One HTML comment line vs 75+ lines of enforcement content.
- **Multi-developer friendly:** `PRISM.md` is a standalone file that can be gitignored or committed without conflicting with project instructions.
- **Self-contained enforcement:** All rules in one file, easy to version and update.
- **Explicit handoffs:** The automatic workflow handoffs table closes the gap where the workflow would stall after task decomposition.
- **Implementation loop works:** The per-task developer -> QA -> fix cycle is now explicitly defined and triggered automatically.

### Negative

- **Relies on Claude following the pointer directive:** The HTML comment asks Claude to check for `PRISM.md` — this is an implicit instruction that depends on Claude's instruction-following behavior.
- **Two files instead of one:** Projects now have both a pointer in `CLAUDE.md` and a separate `PRISM.md`.

### Neutral

- The preflight check concept from D021 is retained; only the injection method changes.
- The dev repo guard remains unchanged (skips enforcement entirely for the prism-os development repository).

## Supersedes

- D021 enforcement injection method (the preflight check concept and Part A verification are retained)

## Related

- D005: Spec-First Development
- D008: Trigger-Based Routing
- ADR-019: UI/UX Designer Agent
