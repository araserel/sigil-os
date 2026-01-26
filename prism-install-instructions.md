# Prism OS Installation Instructions

> **For Claude Desktop / Claude Code users who want to install Prism OS.**
>
> Give this file to Claude and ask: "Please help me install Prism OS following these instructions."

---

## What Prism OS Does

Prism OS helps you build software through structured specifications. You describe what you want in plain language, and Prism guides you through a professional development process - no coding knowledge required.

## What Gets Installed

| Location | What | Purpose |
|----------|------|---------|
| `~/.prism-os/` | Source code | For updates |
| `~/.claude/` | Commands, agents, skills | Global functionality |
| Per-project | `memory/`, `specs/` | Project-specific data |

---

## Prerequisites

### Git (Required)

Prism OS uses Git for version control and updates.

**Check if Git is installed:**
```bash
git --version
```

**If not installed:**

- **macOS:** Open Terminal and run:
  ```bash
  xcode-select --install
  ```
  Click "Install" when prompted.

- **Linux (Ubuntu/Debian):**
  ```bash
  sudo apt update && sudo apt install git
  ```

- **Linux (Fedora/RHEL):**
  ```bash
  sudo dnf install git
  ```

- **Windows (WSL):** First ensure you have WSL installed, then in WSL terminal:
  ```bash
  sudo apt update && sudo apt install git
  ```

---

## Installation Steps

### Step 1: Clone the Repository

Run this command to download Prism OS:

```bash
git clone https://github.com/adamriedthaler/prism-os.git ~/.prism-os
```

**What this does:** Downloads Prism OS to a hidden folder called `.prism-os` in your home directory.

### Step 2: Run the Global Installer

```bash
~/.prism-os/install-global.sh
```

**What this does:** Installs Prism commands, agents, and skills to `~/.claude/` where they're available in all your projects.

### Step 3: Verify Installation

```bash
~/.prism-os/install-global.sh --verify
```

You should see green checkmarks for all components.

---

## Post-Installation

### Starting a New Project

1. Create or navigate to your project folder
2. Start Claude Code or Claude Desktop
3. Type `/prism` to begin

Prism will guide you through:
- Setting up project principles (constitution)
- Creating feature specifications
- Planning and implementing features

### Per-Project Files

Each project using Prism needs its own:
- `memory/constitution.md` - Project principles
- `specs/` - Feature specifications

Prism will help you create these when you run `/prism` for the first time in a project.

---

## Updating Prism OS

### Option 1: Using the Update Command

From any project with Claude:
```
/prism-update
```

### Option 2: Manual Update

```bash
cd ~/.prism-os
git pull
./install-global.sh
```

---

## Uninstalling

To remove Prism OS:

```bash
~/.prism-os/install-global.sh --uninstall
```

To also remove the source code:
```bash
rm -rf ~/.prism-os
```

---

## Troubleshooting

### "git: command not found"

Git is not installed. Follow the Git installation steps above for your operating system.

### "Permission denied"

The installer script needs to be executable:
```bash
chmod +x ~/.prism-os/install-global.sh
```

### "~/.claude/ not found" or commands not working

Try running the installer again:
```bash
~/.prism-os/install-global.sh
```

### WSL-Specific Issues

If using Windows Subsystem for Linux:

1. Make sure you're running commands **inside WSL**, not in PowerShell/CMD
2. Your home directory in WSL is `/home/yourusername`, not your Windows home
3. If Claude Desktop doesn't see the files, you may need to configure it to use WSL

### "fatal: destination path already exists"

The repository was already cloned. Either:
- Continue with step 2 (run the installer)
- Or remove and re-clone:
  ```bash
  rm -rf ~/.prism-os
  git clone https://github.com/adamriedthaler/prism-os.git ~/.prism-os
  ```

---

## Getting Help

- **In Claude:** Ask "How do I use Prism OS?" or type `/prism help`
- **GitHub Issues:** https://github.com/adamriedthaler/prism-os/issues
- **Documentation:** See `~/.prism-os/prism/docs/` after installation

---

## Important Notes

- **Keep `~/.prism-os/`** - This folder is needed for updates
- **Don't delete `~/.claude/`** - This contains all your Claude configurations
- **Each project is independent** - Project-specific files stay in each project folder
