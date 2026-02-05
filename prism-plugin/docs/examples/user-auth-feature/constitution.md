# Project Constitution: TaskFlow App

> These principles are immutable. All agents respect these boundaries.

---

## Article 1: Technology Stack

| Component | Choice | Rationale |
|-----------|--------|-----------|
| **Language** | TypeScript 5.x | Type safety for team productivity |
| **Framework** | Next.js 14 | Full-stack React with server components |
| **Database** | PostgreSQL 15 | Reliable, scalable relational database |
| **ORM** | Prisma | Type-safe database access |
| **Auth** | NextAuth.js | Built-in Next.js authentication |
| **Styling** | Tailwind CSS | Utility-first, consistent design |

---

## Article 2: Code Standards

### Style & Formatting
- Use Prettier with default configuration
- Maximum line length: 100 characters
- Use semicolons consistently

### Type Safety
- No `any` types except in test files
- All functions must have explicit return types
- Use strict TypeScript configuration

### Naming Conventions
- Variables and functions: `camelCase`
- Components and classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- File names: `kebab-case.ts` for utilities, `PascalCase.tsx` for components

### Code Organization
- One component per file
- Co-locate tests with source files
- Group related files in feature folders

---

## Article 3: Testing Requirements

| Requirement | Standard |
|-------------|----------|
| Unit test coverage | Minimum 60% |
| Integration tests | Required for all API endpoints |
| E2E tests | Required for critical user flows |
| Test pattern | Test-first for critical paths |

### Testing Tools
- Jest for unit and integration tests
- React Testing Library for component tests
- Playwright for E2E tests

---

## Article 4: Security Mandates

### Authentication
- All API endpoints require authentication by default
- Public endpoints must be explicitly marked
- Session tokens expire after 24 hours

### Secrets Management
- No secrets in code; use environment variables
- `.env.local` for development, never committed
- Production secrets in secure vault

### Data Protection
- Passwords hashed with bcrypt (min 12 rounds)
- Sensitive data encrypted at rest
- HTTPS required in production

### Input Validation
- Validate all user input server-side
- Sanitize output to prevent XSS
- Use parameterized queries only

---

## Article 5: Architecture Principles

### Design Patterns
- Prefer composition over inheritance
- Use React Server Components where possible
- Follow the Single Responsibility Principle

### Layer Separation
- UI components cannot access database directly
- Business logic in dedicated service files
- API routes handle HTTP only, delegate to services

### State Management
- Server state via React Query
- Local UI state via React hooks
- No global state unless absolutely necessary

### Error Handling
- All async operations must have error handling
- User-friendly error messages
- Log errors server-side with context

---

## Article 6: Approval Requirements

| Change Type | Required Approval |
|-------------|-------------------|
| New dependencies | Security review |
| Database migrations | DBA review |
| Authentication changes | Security lead |
| Production deployment | Team lead |
| API breaking changes | Product owner |

---

## Article 7: Accessibility Requirements

### Compliance Level
- **Minimum:** WCAG 2.1 Level AA
- **Target:** WCAG 2.1 Level AAA where feasible

### Specific Requirements
| Area | Requirement |
|------|-------------|
| Color contrast | 4.5:1 for normal text, 3:1 for large text |
| Keyboard navigation | All interactive elements accessible |
| Screen readers | Proper ARIA labels and roles |
| Focus indicators | Visible on all interactive elements |
| Form accessibility | Labels on all inputs, errors announced |
| Semantic structure | Proper heading hierarchy, landmarks |

### Validation
- Accessibility checks included in CI/CD
- Manual testing with screen reader monthly

---

*Constitution established: January 2024*
*Last updated: January 2024*
