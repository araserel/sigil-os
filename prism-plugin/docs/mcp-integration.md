# MCP Integration Guide

> Optional external tool integrations for Prism using Model Context Protocol.

---

## Overview

Prism can integrate with external tools through **Model Context Protocol (MCP)** to enhance workflow capabilities. These integrations are **optional** — Prism functions fully without them.

**What is MCP?**

MCP (Model Context Protocol) is a standard for connecting AI assistants to external data sources and tools. It allows Claude to access project management systems, documentation platforms, and other services.

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

Automatically sync tasks from Prism to your project tracking system.

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
Task Planner creates → /specs/###/tasks.md
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
Spec created → /specs/###/spec.md (local only)
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

Trigger and monitor deployment pipelines from Prism.

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

[Prism] Feature: User Authentication
Phase: Implement → Validate
Status: 5/8 tasks complete
Next: QA validation running

View details: /specs/001-user-auth/
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

### Prerequisites

1. Claude Code with MCP support enabled
2. MCP server for your target integration
3. API credentials for the external service

### General Setup Steps

1. **Install MCP Server**
   ```bash
   # Example for Context7
   npm install -g @anthropic/mcp-server-context7
   ```

2. **Configure MCP in Claude Code**
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

3. **Add Credentials**
   Set environment variables or use secure credential storage.

4. **Test Connection**
   Verify the MCP server responds correctly.

### Prism-Specific Configuration

Add MCP preferences to your project context:

```markdown
<!-- /memory/project-context.md -->

## MCP Integrations

| Service | Status | Purpose |
|---------|--------|---------|
| Jira | Active | Task tracking |
| Confluence | Active | Documentation |
| Context7 | Active | Research |
```

---

## Behavior Without MCP

Prism is designed to work fully without MCP integrations:

| Feature | Without MCP | With MCP |
|---------|-------------|----------|
| Task tracking | Local `tasks.md` | Local + Jira/Linear |
| Documentation | Local markdown | Local + Confluence |
| Research | Web search | Web + Context7 |
| CI/CD | Manual commands | Automated triggers |
| Notifications | Local status | Local + Slack/Teams |

**Key Principle:** MCP enhances but never replaces core functionality.

---

## Security Considerations

### Data Flow

```
Prism → MCP Server → External Service
            ↑
     Credentials required
```

### Best Practices

1. **Least Privilege** — Grant only necessary permissions
2. **Audit Logging** — Track what data flows to external services
3. **Credential Security** — Use environment variables, not hardcoded
4. **Review Before Send** — Human approval for sensitive data
5. **Local First** — Always maintain local copies

### Sensitive Data

**Never send to external services:**
- API keys or secrets
- Personal data without consent
- Security vulnerability details (until fixed)
- Proprietary business logic

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

- [Context Management](/docs/context-management.md) — Project state
- [Error Handling](/docs/error-handling.md) — Integration errors
- [Skills README](/.claude/skills/README.md) — Skill catalog
