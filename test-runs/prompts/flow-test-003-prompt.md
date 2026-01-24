## Task: Dry-Run QA Fix Loop Test

Simulate a validation failure that requires the qa-fixer loop.

### Simulated Scenario
Developer completed task but:
- 2 lint errors present
- 1 missing test for edge case

### Expected Flow
```
qa-validator (fail) → qa-fixer (iteration 1) → qa-validator (fail) → qa-fixer (iteration 2) → qa-validator (pass) → proceed
```

### Output to `/test-runs/flow-test-003/`