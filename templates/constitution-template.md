# Project Constitution: [PROJECT NAME]

> These principles are immutable. All agents respect these boundaries without being reminded.
>
> **Created:** [DATE]
> **Last Modified:** [DATE]
> **Status:** Active

---

## Article 1: Technology Stack

Define the core technologies for this project. Agents will not suggest alternatives unless explicitly asked.

### Primary Language
- **Language:** [e.g., TypeScript, Python, Go]
- **Version:** [e.g., TypeScript 5.x, Python 3.11+]
- **Rationale:** [Why this language was chosen]

### Framework
- **Framework:** [e.g., Next.js, FastAPI, none]
- **Version:** [e.g., Next.js 14.x]
- **Rationale:** [Why this framework was chosen]

### Database
- **Database:** [e.g., PostgreSQL, MongoDB, SQLite]
- **Version:** [e.g., PostgreSQL 15+]
- **ORM/Driver:** [e.g., Prisma, SQLAlchemy]
- **Rationale:** [Why this database was chosen]

### Additional Technologies
<!-- Add any other core technologies (caching, queuing, etc.) -->
- [Technology]: [Version] — [Purpose]

---

## Article 2: Code Standards

Define the coding standards that all generated code must follow.

### Style & Formatting
- [ ] [e.g., Use Prettier with default configuration]
- [ ] [e.g., Maximum line length: 100 characters]
- [ ] [e.g., Use semicolons at end of statements]

### Type Safety
- [ ] [e.g., All functions must have explicit return types]
- [ ] [e.g., No `any` types except in test files]
- [ ] [e.g., Prefer interfaces over type aliases for object shapes]

### Naming Conventions
- [ ] [e.g., Use camelCase for variables and functions]
- [ ] [e.g., Use PascalCase for classes and components]
- [ ] [e.g., Use SCREAMING_SNAKE_CASE for constants]

### Code Organization
- [ ] [e.g., One component per file]
- [ ] [e.g., Imports ordered: external, internal, relative]
- [ ] [e.g., Maximum function length: 50 lines]

---

## Article 3: Testing Requirements

Define the testing standards that all code must meet.

### Unit Testing
- **Required Coverage:** [e.g., 80% minimum]
- **Framework:** [e.g., Jest, pytest, Go testing]
- **Requirements:**
  - [ ] [e.g., All public functions must have unit tests]
  - [ ] [e.g., Edge cases must be tested explicitly]
  - [ ] [e.g., Mocks must be used for external dependencies]

### Integration Testing
- **Framework:** [e.g., Supertest, httpx, built-in]
- **Requirements:**
  - [ ] [e.g., All API endpoints must have integration tests]
  - [ ] [e.g., Database operations must be tested with real database]

### End-to-End Testing
- **Framework:** [e.g., Playwright, Cypress, none]
- **Requirements:**
  - [ ] [e.g., Critical user flows must have E2E tests]
  - [ ] [e.g., E2E tests run in CI before merge]

### Test-First Pattern
- [ ] Tests must be written before implementation
- [ ] Tests must fail before implementation is complete
- [ ] Implementation is complete when tests pass

---

## Article 4: Security Mandates

Define security requirements that cannot be bypassed.

### Authentication
- [ ] [e.g., All API endpoints require authentication except public endpoints]
- [ ] [e.g., Use JWT tokens with 1-hour expiration]
- [ ] [e.g., Refresh tokens must be stored securely]

### Authorization
- [ ] [e.g., Role-based access control required]
- [ ] [e.g., All data access must be scoped to user/tenant]

### Secrets Management
- [ ] [e.g., No secrets in code—use environment variables]
- [ ] [e.g., .env files must be in .gitignore]
- [ ] [e.g., Production secrets managed via vault/secrets manager]

### Input Validation
- [ ] [e.g., All user input must be validated]
- [ ] [e.g., SQL queries must use parameterized statements]
- [ ] [e.g., File uploads must be validated for type and size]

### Dependency Security
- [ ] [e.g., New dependencies require security review]
- [ ] [e.g., Dependencies must be updated monthly]
- [ ] [e.g., Known vulnerabilities must be addressed within 7 days]

---

## Article 5: Architecture Principles

Define architectural decisions that guide system design.

### Design Principles
- [ ] [e.g., Prefer composition over inheritance]
- [ ] [e.g., Follow SOLID principles]
- [ ] [e.g., Use dependency injection for testability]

### Layering
- [ ] [e.g., No direct database access from UI components]
- [ ] [e.g., Business logic must be in service layer]
- [ ] [e.g., API controllers should be thin—validation and delegation only]

### State Management
- [ ] [e.g., Use React Context for global state]
- [ ] [e.g., Prefer server state over client state]
- [ ] [e.g., No state in services—stateless design]

### Error Handling
- [ ] [e.g., All errors must be caught and logged]
- [ ] [e.g., User-facing errors must be sanitized]
- [ ] [e.g., Use structured error types, not strings]

---

## Article 6: Approval Requirements

Define what requires human approval before proceeding.

### Code Changes
- [ ] [e.g., New dependencies require security review]
- [ ] [e.g., Database schema changes require DBA approval]
- [ ] [e.g., Changes to authentication require security review]

### Deployments
- [ ] [e.g., Production deployments require PM approval]
- [ ] [e.g., Database migrations require manual verification]
- [ ] [e.g., Rollback plan required for all production changes]

### Architecture
- [ ] [e.g., New services require architecture review]
- [ ] [e.g., Third-party integrations require security review]
- [ ] [e.g., Breaking API changes require version bump and migration plan]

---

## Article 7: Accessibility Requirements

Define accessibility standards that all UI code must meet.

### Compliance Standards
- **Minimum:** WCAG 2.1 Level AA
- **Target:** WCAG 2.1 Level AAA (where feasible)
- **Validation:** Accessibility checks included in QA phase

### Visual Requirements
- [ ] Color contrast: 4.5:1 minimum for normal text
- [ ] Color contrast: 3:1 minimum for large text and UI components
- [ ] Information not conveyed by color alone
- [ ] Text resizable up to 200% without loss of content

### Interaction Requirements
- [ ] All interactive elements keyboard accessible
- [ ] Visible focus indicators on all focusable elements
- [ ] No keyboard traps
- [ ] Skip links provided for navigation

### Assistive Technology Requirements
- [ ] Proper ARIA labels, roles, and live regions
- [ ] All images have meaningful alt text
- [ ] Form inputs have associated labels
- [ ] Error messages announced to screen readers

### Structural Requirements
- [ ] Proper heading hierarchy (h1 → h2 → h3)
- [ ] Landmark regions used (main, nav, footer)
- [ ] Tables have headers and captions
- [ ] Lists used for list content

---

## Amendment Process

To modify this constitution:

1. Propose the change with rationale
2. Review impact on existing code and specs
3. Obtain explicit human approval
4. Document the change with date and reason
5. Update affected specs and code as needed

**Amendment History:**
| Date | Article | Change | Approved By |
|------|---------|--------|-------------|
| [DATE] | — | Initial constitution | [NAME] |

---

## Quick Reference

### What Agents Check
- Before suggesting a technology: Article 1
- Before writing code: Articles 2, 7
- Before skipping tests: Article 3
- Before handling user input: Article 4
- Before designing a solution: Article 5
- Before deploying or changing dependencies: Article 6
- Before creating UI: Article 7

### What Requires Approval
See Article 6 for the complete list. Key items:
- Production deployments
- Database migrations
- New dependencies
- Security-related changes
- Breaking API changes
