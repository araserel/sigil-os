# Tasks: User Authentication

**Feature ID:** 001-user-auth
**Total Tasks:** 18
**Estimated Duration:** 12 days
**Created:** 2024-01-16

---

## Task Legend

| Symbol | Meaning |
|--------|---------|
| `[ ]` | Not started |
| `[~]` | In progress |
| `[x]` | Complete |
| `[P]` | Can run in parallel |
| `[B]` | Blocking (others depend on this) |

---

## Phase 1: Foundation

### T001: Set up NextAuth.js configuration [B]
**Description:** Install NextAuth.js and create initial configuration file.

**Files:**
- `src/lib/auth.ts` (new)
- `package.json` (modify)

**Acceptance Criteria:**
- [ ] NextAuth.js installed
- [ ] Basic config file created
- [ ] TypeScript types configured

**Test First:** No (configuration)

---

### T002: Create Prisma schema for auth [B]
**Description:** Add User, Session, and VerificationToken models to Prisma schema.

**Files:**
- `prisma/schema.prisma` (modify)

**Acceptance Criteria:**
- [ ] User model with required fields
- [ ] Session model with foreign key
- [ ] VerificationToken model
- [ ] Proper indexes defined

**Depends On:** None
**Test First:** No (schema)

---

### T003: Run database migration [B]
**Description:** Generate and apply Prisma migration for auth tables.

**Files:**
- `prisma/migrations/[timestamp]_add_user_auth/` (new)

**Acceptance Criteria:**
- [ ] Migration generated successfully
- [ ] Migration applied to development database
- [ ] Tables created with correct structure

**Depends On:** T002
**Test First:** No (migration)

---

### T004: Create validation schemas [P]
**Description:** Create Zod schemas for input validation.

**Files:**
- `src/lib/validations/auth.ts` (new)

**Acceptance Criteria:**
- [ ] Email validation schema
- [ ] Password validation schema (8+ chars, 1 number, 1 special)
- [ ] Registration input schema
- [ ] Login input schema

**Depends On:** None
**Test First:** Yes

---

## Phase 2: Core Authentication

### T005: Create NextAuth API route [B]
**Description:** Set up the NextAuth catch-all API route.

**Files:**
- `src/app/api/auth/[...nextauth]/route.ts` (new)

**Acceptance Criteria:**
- [ ] Route exports GET and POST handlers
- [ ] Connected to auth configuration
- [ ] Handles all NextAuth endpoints

**Depends On:** T001, T003
**Test First:** No (route setup)

---

### T006: Implement password hashing utilities [P]
**Description:** Create utility functions for hashing and verifying passwords.

**Files:**
- `src/lib/auth-utils.ts` (new)

**Acceptance Criteria:**
- [ ] hashPassword function using bcrypt (12 rounds)
- [ ] verifyPassword function
- [ ] Both properly typed

**Depends On:** None
**Test First:** Yes

---

### T007: Build PasswordInput component [P]
**Description:** Create reusable password input with visibility toggle.

**Files:**
- `src/components/auth/PasswordInput.tsx` (new)

**Acceptance Criteria:**
- [ ] Toggle button to show/hide password
- [ ] Proper ARIA labels
- [ ] Keyboard accessible
- [ ] Works with form libraries

**Depends On:** None
**Test First:** Yes

---

### T008: Build LoginForm component
**Description:** Create login form with email and password fields.

**Files:**
- `src/components/auth/LoginForm.tsx` (new)

**Acceptance Criteria:**
- [ ] Email and password fields
- [ ] Form validation with error display
- [ ] Submit button with loading state
- [ ] Proper accessibility labels
- [ ] "Forgot password?" link

**Depends On:** T004, T007
**Test First:** Yes

---

### T009: Build login page
**Description:** Create login page using LoginForm component.

**Files:**
- `src/app/(auth)/login/page.tsx` (new)

**Acceptance Criteria:**
- [ ] Renders LoginForm
- [ ] Link to registration
- [ ] Responsive layout
- [ ] Semantic HTML structure

**Depends On:** T008
**Test First:** No (page)

---

### T010: Build RegisterForm component
**Description:** Create registration form with validation.

**Files:**
- `src/components/auth/RegisterForm.tsx` (new)

**Acceptance Criteria:**
- [ ] Email, password, confirm password fields
- [ ] Password strength indicator
- [ ] Real-time validation feedback
- [ ] Proper error messages
- [ ] Accessibility compliant

**Depends On:** T004, T007
**Test First:** Yes

---

### T011: Implement user registration server action
**Description:** Create server action to handle user registration.

**Files:**
- `src/lib/auth-actions.ts` (new)

**Acceptance Criteria:**
- [ ] Validates input
- [ ] Checks for existing email
- [ ] Hashes password
- [ ] Creates user in database
- [ ] Returns appropriate response

**Depends On:** T003, T004, T006
**Test First:** Yes

---

### T012: Build registration page
**Description:** Create registration page using RegisterForm.

**Files:**
- `src/app/(auth)/register/page.tsx` (new)

**Acceptance Criteria:**
- [ ] Renders RegisterForm
- [ ] Link to login
- [ ] Success redirect to login
- [ ] Responsive layout

**Depends On:** T010, T011
**Test First:** No (page)

---

### T013: Add session provider to layout
**Description:** Wrap application with NextAuth SessionProvider.

**Files:**
- `src/app/layout.tsx` (modify)
- `src/providers/AuthProvider.tsx` (new)

**Acceptance Criteria:**
- [ ] SessionProvider wraps children
- [ ] Session available throughout app
- [ ] No hydration errors

**Depends On:** T005
**Test First:** No (configuration)

---

### T014: Create protected route middleware
**Description:** Add middleware to protect authenticated routes.

**Files:**
- `src/middleware.ts` (new or modify)

**Acceptance Criteria:**
- [ ] Redirects unauthenticated users to login
- [ ] Allows access to public routes
- [ ] Preserves intended destination

**Depends On:** T005, T013
**Test First:** Yes

---

## Phase 3: Password Management

### T015: Build ForgotPasswordForm component
**Description:** Create form to request password reset.

**Files:**
- `src/components/auth/ForgotPasswordForm.tsx` (new)

**Acceptance Criteria:**
- [ ] Email input field
- [ ] Submit with loading state
- [ ] Success message (generic)
- [ ] Accessible

**Depends On:** T004
**Test First:** Yes

---

### T016: Implement password reset email sending
**Description:** Create server action to send reset emails.

**Files:**
- `src/lib/auth-actions.ts` (modify)
- `src/lib/email/password-reset.ts` (new)

**Acceptance Criteria:**
- [ ] Generates secure token
- [ ] Stores token in database
- [ ] Sends email via SendGrid
- [ ] Token expires in 1 hour

**Depends On:** T003
**Test First:** Yes

---

### T017: Build forgot password page
**Description:** Create page for password reset requests.

**Files:**
- `src/app/(auth)/forgot-password/page.tsx` (new)

**Acceptance Criteria:**
- [ ] Renders ForgotPasswordForm
- [ ] Link back to login
- [ ] Responsive layout

**Depends On:** T015, T016
**Test First:** No (page)

---

### T018: Implement rate limiting
**Description:** Add rate limiting to authentication endpoints.

**Files:**
- `src/lib/rate-limit.ts` (new)
- `src/middleware.ts` (modify)

**Acceptance Criteria:**
- [ ] Max 5 login attempts per 15 minutes
- [ ] Max 3 password reset requests per hour
- [ ] Clear error message when limited
- [ ] Resets after timeout

**Depends On:** T014
**Test First:** Yes

---

## Dependency Map

```
T001 (NextAuth config) ──────┐
                             ├──► T005 (API route) ──► T013 (Provider) ──► T014 (Middleware)
T002 (Schema) ──► T003 (Migration) ──┘
                             │
T004 (Validation) ──────────────┼──► T008 (LoginForm) ──► T009 (Login page)
                             │  │
T006 (Password utils) ──────┼──┼──► T011 (Register action)
                             │  │              │
T007 (PasswordInput) ────────┼──┴──► T010 (RegisterForm) ──► T012 (Register page)
                             │
                             └──► T015 (ForgotForm) ──► T017 (Forgot page)
                                       │
                             T016 (Email) ──┘

T014 (Middleware) ──► T018 (Rate limiting)
```

---

## Parallel Opportunities

These tasks can run simultaneously:

**Group 1 (Foundation):**
- T001, T002, T004 (no dependencies)

**Group 2 (Components):**
- T006, T007 (can start after T001)

**Group 3 (Forms):**
- T008, T010, T015 (after T004, T007)

---

## Blockers Log

| Date | Task | Blocker | Resolution |
|------|------|---------|------------|
| - | - | None | - |

---

## Progress Summary

| Phase | Tasks | Complete | In Progress |
|-------|-------|----------|-------------|
| Foundation | 4 | 0 | 0 |
| Core Auth | 10 | 0 | 0 |
| Password Mgmt | 4 | 0 | 0 |
| **Total** | **18** | **0** | **0** |

---

*Tasks created: 2024-01-16*
