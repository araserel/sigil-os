# QA Engineer: Validation Iteration 1 (FAIL)

**Received from:** Developer
**Timestamp:** 2026-01-14T15:00:00Z
**Task:** T008 - Create password reset email template
**QA Iteration:** 1 of 5

## Simulated Context

Developer has completed T008 (password reset email template) but submitted with issues:
- 2 lint errors in the template file
- Missing test for empty email address edge case

## Validation Checks

### 1. Test Execution

```
Running: npm test -- --coverage --testPathPattern="email-template"

PASS tests/email/password-reset-template.test.ts (0.892s)

Test Suites: 1 passed, 1 total
Tests:       6 passed, 6 total
Time:        0.892s

Coverage Summary:
  Statements   : 87.50% (14/16)
  Branches     : 75.00% (6/8)
  Functions    : 100% (4/4)
  Lines        : 86.67% (13/15)
```

**Result:** PASS (tests pass, but coverage below threshold)

### 2. Lint/Type Checks

```
Running: npm run lint && npm run type-check

ESLint:
  src/email/templates/password-reset.ts
    Line 23:5   error  'userName' is assigned a value but never used  @typescript-eslint/no-unused-vars
    Line 45:12  error  Missing return type on function                @typescript-eslint/explicit-function-return-type

  2 problems (2 errors, 0 warnings)

TypeScript:
  No type errors found.
```

**Result:** FAIL - 2 lint errors

### 3. Requirements Coverage

| Requirement ID | Description | Test Coverage | Status |
|----------------|-------------|---------------|--------|
| FR-008-1 | Email contains reset link | test: "includes reset link" | COVERED |
| FR-008-2 | Email includes user greeting | test: "includes user name" | COVERED |
| FR-008-3 | Email has expiry warning | test: "shows 1-hour expiry" | COVERED |
| FR-008-4 | Handle empty/missing email gracefully | NO TEST | **MISSING** |
| NFR-008-1 | Email is accessible (plain text alt) | test: "has plain text version" | COVERED |

**Result:** FAIL - FR-008-4 not covered

### 4. Regression Check

```
Running: npm test -- --testPathPattern="email"

PASS tests/email/password-reset-template.test.ts (0.892s)
PASS tests/email/welcome-template.test.ts (0.456s)
PASS tests/email/notification-template.test.ts (0.234s)

Test Suites: 3 passed, 3 total
Tests:       18 passed, 18 total
Time:        1.582s
```

**Result:** PASS - No regressions

### 5. Accessibility Check

```
Checking email template accessibility...

[check] Plain text alternative provided
[check] Alt text for logo image
[check] Sufficient color contrast in HTML version
[check] Links have descriptive text (not "click here")
```

**Result:** PASS

## Validation Summary

| Check Category | Result | Issues |
|----------------|--------|--------|
| Test Execution | PASS | - |
| Lint/Type | **FAIL** | 2 lint errors |
| Requirements | **FAIL** | FR-008-4 missing test |
| Regressions | PASS | - |
| Accessibility | PASS | - |

## Overall Result: FAIL

**Issues Found:**

| ID | Category | Severity | Description |
|----|----------|----------|-------------|
| LINT-001 | Lint | Error | Unused variable 'userName' at line 23 |
| LINT-002 | Lint | Error | Missing return type at line 45 |
| REQ-001 | Coverage | Medium | Missing test for FR-008-4 (empty email handling) |

## Action Required: Invoke qa-fixer

Per workflow model, invoking `qa-fixer` skill to remediate issues.

**Handoff to qa-fixer:**
```json
{
  "chain_id": "flow-test-003",
  "task": "T008",
  "qa_iteration": 1,
  "issues": [
    {
      "id": "LINT-001",
      "type": "lint",
      "file": "src/email/templates/password-reset.ts",
      "line": 23,
      "message": "Unused variable 'userName'",
      "fix_hint": "Remove or use the variable"
    },
    {
      "id": "LINT-002",
      "type": "lint",
      "file": "src/email/templates/password-reset.ts",
      "line": 45,
      "message": "Missing return type",
      "fix_hint": "Add explicit return type annotation"
    },
    {
      "id": "REQ-001",
      "type": "missing_test",
      "requirement": "FR-008-4",
      "description": "Handle empty/missing email gracefully",
      "fix_hint": "Add test case for empty email input"
    }
  ],
  "max_iterations": 5,
  "remaining_iterations": 4
}
```
