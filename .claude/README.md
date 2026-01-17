# .claude Directory

This directory contains Claude Code configuration for the Prism operating system.

## Structure

```
.claude/
├── agents/           # Agent definitions (8 core agents)
├── skills/           # Skill definitions organized by category
│   ├── workflow/     # Core workflow skills (spec-writer, clarifier, etc.)
│   ├── engineering/  # Engineering skills (code-reviewer, adr-writer, etc.)
│   ├── quality/      # Quality skills (qa-validator, qa-fixer)
│   └── research/     # Research skills (researcher, knowledge-search)
└── chains/           # Skill chain definitions
```

## Usage

Claude Code automatically loads agent and skill definitions from this directory. Agents are invoked based on trigger words in user requests; skills are invoked by agents or directly via slash commands.

## Adding New Components

- **Agents:** Add `.md` files to `agents/` following the agent template format
- **Skills:** Add `.md` files to the appropriate `skills/` subdirectory
- **Chains:** Add `.md` files to `chains/` defining skill sequences

See `/docs/extending-skills.md` for detailed guidance.
