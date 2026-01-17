## Context

You are continuing work on **Prism OS**, an AI-powered spec-driven development operating system. Phases 1-5 are complete:

- **Phase 1 (Foundation):** Project structure, constitution, base CLAUDE.md ✓
- **Phase 2 (Core Workflow):** Skills, templates, guided prompts, skill chains ✓
- **Phase 3 (Agents):** 8 agent definitions, routing, handoffs ✓
- **Phase 4 (Quality & Review):** QA skills, review pipeline, validation loops ✓
- **Phase 5 (Integration & Polish):** Context persistence, error handling, status reporting, versioning, extension docs, MCP integration ✓

Phase 6 focuses on **Documentation**: Creating comprehensive guides for non-technical users (PMs, POs, business stakeholders).

---

## Project Location

```
/Users/adamriedthaler/Projects/SpecMaster/
```

**Key Files to Reference:**
- `PROJECT_PLAN.md` — Full implementation plan with Phase 6 tasks
- `CLAUDE.md` — Main operating system specification
- `/memory/constitution.md` — Project principles
- `/docs/` — Existing documentation (context-management, error-handling, versioning, extending-skills, mcp-integration)
- `.claude/skills/` — All skill definitions (for command/feature documentation)
- `.claude/agents/` — All agent definitions (for workflow documentation)

---

## Phase 6 Objectives

Create comprehensive, non-technical documentation so PMs and POs can use Prism without developer assistance.

**Target Audience:** Product Managers, Product Owners, Business Stakeholders
**Key Constraint:** Plain language throughout — no unexplained jargon

---

## Tasks Overview

### Task 6.1: Create User Guide for PMs/POs
**Goal:** Primary user documentation covering all common workflows.

**Subtasks:**
- [ ] 6.1.1: Create `/docs/user-guide.md`
- [ ] 6.1.2: Write "Getting Started" section (first session, constitution setup)
- [ ] 6.1.3: Write "Creating Features" section (spec workflow)
- [ ] 6.1.4: Write "Understanding Status" section (phases, progress, blockers)
- [ ] 6.1.5: Write "Making Decisions" section (how to respond to technical choices)
- [ ] 6.1.6: Write "Troubleshooting" section (common issues, how to get help)
- [ ] 6.1.7: Include diagrams where helpful
- [ ] 6.1.8: Use plain language throughout—no jargon

**Acceptance Criteria:**
- A PM can use Prism after reading this guide
- No unexplained technical terms
- All common workflows covered

---

### Task 6.2: Create Quick-Start Tutorial
**Goal:** Hands-on tutorial completable in 30 minutes.

**Subtasks:**
- [ ] 6.2.1: Create `/docs/quick-start.md`
- [ ] 6.2.2: Define a simple example feature to build
- [ ] 6.2.3: Walk through each phase with the example
- [ ] 6.2.4: Show expected outputs at each step
- [ ] 6.2.5: Highlight decision points and how to handle them
- [ ] 6.2.6: Keep tutorial completable in 30 minutes

**Acceptance Criteria:**
- New user can complete tutorial in 30 minutes
- Covers full workflow from spec to implementation
- Clear expected outcomes at each step

---

### Task 6.3: Create Example Project Walkthrough
**Goal:** Document a complete example project from start to finish.

**Subtasks:**
- [ ] 6.3.1: Create `/docs/examples/user-auth-feature/` directory
- [ ] 6.3.2: Include example constitution.md
- [ ] 6.3.3: Include example spec.md with clarifications
- [ ] 6.3.4: Include example plan.md
- [ ] 6.3.5: Include example tasks.md
- [ ] 6.3.6: Include narrative walkthrough document
- [ ] 6.3.7: Highlight key decision points and how they were resolved

**Acceptance Criteria:**
- Complete example from constitution to implementation
- All artifacts included
- Narrative explains reasoning at each step

---

### Task 6.4: Create Troubleshooting Guide
**Goal:** Document common issues and solutions.

**Subtasks:**
- [ ] 6.4.1: Create `/docs/troubleshooting.md`
- [ ] 6.4.2: Document "Stuck at clarification" issue and resolution
- [ ] 6.4.3: Document "QA loop not resolving" issue and resolution
- [ ] 6.4.4: Document "Wrong agent responding" issue and resolution
- [ ] 6.4.5: Document "Context lost between sessions" issue and resolution
- [ ] 6.4.6: Document "How to override agent decisions" guide
- [ ] 6.4.7: Add contact/escalation information

**Acceptance Criteria:**
- Common issues documented with solutions
- Non-technical language used
- Escalation path clear

---

### Task 6.5: Create Command Reference
**Goal:** Document all slash commands and their usage.

**Subtasks:**
- [ ] 6.5.1: Create `/docs/command-reference.md`
- [ ] 6.5.2: Document each command (spec, clarify, plan, tasks, status, constitution)
- [ ] 6.5.3: Include syntax, parameters, and examples for each
- [ ] 6.5.4: Include expected output examples
- [ ] 6.5.5: Add "When to use" guidance for each command

**Acceptance Criteria:**
- All commands documented
- Examples for each command
- Clear guidance on when to use each

---

## Recommended Approach

### Suggested Task Order

1. **Start with 6.5 (Command Reference)** — Quick win, establishes vocabulary
2. **Then 6.2 (Quick-Start Tutorial)** — Hands-on, reveals documentation gaps
3. **Then 6.1 (User Guide)** — Comprehensive, builds on tutorial learnings
4. **Then 6.4 (Troubleshooting)** — Anticipates user pain points
5. **Finally 6.3 (Example Walkthrough)** — Full example, uses all prior docs

### Working Pattern

For each task:
1. Read existing system files to understand actual behavior
2. Write in plain language — imagine explaining to a smart non-technical person
3. Include concrete examples, not abstract descriptions
4. Test any commands/workflows you document to verify accuracy
5. Cross-reference other docs where helpful

---

## Documentation Standards

### Language Guidelines

**DO:**
- Use active voice ("Click the button" not "The button should be clicked")
- Define terms on first use if they can't be avoided
- Use concrete examples throughout
- Keep sentences short
- Use numbered steps for procedures

**DON'T:**
- Use technical jargon without explanation
- Assume familiarity with development concepts
- Write walls of text without structure
- Use acronyms without defining them first

### Structure Guidelines

Each document should have:
1. **Clear title** — What this document covers
2. **Purpose statement** — Who this is for and what they'll learn
3. **Prerequisites** — What they need before starting (if any)
4. **Main content** — Organized with clear headings
5. **Next steps** — What to do after reading this

### Example Formatting

When showing expected output or examples:

```markdown
**Example: Creating a new feature**

You say:
> "I want to add a password reset feature"

Prism responds:
> "I'll help you create a specification for a password reset feature.
> First, let me ask a few questions to understand what you need..."
```

---

## Reference Materials

### Commands to Document (Task 6.5)

From CLAUDE.md, the slash commands are:
- `/status` — Show current workflow state
- `/spec` — Create new feature specification
- `/clarify` — Resolve ambiguities in current spec
- `/plan` — Generate implementation plan
- `/tasks` — Break plan into tasks
- `/constitution` — Create or update project constitution
- `/handoff` — Generate engineer handoff package

### Workflow Phases to Explain (Task 6.1)

1. **Assess** — Determine complexity and track
2. **Specify** — Create feature specification
3. **Clarify** — Resolve ambiguities
4. **Plan** — Design technical approach
5. **Tasks** — Break into executable work
6. **Implement** — Write the code
7. **Validate** — Run quality checks
8. **Review** — Final review and approval

### Common Issues to Document (Task 6.4)

From flow tests and error-handling.md:
- Clarification loop stuck (max 3 iterations)
- QA fix loop not resolving (max 5 iterations)
- Constitution violations requiring human decision
- Context not loading on session restart
- Wrong agent handling request

---

## Constraints & Principles

From the constitution and project patterns:

- **Non-technical user focus:** Every doc must be readable by someone with no coding experience
- **Concrete over abstract:** Show don't tell — use examples liberally
- **Progressive disclosure:** Start simple, add detail for those who want it
- **Accuracy:** Test commands before documenting them

---

## Phase 6 Review Gate

**Definition of Done:**
- [ ] User guide complete and reviewed for clarity
- [ ] Quick-start tutorial completable in 30 minutes
- [ ] Example project walkthrough complete
- [ ] Troubleshooting guide covers common issues
- [ ] Command reference complete
- [ ] Non-technical reviewer validates documentation clarity

**Deliverables:**
- `/docs/user-guide.md`
- `/docs/quick-start.md`
- `/docs/examples/user-auth-feature/` (all artifacts)
- `/docs/troubleshooting.md`
- `/docs/command-reference.md`

---

## Getting Started

Begin by reading the current state:

```
Read these files to understand what you're documenting:
1. CLAUDE.md (commands, workflow, agents)
2. .claude/skills/workflow/status-reporter.md (status output format)
3. /docs/error-handling.md (error categories for troubleshooting)
4. /docs/context-management.md (session continuity for troubleshooting)
5. /templates/ (all templates users will see populated)
```

Then start with Task 6.5 (Command Reference) — it's the quickest to complete and establishes the vocabulary for other docs.

---

## Quality Check

Before marking any doc complete, verify:

1. **No jargon test:** Could your non-technical friend understand this?
2. **Accuracy test:** Did you verify the commands/workflows actually work this way?
3. **Completeness test:** Does it cover what a new user would need?
4. **Flow test:** Does it have a clear beginning, middle, and end?

---

## Questions?

If anything is unclear or you need decisions made, pause and ask. Documentation quality matters more than speed — take time to get it right.
