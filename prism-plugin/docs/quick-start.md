# Quick Start Guide

> Go from idea to working code in plain English. No coding required.

---

## What is Prism?

Prism is like having a technical team that speaks your language. You describe what you want to build in plain English, and Prism turns that into working software — with checkpoints along the way where you review and approve.

Think of it like this: You're the architect describing your dream house. Prism is the construction crew that builds it, but checks in with you at each major step to make sure they understood correctly.

```mermaid
flowchart LR
    A[Your Idea] --> B[Prism]
    B --> C[Working Code]

    style A fill:#e0f2fe,stroke:#0ea5e9
    style B fill:#6366f1,stroke:#4f46e5,color:#fff
    style C fill:#d1fae5,stroke:#10b981
```

---

## Prerequisites

You need **Node.js 18+**, **Claude Code**, and **Git** installed. If you're not sure, the [Installation Guide](installation.md) walks you through each one.

Already have them? Skip to Installation below.

### Starting from Zero?

If you have an idea but no code yet — that's perfect. Prism is designed for exactly this. After installing Prism, run `/prism`. It will detect you're starting fresh and guide you through **Discovery** — a conversation that helps you choose a tech stack. You don't need to know what framework or database to use.

---

## Installation

Prism is a Claude Code plugin (a set of tools that run inside Claude Code, the AI coding assistant). Installation takes about 30 seconds.

For full details and troubleshooting, see the [Installation Guide](installation.md).

### Step 1: Add the Marketplace

```bash
claude plugin marketplace add araserel/prism-os
```

### Step 2: Install the Plugin

```bash
claude plugin install prism@prism-os
```

### Step 3: Verify

Start Claude Code and run:

```
/prism status
```

You should see the Prism status dashboard. That's it — Prism is ready.

### What Prism Adds to Your Project

When you run `/prism` for the first time, it creates these project files:

| Folder | What It Contains |
|--------|------------------|
| `memory/` | Project rules, state, and learnings |
| `specs/` | Feature specifications you create |
| `PRISM.md` | Enforcement rules (auto-generated) |

> **Note:** The plugin itself is managed by Claude Code. Only your project-specific files live in your repository.

---

## Initialize Your Project

Before building features, tell Prism about your project. This is a one-time setup.

### Step 1: Start Claude Code

From your project folder:
```bash
claude
```

This opens an interactive session with Claude Code. You'll see a prompt where you can type commands.

### Step 2: Set Up Project Principles

Type:
```
/constitution
```

Prism guides you through 3 quick rounds in plain language:

```
Round 1: I scanned your project and found:
- Language: TypeScript
- Framework: Next.js
- Database: PostgreSQL

Is this correct? Anything to add or change?
> Looks good

Round 2: What kind of project is this?
1. MVP / Prototype — Ship fast, add polish later
2. Production App — Balance speed with stability
3. Enterprise — Maximum rigor
> 2

Round 3: A few optional preferences (say "skip" for defaults):
- Should I ask before adding external services? (Yes/No)
- Should the app work offline? (Yes/No)
- Accessibility: Works for everyone, or standard?
> skip
```

That's it — Prism handles all the technical details automatically based on your choices.

### What This Creates

Your answers become your project's **constitution** — rules that Prism follows for all features:

```
Technology Stack
├── Language: TypeScript
├── Framework: Next.js
├── Database: PostgreSQL
└── Quality: Production App

Standards (auto-configured)
├── Test Coverage: 60%+ minimum
├── Code Style: Prettier + ESLint
├── Security: Auth required, secrets in env vars
└── Accessibility: WCAG 2.1 AA
```

---

## Start Your First Feature

Now the fun part — building something!

### What `/prism` Does Automatically

Every time you run `/prism`, Prism runs a quick health check in the background. It makes sure your setup is correct and your project files are up to date. You don't need to do anything. If something needs your attention, Prism tells you.

### Step 1: Describe What You Want

In your Claude Code session, just describe the feature in plain English:

```
/prism "Add a contact form where visitors can send messages to our support team"
```

Or simply type naturally:
```
I want to add a contact form to the website
```

Prism understands both.

### Step 2: Watch Prism Create the Specification

Prism analyzes your request and creates a structured specification — a detailed description of what will be built.

```mermaid
sequenceDiagram
    participant You
    participant Prism
    participant Spec as Specification

    You->>Prism: "Add a contact form"
    Prism->>Prism: Analyze request
    Prism->>Spec: Create specification
    Prism-->>You: Show spec for review

    Note over You,Prism: ⏸️ Checkpoint: Review & Approve

    You->>Prism: "Looks good" or "Change X"
    Prism->>Prism: Continue to planning...
```

You'll see something like:

```
Creating specification for: Contact Form
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Track: Standard (feature with moderate complexity)

User Scenarios (P1 = Must Have)
├── US-001 [P1]: As a visitor, I can submit a message
├── US-002 [P1]: As a visitor, I see confirmation my message was sent
└── US-003 [P2]: As a visitor, I receive an email copy

Requirements
├── FR-001 [P1]: Form accepts name, email, message
├── FR-002 [P1]: Form validates email format
├── FR-003 [P1]: Success message shown on submit
└── NFR-001 [P1]: Form works on mobile devices

Does this match what you want? (Y/n)
```

### Step 3: Review and Approve

This is your checkpoint. Read through the specification and:

- **If it looks right:** Type `Y` or `yes` or just press Enter
- **If something's wrong:** Describe what needs to change
- **If you have questions:** Just ask

For example:
```
> The form should also have a phone number field

Got it. I'll add an optional phone number field to the specification.
```

### Step 4: Answer Clarification Questions

Prism may ask follow-up questions to remove ambiguity:

```
Clarification Questions
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Q1: How should the form prevent spam?
   A) CAPTCHA (user solves a puzzle)
   B) Honeypot field (invisible trap for bots) ← Recommended
   C) Rate limiting (max submissions per hour)

Your choice (A/B/C):
```

Just type your choice (like `B`). Prism updates the specification with your answer.

---

## Watch Prism Build

After you approve the specification, Prism automatically:

1. Creates an implementation plan
2. Breaks it into tasks
3. Starts building

```
You Approve Spec
      │
      ▼
  Create Plan
      │
      ▼
  Break into Tasks
      │
      ▼
  ┌─── Per-Task Loop ───────────────────────┐
  │                                          │
  │   Build Task ──▶ Quality Check           │
  │                     │                    │
  │               Pass? ├──Yes──▶ Next Task  │
  │                     │                    │
  │                    No                    │
  │                     │                    │
  │               Fix & Recheck              │
  │               (up to 5 times)            │
  │                                          │
  └──────────────────────────────────────────┘
      │
      ▼
  Code Review ──▶ Done!
```

### What You'll See in the Terminal

As Prism works, you'll see progress updates:

```
📋 Feature: Contact Form
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Specification - Complete (5 requirements)
✅ Clarification - 2 questions resolved
✅ Planning      - Complete
🔄 Tasks        - 4/7 complete

Current: Building form validation logic

[████████░░░░░░░░] 57%
```

### Check Status Anytime

If you want a detailed status update:
```
/prism status
```

Or just ask:
```
What's the progress?
```

### Stepping Away?

You can close the terminal and come back later. Your progress is saved. When you return:
```bash
claude
```

Then:
```
/prism continue
```

Prism picks up exactly where it left off.

---

## Done! Now What?

When Prism finishes, you'll see:

```
✅ Feature Complete: Contact Form
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All tasks completed successfully!

Files Created:
├── src/components/ContactForm.tsx
├── src/app/api/contact/route.ts
├── src/lib/validations/contact.ts
└── tests/contact-form.test.ts

Quality Checks:
├── ✅ All tests passing (12/12)
├── ✅ No linting errors
└── ✅ Accessibility validated

Next steps:
1. Review the changes in your code editor
2. Test the feature manually
3. Commit when ready: git add . && git commit -m "Add contact form"
```

### Review the Changes

Open your code editor and look at the new files. Even if you don't understand the code, you can:
- Check that file names make sense
- See that tests exist
- Look for any comments Prism added

### Test the Feature

If your project has a development server:
```bash
npm run dev
```

Then open your browser and try the new feature.

### What Prism Learned

During implementation, Prism automatically captured lessons for future features:
- **Patterns** — Reusable rules it discovered while building
- **Gotchas** — Traps it encountered and how to avoid them
- **Decisions** — Why certain choices were made

Run `/learn` to see what was captured. These learnings help future features go smoother — Prism remembers what worked and avoids past mistakes.

### Commit Your Changes

When you're happy with the feature, save it to your project history:

```bash
git add .
git commit -m "Add contact form feature"
```

> **New to Git?** Here's what these commands do:
> - `git add .` — Stages all changed files (tells Git "I want to save these")
> - `git commit -m "..."` — Saves a snapshot with a description
>
> Think of it like saving a document, but with a note about what changed.

**Want Prism to handle commits?** Just ask:
```
Commit these changes with a good message
```

Prism will create an appropriate commit message and run the commands for you.

---

## If Something Goes Wrong

Don't worry — things don't always go perfectly. Here's how to handle common situations.

### Prism Gets Stuck

If Prism seems frozen or you're not sure what's happening:

```
/prism status
```

This shows exactly where things stand. You might see:
```
⚠️ Blocked: Waiting for clarification

Question pending: "Should the form require all fields?"
```

Just answer the question to continue.

### The Spec Doesn't Match What You Want

Before approving, you can request changes:

```
Actually, I don't want the email confirmation feature.
Just show a success message on the page.
```

Prism will update the specification and show it again for approval.

### Tests Are Failing

After each task is built, Prism runs quality checks and automatically tries to fix any failures (up to 5 attempts per task). If it can't fix an issue, you'll see:

```
⚠️ Escalation: Test failures require attention

Failing: tests/contact-form.test.ts
- Expected: Form submits successfully
- Actual: API returns 500 error

This may require manual investigation.
Options:
1. Let me try a different approach
2. Skip this test for now
3. Get help from a developer

Your choice (1/2/3):
```

Choose option 1 to let Prism try again, or option 3 if you want to involve a developer.

### You Made a Mistake

You can always start over:

```
/spec "Add a contact form"
```

This creates a new specification from scratch.

---

## Updating Prism

When new versions are released, update with a single command.

From within Claude Code:
```
/prism-update
```

Or from your terminal:
```bash
claude plugin update prism@prism-os
```

Your project files (`memory/`, `specs/`) are not affected by updates. Only the plugin components are updated.

After updating, start a new Claude Code session and run `/prism` to verify.

---

## Command Cheat Sheet

These four commands cover most use cases:

| Command | What It Does |
|---------|--------------|
| `/prism` | Show status and what to do next |
| `/prism "..."` | Start building a feature from your description |
| `/prism continue` | Resume work on an in-progress feature |
| `/constitution` | Set up or update project rules |

You don't have to remember commands. Just say what you mean — "I want to add user login" works as well as `/prism "Add login"`.

For the full list of commands, see the [Command Reference](command-reference.md).

---

## How It Works (Optional Reading)

> **Skip this section** if you just want to build things. Come back when you're curious about what's happening under the hood.

<details>
<summary>Click to expand: Architecture Overview</summary>

Here's how all the pieces fit together:

```mermaid
flowchart TD
    subgraph You
        A[Your Ideas]
    end

    subgraph Prism[Prism OS]
        B[Orchestrator]
        B --> C[Business Analyst]
        B --> D[Architect]
        B --> E[Developer]
        B --> F[QA Engineer]

        C --> G[Specifications]
        D --> H[Plans]
        E --> I[Code]
        F --> J[Quality Checks]
    end

    subgraph Claude[Claude Code]
        K[AI Engine]
    end

    subgraph Project[Your Project]
        L[Working Software]
    end

    A --> B
    B --> K
    K --> B
    J --> L

    style You fill:#e0f2fe,stroke:#0ea5e9
    style Prism fill:#e0e7ff,stroke:#6366f1
    style Claude fill:#fef3c7,stroke:#f59e0b
    style Project fill:#d1fae5,stroke:#10b981
```

**You** describe what you want in plain English.

**Prism** routes your request to specialized AI agents:
- **Business Analyst** — Turns your description into a specification
- **Architect** — Designs how the code should be structured
- **Developer** — Writes the actual code
- **QA Engineer** — Checks each task right after the Developer finishes it (not at the end)

**Claude Code** powers these agents with advanced language understanding.

**Your Project** receives working, tested code.

</details>

<details>
<summary>Click to expand: The Full Workflow</summary>

Here's the complete journey from idea to working code:

```mermaid
sequenceDiagram
    participant You
    participant Prism
    participant Agents as AI Agents
    participant Code as Your Code

    rect rgb(224, 242, 254)
        Note over You,Prism: 1. Describe
        You->>Prism: "Add a contact form"
    end

    rect rgb(224, 231, 255)
        Note over Prism,Agents: 2. Specify
        Prism->>Agents: Analyze request
        Agents->>Prism: Create specification
        Prism-->>You: Show spec for review
        You->>Prism: Approve (or request changes)
    end

    rect rgb(254, 243, 199)
        Note over Prism,Agents: 3. Clarify
        Prism->>Agents: Check for ambiguities
        Agents-->>You: Ask clarifying questions
        You->>Prism: Provide answers
    end

    rect rgb(209, 250, 229)
        Note over Prism,Code: 4. Build
        Prism->>Agents: Create plan
        Agents->>Agents: Break into tasks
        loop Each Task
            Agents->>Code: Write code
            Agents->>Agents: Run tests
        end
    end

    rect rgb(220, 252, 231)
        Note over Prism,You: 5. Deliver
        Agents->>Agents: Quality checks
        Prism-->>You: Feature complete!
    end
```

</details>

---

## What's Next?

You've built your first feature. Here's how to keep going:

- **Build another feature:** Just describe it and Prism handles the rest
- **See a complex example:** Read the [User Authentication Walkthrough](examples/user-auth-feature/README.md)
- **Learn all commands:** See the [Command Reference](command-reference.md)
- **Troubleshoot issues:** Check the [Troubleshooting Guide](troubleshooting.md)
- **Understand the terms:** Browse the [Glossary](glossary.md)

---

*You're now ready to build software with Prism. Just describe what you want — and watch it happen.*
