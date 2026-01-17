# Chains Directory

Contains skill chain definitions that orchestrate multi-skill workflows.

## Core Chains

| Chain | File | Use Case |
|-------|------|----------|
| Full Pipeline | `full-pipeline.md` | Standard/Enterprise track features |
| Quick Flow | `quick-flow.md` | Bug fixes, small changes |
| Research-First | `research-first.md` | New technology decisions |
| QA Loop | `qa-loop.md` | Validation and fix cycle |
| Review Pipeline | `review-pipeline.md` | Pre-merge reviews |

## Chain Definition Format

```markdown
---
name: chain-name
description: When to use this chain
track: quick|standard|enterprise|all
---

# Chain: [Name]

## Use Case
[When this chain applies]

## Skill Sequence
[Ordered list of skills with conditions]

## State Transitions
[What triggers moves between skills]

## Human Checkpoints
[Where the chain pauses for approval]

## Error Handling
[How failures are managed]
```

## Chain Execution

Chains are invoked by:
1. Orchestrator selecting based on complexity assessment
2. User explicitly requesting a track
3. Skills invoking as part of their workflow
