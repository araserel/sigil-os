# Agents Directory

Contains definitions for the 8 core Prism OS agents.

## Core Team

| Agent | File | Primary Responsibility |
|-------|------|------------------------|
| Orchestrator | `orchestrator.md` | Route requests, manage workflow, track progress |
| Business Analyst | `business-analyst.md` | Requirements, specs, clarification |
| Architect | `architect.md` | Technical design, research, ADRs |
| Task Planner | `task-planner.md` | Task breakdown, sprint planning |
| Developer | `developer.md` | Code implementation |
| QA Engineer | `qa-engineer.md` | Validation, quality assurance |
| Security | `security.md` | Security review |
| DevOps | `devops.md` | Deployment, infrastructure |

## Agent Definition Format

Each agent file follows this structure:

```markdown
---
name: agent-name
description: When to invoke + role summary
tools: [List of permitted tools]
---

[System prompt defining agent behavior]

## Trigger Words
[Keywords that route requests to this agent]

## Skills Invoked
[Skills this agent can call]

## Handoff Protocol
[How this agent transitions work to others]
```

## Adding Specialist Agents

Additional specialist agents can be added from the awesome-subagents library. Place them in this directory following the standard format.
