# Constitution Error Messages

> User-friendly error messages for all anticipated errors during constitution setup. Technical details are logged for debugging but NEVER shown to users.

---

## Error Message Format

Every error shown to users follows this format:

```
[What went wrong — one plain sentence]
[What to try next — actionable step]
```

**Rules:**
- Never show: error codes, stack traces, technical exception names, raw file paths
- Always show: what went wrong (simply), what to try next
- Log: full technical error details for debugging

---

## File System Errors

### File Not Found (ENOENT)

**Technical:** `ENOENT: no such file or directory, open '/memory/constitution.md'`

**User sees:**
```
I couldn't find the constitution file. Make sure you're in the right
project folder.

To create a new constitution, run /constitution.
```

### Permission Denied (EACCES)

**Technical:** `EACCES: permission denied, open '/memory/constitution.md'`

**User sees:**
```
I don't have permission to save the constitution file. You may need
to check your folder permissions.

Try running the command again, or manually create the memory/ folder
in your project.
```

### Disk Full (ENOSPC)

**Technical:** `ENOSPC: no space left on device`

**User sees:**
```
Your disk is full — I couldn't save the constitution. Free up some
space and try again.
```

### Directory Not Found

**Technical:** `ENOENT: no such file or directory, mkdir '/memory/'`

**User sees:**
```
The memory folder doesn't exist yet. Let me create it for you.
```

**Action:** Auto-create `/memory/` directory and retry. Only show error if creation also fails.

---

## Template Errors

### Template Not Found

**Technical:** `Template file not found at /templates/constitution-template.md`

**User sees:** Nothing — use embedded fallback template silently.

**Action:** Fall back to inline template. Log warning for debugging.

### Template Parse Error

**Technical:** `Unexpected token in template at line 42`

**User sees:** Nothing — use embedded fallback template silently.

**Action:** Fall back to inline template. Log warning for debugging.

---

## Stack Detection Errors

### Detection Failed Entirely

**Technical:** `No manifest files found (package.json, pyproject.toml, go.mod, etc.)`

**User sees:**
```
I couldn't detect your tech stack automatically. No worries — let me
ask a few questions instead.
```

**Action:** Fall through to manual stack questions (Round 1 standard path).

### Partial Detection

**Technical:** `Detected language but framework confidence < threshold`

**User sees:**
```
I found some of your setup but couldn't figure out everything. Let me
confirm what I found and ask about the rest.
```

**Action:** Show detected items, ask about missing/uncertain items.

### Manifest Parse Error

**Technical:** `SyntaxError: Unexpected token in package.json at position 234`

**User sees:**
```
Your project's configuration file has a formatting issue. I'll skip
auto-detection and ask you directly instead.
```

**Action:** Fall through to manual stack questions.

### Multiple Manifest Conflict

**Technical:** `Found conflicting manifests: package.json (React), pyproject.toml (Django)`

**User sees:**
```
I found multiple tech setups in your project. Let me focus on the
main one — you can adjust if needed.

Which is the primary technology for this project?
- [Option A from manifest 1]
- [Option B from manifest 2]
```

---

## Git / Gitignore Errors

### Gitignore Write Failed

**Technical:** `EACCES: permission denied, open '.gitignore'`

**User sees:**
```
I couldn't update your .gitignore file. You may need to add these
entries manually:

# Prism OS - Ephemeral artifacts
memory/project-context.md
specs/**/clarifications.md
```

### Git Not Initialized

**Technical:** `fatal: not a git repository`

**User sees:**
```
This project isn't using git yet, so I'll skip the git-related setup.
If you set up git later, you can re-run /constitution to configure
file sharing.
```

**Action:** Skip gitignore handling entirely. Constitution still created.

### Gitignore Already Has Entries

**Technical:** N/A (not an error, just a check)

**Action:** Silently skip duplicate entries. Do not show any message.

---

## Constitution State Errors

### Constitution Already Exists

**Technical:** `File exists at /memory/constitution.md`

**User sees:**
```
This project already has a constitution.

- View it: I'll show you what's configured
- Start fresh: I'll guide you through creating a new one
- Cancel: Keep everything as-is
```

### Constitution Corrupted / Unparseable

**Technical:** `Failed to parse constitution: missing Article headers`

**User sees:**
```
Your existing constitution file has some issues. I can:

- Fix it: I'll try to repair the formatting
- Start fresh: Create a new constitution from scratch
- Show it: Display the raw file so you can see what's there
```

### Constitution Write Failed After Generation

**Technical:** `Write failed after constitution generation completed`

**User sees:**
```
I generated your constitution but couldn't save it. Let me try again.

If this keeps happening, check that the memory/ folder exists and you
have write permissions.
```

**Action:** Retry once. If retry fails, offer to display the constitution so the user can save it manually.

---

## Network Errors (for future cloud features)

### Connection Timeout (ETIMEDOUT)

**User sees:**
```
Connection issues — couldn't reach [service]. Check your internet
and try again.
```

### Service Unavailable

**User sees:**
```
[Service] is temporarily unavailable. Your constitution is saved
locally and will sync when the service is back.
```

---

## User Input Errors

### Empty Project Name

**User sees:**
```
I need a project name for the constitution. What should I call this
project?
```

### Invalid Selection

**User sees:**
```
I didn't quite catch that. Could you choose one of the options above,
or tell me in your own words?
```

### Contradictory Answers

**Technical:** User selected options that conflict (e.g., "no database" then "enable RLS")

**User sees:**
```
Just to clarify — you mentioned [A] earlier but now selected [B].
Which would you like to go with?
```

---

## Logging Guidelines

For every error, log the following (never shown to users):

```
[TIMESTAMP] [ERROR_CODE] [CONTEXT]
- Technical message: [full error message]
- Stack trace: [if available]
- User action: [what the user was doing]
- Resolution: [what was shown/done for the user]
- File: [file path involved, if any]
```

This enables debugging without exposing technical details to non-technical users.
