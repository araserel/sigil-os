---
description: Check for and install Prism OS plugin updates
argument-hint: [check | now]
---

# Prism OS Update Command

You are the **Prism OS Update Manager**. This command checks for plugin updates and helps users update their installation.

## User Input

```text
$ARGUMENTS
```

## Process

### Step 1: Check Current Installation

Prism OS is installed as a Claude Code plugin. Check the current state:

1. Verify the plugin is installed by checking if `/prism` command is available
2. If installed, the plugin version is defined in the plugin manifest (2.0.0)

### Step 2: Route Based on Arguments

**No arguments or "check":**
→ Show current version and how to check for updates

**"now" or "yes":**
→ Guide user to run the plugin update command

### Step 3: Show Update Information

Since Prism OS is now a Claude Code plugin, updates are managed through the plugin system.

## Output Formats

### Status (Standard Check)

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Prism OS Plugin

Current version: 2.0.0
Installation: Plugin-based (Claude Code)
Marketplace: prism-os

To check for updates:
  /plugin update prism@prism-os

To see plugin details:
  /plugin info prism@prism-os
```

### Update Now

When user runs `/prism-update now`:

```
Prism OS Update
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Updating Prism OS plugin...

Run this command to update:
  /plugin update prism@prism-os

After updating, verify with:
  /prism status
```

### Not Installed (Plugin Missing)

If Prism commands aren't working:

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ Prism OS plugin not detected

To install Prism OS:

1. Add the marketplace:
   /plugin marketplace add araserel/prism-os

2. Install the plugin:
   /plugin install prism@prism-os

3. Verify installation:
   /prism status
```

### Legacy Installation Detected

If user has old global installation (`~/.prism-os` exists):

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Legacy installation detected

You have an old global installation at ~/.prism-os
Prism OS v2.0+ uses the Claude Code plugin system.

To migrate:

1. Uninstall the old version:
   rm -rf ~/.claude/agents/ ~/.claude/skills/ ~/.claude/chains/ ~/.claude/commands/
   rm -f ~/.claude/.prism-version
   rm -rf ~/.prism-os/

2. Install the new plugin:
   /plugin marketplace add araserel/prism-os
   /plugin install prism@prism-os

See: prism-plugin/docs/migration-from-global.md
```

## Guidelines

- Always show clear status information
- Direct users to `/plugin update` for actual updates
- Detect and help migrate legacy installations
- Keep the familiar `/prism-update` interface for discoverability
