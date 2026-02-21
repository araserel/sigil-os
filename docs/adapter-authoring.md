# Creating an Integration Adapter

This guide explains how to create a new adapter that connects Sigil to an external tool (issue tracker, CI/CD system, etc.). The Jira adapter is used as a reference throughout.

## What Adapters Do

An adapter translates between Sigil's internal format and an external tool's API. Each adapter provides:

- **Read protocols** — Fetch work items, statuses, and metadata
- **Write protocols** — Post summaries, transition statuses, link artifacts
- **Category mapping** — Map the tool's work item types to Sigil categories
- **Configuration** — Org-level defaults shared via the shared context repo

## File Structure

Create a new directory under `sigil-plugin/skills/integration/`:

```
sigil-plugin/skills/integration/
  your-tool/
    SKILL.md    <- Adapter definition
```

## SKILL.md Template

```yaml
---
name: your-tool
description: Adapter for Your Tool — fetches and writes work items via Your Tool MCP.
version: 1.0.0
category: integration
chainable: false
invokes: []
invoked_by: [ticket-loader, handoff-back]
tools: ToolSearch, mcp__your_tool__get_item, mcp__your_tool__add_comment
model: haiku
---
```

## Required Protocols

### Phase 1: Read Protocols

Every adapter must implement these three protocols:

#### Fetch Ticket

Called by `ticket-loader` Step 2. Receives a ticket key and returns structured data.

**Must return:**
```json
{
  "key": "TOOL-123",
  "summary": "...",
  "description": "...",
  "type": "...",
  "priority": "...",
  "status": "...",
  "labels": [],
  "story_points": null,
  "assignee": "...",
  "reporter": "...",
  "parent_key": null,
  "subtask_count": 0,
  "link_count": 0
}
```

All fields are optional except `key` and `summary`. Use `null` for unavailable fields.

#### Fetch Parent

Called by `ticket-loader` Step 3. Receives a parent key and returns parent context.

**Must return:** `{ key, summary, description, type }` or `null` if no parent.

#### Categorize

Called by `ticket-loader` Step 4. Maps the tool's work item types and labels to Sigil categories.

**Sigil categories:** `feature`, `bug`, `enhancement`, `maintenance`

Define a mapping table in your adapter. The ticket-loader uses this to route work through the appropriate workflow track.

### Phase 2: Write Protocols

These are optional but recommended for closing the loop on ticket-driven workflows:

#### Post Summary

Called by `handoff-back` Step 3. Posts an implementation summary as a comment or note on the ticket.

#### Transition Status

Called by `handoff-back` Step 3. Moves the ticket to a "done" status. Must check available transitions first.

#### Link Artifact

Called by `handoff-back` Step 3. Adds a link to the spec directory or review package. Optional — fall back to including the link in the summary comment if the tool doesn't support external links.

## Configuration Schema

Each adapter defines a configuration schema that can be shared via the shared context repo's `integrations/` directory:

```yaml
adapter: your-tool
name: Your Tool
mcp_tools:
  - mcp__your_tool__get_item
  - mcp__your_tool__add_comment
config:
  project_keys: [PROJ, TEAM]
  category_mapping:
    bug: [Bug, Defect]
    feature: [Story, Feature]
    enhancement: [Task]
    maintenance: [Chore]
  status_mapping:
    done: [Done, Closed]
    in_progress: [In Progress]
    todo: [To Do, Open]
```

This config is stored in `.sigil/config.yaml` under `integrations.your-tool:` after setup.

## MCP Requirements

Your adapter needs an MCP server that provides access to the external tool's API. Document which MCP tools are required and provide setup guidance for users who don't have them configured.

Use `ToolSearch` to verify MCP availability before invoking any protocol.

## Error Handling

Follow these conventions:
- Return structured error objects: `{ error: "error_type", message: "..." }`
- Write protocols are always non-blocking — failures produce warnings, not halts
- Read protocol failures should offer plain-text input as a fallback
- If MCP is not configured, provide setup guidance

## Reference: Jira Adapter

See `sigil-plugin/skills/integration/jira/SKILL.md` for a complete working example. It demonstrates:
- MCP tool usage with `ToolSearch` for discovery
- Category mapping with label overrides
- Status transition with available-transitions check
- Graceful degradation when tools are missing
