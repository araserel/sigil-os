# Quick-Start Tutorial

> Build your first feature specification in 30 minutes.

This hands-on tutorial walks you through creating a complete feature specification using Prism. By the end, you'll have a fully documented feature ready for engineering handoff.

---

## What You'll Learn

- How to set up your project constitution (the rules your project follows)
- How to create a feature specification from a plain-language description
- How to answer clarification questions to remove ambiguity
- How to review and hand off the final documentation

---

## Prerequisites

- Prism installed and running
- 30 minutes of uninterrupted time
- No technical knowledge required

---

## Part 1: First-Time Setup (10 minutes)

Before creating features, you need to establish your project's constitution. This is a one-time setup that defines the standards all features must follow.

### What is a Constitution?

A **constitution** is your project's rulebook. It answers questions like:

- What programming language does the project use?
- What database stores the data?
- What testing standards must be met?
- What accessibility requirements apply?

Having these decisions documented prevents debates during implementation and ensures consistency across features.

### Setting Up Your Constitution

**Step 1:** Start the constitution wizard.

```
/constitution
```

**Step 2:** Answer the questions about your project.

Prism will ask about:

| Topic | Example Questions |
|-------|-------------------|
| Technology | What language? What framework? What database? |
| Standards | What testing coverage? What code style? |
| Security | What authentication method? What data protection? |
| Accessibility | What compliance level? WCAG AA? AAA? |

**Step 3:** Review and confirm.

Prism shows a summary of your choices. Review it, make any corrections, and confirm.

**Example Constitution Summary:**

```
Technology Stack
├── Language: TypeScript
├── Framework: Next.js
├── Database: PostgreSQL
└── Auth: NextAuth.js

Standards
├── Test Coverage: 60% minimum
├── Code Style: Prettier defaults
└── Accessibility: WCAG 2.1 AA
```

**Tip:** If you're unsure about technical choices, skip this step and come back to it with your tech lead. For now, you can proceed with the default constitution.

---

## Part 2: Creating Your Feature (15 minutes)

Now let's create a feature specification. We'll use a simple example: adding a contact form to a website.

### The Scenario

Your marketing team wants a contact form on the website. Visitors should be able to:

- Enter their name, email, and message
- Submit the form
- See a confirmation that their message was received
- Receive an email copy of their submission

### Step 1: Describe Your Feature

**Command:**

```
/spec Add a contact form to the website
```

**What to Include:**

Describe the feature in plain language. More detail means fewer clarification questions later.

**Example Input:**

> "Add a contact form to the marketing website. Users should enter their name, email address, and a message. When they submit, show a confirmation and send them an email copy. The form should work on mobile phones and be accessible to screen reader users. We want to prevent spam submissions."

**What Prism Produces:**

A structured specification with:

1. **User Scenarios** - Who uses this and why
2. **Requirements** - Exactly what the system must do
3. **Key Entities** - What data is involved
4. **Success Criteria** - How to know it's working

**Example Output (abbreviated):**

```
User Scenarios
├── US-001 [P1]: As a visitor, I want to submit a contact form
├── US-002 [P1]: As a visitor, I want confirmation my message was sent
├── US-003 [P2]: As a visitor, I want an email copy of my submission
└── US-004 [P2]: As an admin, I want spam protection

Requirements
├── FR-001 [P1]: Form accepts name, email, message
├── FR-002 [P1]: Form validates email format
├── FR-003 [P1]: Success message shown on submit
├── FR-004 [P2]: Confirmation email sent to user
├── NFR-001 [P1]: Form works on mobile devices
└── NFR-002 [P1]: Form meets WCAG 2.1 AA
```

**What the Priorities Mean:**

| Priority | Meaning | Included In |
|----------|---------|-------------|
| P1 | Must have | Initial release |
| P2 | Should have | Initial release if possible |
| P3 | Nice to have | Future enhancement |

### Step 2: Answer Clarification Questions

Prism may have questions to resolve ambiguities.

**Command:**

```
/clarify
```

**Example Questions:**

**Q1: Spam Protection Method**
> "How should the form prevent spam?"
>
> A) CAPTCHA (user solves a puzzle)
> B) Honeypot field (invisible trap for bots)
> C) Rate limiting (max submissions per hour)
> D) Email verification required

**Your Answer:** Consider your users. CAPTCHA is effective but adds friction. Honeypot is invisible to real users. Rate limiting might not stop determined spammers.

For this example, choose **B) Honeypot field** - it's invisible to legitimate users but catches most bots.

**Q2: Email Notification Recipients**
> "Who should receive notification when a form is submitted?"
>
> A) Single email address
> B) Multiple team members
> C) Department-specific routing
> D) No internal notification (just logs)

**Your Answer:** For a simple contact form, **A) Single email address** is usually sufficient. You can specify marketing@company.com or support@company.com.

**After Clarification:**

The specification is updated with your decisions. No ambiguity remains.

### Step 3: Generate the Plan

With requirements finalized, generate the implementation plan.

**Command:**

```
/plan
```

**What Prism Produces:**

A technical plan showing:

- What files will be created
- What components are needed
- How the feature integrates with existing code
- What tests are required

**Example Output (abbreviated):**

```
Files to Create
├── src/components/ContactForm.tsx
├── src/app/api/contact/route.ts
├── src/lib/email/contact-confirmation.ts
└── src/lib/validations/contact.ts

Integration Points
├── Email service (SendGrid) - configured
├── Database - not needed (email only)
└── Analytics - track form submissions

Testing Strategy
├── Unit: Form validation
├── Integration: Email sending
└── E2E: Full form submission flow
```

**What to Review:**

1. **Does this match what you asked for?** Check that all your requirements appear.
2. **Are there any surprises?** New files or integrations you didn't expect?
3. **Is anything missing?** Features you mentioned but don't see?

### Step 4: Create Tasks

Convert the plan into a task list for your engineering team.

**Command:**

```
/tasks
```

**What Prism Produces:**

A prioritized list of tasks with dependencies.

**Example Output:**

```
Phase 1: Foundation
├── T001 [B]: Create validation schemas
├── T002 [P]: Build ContactForm component
└── T003 [P]: Set up form styling

Phase 2: Backend
├── T004 [B]: Create API endpoint (depends on T001)
├── T005: Integrate email service (depends on T004)
└── T006: Add honeypot spam protection

Phase 3: Polish
├── T007: Add loading states
├── T008: Write unit tests
└── T009: Write E2E tests
```

**Understanding the Symbols:**

| Symbol | Meaning |
|--------|---------|
| `[B]` | Blocking - other tasks wait for this |
| `[P]` | Parallel - can run alongside other `[P]` tasks |
| (depends on T00X) | Must wait for that task to finish |

**What This Tells Your Team:**

- Start with T001 (validation schemas) - it blocks other work
- T002 and T003 can happen simultaneously
- T004 needs T001 done first
- T007, T008, T009 are independent finishing touches

---

## Part 3: Next Steps (5 minutes)

### Hand Off to Engineering

When you're ready, create a handoff package.

**Command:**

```
/handoff
```

This generates a complete package containing:

- Feature specification
- Clarification decisions
- Implementation plan
- Task breakdown

Your engineers receive everything they need without a lengthy kickoff meeting.

### Check Progress Later

As work proceeds, check status anytime.

**Command:**

```
/status
```

**Example Output:**

```
Feature: Contact Form
Phase: Implementation
Progress: ████████░░ 80%

Completed: 7/9 tasks
├── [x] T001: Create validation schemas
├── [x] T002: Build ContactForm component
├── [x] T003: Set up form styling
├── [x] T004: Create API endpoint
├── [x] T005: Integrate email service
├── [x] T006: Add honeypot spam protection
├── [x] T007: Add loading states
├── [~] T008: Write unit tests
└── [ ] T009: Write E2E tests
```

---

## Quick Reference Card

### Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/constitution` | Set project rules | Once per project |
| `/spec [description]` | Create specification | Start of each feature |
| `/clarify` | Resolve ambiguities | After spec, if questions exist |
| `/plan` | Generate implementation plan | After clarification complete |
| `/tasks` | Create task breakdown | After plan approved |
| `/status` | Check progress | Anytime |
| `/handoff` | Create engineer package | When ready for development |

### Workflow

```
/constitution  (one time)
      │
      ▼
   /spec ──► /clarify ──► /plan ──► /tasks ──► /handoff
      │          │          │         │           │
   Create    Resolve    Generate   Create    Hand to
   spec      questions   plan      tasks     engineers
```

### Priority Definitions

| Priority | Label | Meaning |
|----------|-------|---------|
| P1 | Must have | Required for release |
| P2 | Should have | Include if possible |
| P3 | Nice to have | Future enhancement |

### Task Symbols

| Symbol | Meaning |
|--------|---------|
| `[ ]` | Not started |
| `[~]` | In progress |
| `[x]` | Complete |
| `[B]` | Blocking (do first) |
| `[P]` | Can run in parallel |

---

## What's Next?

- **See a complete example:** Read the [User Authentication Walkthrough](examples/user-auth-feature/README.md) for a more complex feature
- **Learn all commands:** See the [Command Reference](command-reference.md) for full details
- **Deep dive:** Read the [User Guide](user-guide.md) for comprehensive coverage
- **Troubleshooting:** See [Troubleshooting](troubleshooting.md) if you encounter issues

---

*Congratulations! You've completed your first feature specification with Prism.*
