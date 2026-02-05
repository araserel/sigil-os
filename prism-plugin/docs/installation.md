# Installation Guide

Step-by-step instructions to set up Prism for your project.

---

## Prerequisites

**Dependency chain:** Node.js → Claude Code → Prism OS

### For Claude Code (required)

#### Node.js 18+

Claude Code requires Node.js to run.

**Check if installed:**
```bash
node --version
```

You should see `v18.x.x` or higher. If not, [download Node.js here](https://nodejs.org/).

#### Claude Code CLI

Prism runs on Claude Code, Anthropic's AI coding assistant.

**Install Claude Code:**
```bash
npm install -g @anthropic-ai/claude-code
```

**Verify installation:**
```bash
claude --version
```

**Authenticate:**
```bash
claude auth login
```

Follow the prompts to connect your Anthropic account. You'll need a Claude Pro, Max, or API subscription.

> **Note:** See [Anthropic's documentation](https://docs.anthropic.com/en/docs/claude-code) for detailed setup instructions.

### For Prism OS

No additional dependencies required. Prism OS is distributed as a Claude Code plugin and includes all necessary components.

---

## Installation

Prism OS is distributed as a Claude Code plugin.

### Step 1: Add the Marketplace

```bash
# Add the Prism OS marketplace
claude plugin marketplace add araserel/prism-os
```

### Step 2: Install the Plugin

```bash
# Install the prism plugin
claude plugin install prism@prism-os
```

### Step 3: Verify Installation

```bash
# List installed plugins
claude plugin list
```

You should see `prism` in the list.

### Alternative: Local Development Installation

If you're developing or testing Prism locally:

```bash
# From the prism-os repository root
claude plugin marketplace add ./
claude plugin install prism@prism-os
```

---

## Initial Setup

### Step 1: Set Up the Constitution

The constitution defines rules that apply to all work in your project. Run the guided setup:

```bash
# Start Claude Code
claude

# Run the constitution setup
> /constitution
```

Prism walks you through 3 quick rounds:
1. **Confirm your tech stack** (auto-detected from your project)
2. **Choose project type** (MVP, Production, or Enterprise)
3. **Optional preferences** (external services, offline support, accessibility)

All technical details (code style, testing levels, security rules) are configured automatically based on your choices.

### Step 2: Initialize Project Context

The project context file tracks your session state. Reset it for a fresh start:

```bash
# View the template
cat memory/project-context.md
```

The context will be populated automatically as you work. No manual setup needed.

### Step 3: Verify Plugin Integration

Start Claude Code and verify Prism is working:

```bash
# Start Claude Code in your project directory
claude

# Check Prism status
> /prism status
```

You should see the Prism status dashboard showing the installed version and available commands.

---

## Verification Checklist

Run through this checklist to confirm setup is complete:

- [ ] Claude Code installed and authenticated (`claude --version`)
- [ ] Prism plugin installed (`claude plugin list` shows `prism`)
- [ ] `/prism status` shows the Prism dashboard
- [ ] `memory/constitution.md` exists and is customized (after first `/prism` run)
- [ ] `PRISM.md` exists in project root (auto-created by plugin)

---

## Troubleshooting

### "Plugin not found" error

The plugin isn't installed or the marketplace isn't added.

**Fix:** Add the marketplace and reinstall:
```bash
claude plugin marketplace add araserel/prism-os
claude plugin install prism@prism-os
```

### "claude: command not found"

Claude Code isn't installed or not in your PATH.

**Fix:** Reinstall Claude Code:
```bash
curl -fsSL https://claude.ai/install.sh | sh
```

Or add to PATH manually if installed in a non-standard location.

### `/prism` command not recognized

The plugin may not be properly installed.

**Fix:**
1. Check plugin is installed: `claude plugin list`
2. Reinstall if needed: `claude plugin install prism@prism-os`
3. Restart Claude Code session

### PRISM.md not created automatically

The SessionStart hook may not have run.

**Fix:**
1. Start a new Claude Code session
2. Run `/prism` to trigger preflight check
3. Verify `PRISM.md` was created in project root

### Claude Code doesn't follow enforcement rules

PRISM.md may be missing or outdated.

**Fix:**
1. Delete `PRISM.md` and restart session
2. Run `/prism` to regenerate with current enforcement rules
3. Verify CLAUDE.md has the pointer line: `<!-- Project: Check for ./PRISM.md and follow all rules if present -->`

---

## Next Steps

Installation complete! Continue with:

1. **[Quick Start Guide](quick-start.md)** — 30-minute hands-on tutorial
2. **[User Guide](user-guide.md)** — Complete reference for daily use
3. **[Command Reference](command-reference.md)** — All available commands

---

## Getting Help

If you're stuck:

1. Check the [Troubleshooting Guide](troubleshooting.md) for common issues
2. Run the linter with full diagnostics: `python3 tools/workflow-linter.py --verbose --fix-suggestions`
3. Review CLAUDE.md for system configuration details

---

## Updating Prism

To update to a newer version:

```bash
# Update the plugin
claude plugin update prism@prism-os
```

Or use the Prism command:

```
/prism-update
```

Your project-specific files (`memory/`, `specs/`) are not affected by updates. Only the plugin components are updated.

**After updating:**
1. Start a new Claude Code session
2. Run `/prism` to verify the update and refresh enforcement rules
3. Check the changelog for any migration steps

---

## Team Installation (Coming Soon)

Team-wide Prism installation will use Claude Code's plugin scoping:

```json
// .claude/settings.json (project root, committed)
{
  "plugins": {
    "prism-os": {
      "enabled": true,
      "version": "2.0.0"
    }
  }
}
```

This feature requires Prism's team sync capabilities (Stage 2 roadmap).
