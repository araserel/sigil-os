## Task: Dry-Run QA & Review Flow Test

Execute a simulated validation and review workflow. This continues from where flow-test-001 stopped.

### Test Mode Rules
- No actual code changes — agents describe what they WOULD do
- Create simulation artifacts documenting the workflow
- Track all handoffs with timestamps
- Output to `/test-runs/flow-test-002/`

### Simulated Context
Assume Developer has just completed T010 (POST /auth/reset-password endpoint) from flow-test-001.

### Expected Flow
```
Developer → QA Engineer (qa-validator) → QA Engineer (pass) → Security (code-reviewer + security-reviewer) → DevOps (deploy-checker) → [STOP]
```

### What Each Agent Should Output
[Similar structure to flow-test-001 — each agent creates simulation artifact documenting what they would do]

### Success Criteria
- QA validation passes on first attempt
- Code review: approved with suggestions
- Security review: secure (no findings)
- Deploy readiness: ready for staging