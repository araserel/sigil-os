# Agents Directory

Contains definitions for the 9 core Sigil OS agents.

## Core Team

| Agent | File | Primary Responsibility |
|-------|------|------------------------|
| Orchestrator | `orchestrator.md` | Route requests, manage workflow, track progress |
| Business Analyst | `business-analyst.md` | Requirements, specs, clarification |
| UI/UX Designer | `uiux-designer.md` | Component design, accessibility, framework selection |
| Architect | `architect.md` | Technical design, research, ADRs |
| Task Planner | `task-planner.md` | Task breakdown, sprint planning |
| Developer | `developer.md` | Code implementation |
| QA Engineer | `qa-engineer.md` | Validation, quality assurance |
| Security | `security.md` | Security review |
| DevOps | `devops.md` | Deployment, infrastructure |

## Workflow Sequence

For features with UI components, the standard handoff sequence is:

```
Orchestrator → Business Analyst → UI/UX Designer → Architect → Task Planner → Developer → QA Engineer → [Security/DevOps]
```

For backend-only features, UI/UX Designer is skipped.

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

## Specialists

Specialist agents provide domain-specific behavior overrides for base agents. They live in the `specialists/` subdirectory and are loaded at runtime by the implementation loop when the `specialist-selection` skill assigns them to a task.

### Inheritance Model

Each specialist file declares an `extends` field in its frontmatter (e.g., `extends: developer`). At runtime:
1. The base agent definition is loaded first
2. The specialist's override sections replace matching sections in the base
3. The merged behavior applies for the duration of that task
4. Tasks without a specialist assignment use the base agent directly

For full merge rules (field precedence, tool union, constraint inheritance), see [Specialist Merge Protocol](../docs/dev/specialist-merge-protocol.md).

### Developer Specialists (extend `developer`)

| Specialist | File | Focus |
|-----------|------|-------|
| API Developer | `specialists/api-developer.md` | API contracts, backwards compat, REST/GraphQL |
| Frontend Developer | `specialists/frontend-developer.md` | Components, accessibility, responsive design |
| Data Developer | `specialists/data-developer.md` | Schema integrity, migrations, query performance |
| Integration Developer | `specialists/integration-developer.md` | Third-party APIs, retry/circuit-breaker, credentials |

### QA Specialists (extend `qa-engineer`)

| Specialist | File | Focus |
|-----------|------|-------|
| Functional QA | `specialists/functional-qa.md` | Business logic correctness, requirement coverage |
| Edge Case QA | `specialists/edge-case-qa.md` | Boundaries, race conditions, adversarial testing |
| Performance QA | `specialists/performance-qa.md` | Load patterns, query analysis, metrics validation |

### Security Specialists (extend `security`)

| Specialist | File | Focus |
|-----------|------|-------|
| AppSec Reviewer | `specialists/appsec-reviewer.md` | OWASP Top 10, auth flaws, injection vectors |
| Data Privacy Reviewer | `specialists/data-privacy-reviewer.md` | PII handling, encryption, GDPR/CCPA |

### Adding Custom Specialists

To create a custom specialist:

1. Create a new `.md` file in `specialists/`
2. Include YAML frontmatter with `name`, `extends` (must reference a valid base agent), and `description`
3. Add override sections: Priorities, Evaluation Criteria, Risk Tolerance, Domain Context, Collaboration Notes
4. Keep files lean (30-50 lines) — only include differentiation from the base agent
5. The `specialist-selection` skill will need file scope or keyword patterns added to recognize the new specialist
