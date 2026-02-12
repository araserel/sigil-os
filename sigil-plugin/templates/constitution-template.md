<!-- STRICT TEMPLATE: Preserve EXACT heading names, column structure, and formatting.
     Fill in [BRACKETED] values but do not rename articles or restructure sections. -->

# Project Constitution: [PROJECT NAME]

> These principles are immutable. All agents respect these boundaries without being reminded.
>
> **Created:** [DATE]
> **Last Modified:** [DATE]
> **Project Type:** [MVP / Production / Enterprise]
> **Status:** Active

---

## Article 1: Technology Stack

The core technologies for this project. Agents will not suggest alternatives unless explicitly asked.

### Primary Language
- **Language:** [e.g., TypeScript, Python, Go]
- **Version:** [e.g., TypeScript 5.x, Python 3.11+]

### Framework
- **Framework:** [e.g., Next.js, FastAPI, none]
- **Version:** [e.g., Next.js 14.x]

### Database
- **Database:** [e.g., PostgreSQL, MongoDB, SQLite]
- **Version:** [e.g., PostgreSQL 15+]
- **ORM/Driver:** [e.g., Prisma (tool that simplifies database access), SQLAlchemy]

### Additional Technologies
<!-- Add any other core technologies (caching, queuing, etc.) -->
- [Technology]: [Version] — [Purpose]

---

## Article 2: Code Standards

Coding standards that all generated code must follow. These were auto-configured based on the detected stack and project type.

### Style & Formatting
- [ ] [e.g., Prettier (automatic code formatting tool) with default configuration]
- [ ] [e.g., ESLint (automatic code quality checker) with framework rules]
- [ ] [e.g., Maximum line length: 100 characters]

### Type Safety
<!-- For typed languages like TypeScript -->
- [ ] [e.g., TypeScript strict mode (catches more bugs before they reach users) enabled]
- [ ] [e.g., No `any` types — all data must have defined shapes]

### Naming Conventions
- [ ] [e.g., PascalCase (naming style: MyComponent) for components]
- [ ] [e.g., camelCase (naming style: myFunction) for variables and functions]
- [ ] [e.g., SCREAMING_SNAKE_CASE for constants]

### Code Organization
- [ ] [e.g., Feature-based folders — all code for a feature lives together]
- [ ] [e.g., One component per file]
- [ ] [e.g., Maximum function length: 50 lines]
- [ ] [e.g., Maximum file length: 300 lines]

---

## Article 3: Testing Requirements

How thoroughly code is tested before shipping. Configured for [PROJECT TYPE] level rigor.

### Unit Testing
- **Required Coverage:** [e.g., 60% minimum]
- **Framework:** [e.g., Jest, pytest, Go testing]
- **Requirements:**
  - [ ] [e.g., All public functions must have unit tests]
  - [ ] [e.g., Edge cases tested for critical paths]

### Integration Testing
- **Framework:** [e.g., Supertest, httpx, built-in]
- **Requirements:**
  - [ ] [e.g., All API endpoints must have integration tests]
  - [ ] [e.g., Database operations tested with real database]

### End-to-End Testing (tests that simulate real user actions)
- **Framework:** [e.g., Playwright, Cypress, none]
- **Requirements:**
  - [ ] [e.g., Critical user flows must have E2E tests]
  - [ ] [e.g., E2E tests run in CI (automatic testing pipeline) before merge]

### Test-First Pattern
- [ ] [e.g., Tests written before code for complex features]

---

## Article 4: Security Mandates

Non-negotiable security requirements that protect users and data.

### Authentication (verifying who users are)
- [ ] [e.g., All features require login unless marked public]
- [ ] [e.g., JWT (secure login tokens) with appropriate expiration]
- [ ] [e.g., Refresh tokens stored securely]

### Authorization (controlling what users can access)
- [ ] [e.g., Row-Level Security (keeps each user's data private) where supported]
- [ ] [e.g., All data access scoped to the logged-in user]

### Secrets Management (protecting passwords and API keys)
- [ ] [e.g., No secrets in code — use environment variables (secure storage for passwords and API keys)]
- [ ] [e.g., .env files must be in .gitignore (prevents accidental sharing)]

### Input Validation (preventing attacks from user input)
- [ ] [e.g., All user input must be validated before processing]
- [ ] [e.g., Parameterized queries (prevents database attacks from user input) required]

### Dependency Security
- [ ] [e.g., New packages require review before adding]
- [ ] [e.g., Known vulnerabilities addressed promptly]

---

## Article 5: Architecture Principles

How the system is structured. Auto-configured based on stack and project type.

### Design Principles
- [ ] [e.g., Prefer composition over inheritance (build by combining small pieces)]
- [ ] [e.g., Keep it simple — straightforward solutions preferred]
- [ ] [e.g., Dependency injection (pattern that makes code easier to test) for testability]

### Layering
- [ ] [e.g., No direct database access from UI — go through a service layer]
- [ ] [e.g., Business logic separated from display logic]

### State Management
- [ ] [e.g., React Query (handles loading and caching data) for server state]
- [ ] [e.g., Prefer server state over client state]

### Error Handling
- [ ] [e.g., All errors caught and logged]
- [ ] [e.g., User-facing errors show helpful messages, not technical details]

---

## Article 6: Approval Requirements

What requires human sign-off before the AI proceeds. Configured for [PROJECT TYPE] level oversight.

### Code Changes
- [ ] [e.g., New dependencies (external packages) require review]
- [ ] [e.g., Database schema changes require approval]
- [ ] [e.g., Changes to login/security require review]

### Deployments
- [ ] [e.g., Production releases require approval]
- [ ] [e.g., Database migrations (structural database changes) require verification]

### Architecture
- [ ] [e.g., New services require review]
- [ ] [e.g., Third-party integrations (external service connections) require approval]

---

## Article 7: Accessibility Requirements

Standards ensuring the application works for all users, including those with disabilities.

### Compliance Standards
- **Minimum:** WCAG 2.1 (Web Content Accessibility Guidelines) Level [AA/AAA]
- **Target:** WCAG 2.1 Level [AAA] (where feasible)
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
- [ ] Proper ARIA (attributes that help screen readers understand your app) labels and roles
- [ ] All images have meaningful alt text
- [ ] Form inputs have associated labels
- [ ] Error messages announced to screen readers

### Structural Requirements
- [ ] Proper heading hierarchy (h1 → h2 → h3)
- [ ] Landmark regions used (main, nav, footer)
- [ ] Tables have headers and captions

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
