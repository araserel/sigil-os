---
name: connect-wizard
description: Interactive setup flow for connecting a project to a shared context repository via GitHub MCP.
version: 1.1.0
category: shared-context
chainable: false
invokes: [shared-context-sync]
invoked_by: [connect]
tools: Read, Write, Bash, ToolSearch
model: sonnet
---

# Skill: Connect Wizard

## Purpose

Guide users through connecting their project to a shared context repository. Handles GitHub MCP detection, repo validation, directory scaffolding, and sentinel file creation.

## When to Invoke

When the user runs `/connect` or says "connect to shared context", "set up shared context", "share learnings across projects", etc.

## Inputs

**Mode:** `interactive` (no arguments) or `direct` (repo path provided)

**For direct mode:**
- `repo_path`: `owner/repo` format string

## Process: Interactive Mode

### Step 1: Introduction

Display:
```
Shared Context Setup
==============================

Prism can share learnings and project context across
your code projects. This helps when you work on more
than one project — like a frontend and backend, or
mobile and web apps.

Do you work across multiple code projects? [Y/n]:
```

If user says no → exit with: "No problem. You can run `/connect` anytime if you change your mind."

### Step 2: GitHub MCP Check

Use the `shared-context-sync` skill's GitHub MCP Detection procedure.

**If MCP detected:**
```
Step 1 of 3: GitHub Connection
-------------------------------

Checking... GitHub MCP detected.
```

**If MCP not detected:**
```
Step 1 of 3: GitHub Connection
-------------------------------

Checking... GitHub MCP not found.

Sharing context requires a GitHub connection (MCP).
Want me to help you set that up? [Y/n]:
```

If yes, display the setup guidance from `shared-context-sync` MCP Detection, then ask user to restart their session and run `/connect` again.

If no → exit with: "You'll need GitHub MCP to use shared context. Run `/connect` when you're ready."

### Step 3: Repository Selection

```
Step 2 of 3: Shared Context Repository
---------------------------------------

Have you already created a shared context repo
on GitHub? [y/N]:
```

**If yes:**
```
Enter the repo path (e.g., my-org/platform-context):
>
```

**If no:**
```
No problem. Create a new repository on GitHub:
  1. Go to github.com/new
  2. Name it something like "platform-context"
  3. Make it private (recommended)
  4. Come back here with the path

Enter the repo path (e.g., my-org/platform-context):
>
```

### Step 4: Validate and Connect

1. Validate repo path format: must be `owner/repo`
2. Attempt to read from the repo via GitHub MCP to confirm access
3. If repo is empty or missing expected structure → offer to scaffold (see Scaffolding below)
4. If repo is not accessible → show error and allow retry

### Step 5: Scaffold (if needed)

If the repo is empty or doesn't have the shared context structure:

```
This repo is empty. Set up the shared context structure? [Y/n]:
```

If yes, use the `shared-context-sync` Scaffolding Protocol, which creates all files in a single commit via `mcp__github__push_files`:
- `README.md` — auto-generated explanation of the repo's purpose
- `shared-standards/.gitkeep`
- `profiles/.gitkeep`
- `learnings/.gitkeep`

**README.md content:**
```markdown
# Shared Context

This repository stores shared learnings, project profiles, and organizational
standards for use across code projects via [Prism OS](https://github.com/araserel/prism-os).

## Structure

- `learnings/` — Per-project learnings (patterns, gotchas, decisions)
- `profiles/` — Per-project profiles (tech stack, APIs, dependencies)
- `shared-standards/` — Organization-level standards

## How it works

Projects connect to this repo using `prism connect`. After connecting:
- Learnings sync automatically when you use `/learn`
- Latest shared context loads when you use `/prime`

Each project's learnings are stored in a subdirectory named after the project.
```

### Step 6: Create Sentinel

Use the `shared-context-sync` skill's Write Sentinel Entry procedure:
1. Detect current project identity (repo identity from git remote)
2. Write/update `~/.prism/registry.json` with the new project entry
3. Initialize local cache structure if needed

### Step 7: Shared Standards Discovery

After connecting, check if `shared-standards/` has content via MCP:

```
mcp__github__get_file_contents(owner, repo, path="shared-standards/")
```

If the directory contains files beyond `.gitkeep` (e.g., `security-standards.md`, `accessibility.md`):

**If standards exist:**
```
Your team has shared standards available:
  - security-standards.md
  - accessibility.md

You can reference them in your project's constitution
with @inherit markers. For example:

  <!-- @inherit: shared-standards/security-standards.md -->

These will be expanded automatically when you run /prime.
```

**If only `.gitkeep` or empty:** Skip silently — no standards to discover yet.

### Step 8: Confirmation

```
Step 3 of 3: Confirm
---------------------

Shared context is now active:
  - Repository: {owner/repo}
  - Learnings sync when you use /learn
  - Latest context loads when you use /prime
  - This project: {current-project-identity}

To disconnect later, remove this project's entry
from ~/.prism/registry.json (or delete the file).

Ready to go.
```

---

## Process: Direct Mode

When invoked with a repo path (e.g., `prism connect my-org/platform-context`):

1. Skip Steps 1-3 (introduction, MCP check prompt, repo selection prompt)
2. Still perform MCP check silently — if MCP not available, show error and guidance
3. Proceed directly to Step 4 (validate and connect) with the provided repo path
4. Continue through Steps 5-8 as normal

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Invalid repo path format | "Repo path should be `owner/repo` (e.g., `my-org/platform-context`)." Allow retry. |
| Repo not accessible via MCP | "Could not reach `{repo}`. Check that the repository exists and you have access." Allow retry. |
| MCP write fails during scaffold | "Could not set up the repo structure. Check your write access to `{repo}`." |
| Git not initialized | Caught by `/connect` pre-checks, not this skill. |
| No git remote | Caught by `/connect` pre-checks, not this skill. |
| Already connected | Caught by `/connect`, shows current config and asks to update. |
| MCP permission denied | "Could not write to shared repo. Ask your admin for write access to `{repo}`." |

---

## Outputs

**On success:**
- `~/.prism/registry.json` created/updated with project entry
- `~/.prism/cache/shared/` directory structure initialized
- Shared repo scaffolded (if empty)

**Handoff data:**
```json
{
  "connected": true,
  "shared_repo": "my-org/platform-context",
  "project_identity": "my-org/web-app",
  "scaffolded": true,
  "shared_standards_available": false
}
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-09 | Initial release — interactive and direct connection flows |
| 1.1.0 | 2026-02-09 | Added MCP tool specifics to scaffolding and standards discovery, references shared-context-sync protocols |
