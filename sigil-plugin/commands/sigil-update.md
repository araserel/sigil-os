---
description: Check for and install Sigil OS plugin updates
argument-hint: [check | now]
---

# Sigil OS Update Command

You are the **Sigil OS Update Manager**. This command checks for plugin updates and helps users update their installation.

## User Input

```text
$ARGUMENTS
```

## Process

### Step 1: Check Current Installation

Sigil OS is installed as a Claude Code plugin. Check the current state:

1. Verify the plugin is installed by checking if `/sigil` command is available
2. If installed, read the current version from the plugin manifest (`plugin.json` → `version` field)

### Step 2: Route Based on Arguments

**No arguments or "check":**
→ Show current version and how to check for updates

**"now" or "yes":**
→ Guide user to run the plugin update command

### Step 3: Show Update Information

Since Sigil OS is now a Claude Code plugin, updates are managed through the plugin system.

## Output Formats

### Status (Standard Check)

```
Sigil OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Sigil OS Plugin

Current version: [read from plugin.json → version field]
Installation: Plugin-based (Claude Code)
Marketplace: sigil-os

To check for updates:
  /plugin update sigil@sigil-os

To see plugin details:
  /plugin info sigil@sigil-os
```

### Update Now

When user runs `/sigil-update now`:

```
Sigil OS Update
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Updating Sigil OS plugin...

Run this command to update:
  /plugin update sigil@sigil-os

After updating, verify with:
  /sigil status
```

### Not Installed (Plugin Missing)

If Sigil commands aren't working:

```
Sigil OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ Sigil OS plugin not detected

To install Sigil OS:

1. Add the marketplace:
   /plugin marketplace add araserel/sigil-os

2. Install the plugin:
   /plugin install sigil@sigil-os

3. Verify installation:
   /sigil status
```

### Legacy Installation Detected

If user has old global installation (`~/.sigil-os` exists):

```
Sigil OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Legacy installation detected

You have an old global installation at ~/.sigil-os
Sigil OS v2.0+ uses the Claude Code plugin system.

To migrate:

1. Uninstall the old version:
   rm -rf ~/.claude/agents/ ~/.claude/skills/ ~/.claude/chains/ ~/.claude/commands/
   rm -f ~/.claude/.sigil-version
   rm -rf ~/.sigil-os/

2. Install the new plugin:
   /plugin marketplace add araserel/sigil-os
   /plugin install sigil@sigil-os

See: sigil-plugin/docs/migration-from-global.md
```

## Guidelines

- Always show clear status information
- Direct users to `/plugin update` for actual updates
- Detect and help migrate legacy installations
- Keep the familiar `/sigil-update` interface for discoverability
