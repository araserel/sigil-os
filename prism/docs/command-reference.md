# Command Reference

> Quick reference for all Prism commands.

---

## Command Overview

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/spec` | Create a feature specification | Starting a new feature |
| `/clarify` | Resolve ambiguities | Spec has open questions |
| `/plan` | Generate implementation plan | Spec is approved |
| `/tasks` | Break plan into tasks | Plan is approved |
| `/status` | Show workflow progress | Anytime |
| `/constitution` | View or edit project rules | First-time setup or updates |
| `/handoff` | Generate engineer review package | Ready for technical review |

---

## Command Flow

Commands follow this typical sequence:

```
/constitution (one-time setup)
        ↓
    /spec "description"
        ↓
    /clarify (if needed)
        ↓
      /plan
        ↓
      /tasks
        ↓
    [Implementation]
        ↓
     /handoff
```

You can use `/status` at any point to see where you are.

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

## /plan

Generate a technical implementation plan from your specification.

### Syntax

```
/plan
```

### What It Does

1. Analyzes your clarified specification
2. Researches any technical unknowns
3. Creates a detailed implementation plan
4. Validates against your project's constitution (rules)

### Example

**You type:**
```
/plan
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

## /tasks

Break the approved plan into executable work items.

### Syntax

```
/tasks
```

### What It Does

1. Analyzes the implementation plan
2. Breaks work into small, trackable tasks
3. Identifies dependencies between tasks
4. Marks which tasks can run in parallel

### Example

**You type:**
```
/tasks
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
- You can check `/status` anytime
- You'll be notified if something needs your attention

---

## /status

Show the current state of your workflow.

### Syntax

```
/status
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

## Quick Reference Card

| Command | Purpose | Example |
|---------|---------|---------|
| `/spec` | Start new feature | `/spec Add user login` |
| `/clarify` | Answer questions | `/clarify` |
| `/plan` | Create tech plan | `/plan` |
| `/tasks` | Break into tasks | `/tasks` |
| `/status` | Check progress | `/status` |
| `/constitution` | Set project rules | `/constitution` |
| `/handoff` | Engineer review | `/handoff` |

### Typical Workflow

```
1. /constitution  (one-time setup)
2. /spec "feature description"
3. /clarify (if questions arise)
4. /plan
5. /tasks
6. /status (check progress)
7. /handoff (before deployment)
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
