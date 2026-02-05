# Prism OS

**Specification-driven development for Claude Code.**

Transform natural language descriptions into implemented, tested features through structured workflows.

---

## Installation

Prism OS is a Claude Code plugin. Install it in seconds:

```bash
# Add the marketplace
claude plugin marketplace add araserel/prism-os

# Install the plugin
claude plugin install prism@prism-os
```

Or from within Claude Code:
```
/plugin marketplace add araserel/prism-os
/plugin install prism@prism-os
```

### Verify Installation

```
/prism status
```

You should see the Prism OS status dashboard.

---

## Quick Start

Once installed, describe what you want to build:

```
/prism "Add a user login page with email and password"
```

Prism guides you through:
1. **Specification** — Captures requirements
2. **Clarification** — Resolves ambiguities
3. **Planning** — Creates implementation plan
4. **Tasks** — Breaks plan into actionable items
5. **Implementation** — Writes and validates code
6. **Review** — Security and code review

### Key Commands

| Command | Purpose |
|---------|---------|
| `/prism` | Show status and next steps |
| `/prism "description"` | Start building a new feature |
| `/prism continue` | Resume where you left off |
| `/prism-update` | Check for plugin updates |

---

## Updating

```
/plugin update prism@prism-os
```

Or use the familiar command:
```
/prism-update
```

---

## Documentation

- [Quick Start Guide](prism-plugin/docs/quick-start.md)
- [User Guide](prism-plugin/docs/user-guide.md)
- [Command Reference](prism-plugin/docs/command-reference.md)

### Migrating from Global Install?

If you previously used `install-global.sh`, see the [Migration Guide](prism-plugin/docs/migration-from-global.md).

---

## For Contributors

### Repository Structure

| Path | Purpose |
|------|---------|
| `prism-plugin/` | **The plugin** — distributable product |
| `CLAUDE.md` | Development instructions |
| `STATUS.md` | Implementation status |
| `tools/` | Development utilities (linter, etc.) |
| `tests/` | Test files |

### Development Setup

```bash
# Clone the repository
git clone https://github.com/araserel/prism-os.git
cd prism-os

# Install locally for testing
claude plugin marketplace add ./
claude plugin install prism@prism-os

# Run the linter
python3 tools/workflow-linter.py --verbose
```

### Key Files

| File | Purpose |
|------|---------|
| `prism-plugin/.claude-plugin/plugin.json` | Plugin manifest |
| `prism-plugin/commands/` | Slash commands |
| `prism-plugin/agents/` | Agent definitions |
| `prism-plugin/skills/` | Skill implementations |
| `prism-plugin/hooks/` | Lifecycle hooks |

---

## Links

- [Plugin Documentation](prism-plugin/docs/README.md)
- [Development Status](STATUS.md)
- [Project Roadmap](PROJECT_PLAN.md)

---

Built with [Claude Code](https://www.anthropic.com/claude-code) by Anthropic.
