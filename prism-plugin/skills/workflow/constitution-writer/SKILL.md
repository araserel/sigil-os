---
name: constitution-writer
description: Creates project constitution through guided conversation accessible to non-technical users. Uses tiered questions (auto-decide technical details, translate necessary questions, keep business decisions) with a maximum of 3 interaction rounds. Invoke when setting up a new project or when user says "constitution", "project principles", or "project setup". Can be pre-populated from project foundation or codebase assessment.
version: 2.0.0
category: workflow
chainable: true
invokes: []
invoked_by: [foundation-writer, orchestrator, codebase-assessment]
tools: Read, Write, Edit, Glob
---

# Skill: Constitution Writer

## Purpose

Guide users through creating their project constitution—the immutable principles that govern all agent decisions. Designed for non-technical users (product managers, founders, business stakeholders) with zero coding knowledge required. Technical details are auto-decided; user-facing questions use plain language.

## When to Invoke

- New project setup
- User requests `/constitution`
- User asks about "project principles" or "project rules"
- No constitution exists in `/memory/constitution.md`
- After Discovery chain completes (invoked by foundation-writer)

## Design Principles

### Tiered Question Strategy

All constitution questions are categorized into three tiers:

**Tier 1 — Auto-Decide (Never Ask User)**
Technical implementation details decided by Prism based on detected stack and best practices:

| Topic | Auto-Decision Logic |
|-------|---------------------|
| TypeScript strictness | Always strict mode for TS projects |
| Naming conventions | Framework-appropriate (PascalCase components for React, etc.) |
| Import organization | Standard for detected framework |
| Error handling patterns | Best practices for stack |
| Architecture patterns | Framework defaults (feature folders for React, etc.) |
| Max file/function length | Sensible defaults (50 lines function, 300 lines file) |
| Code organization rules | Infer from detected stack |
| Type safety level | Strict for typed languages |
| Formatter config | Framework standard (Prettier for JS/TS, Black for Python, etc.) |
| Linter config | Framework standard (ESLint for JS/TS, Ruff for Python, etc.) |

**Tier 2 — Translate (Ask in Plain Language)**
Questions with user impact that need translation from technical to plain language:

| Technical Concept | Plain Language Version |
|-------------------|------------------------|
| Test coverage target | "How thoroughly should features be tested before you see them?" |
| Offline tolerance | "Should the app work when users have no internet?" |
| Testing requirements | "How much testing do you want before features ship?" |
| External service dependencies | "Should I ask before adding features that need external services (like payment processors or email senders)?" |
| Accessibility level | "Should this work for everyone, including people with disabilities?" |

**Tier 3 — Ask Directly (Business Decisions)**
Questions users can answer without technical knowledge:

| Question | Why Keep |
|----------|----------|
| Approval requirements | Users understand "Ask me before deleting files" |
| What requires sign-off | Direct business decision |
| Project type/rigor level | Users know if they're building an MVP or enterprise product |

### Maximum 3 Interaction Rounds

The setup flow MUST complete in 3 or fewer rounds. Never exceed this regardless of project complexity.

### "Why This Matters" Context

Every user-facing question includes a one-sentence explanation of real-world impact.

### Smart Defaults with Opt-Out

Replace open-ended questions with pre-configured defaults the user can accept or change.

## Inputs

**Required:**
- `project_name`: string — Name of the project

**Optional:**
- `tech_preferences`: object — Any known technology preferences
- `existing_constitution`: string — Path to existing constitution to update

**From Discovery Chain (when invoked by foundation-writer):**
- `foundation_path`: string — Path to approved foundation document
- `pre_populated_constitution`: object — Pre-filled data from Discovery

**From Assessment Path (when invoked by codebase-assessment):**
- `detected_stack`: object — Stack detected from codebase analysis
- `classification`: string — "scaffolded" | "mature"

## Process

### Step 0: Check for Pre-Population Sources

```
Determine pre-population path (in priority order):

1. IF foundation_path provided:
   → Use Foundation Path (from Discovery chain)
   - Load /memory/project-foundation.md
   - Extract pre_populated_constitution data
   - Pre-fill stack information
   - Skip Round 1, go directly to Round 2

2. ELSE IF detected_stack provided:
   → Use Assessment Path (from codebase-assessment)
   - Use detected_stack for Round 1 pre-population
   - Show detection summary for user confirmation

3. ELSE IF no constitution exists AND repo appears established:
   → Invoke codebase-assessment first
   - Run assessment to detect stack
   - If stack detected, continue with Assessment Path
   - If no stack detected, fall through to Standard Path

4. ELSE:
   → Use Standard Path
   - Ask Round 1 with graceful stack question
```

### Step 1: Check for Existing Constitution

```
Check if /memory/constitution.md exists:

- If exists and not updating:
  Show: "This project already has a constitution. Would you like to
         view it, or start fresh?"
  Options: View current | Start fresh | Cancel

- If exists and updating: Load for modification

- If not exists: Proceed with new creation
```

### Step 2: Three-Round Guided Flow

#### Round 1: Stack Validation

**When stack detected (Assessment or Foundation path):**
```
I detected you're building with:
- Language: [detected]
- Framework: [detected]
- Database: [detected]

Is this correct? Anything to add or change?
```

**When stack NOT detected:**
```
I couldn't detect your tech stack automatically.
What are you building with?

A few questions:
- What programming language? (e.g., TypeScript, Python, Go)
- Using a framework? (e.g., Next.js, Django, Express)
- Using a database? (e.g., PostgreSQL, MongoDB, none yet)
```

**Error Case:** If detection fails entirely, show: "I couldn't detect your tech stack automatically. Let me ask a few questions instead." Then ask the above questions.

#### Round 2: Project Type (Single Cascading Question)

```
What kind of project is this?

Why this matters: This shapes how much testing, security checks,
and documentation I set up. You can always adjust later.

1. MVP / Prototype
   Ship fast, add polish later. Minimal testing, flexible structure.

2. Production App
   Balance speed with stability. Standard testing, proven patterns.

3. Enterprise
   Maximum rigor. Comprehensive testing, full documentation,
   strict reviews.
```

This single choice auto-configures ALL Tier 1 decisions:

| Setting | MVP | Production | Enterprise |
|---------|-----|------------|------------|
| Test coverage | Essential paths only | 60%+ coverage | 80%+ coverage |
| Test-first | Not required | For complex features | Required for all features |
| Security rigor | Standard best practices | Standard + auth review | Maximum + audit trail |
| Approval gates | Major changes only | Deps, DB, auth, deploys | All changes reviewed |
| Documentation | Light | Standard | Comprehensive |
| Code review | Optional | Required for key areas | Required for everything |
| E2E testing | Critical flows only | Key user journeys | All user flows |

#### Round 3: Optional Preferences

```
A few optional preferences (say "skip" to use smart defaults):

1. Should I ask before adding features that need external
   services (like payment processors or email senders)?

   Why this matters: External services may have costs or require
   accounts to set up.

   - Yes (Recommended): I'll flag these for your approval
   - No: I'll add them as needed

2. Should the app work when users have no internet?

   Why this matters: Offline mode means users can access their data
   with poor signal, but adds complexity.

   - Yes: Works offline, syncs when connected
   - No (Default): Requires internet connection

3. How accessible should this be?

   Why this matters: Accessibility ensures people with disabilities
   can use your app. It's also a legal requirement in many countries.

   - Works for everyone (Recommended): Follows accessibility
     standards so all users can participate
   - Standard: Basic accessibility included
```

### Step 3: Auto-Configure and Generate

Using the project type selection + stack detection + optional preferences:

1. **Auto-decide all Tier 1 items** based on stack and project type
2. **Load template** from `/templates/constitution-template.md`
3. **Fill in all articles** with:
   - Detected/confirmed stack (Article 1)
   - Auto-decided code standards with jargon translations (Article 2)
   - Project-type-appropriate testing (Article 3)
   - Stack-appropriate security with translations (Article 4)
   - Framework-standard architecture (Article 5)
   - Project-type-appropriate approvals (Article 6)
   - Selected accessibility level (Article 7)
4. **Add inline jargon explanations** for all technical terms
5. **Write to** `/memory/constitution.md`

### Step 4: Gitignore Handling

**Auto-add (no prompt needed):**
```gitignore
# Prism OS - Ephemeral artifacts (auto-added)
memory/project-context.md
specs/**/clarifications.md
```

**Prompt user:**
```
Should your team share the project constitution via git?

Why this matters: If you work with a team, sharing the constitution
means everyone (and all AI tools) follow the same rules.

- Yes (Recommended for teams): Constitution is version controlled
- No (Solo projects): Constitution stays local only
```

Implementation:
- Check if `.gitignore` exists; create if not
- Append entries without duplication
- Use clear comment header: `# Prism OS - Ephemeral artifacts`
- If user says No to sharing: also add `memory/constitution.md`

**Error case:** If gitignore write fails, show: "Couldn't update .gitignore — you may need to add these entries manually: [list entries]"

### Step 5: Confirm and Explain

Show a plain-language summary:

```
Your constitution is ready!

Here's what I set up:

**Tech Stack:** [Language] + [Framework] + [Database]

**Quality Level:** [Project Type]
- Testing: [plain description, e.g., "Key features tested before shipping"]
- Security: [plain description, e.g., "User data kept private, no secrets in code"]
- Reviews: [plain description, e.g., "I'll ask before adding new tools or changing the database"]

**Accessibility:** [plain description]

This is saved at /memory/constitution.md. All AI agents will follow
these rules automatically.

To change it later, run /constitution edit.
```

## Outputs

**Artifact:**
- `/memory/constitution.md` — Complete project constitution

**Handoff Data:**
```json
{
  "constitution_path": "/memory/constitution.md",
  "project_name": "Project Name",
  "project_type": "mvp|production|enterprise",
  "articles_completed": 7,
  "key_decisions": [
    "TypeScript as primary language",
    "Next.js framework",
    "PostgreSQL database",
    "Production-level testing and security"
  ]
}
```

## Project Type Cascade Details

### MVP / Prototype

Auto-configures:
- **Article 2 (Code Standards):** Framework defaults, relaxed complexity limits (100 lines function, 500 lines file), standard formatting
- **Article 3 (Testing):** Essential paths tested, no coverage mandate, test-first not required
- **Article 4 (Security):** Standard best practices (no secrets in code, validate user input, auth where needed)
- **Article 5 (Architecture):** Simple structure, pragmatic patterns, no strict layering
- **Article 6 (Approvals):** Major changes only (new services, breaking changes)
- **Article 7 (Accessibility):** Basic accessibility (keyboard nav, alt text, contrast)

### Production App

Auto-configures:
- **Article 2:** Strict formatting, moderate complexity limits (50 lines function, 300 lines file), type safety enforced
- **Article 3:** 60%+ coverage, integration tests for APIs, test-first for complex features, E2E for key flows
- **Article 4:** Auth required by default, environment variables for secrets, input validation, dependency review
- **Article 5:** Feature-based organization, service layer pattern, composition over inheritance
- **Article 6:** Dependencies, database changes, auth changes, and production deploys require approval
- **Article 7:** WCAG 2.1 AA minimum, keyboard navigation, screen reader support

### Enterprise

Auto-configures:
- **Article 2:** Strict formatting, strict complexity limits (30 lines function, 200 lines file), full type safety, comprehensive documentation
- **Article 3:** 80%+ coverage, all APIs tested, test-first required, E2E for all user flows, performance testing
- **Article 4:** All endpoints authenticated, secrets manager, audit trail, security review for all changes, vulnerability SLA
- **Article 5:** Strict layering, dependency injection, SOLID principles, documented architecture decisions
- **Article 6:** All code changes reviewed, architecture decisions require approval, deployment plans required
- **Article 7:** WCAG 2.1 AAA target, comprehensive assistive technology support, accessibility testing in CI

## Jargon Translation

When generating the constitution, include inline explanations for technical terms:

| Technical Term | Inline Explanation |
|----------------|-------------------|
| RLS (Row-Level Security) | (keeps each user's data private) |
| TypeScript strict mode | (catches more bugs before they reach users) |
| React Query | (handles loading and caching data) |
| Environment variables | (secure storage for passwords and API keys) |
| Functional components | (modern React pattern, easier to maintain) |
| E2E tests | (tests that simulate real user actions) |
| CI/CD | (automatic testing and deployment) |
| PascalCase | (naming style: MyComponent) |
| camelCase | (naming style: myFunction) |
| snake_case | (naming style: my_function) |
| ORM | (tool that simplifies database access) |
| JWT | (secure login tokens) |
| SOLID principles | (design guidelines for maintainable code) |
| Dependency injection | (pattern that makes code easier to test) |
| WCAG | (Web Content Accessibility Guidelines — the international standard) |
| ARIA | (attributes that help screen readers understand your app) |
| Parameterized queries | (prevents database attacks from user input) |
| Prettier | (automatic code formatting tool) |
| ESLint | (automatic code quality checker) |

**Format in constitution:**
```markdown
- TypeScript strict mode (catches more bugs before they reach users) enabled
- Row-Level Security (keeps each user's data private) enabled on ALL tables
```

## Error Handling

All errors shown to users MUST be plain language with actionable next steps. Log technical details for debugging; surface only the friendly message.

| Technical Error | User-Friendly Message |
|-----------------|----------------------|
| ENOENT / File not found | "I couldn't find [filename]. Make sure you're in the right project folder." |
| EACCES / Permission denied | "I don't have permission to modify [file]. You may need to check your folder permissions." |
| ETIMEDOUT / Network timeout | "Connection issues — couldn't reach [service]. Check your internet and try again." |
| JSON parse error | "The [filename] file has formatting issues. I'll try to fix it, or you can restore from backup." |
| Stack detection failed | "I couldn't detect your tech stack automatically. Let me ask a few questions instead." |
| Git operation failed | "Couldn't update .gitignore — you may need to add these entries manually: [list entries]" |
| Constitution already exists | "This project already has a constitution. Want to view it, or start fresh?" |
| Template not found | Use embedded fallback template (no user-facing error) |
| Foundation data conflicts | User input takes precedence (no error, just override) |
| Monorepo detected | "I found multiple tech setups in your project. Let me focus on the main one — you can adjust if needed." |

## Human Checkpoints

- **Review Tier:** Constitution creation (user reviews final document)
- User confirms stack in Round 1
- User selects project type in Round 2
- Final constitution shown for approval before saving

## Foundation Integration

When invoked from the Discovery chain (via `foundation-writer`):

### Pre-Population Behavior

| Data | Source | User Action |
|------|--------|-------------|
| Language, framework, database | Foundation document | Confirm in Round 1 (or skip if confident) |
| All technical details | Auto-decided from stack + project type | None — automatic |
| Project type | Asked in Round 2 | Select one option |
| Optional preferences | Asked in Round 3 | Answer or skip |

### Abbreviated Flow

When foundation data is available:
1. Show detected stack from foundation → User confirms (Round 1)
2. Ask project type (Round 2)
3. Ask optional preferences (Round 3)
4. Generate constitution with auto-decided technical details

## Assessment Path Integration

When invoked from `codebase-assessment`:

### Trigger Conditions

1. No `/memory/constitution.md` exists
2. No `/memory/project-foundation.md` exists
3. Codebase-assessment classifies repo as "scaffolded" or "mature"

### Assessment Path Flow

1. Show: "Analyzing your project..."
2. Present detected stack in plain language (Round 1)
3. Ask project type (Round 2)
4. Ask optional preferences (Round 3)
5. Generate constitution

### Handling Detection Issues

- **Uncertain fields:** Show what was found, ask user to clarify in plain language
- **Missing fields:** Ask gracefully: "I couldn't detect a database. Are you using one?"
- **Conflicting signals:** Show: "I found multiple [items]. Which one is your primary?"
- **Detection failure:** Fall back to friendly manual questions (no error shown)

## Backward Compatibility

- Existing constitutions in `/memory/constitution.md` continue to work unchanged
- The 7-article structure is preserved
- Only the creation flow changes — the output format stays the same
- Constitutions created by previous versions are fully valid

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
| 1.1.0 | 2026-01-20 | Added Foundation integration, pre-population support |
| 1.2.0 | 2026-01-27 | Added Assessment Path integration for established repos |
| 2.0.0 | 2026-01-29 | Non-technical user refactor: tiered questions, 3-round max, plain language, smart defaults, jargon translation, gitignore handling, friendly errors |
