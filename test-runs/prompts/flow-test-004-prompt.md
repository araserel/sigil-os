## Task: Dry-Run Escalation Test

Simulate a validation failure that cannot be auto-fixed and requires human escalation.

### Simulated Scenario
Developer completed task but:
- Architecture violation detected (wrong pattern used)
- Cannot be auto-fixed — requires human decision

### Expected Flow
```
qa-validator (fail) → qa-fixer (cannot fix) → escalate to Orchestrator → Human
```

### Output to `/test-runs/flow-test-004/`