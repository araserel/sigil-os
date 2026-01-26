# Prism OS

Specification-driven development for non-technical users.

## Installation

Copy the contents of this directory to your project:

```bash
# Note: use /. to include hidden directories like .claude/
cp -r /path/to/prism-os/prism/. /your/project/
```

Or clone and copy:

```bash
git clone <repository-url>
cp -r prism-os/prism/. /your/project/
```

## Quick Start

```
/prism [your request]
```

Examples:
- `/prism I need user authentication with social login`
- `/prism Review this spec for completeness`
- `/prism status`

Or use natural language:
- "I want to add a contact form"
- "What's the progress?"
- "Keep going"

## Documentation

See `docs/` for complete reference:
- [Quick Start](docs/quick-start.md) — Get running in 5 minutes
- [User Guide](docs/user-guide.md) — Complete usage reference
- [Command Reference](docs/command-reference.md) — All commands documented
- [Glossary](docs/glossary.md) — Term definitions

## Requirements

- Claude Code CLI (with active subscription)
- Node.js 18+ (required by Claude Code)
- A project directory for Prism to operate in

## What's Included

```
.claude/          AI agent and skill definitions
├── agents/       Specialized AI agents
├── skills/       Reusable workflow skills
├── chains/       Multi-step workflows
└── commands/     Slash command definitions

templates/        Document templates
memory/           Project state and constitution
docs/             User documentation
CLAUDE.md         Main configuration
```

## Philosophy

- **Specs before code** — Every feature starts with a clear specification
- **Humans stay in control** — AI handles translation; humans make decisions
- **Plain English by default** — Technical details available but never required
- **Quality is non-negotiable** — Built-in review gates catch issues early
