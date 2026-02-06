# Prism OS Installation Instructions

> **For Claude Code users who want to install Prism OS.**
>
> Give this file to Claude and ask: "Please help me install Prism OS following these instructions."

---

## What Prism OS Does

Prism OS helps you build software through structured specifications. You describe what you want in plain language, and Prism guides you through a professional development process - no coding knowledge required.

## What Gets Installed

| Component | How | Purpose |
|-----------|-----|---------|
| Prism plugin | Claude Code plugin system | Commands, agents, skills |
| Per-project files | Auto-created by `/prism` | `memory/`, `specs/`, `PRISM.md` |

---

## Prerequisites

### Claude Code (Required)

Prism OS runs as a plugin for Claude Code.

**Check if Claude Code is installed:**
```bash
claude --version
```

**If not installed:**

Visit [claude.ai/code](https://claude.ai/code) for installation instructions, or run:
```bash
npm install -g @anthropic-ai/claude-code
```

Then authenticate:
```bash
claude auth login
```

---

## Installation Steps

### Step 1: Add the Prism OS Marketplace

```bash
claude plugin marketplace add howardtech/prism-os
```

**What this does:** Registers the Prism OS plugin marketplace with Claude Code.

### Step 2: Install the Plugin

```bash
claude plugin install prism@prism-os
```

**What this does:** Installs Prism commands, agents, and skills as a Claude Code plugin.

### Step 3: Verify Installation

```bash
claude plugin list
```

You should see `prism` in the list of installed plugins.

---

## Post-Installation

### Starting a New Project

1. Create or navigate to your project folder
2. Start Claude Code: `claude`
3. Type `/prism` to begin

Prism will guide you through:
- Setting up project principles (constitution)
- Creating feature specifications
- Planning and implementing features

### Per-Project Files

Each project using Prism will have:
- `PRISM.md` - Enforcement rules (auto-created)
- `memory/constitution.md` - Project principles
- `specs/` - Feature specifications

Prism creates these when you run `/prism` for the first time in a project.

---

## Updating Prism OS

### Using the Update Command

From any project with Claude Code:
```
/prism-update
```

### Using the CLI

```bash
claude plugin update prism@prism-os
```

---

## Uninstalling

To remove Prism OS:

```bash
claude plugin uninstall prism@prism-os
```

To also remove the marketplace:
```bash
claude plugin marketplace remove prism-os
```

---

## Troubleshooting

### "Plugin not found"

The marketplace may not be added:
```bash
claude plugin marketplace add howardtech/prism-os
```

### "claude: command not found"

Claude Code is not installed. Visit [claude.ai/code](https://claude.ai/code) for installation.

### `/prism` command not recognized

The plugin may not be properly installed:
```bash
claude plugin install prism@prism-os
```

Then start a new Claude Code session.

### PRISM.md not created

Run `/prism` in your project to trigger the preflight check and create `PRISM.md`.

---

## Getting Help

- **In Claude:** Type `/prism help`
- **GitHub Issues:** https://github.com/howardtech/prism-os/issues
- **Documentation:** See `prism-plugin/docs/` in the repository

---

## Important Notes

- **Project files are independent** - Each project has its own `memory/` and `specs/`
- **Plugin updates are safe** - Your project-specific files are never modified by updates
- **Enforcement rules are auto-created** - `PRISM.md` is generated in each project as needed
