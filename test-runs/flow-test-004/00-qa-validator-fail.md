# QA Engineer: Validation (FAIL - Architecture Violation)

**Received from:** Developer
**Timestamp:** 2026-01-14T16:00:00Z
**Task:** T007 - Implement POST /auth/forgot-password endpoint
**QA Iteration:** 1 of 5

## Simulated Context

Developer completed T007 (forgot-password endpoint) but implemented it using a pattern that violates the project constitution (Article 5 - Architecture Principles).

**Violation:** Direct database access from route handler instead of going through service layer.

## Validation Checks

### 1. Test Execution

```
Running: npm test -- --coverage --testPathPattern="forgot-password"

PASS tests/api/auth/forgot-password.test.ts (1.245s)

Test Suites: 1 passed, 1 total
Tests:       8 passed, 8 total
Time:        1.245s

Coverage Summary:
  Statements   : 92.00% (23/25)
  Branches     : 88.89% (8/9)
  Functions    : 100% (5/5)
  Lines        : 91.67% (22/24)
```

**Result:** PASS - Tests pass (functionality works)

### 2. Lint/Type Checks

```
Running: npm run lint && npm run type-check

ESLint:
  src/api/routes/auth/forgot-password.ts - 0 errors, 0 warnings

TypeScript:
  No type errors found.
```

**Result:** PASS - No lint or type errors

### 3. Requirements Coverage

| Requirement ID | Description | Test Coverage | Status |
|----------------|-------------|---------------|--------|
| FR-007-1 | Accept email address | test: "accepts valid email" | COVERED |
| FR-007-2 | Generate reset token | test: "creates token" | COVERED |
| FR-007-3 | Send reset email | test: "sends email" | COVERED |
| FR-007-4 | Generic response (no enumeration) | test: "same response for valid/invalid" | COVERED |

**Result:** PASS - All requirements covered

### 4. Regression Check

```
Running: npm test -- --testPathPattern="auth"

PASS tests/api/auth/forgot-password.test.ts (1.245s)
PASS tests/api/auth/login.test.ts (0.456s)
PASS tests/api/auth/register.test.ts (0.523s)

Test Suites: 3 passed, 3 total
Tests:       22 passed, 22 total
Time:        2.224s
```

**Result:** PASS - No regressions

### 5. Constitution Compliance Check

```
Checking against constitution Article 5 (Architecture Principles)...

Principle: "No direct database access from UI components or route handlers"

Scanning: src/api/routes/auth/forgot-password.ts

  Line 34:  const user = await db.query('SELECT * FROM users WHERE email = $1', [email]);
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            VIOLATION: Direct database query in route handler

  Line 45:  await db.query('INSERT INTO password_reset_tokens ...', [...]);
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            VIOLATION: Direct database query in route handler

Constitution Check: FAIL
  - Article 5, Principle 2: "No direct database access from route handlers"
  - 2 violations found
```

**Result:** FAIL - Constitution violation detected

### 6. Accessibility Check

**Result:** PASS (N/A for API endpoint)

## Validation Summary

| Check Category | Result | Notes |
|----------------|--------|-------|
| Test Execution | PASS | 8/8 tests passing |
| Lint/Type | PASS | No errors |
| Requirements | PASS | 4/4 covered |
| Regressions | PASS | No regressions |
| **Constitution** | **FAIL** | Article 5 violation |
| Accessibility | PASS | N/A |

## Overall Result: FAIL

**Issue Found:**

| ID | Category | Severity | Description |
|----|----------|----------|-------------|
| CONST-001 | Constitution | **BLOCKING** | Direct DB access in route handler violates Article 5 |

## Issue Details

### CONST-001: Architecture Violation

**Constitution Reference:**
> Article 5, Principle 2: "No direct database access from UI components or route handlers. All data access must go through the service layer."

**What Developer Did:**
```typescript
// src/api/routes/auth/forgot-password.ts (lines 34, 45)

router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;

  // VIOLATION: Direct database access
  const user = await db.query('SELECT * FROM users WHERE email = $1', [email]);

  if (user) {
    const token = generateToken();
    // VIOLATION: Direct database access
    await db.query('INSERT INTO password_reset_tokens ...', [token, user.id]);
    await sendEmail(email, token);
  }

  res.json({ message: 'If email exists, reset link sent' });
});
```

**What Should Have Been Done:**
```typescript
// Correct pattern using service layer

router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;

  // Delegate to service layer
  await passwordResetService.initiateReset(email);

  res.json({ message: 'If email exists, reset link sent' });
});
```

**Why This Matters:**
1. Violates separation of concerns
2. Makes route handlers harder to test
3. Bypasses service-level validation and business logic
4. Inconsistent with rest of codebase
5. Sets bad precedent for future development

## Classification: Cannot Auto-Fix

**Reason:** This is not a simple code fix. It requires:
1. **Architectural decision:** Create new service or extend existing?
2. **Refactoring scope:** How much code needs to move?
3. **Interface design:** What should the service API look like?
4. **Human judgment:** Confirm this is the right approach

**Auto-fix not appropriate because:**
- Constitution violations require human acknowledgment
- Architectural changes need approval
- Multiple valid approaches exist
- Could affect other parts of the codebase

## Action Required: Invoke qa-fixer with Escalation Flag

**Handoff to qa-fixer:**
```json
{
  "chain_id": "flow-test-004",
  "task": "T007",
  "qa_iteration": 1,
  "issues": [
    {
      "id": "CONST-001",
      "type": "constitution_violation",
      "severity": "blocking",
      "article": "Article 5",
      "principle": "No direct database access from route handlers",
      "file": "src/api/routes/auth/forgot-password.ts",
      "lines": [34, 45],
      "auto_fixable": false,
      "requires_human": true,
      "reason": "Architectural decision required"
    }
  ],
  "escalation_required": true,
  "max_iterations": 5,
  "remaining_iterations": 4
}
```
