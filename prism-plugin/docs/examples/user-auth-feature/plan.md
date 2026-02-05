# Implementation Plan: User Authentication

**Feature ID:** 001-user-auth
**Track:** Standard
**Status:** Approved
**Created:** 2024-01-16

---

## Technical Context

### Existing Stack (from Constitution)
- **Language:** TypeScript 5.x
- **Framework:** Next.js 14 with App Router
- **Database:** PostgreSQL 15 with Prisma ORM
- **Auth Library:** NextAuth.js v5

### Relevant Existing Code
| Area | Current State |
|------|---------------|
| Database | Prisma configured, no User model yet |
| API Routes | App router patterns established |
| UI Components | Tailwind + shadcn/ui in use |
| Email | SendGrid configured but not integrated |

---

## Constitution Gate Checks

### Simplicity Gate
- [x] Maximum 3 new packages (NextAuth.js, bcrypt, zod)
- [x] No new infrastructure required
- [x] Uses existing database

### Anti-Abstraction Gate
- [x] Uses NextAuth.js directly (no wrapper)
- [x] Standard Next.js patterns
- [x] Follows existing project conventions

### Integration-First Gate
- [x] API contracts defined (see below)
- [x] Data models documented
- [x] Integration points identified

### Accessibility Gate
- [x] WCAG requirements identified
- [x] Keyboard navigation planned
- [x] Screen reader behavior specified

---

## Project Structure Changes

### New Files
```
src/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   │   └── page.tsx          # Login page
│   │   ├── register/
│   │   │   └── page.tsx          # Registration page
│   │   └── forgot-password/
│   │       └── page.tsx          # Password reset request
│   └── api/
│       └── auth/
│           └── [...nextauth]/
│               └── route.ts      # NextAuth API route
├── components/
│   └── auth/
│       ├── LoginForm.tsx         # Login form component
│       ├── RegisterForm.tsx      # Registration form
│       ├── ForgotPasswordForm.tsx
│       └── PasswordInput.tsx     # Reusable password field
├── lib/
│   ├── auth.ts                   # NextAuth configuration
│   ├── auth-actions.ts           # Server actions
│   └── validations/
│       └── auth.ts               # Zod schemas
└── prisma/
    └── migrations/
        └── [timestamp]_add_user_auth/
            └── migration.sql     # User/Session tables
```

### Modified Files
| File | Changes |
|------|---------|
| `prisma/schema.prisma` | Add User, Session, VerificationToken models |
| `src/app/layout.tsx` | Add SessionProvider wrapper |
| `src/middleware.ts` | Add auth protection for routes |
| `.env.local` | Add NEXTAUTH_SECRET, email config |

### Deleted Files
None

---

## API Contracts

### POST /api/auth/register

**Request:**
```typescript
{
  email: string;      // Valid email format
  password: string;   // 8+ chars, 1 number, 1 special
  name?: string;      // Optional display name
}
```

**Response (Success - 201):**
```typescript
{
  success: true;
  user: {
    id: string;
    email: string;
    name: string | null;
  }
}
```

**Response (Error - 400):**
```typescript
{
  success: false;
  error: {
    code: "VALIDATION_ERROR" | "EMAIL_EXISTS";
    message: string;
    fields?: { [key: string]: string };
  }
}
```

### POST /api/auth/forgot-password

**Request:**
```typescript
{
  email: string;
}
```

**Response (200 - always, to prevent enumeration):**
```typescript
{
  success: true;
  message: "If an account exists, a reset email has been sent."
}
```

### POST /api/auth/reset-password

**Request:**
```typescript
{
  token: string;      // From email link
  password: string;   // New password
}
```

**Response (Success - 200):**
```typescript
{
  success: true;
  message: "Password updated successfully."
}
```

---

## Data Model Changes

### New Tables

**User**
```sql
CREATE TABLE "User" (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "email" VARCHAR(255) UNIQUE NOT NULL,
  "passwordHash" VARCHAR(255) NOT NULL,
  "name" VARCHAR(255),
  "emailVerified" TIMESTAMP,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "lastLoginAt" TIMESTAMP
);

CREATE INDEX "User_email_idx" ON "User"("email");
```

**Session**
```sql
CREATE TABLE "Session" (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "sessionToken" VARCHAR(255) UNIQUE NOT NULL,
  "userId" UUID NOT NULL REFERENCES "User"("id") ON DELETE CASCADE,
  "expires" TIMESTAMP NOT NULL,
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Session_userId_idx" ON "Session"("userId");
CREATE INDEX "Session_sessionToken_idx" ON "Session"("sessionToken");
```

**VerificationToken** (for password reset)
```sql
CREATE TABLE "VerificationToken" (
  "identifier" VARCHAR(255) NOT NULL,
  "token" VARCHAR(255) UNIQUE NOT NULL,
  "expires" TIMESTAMP NOT NULL,
  PRIMARY KEY ("identifier", "token")
);
```

---

## Dependencies

### New Packages
| Package | Version | Purpose | Security Review |
|---------|---------|---------|-----------------|
| next-auth | ^5.0.0 | Authentication framework | Widely used, maintained |
| bcrypt | ^5.1.1 | Password hashing | Industry standard |
| zod | ^3.22.0 | Input validation | Already in project |

### Configuration
| Variable | Description |
|----------|-------------|
| `NEXTAUTH_SECRET` | 32+ char random string for token signing |
| `NEXTAUTH_URL` | Application base URL |
| `SENDGRID_API_KEY` | Email service API key |
| `EMAIL_FROM` | Sender email address |

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Password breach | Low | High | bcrypt + monitoring |
| Session hijacking | Low | High | Secure cookies, rotation |
| Brute force attack | Medium | Medium | Rate limiting, lockout |
| Email enumeration | Medium | Low | Generic error messages |
| CSRF attack | Low | Medium | Built-in NextAuth protection |

---

## Testing Strategy

### Unit Tests
- Password validation (strength requirements)
- Email format validation
- Token generation/verification

### Integration Tests
- User registration flow
- Login/logout flow
- Password reset email sending
- Session persistence

### E2E Tests
- Complete registration → login → dashboard flow
- Password reset from email
- Rate limiting behavior

### Accessibility Tests
- Keyboard navigation through forms
- Screen reader form labels
- Error message announcements
- Focus management on errors

---

## Implementation Phases

### Phase 1: Foundation (Days 1-2)
- Set up NextAuth.js configuration
- Create Prisma schema and migrations
- Implement basic User model

### Phase 2: Core Auth (Days 3-5)
- Build login page and form
- Build registration page and form
- Implement session handling
- Add protected route middleware

### Phase 3: Password Management (Days 6-7)
- Implement forgot password flow
- Build reset password page
- Integrate email sending

### Phase 4: Polish & Security (Days 8-10)
- Add rate limiting
- Implement error handling
- Build loading states
- Complete accessibility audit

### Phase 5: Testing (Days 11-12)
- Write unit tests
- Write integration tests
- Write E2E tests
- Fix any issues found

---

## Architecture Decisions

### ADR-001: Session Storage

**Decision:** Store sessions in database, not JWT-only.

**Context:** NextAuth supports both JWT and database sessions.

**Options Considered:**
1. JWT-only (stateless)
2. Database sessions (stateful)
3. Hybrid approach

**Choice:** Database sessions

**Rationale:**
- Allows immediate session invalidation on logout
- Enables "log out all devices" feature later
- Constitution requires PostgreSQL usage
- Slight performance cost acceptable for security benefit

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Tech Lead | Pending | - | - |
| Security | Pending | - | - |

---

*Plan created: 2024-01-16*
