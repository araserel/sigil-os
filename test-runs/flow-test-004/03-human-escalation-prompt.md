# Human Escalation: Decision Required

**Escalation ID:** ESC-004-001
**Timestamp:** 2026-01-14T16:15:00Z
**From:** Orchestrator
**Priority:** Medium
**Status:** AWAITING HUMAN INPUT

---

## Decision Required: Architecture Pattern for Password Reset

### What Happened

While validating task T007 (forgot-password endpoint), we found a **constitution violation**. The developer implemented the feature using direct database queries in the route handler instead of going through the service layer.

### The Violation

**Constitution Article 5** states:
> "No direct database access from UI components or route handlers. All data access must go through the service layer."

**Current Code (Problematic):**
```typescript
// src/api/routes/auth/forgot-password.ts

router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;

  // ❌ VIOLATION: Direct database access
  const user = await db.query('SELECT * FROM users WHERE email = $1', [email]);

  if (user) {
    const token = generateToken();
    // ❌ VIOLATION: Direct database access
    await db.query('INSERT INTO password_reset_tokens ...', [token, user.id]);
  }
  // ...
});
```

### Why This Matters

1. **Consistency:** Other endpoints use the service layer pattern
2. **Testability:** Direct DB access is harder to mock in tests
3. **Maintainability:** Business logic scattered across route handlers
4. **Precedent:** Allowing this encourages similar shortcuts

### Your Options

---

#### Option A: Create PasswordResetService (Recommended)

Create a new dedicated service for password reset operations.

**What changes:**
- New file: `src/services/passwordResetService.ts`
- Route calls service instead of database directly
- New tests for service layer

**Trade-offs:**
| Pros | Cons |
|------|------|
| Clean separation of concerns | One more file to maintain |
| Matches existing patterns | Slightly more code |
| Easy to extend later | Medium effort now |
| Best testability | |

**Effort:** Medium (2-3 hours)

---

#### Option B: Extend AuthService

Add password reset methods to the existing authentication service.

**What changes:**
- Modify: `src/services/authService.ts` (add methods)
- Route calls AuthService
- Tests added to existing auth tests

**Trade-offs:**
| Pros | Cons |
|------|------|
| Fewer files | AuthService grows larger |
| Keeps auth logic together | May need to split later |
| Less setup | Mixing concerns somewhat |

**Effort:** Low (1-2 hours)

---

#### Option C: Use Repositories Directly

Have the route call repository classes instead of raw database queries.

**What changes:**
- Modify route to use `userRepository` and `tokenRepository`
- No new service file

**Trade-offs:**
| Pros | Cons |
|------|------|
| Simplest change | Still bypasses service layer |
| Less indirection | May not satisfy constitution spirit |
| Quick to implement | Business logic in route |

**Effort:** Low (30 minutes)

**Note:** This option may still violate the constitution's intent, depending on interpretation.

---

#### Option D: Waive Violation

Accept the current code as an exception to the constitution.

**What changes:**
- Nothing - code stays as-is
- Add comment documenting the exception

**Trade-offs:**
| Pros | Cons |
|------|------|
| No code changes | Weakens constitution authority |
| Ship immediately | Sets bad precedent |
| | Others may cite this exception |

**Effort:** None

**Note:** Not recommended. Exceptions erode standards over time.

---

### AI Recommendation

**We recommend Option A: Create PasswordResetService**

**Rationale:**
1. Matches the existing pattern used by `AuthService` and `UserService`
2. Password reset will likely have multiple operations (initiate, validate, complete, cleanup)
3. Provides clean separation that makes testing straightforward
4. Sets good precedent for future features

### What Happens After You Decide

| Your Choice | Next Steps |
|-------------|------------|
| **A** | qa-fixer creates service, refactors route, qa-validator re-runs |
| **B** | qa-fixer extends AuthService, refactors route, qa-validator re-runs |
| **C** | qa-fixer updates route to use repos, qa-validator re-runs |
| **D** | qa-validator marks waived, proceeds to Review phase |

Work will resume automatically after your decision.

---

## Your Decision

**Please respond with your choice: A, B, C, or D**

You can also provide additional guidance or constraints if needed.

---

### Context (for reference)

| Item | Value |
|------|-------|
| Feature | Password Reset (001-password-reset) |
| Task | T007 - POST /auth/forgot-password |
| Track | Standard |
| QA Iteration | 1 of 5 |
| Tests | 8 passing (functionality works) |
| Blocking | This task only (T008-T014 can proceed in parallel) |

---

*This decision is being requested because constitution violations require explicit human acknowledgment per the Human Interaction Protocol (Tier: Review).*
