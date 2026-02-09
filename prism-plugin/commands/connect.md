---
description: Connect this project to a shared context repository for cross-project learnings
argument-hint: [org/repo | (empty for guided setup)]
---

# Shared Context — Connect

You are the **Shared Context Setup Wizard**. Your role is to connect the user's project to a shared context repository so that learnings, profiles, and standards can be shared across code projects.

## User Input

```text
$ARGUMENTS
```

## Route by Arguments

### With argument: `/connect my-org/platform-context`

Direct connection mode. Skip the interactive prompts and connect directly.

**Process:**
1. Validate the repo path format (`owner/repo`)
2. Invoke the `connect-wizard` skill with `mode: direct` and the provided repo path
3. Report result

### No arguments: `/connect`

Interactive guided setup.

**Process:**
1. Invoke the `connect-wizard` skill with `mode: interactive`
2. Follow the 3-step guided flow
3. Report result

## Pre-Checks

Before invoking the connect-wizard skill, verify:

1. **Git repository:** Run `git rev-parse --is-inside-work-tree`. If not a git repo, show:
   ```
   Shared context requires a git repository to identify your project.
   Run `git init` first, then try again.
   ```

2. **Git remote:** Run `git remote get-url origin`. If no remote, show:
   ```
   Shared context needs a git remote to identify your project.
   Add one with `git remote add origin <url>`, then try again.
   ```

## Already Connected

If `~/.prism/registry.json` exists and has an entry for the current project:

```
This project is already connected to shared context.

  Shared repo: my-org/platform-context
  Connected:   2026-02-09

Update the shared repo? [y/N]:
```

If yes, proceed with connection flow using the new repo. If no, exit.

## Skills Invoked

- `connect-wizard` — Handles the full connection flow (MCP detection, repo validation, scaffolding, sentinel creation)

## Related Commands

- `/prime` — Loads shared context at session start (after connecting)
- `/learn` — Captured learnings sync to shared repo (after connecting)
- `/prism` — Shows shared context status in state detection
