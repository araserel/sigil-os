# Prism OS Repository

**Specification-driven development for non-technical users.**

---

## For Users

**Want to use Prism OS?** See [`prism/README.md`](prism/README.md).

### Quick Install

```bash
# Copy product files to your project (note the /. to include hidden dirs)
cp -r prism/. /path/to/your/project/
```

### What You Get

```
your-project/
├── CLAUDE.md         ← Prism's brain
├── .claude/          ← Agents, skills, commands
├── templates/        ← Document templates
├── memory/           ← Project state
└── docs/             ← Documentation
```

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
