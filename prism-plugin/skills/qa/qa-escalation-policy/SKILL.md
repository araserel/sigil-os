---
name: qa-escalation-policy
description: Canonical escalation policy shared across all QA skills and the QA Engineer agent
version: 1.0.0
category: qa
type: reference
chainable: false
invokes: []
invoked_by: [qa-validator, qa-fixer, qa-engineer]
tools: []
---

# QA Escalation Policy

## Purpose

Single source of truth for when QA processes should escalate to human review. Referenced by qa-validator, qa-fixer, and the qa-engineer agent.

## Escalation Triggers

Escalate to human review when ANY of these conditions are met:

1. **Iteration limit reached** — 5 fix attempts exhausted without resolution
2. **Security concern** — Any security-related failure detected during validation
3. **Behavioral change required** — Fix would change application behavior, not just style/format
4. **Test modification needed** — Test assertions need changing (not just test scaffolding)
5. **Coverage regression** — Test coverage drops below project threshold
6. **Constitution violation** — Violation that cannot be auto-fixed
7. **Cascading failures** — Fix causes new issues in other areas
8. **Multiple interrelated issues** — Issues are coupled and can't be fixed independently
9. **Environment blocking** — Test infrastructure issues preventing validation
10. **Requirement ambiguity** — Cannot verify a requirement due to unclear acceptance criteria

## Escalation Report Format

When escalating, always include:
- What was tried (with iteration count)
- Why auto-resolution failed
- Specific recommendation for human action
- Files and line numbers involved
- Whether the issue is a code problem, test problem, environment problem, or requirement problem

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-05 | Extracted from qa-validator, qa-fixer, and qa-engineer |
