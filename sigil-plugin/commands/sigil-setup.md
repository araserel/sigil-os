---
description: Set up Sigil OS in your project (creates .sigil/ directory, constitution, profile, SIGIL.md)
---

# Sigil OS Setup

You are the **Sigil OS Setup Wizard**. This command initializes Sigil OS in a new project by creating the `.sigil/` directory structure, running the constitution writer, optionally generating a project profile, and configuring enforcement.

## User Input

```text
$ARGUMENTS
```

## Process

### Step 1: Welcome

Display using format from `templates/output-formats.md`:

```
Welcome to Sigil OS! 👋
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sigil helps you build software through structured specifications.
No coding knowledge required — just describe what you want to build.

Let's set up your project. This takes about 2 minutes.
```

### Step 2: Create Directory Structure

Create the `.sigil/` directory and subdirectories:

```
.sigil/
├── learnings/
│   ├── active/
│   └── archived/
└── specs/
```

Use the Write tool to create placeholder files if needed to establish the directory structure.

### Step 3: Ask User Track

Use the `AskUserQuestion` tool to ask:

```
What best describes your role?

This helps Sigil tailor its communication style and the level
of technical detail it shows you.
```

Options:
- **Product / Business** → Sets `user_track: non-technical` — "Sigil will handle technical decisions automatically and communicate in plain English."
- **Engineering / Technical** → Sets `user_track: technical` — "Sigil will show technical details, trade-offs, and specialist names."

Write the user's selection to `.sigil/config.yaml` immediately (the `.sigil/` directory was created in Step 2):

```yaml
# Sigil OS Personal Configuration
user_track: non-technical    # non-technical | technical
execution_mode: automatic    # automatic | directed (directed requires technical track)
```

If the user chose "Engineering / Technical", set `user_track: technical`.

### Step 3.5: Shared Context Check

Ask the user about shared context before creating the constitution, so that shared standards can be incorporated:

```
Do you work across multiple code projects that share
organization rules (security policies, coding standards)?

- Yes — Let's connect now
- No / Not sure — Skip (connect later with /sigil-connect)
```

Use the `AskUserQuestion` tool for this choice.

**If Yes:**

1. Invoke the `connect-wizard` skill (same as `/sigil-connect`)
2. After connection succeeds, invoke the Standards Discover protocol from `shared-context-sync` to list available standards
3. Store discovered `shared_standards` array for use in Step 4

**If No / Not sure:**

Proceed to Step 4 with no `shared_standards`. The user can connect later with `/sigil-connect`.

### Step 4: Run Constitution Writer

Invoke the constitution writer skill:

```
Skill(skill: "sigil-constitution")
```

If `shared_standards` were discovered in Step 3.5, pass them to the constitution writer so it can emit `@inherit` markers for covered articles instead of generating local content.

This guides the user through 3 rounds of questions to create `.sigil/constitution.md`.

### Step 5: Optionally Run Profile Generator

After the constitution is created, ask:

```
Would you like to generate a project profile?

A profile describes your tech stack, APIs, and dependencies.
It helps when sharing context across multiple projects.

- Yes (Recommended) — Scan and generate profile
- Skip — You can run /sigil-profile later
```

Use the `AskUserQuestion` tool for this choice.

If yes, invoke:

```
Skill(skill: "sigil-profile")
```

### Step 6: Run Preflight Check

The preflight check creates `SIGIL.md` with enforcement rules and adds a pointer to `CLAUDE.md`. Read the preflight-check SKILL.md and follow its process to create these files.

This ensures the project has:
- `./SIGIL.md` with enforcement rules
- `./CLAUDE.md` with pointer to SIGIL.md

### Step 7: Configure Gitignore

Check if `.gitignore` exists. If not, create it. Add the following entries (without duplication):

```gitignore
# Sigil OS - Ephemeral artifacts (auto-added)
.sigil/config.yaml
.sigil/project-context.md
.sigil/learnings/
.sigil/waivers.md
.sigil/tech-debt.md
.sigil/specs/**/clarifications.md
```

Note: `.sigil/constitution.md`, `.sigil/project-foundation.md`, `.sigil/project-profile.yaml`, and `.sigil/specs/` are committed to git by default.

### Step 8: Completion Summary

Display using canonical format from `templates/output-formats.md`:

```
Setup Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Directory structure created (.sigil/)
✅ Role selected ([Product / Business | Engineering / Technical])
✅ Shared context [Connected to org/repo | ⬚ Skipped — run /sigil-connect later]
✅ Constitution created (7 articles [, N from shared standards])
✅ Profile generated (or "⬚ Profile — skipped, run /sigil-profile later")
✅ Enforcement rules installed (SIGIL.md)
✅ Gitignore configured

You're ready to go! Try:
  /sigil "describe your first feature"

Or run /sigil help to see all commands.
To change your role later: /sigil-config set user_track [non-technical|technical]
```

## Pre-Checks

If `.sigil/constitution.md` already exists, warn:

```
This project already has Sigil OS set up.

- Run /sigil to see your current status
- Run /sigil-constitution to update your constitution
- Run /sigil-profile to update your profile
```

## Error Handling

- If directory creation fails: "Couldn't create .sigil/ directory. Check file permissions."
- If constitution writer is cancelled: Still complete remaining steps. Show constitution as "⬚ Constitution — skipped, run /sigil-constitution later."
- If gitignore write fails: "Couldn't update .gitignore — you may need to add these entries manually: [list entries]"

## Related Commands

- `/sigil` — Show project status (after setup)
- `/sigil-constitution` — Edit project constitution
- `/sigil-profile` — Generate/update project profile
