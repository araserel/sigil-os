# Migration Guide: Global Installation to Plugin

This guide helps existing Prism OS users migrate from the global `install-global.sh` installation to the new Claude Code plugin architecture.

## Overview

Prism OS v2.0 transitions from a shell-script-based installation to a Claude Code plugin. This provides:

- **Automatic enforcement** via lifecycle hooks (no more relying on Claude following instructions)
- **Standard distribution** via Claude Code's plugin marketplace
- **Easy updates** via `claude plugin update prism-os`
- **Team distribution** via project-scoped plugin configuration

## Prerequisites

- Claude Code v1.0+ with plugin support
- Existing Prism OS global installation (optional, for migration)

## Migration Steps

### Step 1: Uninstall Global Installation (if present)

If you have an existing global installation:

```bash
# Run the uninstall command
~/.prism-os/install-global.sh --uninstall

# Or manually remove:
rm -rf ~/.claude/agents/
rm -rf ~/.claude/skills/
rm -rf ~/.claude/chains/
rm -rf ~/.claude/commands/
rm -f ~/.claude/.prism-version
rm -rf ~/.prism-os/
```

**Note:** This removes global Prism components. Your project-specific files (`memory/`, `specs/`) are not affected.

### Step 2: Install the Plugin

```bash
# Install from marketplace (when available)
claude plugin install prism-os

# Or install from local directory during development
claude plugin install ./prism-plugin
```

### Step 3: Verify Installation

Start a new Claude Code session in your project:

```bash
cd your-project
claude
```

Then run:
```
/prism status
```

You should see the Prism OS status dashboard.

### Step 4: Update Project Files (if needed)

The plugin will automatically update your project's `PRISM.md` file on first run. The new version:

- References plugin-based components instead of `~/.claude/` paths
- Uses enforcement version 2.0.0
- Maintains the same mandatory rules

Your `CLAUDE.md` pointer line remains unchanged:
```
<!-- Project: Check for ./PRISM.md and follow all rules if present -->
```

## What Stays the Same

These project-specific directories are **not affected** by the migration:

| Directory | Purpose | Migration Impact |
|-----------|---------|------------------|
| `memory/constitution.md` | Project principles | No change |
| `memory/project-context.md` | Workflow state | No change |
| `memory/learnings/` | Captured learnings | No change |
| `specs/` | Feature specifications | No change |

## What Changes

| Before (v1.x) | After (v2.0) |
|---------------|--------------|
| Components at `~/.claude/` | Components in plugin |
| Manual preflight check | Automatic via SessionStart hook |
| Git-based updates | Plugin marketplace updates |
| `install-global.sh` | `claude plugin install` |
| Instruction-based enforcement | Hook-based enforcement |

## Team Installation

For teams, add Prism OS to your project's plugin configuration:

**`.claude/settings.json`** (committed to repo):
```json
{
  "plugins": {
    "prism-os": {
      "enabled": true,
      "version": "2.0.0"
    }
  }
}
```

Team members will automatically have Prism OS installed when they open the project in Claude Code.

## Troubleshooting

### "Plugin not found" error

Ensure Claude Code v1.0+ is installed and plugin support is enabled:
```bash
claude --version
```

### Old enforcement rules still appearing

If `PRISM.md` shows v1.x rules, run `/prism` to trigger the automatic update, or manually delete `PRISM.md` to regenerate it.

### Skills not invoking correctly

Verify the plugin is installed:
```bash
claude plugin list
```

Should show `prism-os` in the installed plugins.

### Hook scripts not running

Check that hooks are enabled in your Claude Code settings and that the hook scripts are executable.

## Rolling Back

If you need to revert to the global installation:

```bash
# Uninstall plugin
claude plugin uninstall prism-os

# Reinstall global (deprecated, but available)
git clone https://github.com/araserel/prism-os.git ~/.prism-os
~/.prism-os/install-global.sh
```

## Getting Help

- **Documentation:** `/prism help`
- **Issues:** https://github.com/araserel/prism-os/issues
- **Updates:** `/prism-update`
