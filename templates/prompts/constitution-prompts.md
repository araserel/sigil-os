# Guided Constitution Setup

> Prompts to help users define their project's foundational principles.

---

## Opening

"Let's set up your project's constitution. This is a one-time setup that defines the rules all future work will follow. Think of it as writing down 'how we do things here' so the AI always respects your standards.

Don't worry if you're not sure about everything—I'll offer sensible defaults you can adjust later."

---

## Article 1: Technology Stack

### Main Language

"What programming language does (or will) this project use?"

**Options:**
- A) TypeScript / JavaScript
- B) Python
- C) Go
- D) Other (please specify)

**If unsure:**
"What kind of project is this? I can suggest a language:
- Web app → TypeScript is common
- Data / ML → Python is common
- System tool → Go is common"

### Framework

"Are you using a framework?"

**Options:**
- A) Yes — [which one?]
- B) No framework (plain language)
- C) Not sure yet

**If web app:**
"For web apps, common choices are:
- Next.js (React-based, full-stack)
- Express (Node.js API server)
- Django / FastAPI (Python)

Which fits best, or should we skip this for now?"

### Database

"What database will you use, if any?"

**Options:**
- A) PostgreSQL (robust, widely used)
- B) MySQL / MariaDB
- C) MongoDB (document database)
- D) SQLite (simple, file-based)
- E) None / Not sure yet

**Default suggestion:**
"If you're not sure, PostgreSQL is a safe default for most projects."

---

## Article 2: Code Standards

### Style

"How strict should code formatting be?"

**Options:**
- A) Strict — enforce consistent style everywhere
- B) Moderate — enforce basics, flexibility on details
- C) Relaxed — minimal rules

**Default:** "Most teams do well with Moderate—consistent enough to read easily, flexible enough not to be annoying."

### Type Safety (if TypeScript/typed language)

"How strict should type checking be?"

**Options:**
- A) Strict — all types explicit, no shortcuts
- B) Moderate — types required for public APIs, flexible internally
- C) Relaxed — types where helpful, not mandatory

**Default:** "Moderate is usually the sweet spot."

---

## Article 3: Testing

### Coverage Requirement

"What level of testing do you want?"

**Options:**
- A) High (80%+ coverage) — thorough, catches most issues
- B) Moderate (60%+ coverage) — good balance of safety and speed
- C) Essential only — test critical paths, trust the rest

**Default:** "Moderate (60%+) is a good starting point for most projects."

### Test-First Approach

"Should tests be written before implementation?"

**Options:**
- A) Yes — tests first, then code (test-driven development)
- B) Sometimes — for complex features
- C) Not required — test after implementation is fine

**Default:** "Option B (sometimes) works well—rigor where it matters, flexibility where it doesn't."

---

## Article 4: Security

### Authentication Default

"Should features require users to be logged in by default?"

**Options:**
- A) Yes — everything requires auth unless marked public
- B) No — features are public unless marked protected
- C) Depends — I'll specify per feature

**Default:** "Option A is safer—it's easier to make things public than to realize you forgot to protect something."

### Secret Handling

"How should secrets (passwords, API keys) be handled?"

**Options:**
- A) Environment variables only — no secrets in code ever
- B) Secrets manager — use a vault or service
- C) Not sure yet

**Default:** "Option A (environment variables) is standard and works for most projects."

---

## Article 5: Architecture

### Code Organization

"How should code be organized?"

**Options:**
- A) By feature — all code for a feature in one folder
- B) By layer — separate folders for models, services, controllers
- C) Hybrid — layers within feature folders
- D) Whatever works — no strict rule

**If unsure:**
"This often depends on team size. For smaller teams, A (by feature) is usually cleaner. For larger teams, B (by layer) helps coordination."

### Complexity Philosophy

"When adding new functionality, what's the priority?"

**Options:**
- A) Simplicity — prefer straightforward solutions, even if less elegant
- B) Elegance — invest in clean abstractions that scale
- C) Pragmatic — whatever fits the situation

**Default:** "Option A (simplicity) tends to age better. You can always add elegance later."

---

## Article 6: Approvals

### What Requires Approval

"What changes should require your explicit approval?"

**Check all that apply:**
- [ ] New dependencies / packages
- [ ] Database changes
- [ ] Changes to authentication/security
- [ ] Anything affecting production
- [ ] Architecture decisions

**Default:** "All of these are checked by default. You can always approve quickly, but it ensures you're aware of significant changes."

### Production Safety

"How careful should we be with production changes?"

**Options:**
- A) Very careful — always require approval, have rollback plan
- B) Careful — require approval for risky changes
- C) Standard — normal review process

**Default:** "Option A for production is almost always right."

---

## Article 7: Accessibility

### Compliance Level

"What accessibility standard should we follow?"

**Options:**
- A) WCAG 2.1 AA (standard compliance) — required for most commercial software
- B) WCAG 2.1 AAA (highest level) — best possible accessibility
- C) Basic accessibility — essential needs only

**Explanation:**
"AA is the standard most companies aim for. AAA is ideal but can require significant effort. Basic is a minimum but may exclude some users."

**Default:** "AA minimum, AAA target is a good balance."

### Specific Requirements

"Any specific accessibility needs for your users?"

**Prompts:**
- "Will users with visual impairments use this? (screen readers)"
- "Will users need keyboard-only navigation?"
- "Any users with motor limitations?"

---

## Summary and Confirmation

### Recap

"Here's your constitution:

**Technology:** [Language] + [Framework] + [Database]
**Code Style:** [Level]
**Testing:** [Coverage level], [Test-first?]
**Security:** [Auth default], [Secrets handling]
**Architecture:** [Organization], [Complexity preference]
**Approvals:** [What requires approval]
**Accessibility:** [Standard]

Does this look right?"

### Amendments

"Remember: this constitution can be amended later, but it should be rare. These are your foundational rules, not temporary preferences.

To change it later, just say 'update constitution' and we'll review together."

---

## Quick Setup Option

For users who want to go fast:

"Would you like to:
- A) Go through each article step by step (recommended for new projects)
- B) Use sensible defaults and adjust later (faster)
- C) Copy settings from a similar project"

**If Option B (defaults):**

"Here's a sensible default constitution:
- TypeScript + [appropriate framework]
- Moderate style enforcement
- 60% test coverage, test-first for complex features
- Auth required by default, env vars for secrets
- Simplicity-first, feature-based organization
- Approval required for deps, database, security, production
- WCAG 2.1 AA accessibility

Want to use this and adjust specific items?"

---

## Tips

### For decisive users
Move quickly, confirm at the end.

### For uncertain users
Offer defaults freely. "If you're not sure, [X] works well for most projects."

### For technical users
Can go into more detail if they want, but don't assume they want complexity.

### For first-time projects
Simpler is better. They can add strictness later as needs become clear.
