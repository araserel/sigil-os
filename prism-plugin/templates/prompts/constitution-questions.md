# Constitution Question Bank

> Plain-language questions for the constitution setup flow. All questions are designed for non-technical users — no jargon, no assumptions about coding knowledge.

---

## Question Format

Every question follows this structure:

```
[Question in plain language]

Why this matters: [One sentence explaining real-world impact]

Options:
- [Option]: [Plain explanation of what this means]
```

---

## Round 1: Stack Validation

### Stack Confirmation (When Detected)

```
I scanned your project and found:
- Language: [detected]
- Framework: [detected]
- Database: [detected]

Is this correct? Anything to add or change?
```

Why this matters: Getting the tech stack right means all future suggestions and code will match what you're actually building with.

- **Yes / Looks good:** Lock in detected stack
- **[Correction]:** Update the specific item
- **Add [technology]:** Include additional technology

### Stack Discovery (When Not Detected)

**Question 1: Language**

```
What programming language does your project use?
```

Why this matters: This determines the style and patterns for all generated code.

- **TypeScript / JavaScript:** Most common for web apps
- **Python:** Common for data, AI, and backend services
- **Go:** Common for system tools and high-performance services
- **Other:** Specify your language

**Fallback for "I don't know":**
"What kind of thing are you building? I can suggest a language:
- Website or web app → TypeScript
- Data project or AI → Python
- System tool or API → Go"

**Question 2: Framework**

```
Are you using a framework to build this?
```

Why this matters: Frameworks provide structure and shortcuts. Knowing yours helps me suggest the right patterns.

- **Yes — [which one?]:** Lock in the framework
- **No / None:** Plain language, no framework
- **Not sure:** I'll suggest based on your language and project type

**Fallback for "I don't know":**
"A framework is a toolkit that gives you a head start. Common ones:
- For web apps: Next.js, Django, Rails
- For APIs: Express, FastAPI, Gin
- For mobile: React Native, Flutter

If you're not using one, that's fine too."

**Question 3: Database**

```
Are you storing data? If so, what database?
```

Why this matters: This determines how your app saves and retrieves information.

- **PostgreSQL:** Robust, widely used, good default
- **MySQL:** Popular, well-supported
- **MongoDB:** Flexible document storage
- **SQLite:** Simple, file-based, good for small projects
- **None / Not sure:** Skip for now

**Fallback for "I don't know":**
"If your app needs to save user data (accounts, content, settings), you'll need a database. PostgreSQL is a safe default if you're unsure."

---

## Round 2: Project Type

### Main Question

```
What kind of project is this?
```

Why this matters: This shapes how much testing, security checks, and documentation I set up. You can always adjust later.

**Option 1: MVP / Prototype**
Ship fast, add polish later. Minimal testing, flexible structure. Good for validating ideas quickly.

**Option 2: Production App**
Balance speed with stability. Standard testing, proven patterns. Good for apps real users depend on.

**Option 3: Enterprise**
Maximum rigor. Comprehensive testing, full documentation, strict reviews. Good for regulated industries or large teams.

**Fallback for "I don't know" / "Suggest":**
"Here's a quick way to decide:
- Building something to test an idea? → MVP
- Building something people will use daily? → Production App
- Building for a large company or regulated industry? → Enterprise

If still unsure, Production App is a safe middle ground."

### Project Type Cascade Configurations

#### MVP / Prototype → Auto-Configures:

| Article | Configuration | Plain Description |
|---------|--------------|-------------------|
| Code Standards | Framework defaults, relaxed limits | Clean but flexible code |
| Testing | Essential paths only, no coverage mandate | Key features tested before you see them |
| Security | Standard best practices | User data stays private, no secrets in code |
| Architecture | Simple structure, pragmatic patterns | Organized but not over-engineered |
| Approvals | Major changes only | I'll ask before big decisions |
| Accessibility | Basic standards | Keyboard navigation, readable text |

#### Production App → Auto-Configures:

| Article | Configuration | Plain Description |
|---------|--------------|-------------------|
| Code Standards | Strict formatting, moderate limits | Consistent, readable code |
| Testing | 60%+ coverage, E2E for key flows | Features tested thoroughly before shipping |
| Security | Auth required, input validation, dep review | Login required, user data protected |
| Architecture | Feature-based organization, service layer | Well-structured, maintainable code |
| Approvals | Deps, DB, auth, deploys | I'll ask before adding tools, changing data structure, or deploying |
| Accessibility | WCAG 2.1 AA | Works for everyone, follows international standards |

#### Enterprise → Auto-Configures:

| Article | Configuration | Plain Description |
|---------|--------------|-------------------|
| Code Standards | Strict everything, comprehensive docs | Rigorous, well-documented code |
| Testing | 80%+ coverage, all flows tested | Everything tested before shipping |
| Security | Maximum protection, audit trail | Full security with tracking |
| Architecture | Strict layering, SOLID, DI | Highly structured, enterprise patterns |
| Approvals | All changes reviewed | Every change gets your sign-off |
| Accessibility | WCAG 2.1 AAA target | Highest accessibility standard |

---

## Round 3: Optional Preferences

### Question 1: External Service Approval

```
Should I ask before adding features that need external services
(like payment processors, email senders, or cloud storage)?
```

Why this matters: External services may have costs or require accounts to set up.

- **Yes (Recommended):** I'll flag these for your approval first
- **No:** I'll add them as needed

**Fallback for "I don't understand":**
"If building a feature requires signing up for another company's service (like Stripe for payments or SendGrid for emails), should I check with you first? Most people say yes."

### Question 2: Offline Support

```
Should the app work when users have no internet?
```

Why this matters: Offline mode means users can still access their data with poor signal, but it adds complexity.

- **Yes:** Works offline, syncs when connected
- **No (Default):** Requires internet connection

**Fallback for "I don't understand":**
"Can people use your app in airplane mode or with bad wifi? If you're not sure, 'No' is simpler."

### Question 3: Accessibility Level

```
How accessible should this be?
```

Why this matters: Accessibility ensures people with disabilities can use your app. It's also required by law in many countries.

- **Works for everyone (Recommended):** Follows international accessibility standards (WCAG 2.1 AA) so all users can participate
- **Standard:** Basic accessibility included (keyboard navigation, readable text)

**Fallback for "I don't understand":**
"Will the app work for people who use screen readers, can only use a keyboard (no mouse), or have vision impairments? 'Works for everyone' is recommended."

---

## Gitignore Question

```
Should your team share the project constitution via git?
```

Why this matters: If you work with a team, sharing the constitution means everyone (and all AI tools) follow the same rules.

- **Yes (Recommended for teams):** Constitution is version controlled — your whole team sees the same rules
- **No (Solo projects):** Constitution stays on your machine only

**Fallback for "I don't understand":**
"Git is a tool for sharing code with your team. If you're working alone, say 'No'. If you have teammates, say 'Yes' so everyone follows the same rules."

---

## Tier 1: Auto-Decided Technical Details

These are NEVER asked to users. They are decided automatically based on detected stack and project type.

### TypeScript Projects

| Setting | Auto-Decision | Rationale |
|---------|---------------|-----------|
| Strict mode | Enabled | Catches bugs early |
| No `any` types | Enforced (Production/Enterprise) | Type safety |
| Formatter | Prettier | Industry standard |
| Linter | ESLint with framework rules | Industry standard |
| Import order | External → Internal → Relative | Convention |
| Naming: components | PascalCase | React/framework convention |
| Naming: functions | camelCase | JS/TS convention |
| Naming: constants | SCREAMING_SNAKE_CASE | Convention |

### Python Projects

| Setting | Auto-Decision | Rationale |
|---------|---------------|-----------|
| Type hints | Required (Production/Enterprise) | Code clarity |
| Formatter | Black | Industry standard |
| Linter | Ruff | Modern, fast |
| Import order | stdlib → third-party → local | PEP 8 |
| Naming: functions | snake_case | PEP 8 |
| Naming: classes | PascalCase | PEP 8 |
| Naming: constants | SCREAMING_SNAKE_CASE | PEP 8 |

### Go Projects

| Setting | Auto-Decision | Rationale |
|---------|---------------|-----------|
| Formatter | gofmt | Required by convention |
| Linter | golangci-lint | Industry standard |
| Error handling | Explicit error returns | Go convention |
| Naming: exported | PascalCase | Go convention |
| Naming: unexported | camelCase | Go convention |

### Framework-Specific Defaults

| Framework | Code Organization | Key Pattern |
|-----------|------------------|-------------|
| Next.js | App Router structure | Server components default |
| React | Feature folders | Functional components only |
| Express | Route → Controller → Service | Middleware chain |
| FastAPI | Router → Service → Model | Dependency injection |
| Django | App-based structure | Class-based views |
| Rails | MVC convention | Convention over configuration |

---

## Tier 2: Translated Questions Reference

These questions have user impact but need translation from technical to plain language.

| Original Technical Question | Plain Language Translation | Used In |
|----------------------------|---------------------------|---------|
| "Unit test coverage target?" | "How thoroughly should features be tested before you see them?" | Round 2 cascade |
| "Offline tolerance?" | "Should the app work when users have no internet?" | Round 3, Q2 |
| "What testing requirements?" | "How much testing do you want before features ship?" | Round 2 cascade |
| "TypeScript strictness level?" | Auto-decided, never asked | Tier 1 |
| "Maximum function length?" | Auto-decided, never asked | Tier 1 |
| "Import organization?" | Auto-decided, never asked | Tier 1 |
| "Error handling patterns?" | Auto-decided, never asked | Tier 1 |
| "Architecture patterns?" | Auto-decided, never asked | Tier 1 |
| "RLS policies?" | Auto-decided, never asked | Tier 1 |
| "Naming conventions?" | Auto-decided, never asked | Tier 1 |

---

## Handling Edge Cases

### User Responds in a Non-Standard Way

| User Says | Interpretation | Response |
|-----------|---------------|----------|
| "Sure" / "OK" / "Sounds good" | Acceptance | Confirm what was accepted |
| "Whatever" / "Don't care" | Use defaults | Explain what defaults mean |
| "I don't know" / "No idea" | Needs help | Offer recommendation with rationale |
| "Suggest" / "You decide" | Use defaults | Explain what was configured and why |
| "Help" / "What does that mean?" | Needs explanation | Provide plain-language explanation |
| "Skip" / "Next" | Skip to next | Use defaults, briefly note what was set |
| "Back" / "Wait" | Wants to revisit | Return to previous question |
| Technical answer (e.g., "Jest with 80% coverage") | Technical user | Accept directly, confirm |
