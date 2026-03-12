# Constitution Writer: Question Bank

> **Referenced by:** `constitution-writer` SKILL.md — used to determine what to ask vs auto-decide.

## Tiered Question Strategy

Every potential constitution question falls into one of three tiers. The tier determines how the information is gathered.

### Tier 1: Auto-Decide (Never Ask)

These are purely technical decisions that non-technical users cannot meaningfully answer. Detect from codebase or apply sensible defaults.

| Decision | How to Auto-Decide |
|----------|-------------------|
| Linting tool | Detect from config files (`.eslintrc`, `pyproject.toml`, etc.) or use language default |
| Formatting tool | Detect from config files (`.prettierrc`, `.editorconfig`, etc.) or use language default |
| Test runner | Detect from `package.json` scripts, `pytest.ini`, `go.mod`, etc. |
| ORM | Detect from dependencies (`prisma`, `sqlalchemy`, `gorm`, etc.) |
| Package manager | Detect from lock files (`package-lock.json` → npm, `yarn.lock` → yarn, etc.) |
| File organization | Detect from existing directory structure |
| Import style | Detect from existing code |
| Naming conventions | Detect from existing code (camelCase, snake_case, etc.) |
| Database type | Detect from connection strings, ORMs, or docker-compose |
| Hosting platform | Detect from config files (`vercel.json`, `fly.toml`, `Dockerfile`, etc.) |

### Tier 2: Translate (Ask in Plain Language)

These decisions have business impact but are phrased technically. Translate them.

| Technical Question | Plain Language Version |
|-------------------|----------------------|
| What testing strategy? | How thoroughly should we check your code before shipping? (Options: Basic checks / Standard checks / Comprehensive checks) |
| What security level? | How sensitive is the data in your app? (Options: Public info only / Some private data / Highly sensitive data like payments or health) |
| What accessibility level? | How important is it that everyone can use your app, including people with disabilities? (Options: Basic support / Full support / Certified compliance) |
| Monorepo or polyrepo? | Is all your code in one repository or spread across multiple? (Auto-detect from git structure) |
| What CI/CD pipeline? | How should your code get deployed? (Options: Manual / Automatic on merge / Automatic with approval step) |
| What branching strategy? | How do you organize code changes? (Auto-detect from git branches or ask: Main branch only / Feature branches / Release branches) |

### Tier 3: Ask Directly (User Knows Best)

These are genuine business or preference questions that only the user can answer.

| Question | When to Ask |
|----------|-------------|
| Project name | Always (Round 1) |
| Project type (MVP/Production/Enterprise) | Always (Round 2) |
| Target users | Round 3 — if not obvious from description |
| Compliance requirements (HIPAA, SOC2, GDPR) | Round 3 — if data sensitivity is high |
| Team size | Round 3 — if collaboration features matter |
| Deployment frequency | Round 3 — if CI/CD configuration needed |

## Project Category Detection

Detect the project category from codebase signals to filter which Tier 2 and Tier 3 questions are relevant.

| Category | Detection Signals | Skip Questions About |
|----------|------------------|---------------------|
| **Backend API** | Express/FastAPI/Django/Gin + no frontend framework | UI frameworks, accessibility UI, component architecture |
| **Frontend SPA** | React/Vue/Svelte/Angular + no server framework | Database, ORM, API design, server middleware |
| **Fullstack** | Both frontend and backend frameworks detected | Nothing — all questions potentially relevant |
| **Mobile** | React Native/Flutter/SwiftUI/Kotlin detected | Server hosting, CDN, SSR |
| **CLI Tool** | Commander/Click/Cobra + no web framework | Accessibility, UI frameworks, frontend testing |
| **Library/Package** | `main` field in package.json, `lib/` structure | Hosting, deployment, database, authentication |

## Context-Filtered Round 3 Questions

Only ask Round 3 questions that are relevant to the detected project category AND project type.

### Always Ask (All Categories)
- Project name
- Project type (MVP/Production/Enterprise)

### Ask If Relevant
| Question | Condition |
|----------|-----------|
| Target users | Category is Frontend, Fullstack, or Mobile |
| API versioning strategy | Category is Backend or Fullstack AND type is Production or Enterprise |
| Compliance requirements | Type is Enterprise OR data sensitivity detected as high |
| Deployment target | Not auto-detected from config files |
| Team collaboration rules | Type is Production or Enterprise |
| Branch protection | Type is Enterprise |

### Never Ask (Always Auto-Decide)
- Code formatting rules
- Import ordering
- Variable naming conventions
- Test file naming
- Directory structure conventions
- Git ignore patterns

## Question Flow Summary

```
Round 1: Stack Validation (Tier 1)
  → Auto-detect technology stack from codebase
  → Present findings for user confirmation
  → "I detected Next.js, TypeScript, PostgreSQL. Is that right?"

Round 2: Project Type (Tier 3 + Tier 2)
  → Ask project type (MVP/Production/Enterprise)
  → Apply project-type cascade from article-templates.md
  → Translate remaining Tier 2 questions

Round 3: Optional Preferences (Tier 3, filtered)
  → Only questions relevant to category + type
  → Max 3-5 questions
  → "These are optional — I can use smart defaults for anything you skip"
```
