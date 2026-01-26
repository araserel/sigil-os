# Prism OS Repository

**Specification-driven development for non-technical users.**

---

## For Users

**Want to use Prism OS?** Choose your installation method:

### Option A: Global Install (Recommended)

Install once, use in all projects. Includes automatic updates.

**Using Claude Desktop (Non-Technical):**
1. Download [`prism-install-instructions.md`](prism-install-instructions.md)
2. Give it to Claude: "Please help me install Prism OS following these instructions"
3. Claude will guide you through the process

**Using Terminal (Technical):**
```bash
# Clone the repository
git clone https://github.com/adamriedthaler/prism-os.git ~/.prism-os

# Install globally
~/.prism-os/install-global.sh

# Verify installation
~/.prism-os/install-global.sh --verify
```

**What Gets Installed:**
| Location | Contents |
|----------|----------|
| `~/.prism-os/` | Source code (for updates) |
| `~/.claude/commands/` | Slash commands (`/prism`, `/spec`, etc.) |
| `~/.claude/agents/` | Agent definitions |
| `~/.claude/skills/` | Skill implementations |

**Per-Project Files** (created when you run `/prism`):
| Location | Contents |
|----------|----------|
| `memory/constitution.md` | Project principles |
| `memory/project-context.md` | Current state |
| `specs/` | Feature specifications |

### Option B: Per-Project Install (Legacy)

Copy Prism OS directly into a single project.

```bash
# Copy product files to your project
cp -r prism/. /path/to/your/project/
```

**Note:** This method doesn't support automatic updates.

---

### Updating Prism OS

**Using the command (recommended):**
```
/prism-update
```

**Manually:**
```bash
cd ~/.prism-os && git pull && ./install-global.sh
```

### Uninstalling

```bash
~/.prism-os/install-global.sh --uninstall
rm -rf ~/.prism-os  # Optional: remove source code
```

### Troubleshooting

| Issue | Solution |
|-------|----------|
| `git: command not found` | Install Git first. macOS: `xcode-select --install`. Linux: `sudo apt install git` |
| `Permission denied` | Run `chmod +x ~/.prism-os/install-global.sh` |
| Commands not working | Re-run `~/.prism-os/install-global.sh` |
| WSL issues | Ensure you're in WSL terminal, not PowerShell |

See [`prism-install-instructions.md`](prism-install-instructions.md) for detailed troubleshooting.

---

## For Contributors

### Getting Started

1. Clone this repository
2. Read `CLAUDE.md` (root) for development instructions
3. Read `STATUS.md` for implementation status
4. Product code lives in `prism/`

### Repository Structure

| Path | Purpose |
|------|---------|
| `prism/` | **Distributable product** — what users install |
| `CLAUDE.md` | Development instructions (this repo) |
| `PROJECT_PLAN.md` | Development roadmap |
| `STATUS.md` | Implementation status |
| `tools/` | Development utilities (linter, etc.) |
| `tests/` | Test files |
| `specs/` | Spec development workspace |

### Development Workflow

```bash
# Run the linter
python3 tools/workflow-linter.py --verbose

# Test product in isolation
cp -r prism/ /tmp/test-project/
cd /tmp/test-project/
claude  # Verify it works
```

### Key Principle

**Product code lives in `prism/`.**
When editing Prism functionality, work inside `prism/`. Paths in product files are relative to `prism/` as the root.

---

## Links

- [Product README](prism/README.md) — User documentation
- [Quick Start](prism/docs/quick-start.md) — Get running in 5 minutes
- [Status](STATUS.md) — What's implemented
- [Roadmap](PROJECT_PLAN.md) — Development plan

---

Built with [Claude Code](https://www.anthropic.com/claude-code) by Anthropic.
