# MCP Integration Guide

> Connect Sigil to external tools like Jira, Slack, and Confluence.

> **Audience:** This guide is for advanced users and developers who want to connect Sigil to external services.

---

## Overview

Sigil can connect to external tools through **MCP** (Model Context Protocol — a standard way to link AI assistants to outside services). These connections are **optional**. Sigil works fully without them.

MCP lets Claude access project trackers, wikis, chat tools, and more. You add a connection once, and Sigil uses it automatically during your workflow.

---

## Integration Points

### Overview Table

| Integration | Agent | Skill | Purpose |
|-------------|-------|-------|---------|
| Jira/Linear | Task Planner | task-decomposer | Sync tasks to project tracker |
| Confluence/Notion | Business Analyst | spec-writer | Publish specs to wiki |
| Context7 | Architect | researcher | Access documentation context |
| CI/CD (GitHub Actions, etc.) | DevOps | deploy-checker | Trigger/monitor pipelines |
| Slack/Teams | Orchestrator | status-reporter | Post status updates |
| Sentry/DataDog | QA Engineer | qa-validator | Access error monitoring |

---

## Jira/Linear Integration

### Purpose

Automatically sync tasks from Sigil to your project tracking system.

### Integration Points

| Agent | Skill | Action |
|-------|-------|--------|
| Task Planner | task-decomposer | Create tickets from tasks |
| Developer | — | Update ticket status on completion |
| QA Engineer | qa-validator | Link validation reports |

### Configuration

```json
{
  "mcp_server": "jira",
  "config": {
    "instance_url": "https://your-instance.atlassian.net",
    "project_key": "PROJ",
    "default_issue_type": "Task",
    "status_mapping": {
      "pending": "To Do",
      "in_progress": "In Progress",
      "completed": "Done"
    }
  }
}
```

### Workflow Enhancement

**Without MCP:**
```
Task Planner creates → /.sigil/specs/###/tasks.md
Developer references → tasks.md manually
```

**With MCP:**
```
Task Planner creates → tasks.md AND creates Jira tickets
Developer → tickets update automatically on completion
```

### Sample Task Sync

```markdown
### T001: Implement login form

This task will sync to Jira as:
- Summary: T001: Implement login form
- Description: [Full task description from tasks.md]
- Labels: [feature-id, track]
- Story Points: [Estimated from complexity]
```

---

## Confluence/Notion Integration

### Purpose

Publish specifications and documentation to your team wiki automatically.

### Integration Points

| Agent | Skill | Action |
|-------|-------|--------|
| Business Analyst | spec-writer | Publish spec to wiki |
| Architect | technical-planner | Publish plan to wiki |
| Security | security-reviewer | Publish security report |

### Configuration

```json
{
  "mcp_server": "confluence",
  "config": {
    "base_url": "https://your-instance.atlassian.net/wiki",
    "space_key": "DOCS",
    "parent_page": "Feature Specifications",
    "template_mapping": {
      "spec": "Feature Specification Template",
      "plan": "Implementation Plan Template"
    }
  }
}
```

### Workflow Enhancement

**Without MCP:**
```
Spec created → /.sigil/specs/###/spec.md (local only)
Team access → Must check repository
```

**With MCP:**
```
Spec created → spec.md AND Confluence page
Team access → Wiki link shared automatically
```

---

## Context7 Integration

### Purpose

Provide architects with rich documentation context during planning.

### Integration Points

| Agent | Skill | Action |
|-------|-------|--------|
| Architect | researcher | Query documentation |
| Architect | technical-planner | Access API references |

### Configuration

```json
{
  "mcp_server": "context7",
  "config": {
    "libraries": [
      "react",
      "next.js",
      "prisma"
    ],
    "priority": "stable_versions"
  }
}
```

### Workflow Enhancement

**Without MCP:**
```
Architect researches → Web search, manual docs lookup
```

**With MCP:**
```
Architect researches → Direct access to indexed documentation
```

---

## CI/CD Integration

### Purpose

Trigger and monitor deployment pipelines from Sigil.

### Integration Points

| Agent | Skill | Action |
|-------|-------|--------|
| DevOps | deploy-checker | Check pipeline status |
| DevOps | — | Trigger deployment |
| QA Engineer | qa-validator | Run CI checks |

### Configuration

```json
{
  "mcp_server": "github",
  "config": {
    "repo": "owner/repo",
    "workflows": {
      "test": "test.yml",
      "deploy_staging": "deploy-staging.yml",
      "deploy_production": "deploy-production.yml"
    }
  }
}
```

### Workflow Enhancement

**Without MCP:**
```
DevOps checks → Manual pipeline inspection
Deployment → Manual trigger
```

**With MCP:**
```
DevOps checks → Automated status from GitHub Actions
Deployment → Triggered through MCP with approval
```

---

## Slack/Teams Integration

### Purpose

Post workflow status updates to team channels.

### Integration Points

| Agent | Skill | Action |
|-------|-------|--------|
| Orchestrator | status-reporter | Post status to channel |
| Security | security-reviewer | Alert on critical findings |
| DevOps | deploy-checker | Notify on deployment |

### Configuration

```json
{
  "mcp_server": "slack",
  "config": {
    "channel": "#dev-updates",
    "notifications": {
      "phase_complete": true,
      "blockers": true,
      "deployment": true,
      "security_critical": true
    }
  }
}
```

### Sample Notification

```
#dev-updates

[Sigil] Feature: User Authentication
Phase: Implement → Validate
Status: 5/8 tasks complete
Next: QA validation running

View details: /.sigil/specs/001-user-auth/
```

---

## Error Monitoring Integration

### Purpose

Access application error data during QA and debugging.

### Integration Points

| Agent | Skill | Action |
|-------|-------|--------|
| QA Engineer | qa-validator | Check for runtime errors |
| Developer | — | Access error context |

### Configuration

```json
{
  "mcp_server": "sentry",
  "config": {
    "organization": "your-org",
    "project": "your-project",
    "environment": "staging"
  }
}
```

---

## Setting Up MCP

### What You Need

1. Claude Code with MCP support turned on
2. An MCP server for the service you want to connect (e.g., Jira, Slack)
3. Login credentials for that service (API key or token)

### How to Connect a Service

1. **Install the MCP server** for your service.
   ```bash
   # Example: install the Context7 documentation server
   npm install -g @anthropic/mcp-server-context7
   ```

2. **Tell Claude Code about the server.** Add it to your settings file.
   ```json
   // .claude/mcp-config.json
   {
     "servers": {
       "context7": {
         "command": "mcp-server-context7",
         "args": []
       }
     }
   }
   ```

3. **Add your credentials.** Use environment variables — never put passwords in files.

4. **Test the connection.** Start Claude Code and verify the server responds.

You should now see the service listed when you check your MCP connections.

### Sigil-Specific Configuration

Add MCP preferences to your project context:

```markdown
<!-- /.sigil/project-context.md -->

## MCP Integrations

| Service | Status | Purpose |
|---------|--------|---------|
| Jira | Active | Task tracking |
| Confluence | Active | Documentation |
| Context7 | Active | Research |
```

---

## Behavior Without MCP

Sigil is designed to work fully without MCP integrations:

| Feature | Without MCP | With MCP |
|---------|-------------|----------|
| Task tracking | Local `tasks.md` | Local + Jira/Linear |
| Documentation | Local markdown | Local + Confluence |
| Research | Web search | Web + Context7 |
| CI/CD | Manual commands | Automated triggers |
| Notifications | Local status | Local + Slack/Teams |

**Key Principle:** MCP enhances but never replaces core functionality.

---

## Security

### How Data Flows

```
Sigil → MCP Server → External Service
            ↑
     Credentials required
```

Data only flows outward when an MCP server is set up. Without MCP, nothing leaves your machine.

### Best Practices

1. **Give least access** — Only grant the permissions each service needs
2. **Use environment variables** — Never put credentials in files
3. **Review before sending** — Require human approval for sensitive data
4. **Keep local copies** — MCP adds to your local files, never replaces them

> **Warning:** Never send API keys, personal data, security findings, or business secrets to external services.

---

## Troubleshooting

### MCP Server Not Connecting

1. Verify MCP server is installed and running
2. Check configuration file syntax
3. Verify credentials are set
4. Check network connectivity

### Data Not Syncing

1. Verify API permissions
2. Check rate limits
3. Review MCP server logs
4. Verify field mapping

### Integration Conflicts

1. Check for duplicate IDs
2. Verify status mapping
3. Review sync timing

---

## Related Documents

- [Context Management](dev/context-management.md) — Project state
- [Error Handling](dev/error-handling.md) — Integration errors
- [Skills README](../skills/README.md) — Skill catalog
