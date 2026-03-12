# Constitution Writer: Article Templates

> **Referenced by:** `constitution-writer` SKILL.md — used during article generation.

## Project-Type Cascade

When the user selects a project type, auto-configure articles with these defaults. The user can override any setting — these are starting points, not locks.

### MVP / Side Project

| Article | Auto-Config |
|---------|-------------|
| Article 1: Technology Stack | Detected from codebase (or ask) |
| Article 2: Code Standards | Language defaults (ESLint/Prettier for JS, Black for Python, etc.) |
| Article 3: Testing Requirements | Unit tests for critical paths only; no coverage target |
| Article 4: Security Mandates | OWASP Top 10 basics; input validation; no auth shortcuts |
| Article 5: Architecture Principles | Follow existing patterns; no premature abstraction |
| Article 6: Simplicity Preference | Prefer fewer dependencies; avoid over-engineering |
| Article 7: Accessibility Standards | WCAG 2.1 Level A minimum |

### Production Application

| Article | Auto-Config |
|---------|-------------|
| Article 1: Technology Stack | Detected from codebase (or ask) |
| Article 2: Code Standards | Strict linting + formatting; PR review conventions |
| Article 3: Testing Requirements | Unit + integration; 70% coverage target |
| Article 4: Security Mandates | OWASP Top 10; dependency scanning; secrets management |
| Article 5: Architecture Principles | Documented patterns; ADRs for deviations |
| Article 6: Simplicity Preference | Justify new dependencies; complexity budget |
| Article 7: Accessibility Standards | WCAG 2.1 Level AA |

### Enterprise Application

| Article | Auto-Config |
|---------|-------------|
| Article 1: Technology Stack | Detected + validated against org standards |
| Article 2: Code Standards | Strict linting + formatting; mandatory PR reviews |
| Article 3: Testing Requirements | Unit + integration + E2E; 80% coverage target |
| Article 4: Security Mandates | OWASP Top 10; SAST/DAST; penetration testing; audit logging |
| Article 5: Architecture Principles | Documented patterns; mandatory ADRs; architecture review |
| Article 6: Simplicity Preference | Strict dependency governance; security review for new deps |
| Article 7: Accessibility Standards | WCAG 2.1 Level AA; regular audits |

## Jargon Translation Table

When presenting articles to non-technical users, translate technical terms:

| Technical Term | Plain Language |
|---------------|---------------|
| OWASP Top 10 | Industry-standard security checklist |
| WCAG 2.1 Level AA | Accessibility standards so everyone can use your app |
| ESLint / Prettier | Automatic code formatting tools |
| Unit tests | Automated checks that each piece works correctly |
| Integration tests | Automated checks that pieces work together |
| E2E tests | Automated checks that simulate real user actions |
| Coverage target | What percentage of your code has automated checks |
| ADR | A written record of why a technical decision was made |
| SAST/DAST | Automated security scanning tools |
| Dependency scanning | Checking that libraries you use don't have known security issues |
| Secrets management | How passwords and API keys are stored safely |
| CI/CD | Automatic building and deploying of your code |
| Linting | Automatic code style checking |
| ORM | A tool that lets code talk to databases without writing raw queries |
| API | How different parts of your software talk to each other |
| Middleware | Code that runs between a request and a response |
| Schema migration | Updating your database structure safely |

## Article Content Guidelines

### Article 1: Technology Stack
- Always auto-detect from codebase when possible
- Only ask the user to confirm, not to specify from scratch
- Include: language, framework, database, ORM, hosting, key libraries

### Article 2: Code Standards
- Default to the community standard for the detected language
- Include: linting tool, formatting tool, naming conventions, file organization

### Article 3: Testing Requirements
- Scale testing expectations to project type
- Include: test frameworks, coverage targets, test types required

### Article 4: Security Mandates
- Always include input validation and authentication requirements
- Scale depth to project type (MVP = basics, Enterprise = comprehensive)

### Article 5: Architecture Principles
- Emphasize following existing patterns over introducing new ones
- Include: anti-abstraction stance, dependency direction rules

### Article 6: Simplicity Preference
- Frame as "how simple should solutions be by default"
- Include: dependency budget, complexity justification requirements

### Article 7: Accessibility Standards
- Always include — accessibility is not optional
- Scale level to project type (A for MVP, AA for production+)
