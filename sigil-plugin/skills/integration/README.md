# Integration Skills

Skills in this category provide adapter implementations for external tools (issue trackers, CI/CD, etc.). Each adapter is a subdirectory containing a `SKILL.md` that defines read and write protocols for a specific tool.

## How Adapters Work

Adapters translate between Sigil's internal context format and external tool APIs via MCP. Each adapter defines:

- **Read protocols** — fetch tickets, statuses, metadata from the external tool
- **Write protocols** — post summaries, transition statuses, link artifacts back to the tool
- **Configuration schema** — org-level defaults stored in `.sigil/config.yaml` under `integrations:`
- **Category mapping** — how the tool's work item types map to Sigil's categories (feature, bug, maintenance, enhancement)

## Available Adapters

| Adapter | Tool | Status |
|---------|------|--------|
| `jira/` | Atlassian Jira | Phase 1 (read-only) |

## Adding a New Adapter

See `docs/adapter-authoring.md` for a guide to creating new adapters.
