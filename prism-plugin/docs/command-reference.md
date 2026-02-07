# Command Reference

> Quick reference for all Prism commands.

---

## Command Overview

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/prism` | **Unified entry point** — status, start, resume | Starting any workflow |
| `/spec` | Create a feature specification | Starting a new feature |
| `/clarify` | Resolve ambiguities | Spec has open questions |
| `/prism-plan` | Generate implementation plan | Spec is approved |
| `/prism-tasks` | Break plan into tasks | Plan is approved |
| `/validate` | Run QA validation checks | After each task (automatic), or manually anytime |
| `/review` | Run structured code review | After all tasks pass validation |
| `/prism-status` | Show workflow progress | Anytime |
| `/constitution` | View or edit project rules | First-time setup or updates |
| `/learn` | View, search, or review learnings | Reviewing institutional memory |
| `/prime` | Load project context for a session | Starting a new session |
| `/handoff` | Generate engineer review package | Ready for technical review |
| `/prism-update` | Check for and install Prism updates | Keeping Prism current |

---

## Command Flow

`/prism` is the recommended entry point. It detects your project state and routes to the right phase automatically.

```
/prism (entry point — detects state, suggests next action)
        ↓
/constitution (one-time setup)
        ↓
    /spec "description"
        ↓
    /clarify (if needed)
        ↓
      /prism-plan
        ↓
      /prism-tasks
        ↓
    [Implementation]
        ↓
    /validate
        ↓
    /review
        ↓
     /handoff
```

You can use `/prism`, `/prism-status`, or `/prism status` at any point to see where you are.

---

## /prism

The unified entry point for all Prism workflows. This is the recommended way to interact with Prism.

### Syntax

```
/prism
/prism "feature description"
/prism continue
/prism status
/prism help
```

### Variants

| Usage | What It Does |
|-------|-------------|
| `/prism` | Show status dashboard and suggest next action |
| `/prism "description"` | Start building a new feature from your description |
| `/prism continue` | Resume where you left off |
| `/prism status` | Show detailed workflow status |
| `/prism help` | Show all available commands |

### What It Does

1. Runs a **preflight check** to verify Prism is installed correctly
2. Loads your project context from `project-context.md`
3. Detects your current workflow state
4. Routes to the appropriate action:
   - No active workflow → Suggests starting one
   - Active workflow → Shows status and suggests next step
   - With a description → Starts the spec-first workflow

### Natural Language Alternatives

You don't need to remember the exact syntax. These all work:

| Instead of... | You can say... |
|---------------|----------------|
| `/prism "Add login"` | "I want to add user login" |
| `/prism status` | "What's the progress?" |
| `/prism continue` | "Keep going" or "Next step" |
| `/prism help` | "What can you do?" |

### When to Use

- **Every time you start a session** — `/prism` orients you
- **Starting a new feature** — `/prism "your description"`
- **Returning after a break** — `/prism continue`

---

## /spec

Create a new feature specification from your description.

### Syntax

```
/spec [your feature description]
```

### What It Does

1. Analyzes your description to understand what you want
2. Determines the right workflow track (Quick, Standard, or Enterprise)
3. Creates a structured specification document
4. Identifies any ambiguities that need clarification

### Example

**You type:**
```
/spec Add a contact form that lets visitors send messages to our support team
```

**Prism responds with:**
- A track recommendation (e.g., "Standard track recommended")
- A specification document with:
  - Summary of your feature
  - User scenarios (P1/P2/P3 priority)
  - Functional requirements
  - Success criteria
  - Out of scope items
  - Any open questions

### Expected Output

```markdown
## Feature Specification: Contact Form

### Summary
Allow website visitors to send messages to the support team
through a simple form interface.

### User Scenarios

#### P1 (Must Have)
- [ ] US-001: As a visitor, I want to submit a message so that
      I can contact support

#### P2 (Should Have)
- [ ] US-002: As a visitor, I want to receive confirmation so
      that I know my message was sent

### Requirements
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-001 | Display contact form with name, email, message | P1 |
| FR-002 | Validate email format before submission | P1 |

### Open Questions
- Q1: Should we send an email confirmation to the visitor?
- Q2: What fields are required vs optional?
```

### When to Use

- Starting any new feature or enhancement
- Beginning a bug fix that needs documentation
- When you have an idea you want to develop

### Tips for Better Results

**Do:**
- Describe what the user should be able to do
- Mention who will use the feature
- Include any important constraints

**Avoid:**
- Technical implementation details
- Vague descriptions like "make it better"
- Multiple unrelated features in one spec

### Common Mistakes

| Mistake | Problem | Better Approach |
|---------|---------|-----------------|
| Too vague | "Add login" | "Add email/password login for registered users" |
| Too technical | "Add JWT auth with refresh tokens" | "Let users stay logged in between visits" |
| Too big | "Build e-commerce platform" | Start with one feature: "Add shopping cart" |

---

## /clarify

Start a question-and-answer session to resolve ambiguities in your specification.

### Syntax

```
/clarify
```

### What It Does

1. Reviews your current specification
2. Identifies unclear or ambiguous requirements
3. Asks targeted questions to resolve them
4. Updates the specification with your answers

### Example

**You type:**
```
/clarify
```

**Prism asks:**
```markdown
## Clarification Questions

### Scope Questions
**Q1:** Should the contact form include a subject line, or just a message?
- A) Subject line required
- B) No subject line, just message
- C) Optional subject line

### Behavior Questions
**Q2:** What happens after successful submission?
- A) Show success message on same page
- B) Redirect to thank-you page
- C) Both show message and send email confirmation
```

**You answer:**
```
Q1: C (optional subject line)
Q2: C (show message and send email)
```

### Expected Output

After answering, Prism:
- Updates your specification with the clarified requirements
- Records the Q&A in `clarifications.md`
- Either asks more questions or confirms the spec is ready

### When to Use

- After `/spec` if there are open questions
- When you realize something was unclear
- When Prism asks for clarification

### How Many Rounds?

- Prism asks up to 5 questions per round
- Maximum 3 rounds of clarification
- If still unclear after 3 rounds, you'll be asked to simplify or split the feature

### Tips

- Answer directly — "A" or "B" is fine
- If none of the options fit, explain what you want
- Say "I don't know" if you need help deciding

---

## /prism-plan

Generate a technical implementation plan from your specification.

### Syntax

```
/prism-plan
```

### What It Does

1. Analyzes your clarified specification
2. Researches any technical unknowns
3. Creates a detailed implementation plan
4. Validates against your project's constitution (rules)

### Example

**You type:**
```
/prism-plan
```

**Prism creates:**
```markdown
## Implementation Plan: Contact Form

### Technical Approach
Create a React form component with server-side email handling.

### Files to Change
| File | Change |
|------|--------|
| components/ContactForm.tsx | New - form component |
| pages/api/contact.ts | New - API endpoint |
| styles/contact.css | New - styling |

### Dependencies
- No new dependencies needed

### Risk Assessment
| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Email delivery issues | Low | Use established email service |

### Testing Strategy
- Unit tests for form validation
- Integration test for email sending
```

### Expected Output

The plan includes:
- **Technical approach** — How it will be built
- **Files to change** — What will be created or modified
- **Dependencies** — Any new tools or libraries needed
- **Risk assessment** — What could go wrong and how to prevent it
- **Testing strategy** — How quality will be verified

### When to Use

- After your specification is complete and clarified
- When you're ready to start building

### What You Review

You don't need to understand every technical detail. Focus on:
- Does the scope look right?
- Are there any concerning risks?
- Does the approach match your expectations?

### Approving the Plan

After reviewing:
- Say "approve" or "looks good" to proceed
- Say "I have concerns about..." to discuss changes
- Ask "what does X mean?" for clarification

---

## /prism-tasks

Break the approved plan into executable work items.

### Syntax

```
/prism-tasks
```

### What It Does

1. Analyzes the implementation plan
2. Breaks work into small, trackable tasks
3. Identifies dependencies between tasks
4. Marks which tasks can run in parallel

### Example

**You type:**
```
/prism-tasks
```

**Prism creates:**
```markdown
## Tasks: Contact Form

### Phase 1: Setup
- [ ] **T001:** Create form component file structure
- [ ] **T002:** Set up API endpoint skeleton [P]

### Phase 2: Core Features
- [ ] **T003:** Implement form fields (name, email, message) [Depends: T001]
- [ ] **T004:** Add form validation [Depends: T003]
- [ ] **T005:** Connect form to API [Depends: T002, T004]

### Phase 3: Testing
- [ ] **T006:** Write unit tests [P]
- [ ] **T007:** Write integration tests [Depends: T005]

**Legend:**
[P] = Can run in parallel with other tasks
[Depends: X] = Must wait for task X to complete
```

### Expected Output

The task list shows:
- **Task ID** — T001, T002, etc.
- **Description** — What the task accomplishes
- **Dependencies** — What must finish first
- **Parallelization** — [P] means it can run alongside other tasks

### When to Use

- After the implementation plan is approved
- When you want to see the detailed work breakdown

### Understanding Task Symbols

| Symbol | Meaning |
|--------|---------|
| `[ ]` | Not started |
| `[~]` | In progress |
| `[x]` | Complete |
| `[P]` | Can run in parallel |
| `[B]` | Blocking other tasks |

### What Happens Next

After tasks are created, implementation begins automatically:
- Tasks are completed in order
- You can check `/prism-status` anytime
- You'll be notified if something needs your attention

---

## /prism-status

Show the current state of your workflow.

### Syntax

```
/prism-status
```

### What It Does

1. Checks your current project context
2. Shows which phase you're in
3. Displays progress and any blockers
4. Suggests what to do next

### Example Output

```markdown
## Workflow Status

**Feature:** Contact Form | **Track:** Standard | **Phase:** Implement

### Progress
- [x] Assess — Track determined
- [x] Specify — spec.md created
- [x] Clarify — Requirements clear
- [x] Plan — plan.md created
- [x] Tasks — 7 tasks created
- [~] Implement — Writing code
- [ ] Validate — Pending
- [ ] Review — Pending

**Overall:** [████████░░] 60%

### Current Activity
Completing task T005: Connect form to API

### Blockers
None - all clear

### Next Step
No action needed - implementation in progress
```

### When to Use

- Anytime you want to know where things stand
- After stepping away and returning
- When you're not sure what to do next

### Understanding the Output

| Section | What It Tells You |
|---------|-------------------|
| Feature/Track/Phase | Which feature, complexity level, and current stage |
| Progress | Checkmarks show completed phases |
| Current Activity | What's happening right now |
| Blockers | Any issues preventing progress |
| Next Step | What you need to do (if anything) |

### If There's No Active Workflow

```markdown
## Workflow Status

**No active workflow**

You can start a new workflow by:
- Describing what you want to build
- Requesting to work on a specific feature

Example: "I want to add a password reset feature"
```

---

## /constitution

View or edit your project's rules and standards.

### Syntax

```
/constitution
```

### What It Does

1. If no constitution exists: Guides you through creating one
2. If constitution exists: Shows current rules and allows updates

### First-Time Setup

When you run `/constitution` for the first time, Prism asks about:

1. **Technology Stack** — What languages and frameworks to use
2. **Code Standards** — Naming conventions and style rules
3. **Testing Requirements** — What level of testing is needed
4. **Security Mandates** — Authentication and data protection rules
5. **Architecture Principles** — Design patterns to follow
6. **Approval Requirements** — What needs human review
7. **Accessibility Standards** — Inclusivity requirements

### Example Session

```
Prism: Let's set up your project constitution.
I'll ask a few questions about your preferences.

What programming language will this project use?
> TypeScript

What framework, if any?
> Next.js

What database will you use?
> PostgreSQL

...
```

### Expected Output

```markdown
# Project Constitution

## Article 1: Technology Stack
- **Language:** TypeScript
- **Framework:** Next.js
- **Database:** PostgreSQL

## Article 2: Code Standards
- All functions must have explicit return types
- Use camelCase for variables, PascalCase for components

## Article 3: Testing Requirements
- All API endpoints must have integration tests
- Minimum 60% code coverage

...
```

### When to Use

- **First time:** At project start, before any features
- **Updates:** When project standards need to change

### Why It Matters

The constitution ensures:
- Consistent decisions across all features
- AI agents follow your project's rules
- No need to repeat preferences

---

## /handoff

Generate a package for engineer review.

### Syntax

```
/handoff
```

### What It Does

1. Gathers all artifacts from your feature
2. Creates a summary document for technical review
3. Highlights any items needing engineer attention
4. Provides a plain-language summary you can share

### When to Use

- Before production deployment
- When you want an engineer to review the work
- When technical sign-off is required

### Example Output

```markdown
## Technical Review Package: Contact Form

### Quick Context
- **What:** Contact form for visitor messages
- **Why:** Enable customer support communication
- **Status:** Implementation complete, pending review

### What Was Built
| Artifact | Status |
|----------|--------|
| Specification | Complete |
| Implementation Plan | Complete |
| Code Changes | 3 files modified |
| Tests | All passing |

### Quality Summary
- Code Review: No issues found
- Security Review: Passed
- Test Coverage: 85%

### Items for Engineer Review
1. Email configuration in production
2. Rate limiting settings

### Files Changed
- components/ContactForm.tsx
- pages/api/contact.ts
- styles/contact.css
```

### What to Do With It

1. Share the package path with your engineer
2. Include the summary when you reach out
3. Wait for their feedback
4. Address any requested changes

### Plain-Language Summary

Prism provides a summary you can copy:

> "This package has everything needed to review the contact form feature. It includes what we asked for, how it was built, and what the automated checks found. Please let me know if anything needs changing before we go live."

---

## /validate

Run automated quality assurance checks on implemented code.

### Syntax

```
/validate
```

### What It Does

1. Runs automated quality checks against the current implementation:
   - Tests pass
   - Lint/type checks pass
   - Requirements from the spec are covered
   - No regressions detected
2. If issues are found, attempts automatic remediation (up to 5 attempts)
3. Escalates to you if issues persist after remediation

### When to Use

- After implementation is complete
- Before requesting a handoff or review
- When you want to verify quality at any point

### Expected Output

```markdown
## Validation Results

### Checks
- [x] Tests passing (12/12)
- [x] No lint errors
- [x] Requirements coverage: 100%
- [ ] Performance threshold: 1 issue

### Issues Found
1. Page load time exceeds 2s target (measured: 2.3s)
   - Attempting fix...
   - Fixed: Optimized image loading

### Result: PASS (after 1 fix cycle)
```

---

## /learn

View, search, or review project learnings.

### Syntax

```
/learn
/learn --review
/learn --search "query"
```

### Variants

| Usage | What It Does |
|-------|-------------|
| `/learn` | Show current learnings summary |
| `/learn --review` | Start interactive review and cleanup session |
| `/learn --search "query"` | Search learnings for specific topics |

### What It Does

1. **Default:** Shows a summary of active learnings across all categories (patterns, gotchas, decisions, feature notes)
2. **Review mode:** Walks you through learnings to promote, archive, or prune
3. **Search:** Finds learnings matching your query

### When to Use

- After completing a feature — review what was learned
- Starting a new feature — check relevant patterns
- Periodically — clean up with `--review`

### Expected Output

```markdown
## Active Learnings

### Patterns (12 active)
- Always validate form inputs server-side
- Use server actions for mutations in Next.js
- ...

### Gotchas (5 active)
- API rate limit is 100 requests/minute
- ...

### Recent Decisions (3)
- Chose PostgreSQL over MongoDB for relational data
- ...
```

---

## /prime

Load project context to prepare for a development session.

### Syntax

```
/prime
/prime [focus area]
```

### What It Does

1. Reads your project constitution, current context, and active learnings
2. Loads relevant patterns and gotchas into the session
3. Optionally focuses on a specific area (e.g., a feature or module)
4. Reports the current state so you can pick up where you left off

### When to Use

- At the start of every new Claude Code session
- When switching between features or areas of work
- When context seems stale or incomplete

### Example

```
/prime authentication
```

Loads all context relevant to authentication work: constitution rules, auth-related learnings, and any active auth specs.

---

## /prism-update

Check for and install Prism OS updates.

### Syntax

```
/prism-update
```

### What It Does

1. Checks the current installed version against the latest available
2. Reports what's new in the latest version
3. Guides you through the update process if an update is available

### When to Use

- Periodically to stay current
- When you encounter unexpected behavior
- When new features are announced

### Expected Output

```markdown
## Prism OS Update Check

Current version: 1.1.0
Latest version: 1.2.0

### What's New in 1.2.0
- Added Discovery track for greenfield projects
- Improved QA validation loop
- Bug fixes for context staleness detection

Run the update? (Y/n)
```

---

## Quick Reference Card

| Command | Purpose | Example |
|---------|---------|---------|
| `/prism` | Entry point — status + routing | `/prism "Add user login"` |
| `/spec` | Start new feature | `/spec Add user login` |
| `/clarify` | Answer questions | `/clarify` |
| `/prism-plan` | Create tech plan | `/prism-plan` |
| `/prism-tasks` | Break into tasks | `/prism-tasks` |
| `/validate` | Run QA checks | `/validate` |
| `/prism-status` | Check progress | `/prism-status` |
| `/constitution` | Set project rules | `/constitution` |
| `/learn` | View/review learnings | `/learn --review` |
| `/prime` | Load session context | `/prime authentication` |
| `/handoff` | Engineer review | `/handoff` |
| `/prism-update` | Check for updates | `/prism-update` |

### Typical Workflow

```
1. /prism (start here — detects state automatically)
2. /constitution  (one-time setup)
3. /spec "feature description"
4. /clarify (if questions arise)
5. /prism-plan
6. /prism-tasks
7. /prism-status (check progress)
8. /validate (verify quality)
9. /handoff (before deployment)
```

---

## Getting Help

- **"What should I do next?"** — Get guidance on next steps
- **"I'm stuck on..."** — Get help with a specific issue
- **"Explain..."** — Get clarification on any concept

---

## Related Documents

- [Quick-Start Tutorial](quick-start.md) — Learn by doing
- [User Guide](user-guide.md) — Comprehensive coverage
- [Troubleshooting](troubleshooting.md) — Common issues and solutions
