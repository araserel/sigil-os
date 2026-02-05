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

#### Python 3

Required for the workflow linter tool.

**Check if installed:**
```bash
python3 --version
```

If not installed:
- **macOS:** `brew install python3` or download from [python.org](https://www.python.org/downloads/)
- **Linux:** `sudo apt install python3` (Ubuntu/Debian) or equivalent
- **Windows:** Download from [python.org](https://www.python.org/downloads/)

#### Git (Optional)

Only needed if cloning from a repository.

```bash
git --version
```

---

## Installation

### Option A: Clone from Repository

If Prism is in a Git repository:

```bash
# Clone the repository
git clone <repository-url> my-project
cd my-project

# Verify structure
ls -la
# Should see: CLAUDE.md, .claude/, docs/, templates/, etc.
```

### Option B: Copy to Existing Project

If adding Prism to an existing project:

1. Copy these directories/files to your project root:
   ```
   CLAUDE.md
   .claude/
   templates/
   memory/
   docs/
   tools/
   ```

2. Create empty directories for your work:
   ```bash
   mkdir -p specs
   ```

### Option C: Start Fresh

If starting a new project:

```bash
# Create project directory
mkdir my-project
cd my-project

# Copy Prism OS files (adjust source path as needed)
cp -r /path/to/prism-os/{CLAUDE.md,.claude,templates,memory,docs,tools} .

# Create working directories
mkdir -p specs
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

### Step 3: Verify Installation

Run the workflow linter to check everything is connected properly:

```bash
python3 tools/workflow-linter.py --verbose
```

**Expected output:**
```
Linting Prism OS project at: /path/to/your/project
------------------------------------------------------------
✓ All checks passed!
  Files checked: XX
```

If you see errors, check the [Troubleshooting](#troubleshooting) section below.

### Step 4: Test Claude Code Integration

Start Claude Code and verify it recognizes Prism:

```bash
# Start Claude Code in your project directory
claude

# Ask it about the system
> What commands are available in this project?
```

Claude should respond with the Prism commands defined in CLAUDE.md.

---

## Verification Checklist

Run through this checklist to confirm setup is complete:

- [ ] Claude Code installed and authenticated (`claude --version`)
- [ ] Python 3 available (`python3 --version`)
- [ ] CLAUDE.md exists in project root
- [ ] `.claude/` directory contains `agents/` and `skills/`
- [ ] `templates/` directory exists with template files
- [ ] `memory/constitution.md` exists and is customized
- [ ] Workflow linter passes (`python3 tools/workflow-linter.py`)
- [ ] Claude Code recognizes the project (`claude` then ask about commands)

---

## Troubleshooting

### "CLAUDE.md not found"

The linter or Claude Code can't find the main configuration file.

**Fix:** Make sure you're in the project root directory:
```bash
pwd
ls CLAUDE.md
```

### "claude: command not found"

Claude Code isn't installed or not in your PATH.

**Fix:** Reinstall Claude Code:
```bash
curl -fsSL https://claude.ai/install.sh | sh
```

Or add to PATH manually if installed in a non-standard location.

### "python3: command not found"

Python 3 isn't installed.

**Fix:** Install Python 3 for your platform (see Prerequisites above).

### Linter shows many errors

Common causes:
- Missing directories (`.claude/agents/`, `.claude/skills/`, etc.)
- Files not copied completely

**Fix:** Verify all required directories exist:
```bash
ls -la .claude/
ls -la .claude/agents/
ls -la .claude/skills/
ls -la templates/
ls -la memory/
```

### Claude Code doesn't recognize commands

CLAUDE.md might not be properly formatted or Claude Code isn't reading it.

**Fix:**
1. Verify CLAUDE.md exists and has content
2. Restart Claude Code: exit and run `claude` again
3. Check that you're in the correct directory

### Permission errors

Can't execute the linter or access files.

**Fix:**
```bash
chmod +x tools/workflow-linter.py
chmod -R u+rw .
```

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

1. **Backup your work:**
   ```bash
   cp -r specs/ specs-backup/
   cp memory/constitution.md constitution-backup.md
   ```

2. **Update system files** (keep your specs and constitution):
   ```bash
   # Update from source (adjust path)
   cp -r /path/to/new-prism-os/{CLAUDE.md,.claude,templates,docs,tools} .
   ```

3. **Run the linter** to check for any breaking changes:
   ```bash
   python3 tools/workflow-linter.py --verbose
   ```

4. **Review the changelog** for any migration steps needed.
