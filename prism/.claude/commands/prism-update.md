---
description: Check for and install Prism OS updates
argument-hint: [check | now | force | rollback]
---

# Prism OS Update Command

You are the **Prism OS Update Manager**. This command checks for updates and manages the global Prism OS installation.

## User Input

```text
$ARGUMENTS
```

## Process

### Step 1: Check Current Installation

First, read the version file to understand current state:

```bash
cat ~/.claude/.prism-version 2>/dev/null || echo "NOT_INSTALLED"
```

Parse the output to get:
- `version` - Currently installed version
- `installed` - Installation timestamp
- `source` - Source directory path

If the file doesn't exist, set state to `NOT_INSTALLED`.

### Step 2: Check Source Repository

Check if the source repository exists and is git-tracked:

```bash
# Check if source exists
ls -la ~/.prism-os 2>/dev/null || echo "SOURCE_MISSING"

# Check if it's a git repo
git -C ~/.prism-os rev-parse --is-inside-work-tree 2>/dev/null || echo "NOT_GIT_REPO"
```

### Step 3: Determine State

Based on checks, determine the current state:

| State | Condition |
|-------|-----------|
| `NOT_INSTALLED` | No version file at `~/.claude/.prism-version` |
| `SOURCE_MISSING` | Version file exists but `~/.prism-os` not found |
| `NOT_GIT_REPO` | Source exists but not a git repository |
| `INSTALLED` | Everything present, can check for updates |

### Step 4: Route Based on Arguments

**No arguments or "check":**
→ Check for available updates, show status

**"now" or "yes":**
→ Perform update immediately (if available)

**"force":**
→ Reinstall even if already up-to-date

**"rollback":**
→ Restore from most recent backup

### Step 5: Check for Updates (if state is INSTALLED)

```bash
cd ~/.prism-os && git fetch origin 2>/dev/null

# Compare local and remote
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "UP_TO_DATE"
else
    echo "UPDATE_AVAILABLE"
    # Show what's new
    git log --oneline HEAD..origin/main
fi
```

Handle network errors gracefully:
- If fetch fails, set state to `NO_NETWORK`
- If no upstream, set state to `NO_UPSTREAM`

### Step 6: Perform Update

When user confirms update:

```bash
cd ~/.prism-os && git pull origin main && ./install-global.sh
```

### Step 7: Rollback

When user requests rollback:

1. Find latest backup:
   ```bash
   ls -1t ~/.claude/.prism-backups/ | head -1
   ```

2. Restore files:
   ```bash
   LATEST_BACKUP=$(ls -1t ~/.claude/.prism-backups/ | head -1)
   BACKUP_PATH="$HOME/.claude/.prism-backups/$LATEST_BACKUP"

   # Restore each directory
   [ -d "$BACKUP_PATH/commands" ] && cp -r "$BACKUP_PATH/commands/"* ~/.claude/commands/ 2>/dev/null
   [ -d "$BACKUP_PATH/agents" ] && cp -r "$BACKUP_PATH/agents/"* ~/.claude/agents/ 2>/dev/null
   [ -d "$BACKUP_PATH/skills" ] && cp -r "$BACKUP_PATH/skills/"* ~/.claude/skills/ 2>/dev/null
   ```

3. Report what was restored

## Output Formats

### Status (No Updates)

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Prism OS is up to date

Installed version: 1.0.0
Installed: 2025-01-15
Source: ~/.prism-os

No updates available.
```

### Status (Update Available)

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 Update available!

Current version: 1.0.0
Available version: 1.1.0

Recent changes:
- abc1234 Add new validation skill
- def5678 Fix task decomposer edge case
- ghi9012 Update documentation

Run `/prism-update now` to update.
```

### Not Installed

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ Prism OS is not installed globally

To install:
  git clone https://github.com/adamriedthaler/prism-os.git ~/.prism-os
  ~/.prism-os/install-global.sh
```

### Source Missing

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Source directory not found

Prism OS is installed but the source directory is missing:
  Expected: ~/.prism-os

To fix, re-clone and reinstall:
  git clone https://github.com/adamriedthaler/prism-os.git ~/.prism-os
  ~/.prism-os/install-global.sh
```

### Not Git Repo

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Source is not a git repository

Prism OS was installed from a tarball/zip, not git.
Automatic updates require git.

To convert to git-based installation:
  ~/.prism-os/install-global.sh --convert-to-git

Or manually:
  rm -rf ~/.prism-os
  git clone https://github.com/adamriedthaler/prism-os.git ~/.prism-os
  ~/.prism-os/install-global.sh
```

### Network Error

```
Prism OS Update Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Could not check for updates

Network error or GitHub unreachable.
Try again later or check manually:
  cd ~/.prism-os && git fetch && git status
```

### Update Success

```
Prism OS Update
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Update complete!

Updated from 1.0.0 to 1.1.0

Changes installed:
- 3 commands updated
- 2 skills added
- 1 agent modified

A backup was created before updating.
To rollback: /prism-update rollback
```

### Rollback Success

```
Prism OS Rollback
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Rollback complete!

Restored from backup: backup-20250115-143022

Restored:
- commands/
- agents/
- skills/

Note: Source code at ~/.prism-os was not changed.
To fully revert, you may need to:
  cd ~/.prism-os && git checkout <previous-commit>
```

### Rollback No Backups

```
Prism OS Rollback
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ No backups available

No backup files found at ~/.claude/.prism-backups/

Backups are created automatically during updates.
```

## Guidelines

- Always show clear status before taking action
- Never update without user confirmation (except with `now`/`yes`/`force`)
- Always mention rollback option after updates
- Handle network errors gracefully
- Preserve any custom user files (detect and warn about conflicts)
