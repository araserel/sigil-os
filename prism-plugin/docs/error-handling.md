# Error Handling Protocol

> Unified error taxonomy and recovery procedures across Prism agents and skills.

---

## Overview

This document defines how errors are classified, communicated, and resolved throughout the Prism workflow. Consistent error handling ensures:

- **Predictable behavior** when things go wrong
- **Clear escalation paths** for human intervention
- **Minimal disruption** to workflow progress
- **Actionable context** for resolution

---

## Error Categories

### Three-Tier Taxonomy

| Category | Definition | Recovery | Human Needed |
|----------|------------|----------|--------------|
| **Soft** | Auto-recoverable issues | Retry up to 3x | No |
| **Hard** | Requires decision/input | Escalate with context | Yes |
| **Blocking** | Prevents all progress | Halt and report | Yes |

---

### Soft Errors

**Definition:** Transient or fixable issues that agents can resolve automatically.

**Recovery:** Retry operation (max 3 attempts), apply auto-fix, or skip with documentation.

**Examples:**

| Error | Agent/Skill | Auto-Recovery |
|-------|-------------|---------------|
| Lint errors | qa-validator | Run auto-formatter |
| Type warnings | qa-validator | Attempt type inference fix |
| Minor test failure | qa-fixer | Apply targeted fix |
| Network timeout | researcher | Retry with backoff |
| File format issue | spec-writer | Regenerate section |
| Missing optional dependency | developer | Install and retry |

**Behavior:**
```
On soft error:
1. Log error context
2. Attempt recovery (max 3x)
3. If recovered → Continue workflow
4. If not recovered → Escalate to Hard error
```

---

### Hard Errors

**Definition:** Issues requiring human decision, clarification, or approval to proceed.

**Recovery:** Escalate to human with full context, options, and recommendation.

**Examples:**

| Error | Agent/Skill | Requires |
|-------|-------------|----------|
| Ambiguous requirement | clarifier | User clarification |
| Constitution conflict | architect | Human override decision |
| Security finding | security-reviewer | Risk acceptance |
| Test logic unclear | qa-engineer | Direction on expected behavior |
| Multiple valid approaches | architect | Selection decision |
| Scope exceeds track | task-planner | Re-track approval |

**Behavior:**
```
On hard error:
1. Pause current workflow
2. Document full context (see Error Context JSON)
3. Present options to human
4. Await decision
5. Resume with decision applied
```

---

### Blocking Errors

**Definition:** Fundamental issues that prevent any forward progress until resolved.

**Recovery:** Full stop. Cannot proceed until root cause addressed.

**Examples:**

| Error | Agent/Skill | Resolution Required |
|-------|-------------|---------------------|
| Missing spec file | All | Create or locate spec |
| Invalid workflow state | orchestrator | State correction |
| Critical security vulnerability | security | Must fix before continue |
| Missing required approval | Any approve-tier | Obtain approval |
| Constitution violation | gate-checker | Compliance resolution |
| Circular dependency | task-planner | Architecture revision |
| Artifact corruption | Any | Restore or regenerate |

**Behavior:**
```
On blocking error:
1. HALT all workflow operations
2. Document error with full context
3. Notify human immediately
4. Do NOT attempt workarounds
5. Resume only when blocker resolved
```

---

## Error Context JSON

When escalating errors, include structured context for resolution:

```json
{
  "error_id": "ERR-[timestamp]-[random]",
  "error_category": "soft | hard | blocking",
  "error_code": "[CATEGORY]-[NUMBER]",
  "error_source": {
    "agent": "[Agent name]",
    "skill": "[Skill name if applicable]",
    "phase": "[Current workflow phase]"
  },
  "error_details": {
    "message": "[Human-readable description]",
    "location": "[File:line or workflow step]",
    "expected": "[What should have happened]",
    "actual": "[What actually happened]"
  },
  "recovery_attempted": [
    {
      "action": "[What was tried]",
      "result": "[Outcome]",
      "timestamp": "[When]"
    }
  ],
  "iteration_count": 0,
  "suggested_recovery": [
    {
      "option": "A",
      "description": "[Recovery option]",
      "impact": "[What this affects]",
      "recommended": true
    }
  ],
  "context": {
    "spec_path": "[Path to spec]",
    "chain_id": "[Workflow chain ID]",
    "related_artifacts": ["[List of relevant files]"]
  }
}
```

---

## Agent-Specific Error Handling

### Orchestrator
| Error Type | Category | Handling |
|------------|----------|----------|
| Unknown phase | Blocking | Halt, report invalid state |
| Missing context file | Soft | Create from template |
| Invalid track | Hard | Ask user to confirm track |

### Business Analyst
| Error Type | Category | Handling |
|------------|----------|----------|
| Ambiguous input | Hard | Invoke clarifier (max 3x) |
| Missing user context | Hard | Ask clarifying questions |
| Spec generation failure | Soft | Retry with simpler structure |

### Architect
| Error Type | Category | Handling |
|------------|----------|----------|
| Research inconclusive | Soft | Document gaps, proceed |
| Constitution conflict | Hard | Present conflict, await decision |
| Excessive complexity | Hard | Propose simplification options |

### Task Planner
| Error Type | Category | Handling |
|------------|----------|----------|
| Circular dependency | Blocking | Report, await restructure |
| Task count exceeds limit | Hard | Propose scope reduction |
| Incomplete plan input | Soft | Request missing sections |

### Developer
| Error Type | Category | Handling |
|------------|----------|----------|
| Test won't pass | Soft | Analyze, retry (max 3x) |
| Breaking existing tests | Hard | Report conflict, await direction |
| Criterion impossible | Blocking | Escalate to Task Planner |

### QA Engineer
| Error Type | Category | Handling |
|------------|----------|----------|
| Test failure | Soft | Return to Developer for fix |
| Fix loop exceeded (5x) | Blocking | Escalate to Orchestrator |
| Environment issue | Hard | Report, propose options |
| Flaky test detected | Hard | Propose test remediation |

### Security
| Error Type | Category | Handling |
|------------|----------|----------|
| Critical finding | Blocking | Must resolve before proceed |
| High finding | Hard | Require acknowledgment |
| Dependency vulnerability | Soft | Report in findings, continue |

### DevOps
| Error Type | Category | Handling |
|------------|----------|----------|
| Pipeline failure | Soft | Analyze, retry |
| Environment unhealthy | Blocking | Halt deployment |
| Approval timeout | Hard | Escalate or cancel |

---

## Iteration Limits

Different operations have defined retry limits:

| Operation | Limit | On Exceed |
|-----------|-------|-----------|
| Clarification cycles | 3 | Escalate for human input |
| QA fix cycles | 5 | Escalate to Orchestrator |
| Auto-fix attempts | 3 | Escalate to Hard error |
| Network retries | 3 | Report failure, continue |
| Deployment retries | 2 | Halt and report |

---

## Escalation Paths

### Standard Escalation Flow

```
Soft Error (auto-recoverable)
    │
    ├── Recovery succeeds → Continue
    │
    └── Recovery fails (3x) → Escalate
                                │
                                ▼
Hard Error (needs decision)
    │
    ├── Human decides → Continue with decision
    │
    └── No resolution possible → Escalate
                                    │
                                    ▼
Blocking Error (full stop)
    │
    └── Human resolves root cause → Resume
```

### Agent Escalation Targets

| From Agent | Escalate To |
|------------|-------------|
| Business Analyst | Orchestrator (for workflow) or Human (for decisions) |
| Architect | Orchestrator or Human |
| Task Planner | Orchestrator |
| Developer | Task Planner (scope) or QA Engineer (fix loop) |
| QA Engineer | Orchestrator (loop exceeded) or Developer (fixes) |
| Security | Human (always for findings) |
| DevOps | Human (always for production) |

---

## Error Communication

### To Human

When presenting errors to humans, use this format:

```markdown
## [Error Category]: [Brief Title]

**What happened:**
[Plain language explanation]

**Impact:**
[What this prevents or affects]

**Options:**
A) [First option] - [Consequence]
B) [Second option] - [Consequence]
C) [Third option] - [Consequence]

**Recommendation:** [Option] because [reason]

**To proceed:**
[What human needs to do]
```

### Between Agents

When communicating errors in handoffs, include in State Transfer JSON:

```json
{
  "error_state": {
    "has_error": true,
    "error_category": "hard",
    "error_code": "HARD-042",
    "error_summary": "Multiple valid implementation approaches",
    "recovery_needed": "Decision on approach A vs B",
    "error_context": { /* Full Error Context JSON */ }
  }
}
```

---

## Recovery Protocols

### Soft Error Recovery

1. **Log** the error with context
2. **Attempt** automatic recovery
3. **Verify** recovery succeeded
4. **Document** recovery action taken
5. **Continue** workflow

### Hard Error Recovery

1. **Pause** current operation
2. **Package** full error context
3. **Present** options clearly
4. **Wait** for human decision
5. **Apply** decision
6. **Resume** workflow
7. **Document** decision rationale

### Blocking Error Recovery

1. **Halt** all related operations
2. **Notify** human immediately
3. **Preserve** current state
4. **Document** full context
5. **Do not** attempt workarounds
6. **Wait** for resolution
7. **Validate** resolution before resume
8. **Resume** with clean state

---

## Error Codes Reference

### Code Format
`[CATEGORY]-[NUMBER]`

### Common Codes

| Code | Description |
|------|-------------|
| `SOFT-001` | Auto-fixable lint error |
| `SOFT-002` | Transient network failure |
| `SOFT-003` | Minor type mismatch |
| `HARD-001` | Ambiguous requirement |
| `HARD-002` | Constitution conflict |
| `HARD-003` | Multiple valid approaches |
| `HARD-004` | Scope exceeds track limits |
| `HARD-005` | Security finding requires acknowledgment |
| `BLOCK-001` | Missing required artifact |
| `BLOCK-002` | Invalid workflow state |
| `BLOCK-003` | Critical security vulnerability |
| `BLOCK-004` | Circular dependency |
| `BLOCK-005` | Iteration limit exceeded |

---

## Integration with Handoffs

Error state must be included in handoff State Transfer JSON:

```json
{
  "chain_id": "...",
  "spec_path": "...",
  "track": "...",
  "iteration_counts": {...},
  "approvals": {...},
  "error_state": {
    "has_error": false,
    "errors_resolved": [
      {
        "error_code": "SOFT-001",
        "resolution": "Auto-fixed lint errors",
        "resolved_at": "2024-01-15T10:30:00Z"
      }
    ],
    "current_error": null
  }
}
```

---

## Best Practices

1. **Fail fast** — Detect errors early, don't propagate bad state
2. **Full context** — Always include enough information to diagnose
3. **Clear options** — Present actionable choices, not just problems
4. **Recommend** — Suggest the best option with reasoning
5. **Document** — Log all errors and resolutions for learning
6. **Don't guess** — If uncertain, escalate rather than assume
7. **Preserve state** — Never lose work when errors occur
8. **Clean resume** — Validate state before continuing after errors

---

## Related Documents

- [Context Management Protocol](/docs/context-management.md) — State tracking
- [Handoff Template](/templates/handoff-template.md) — Error state in transitions
- [Constitution](/specs/000-constitution/spec.md) — Quality gates that trigger errors
