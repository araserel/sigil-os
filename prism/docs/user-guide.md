# Prism User Guide

> Complete guide for Product Managers, Product Owners, and business stakeholders.

This guide covers everything you need to know to use Prism effectively. Whether you're creating your first feature specification or managing a complex project, you'll find the information here.

---

## How to Use This Guide

**New to Prism?** Start with Part 1: Getting Started, then work through the [Quick-Start Tutorial](quick-start.md).

**Looking for something specific?** Use the table of contents below to jump to any section.

**Need quick syntax?** See the [Command Reference](command-reference.md).

---

## Table of Contents

1. [Getting Started](#part-1-getting-started)
2. [Creating Features](#part-2-creating-features)
3. [Understanding Technical Output](#part-3-understanding-technical-output)
4. [Working with Your Team](#part-4-working-with-your-team)
5. [Status and Tracking](#part-5-status-and-tracking)
6. [Troubleshooting](#part-6-troubleshooting)
7. [Appendices](#appendices)

---

## Part 1: Getting Started

### What is Prism?

Prism is a tool that helps you create clear, complete feature specifications. You describe what you want in plain language, and Prism:

1. Structures your requirements into a formal specification
2. Asks clarifying questions to resolve ambiguities
3. Creates an implementation plan for engineers
4. Breaks the plan into actionable tasks

The result is documentation that engineers can implement without confusion or back-and-forth questions.

### Design Principles

Prism is built on 7 core principles that guide every decision:

**1. Spec-First Development**
Specifications are the source of truth. Before any code is written, there is a written spec describing what will be built, why it matters, and what success looks like. If the spec is wrong, the code will be wrong — so we invest in getting the spec right.

**2. Guided Decision-Making**
You should never face a technical choice without context. When a technical decision is needed (framework, architecture, security), the system presents options in plain language with trade-offs. You choose based on business needs; the system handles the technical details.

**3. Scale-Adaptive Tracks**
The right amount of process for the right size of work. A bug fix doesn't need a 30-page PRD. A new product doesn't ship with a 5-minute spec. Prism automatically selects the appropriate workflow depth:

| Track | For | Workflow Depth |
|-------|-----|----------------|
| **Quick Flow** | Bug fixes, small tweaks | Lightweight spec → Tasks → Implement |
| **Standard** | Features, enhancements | Full spec → Clarify → Plan → Tasks → Implement → Validate |
| **Enterprise** | New systems, architectural changes | Extended spec → Research → Architecture → Plan → Tasks → Implement → Validate → Review |
| **Discovery** | Greenfield projects, new tech decisions | Problem → Constraints → Options → Decision → Foundation Doc |

**4. Constitutional Boundaries**
Each project has a constitution — immutable principles that guide all decisions. "We use TypeScript." "All APIs require authentication." The AI agents respect these boundaries without being reminded.

**5. Human-in-the-Loop**
Automate the routine. Pause for the consequential. Not every action needs approval. Prism uses a three-tier model: Auto (safe, reversible actions), Review (scope or design changes), and Approve (production deployments, security changes).

**6. Visible Progress**
If you can't see it, you can't manage it. You can see exactly where work stands — which phase, which task, what's blocking — at any time.

**7. Accessibility by Default**
Build for everyone from the start, not as an afterthought. All generated code, interfaces, and documentation meet WCAG 2.1 AA standards as a minimum, validated during the QA phase.

### Key Concepts

Before diving in, familiarize yourself with these terms:

| Term | Definition |
|------|------------|
| **Specification (Spec)** | A written document describing what a feature should do, who it's for, and how to verify it's working |
| **Constitution** | Your project's rulebook - the standards and technologies all features must follow |
| **Track** | The workflow path based on feature size: Quick (small), Standard (medium), Enterprise (large) |
| **Phase** | A stage in the workflow: Assess, Specify, Clarify, Plan, Tasks, Implement, Validate, Review |
| **Priority** | How important a requirement is: P1 (must have), P2 (should have), P3 (nice to have) |

### What Happens Behind the Scenes

When you run `/prism`, several things happen automatically to keep your project healthy:

- **Preflight check** — Every `/prism` run verifies that Prism is installed correctly in your project. If any files are missing or out of date, it reports what needs attention.
- **Enforcement rules** — Prism automatically adds operational rules to your project's `CLAUDE.md` file. These ensure agents follow the correct workflow, respect your constitution, and use the right skills. You don't need to manage this.
- **Context staleness detection** — Prism checks whether `project-context.md` matches the actual state of your spec artifacts. If your project says you're in the "Specify" phase but a `plan.md` already exists, Prism auto-corrects the recorded phase to match reality.
- **Pre-execution context hooks** — Before skills run, they automatically update `project-context.md` so your project state is always current.

### Your First Session

When you start Prism for the first time:

1. **Set up your constitution** (if not already done)
   ```
   /constitution
   ```
   Answer questions about your project's technology and standards.

2. **Check the status**
   ```
   /status
   ```
   See what's in progress and what phase you're in.

3. **Create your first feature**
   ```
   /spec [your feature description]
   ```
   Describe what you want to build.

---

## Part 2: Creating Features

### Workflow Phases

Prism OS operates through 8 phases:

| Phase | Name | Purpose |
|-------|------|---------|
| 0 | Assessment | Evaluate request complexity, select track |
| 1 | Specify | Capture requirements in structured format |
| 2 | Clarify | Surface ambiguities, resolve unknowns |
| 3 | Plan | Create implementation approach |
| 4 | Tasks | Break plan into implementable units |
| 5 | Implement | Execute tasks (handoff point for external teams) |
| 6 | Validate | Verify implementation meets requirements |
| 7 | Review | Final quality gate, capture learnings |

Not all requests traverse all phases. Quick Flow may skip directly from Assessment to Tasks for simple work.

**Assessment:** Prism evaluates your description and selects the appropriate track.

**Specify:** Your description becomes a structured specification with user scenarios, requirements, and success criteria.

**Clarify:** Any ambiguities are resolved through targeted questions (maximum 3 rounds).

**Plan:** A technical implementation plan is generated.

**Tasks:** The plan is broken into discrete, assignable tasks.

**Implement:** Code is written by developers (human or AI).

**Validate:** Automated checks verify quality before review.

**Review:** Final approval before deployment.

### Discovery Track — Starting a New Project

If you're starting from scratch with no existing codebase or tech stack, Prism enters the **Discovery Track**. This is a guided conversation that helps you make foundational decisions before building anything.

**When Discovery activates:**
- You say "new project," "new idea," or "starting from scratch"
- No existing tech stack context is found
- You ask "what tech should I use?"

**How it works:**

| Phase | What Happens |
|-------|-------------|
| Problem Clarity | Define what you're solving and for whom |
| Constraints Gathering | Discuss budget, timeline, team skills, compliance, and scale |
| Tech Stack Options | Prism presents 2-3 viable options as a decision matrix |
| Decision Capture | Your chosen stack is documented in a Project Foundation |
| Transition | The Standard track begins with your foundation as context |

The output is a `project-foundation.md` file that serves as context for all subsequent features. You don't need to know what framework or database to use — Prism recommends options based on what you're building.

### Writing Good Feature Descriptions

The quality of your specification depends on your initial description. Here's how to write effective ones:

**Do Include:**

- Who will use this feature (visitors, logged-in users, admins)
- What they want to accomplish
- Why this matters (business context)
- Any constraints you already know

**Example (Good):**

> "Add a user dashboard showing recent activity. Logged-in users should see their last 10 actions (created, edited, deleted items) with timestamps. They should be able to filter by action type and date range. This is for our power users who manage many items."

**Example (Too Vague):**

> "Add a dashboard."

The vague example will require many clarification rounds. The detailed example might proceed directly to planning.

### Understanding the Specification

When you run `/spec`, Prism produces a document with these sections:

**Summary:** One-paragraph description of the feature and its purpose.

**User Scenarios:** Stories in the format "As a [user], I want to [action] so that [benefit]." Each has a priority (P1, P2, P3) and unique ID.

**Functional Requirements:** Specific things the system must do. Each has:
- Unique ID (FR-001, FR-002, etc.)
- Description of the requirement
- Priority level
- Acceptance criteria (how to verify it works)

**Non-Functional Requirements:** How well the system must perform. Examples:
- Performance: "Page loads in under 2 seconds"
- Security: "Data encrypted in transit"
- Accessibility: "Meets WCAG 2.1 AA"

**Key Entities:** The data involved. For a user profile feature, entities might include User (id, name, email, avatar) and Profile (bio, location, website).

**Success Criteria:** Checkboxes showing what must be true for the feature to be considered complete.

**Out of Scope:** Explicitly states what this feature does NOT include, preventing scope creep.

### Answering Clarification Questions

After creating a spec, you may need to clarify ambiguities.

**Command:**
```
/clarify
```

**What to Expect:**

Prism asks targeted questions with multiple-choice options. Questions might cover:

- Technical approaches (how should X be implemented?)
- Business rules (what happens when Y?)
- Edge cases (what if Z fails?)
- Priorities (which is more important, A or B?)

**Tips for Answering:**

1. **Consider your users.** Which option provides the best experience?
2. **Think about maintenance.** Simpler solutions are easier to maintain.
3. **Ask your tech lead.** If unsure about technical trade-offs, consult before answering.
4. **Document your reasoning.** Prism records your answers - future team members will understand why decisions were made.

**Clarification Limits:**

Prism allows a maximum of 3 clarification rounds. If issues remain after 3 rounds, you'll need to:
- Simplify the feature scope
- Provide more detail in your answers
- Meet with stakeholders to resolve conflicts

---

## Part 3: Understanding Technical Output

### Reading an Implementation Plan

After clarification, `/plan` generates a technical plan. Here's how to interpret it:

**Constitution Gate Checks:** Verifies the plan follows your project rules. All boxes should be checked. If not, discuss with your tech lead.

**Project Structure:** Shows what files will be created or modified. You don't need to understand the file paths, but you can verify:
- New files are being created (not just modifying everything)
- The scope looks reasonable (10 files, not 100)

**API Contracts:** Defines how different parts of the system communicate. Look for:
- Request/Response pairs that match your requirements
- Error handling for expected failure cases

**Dependencies:** Lists new software packages needed. Fewer is generally better. Three or fewer new packages is typical.

**Risk Assessment:** Identifies potential problems and mitigations. Review this with your tech lead if anything seems concerning.

### Understanding Task Breakdowns

The `/tasks` command produces an actionable task list. Here's how to read it:

**Task Structure:**

```
T001: [Task description] [Symbols]
├── Files: [What will be created/changed]
├── Acceptance Criteria: [How to verify completion]
├── Depends On: [What must be done first]
└── Test First: [Yes/No]
```

**Task Symbols:**

| Symbol | Meaning |
|--------|---------|
| `[ ]` | Not started |
| `[~]` | In progress |
| `[x]` | Complete |
| `[B]` | Blocking - other tasks depend on this |
| `[P]` | Parallel - can run alongside other `[P]` tasks |

**Using Tasks for Sprint Planning:**

1. **Identify blocking tasks** - These must be done first
2. **Find parallel opportunities** - Tasks marked `[P]` can be assigned to multiple engineers
3. **Note dependencies** - Ensure dependent tasks are scheduled after their prerequisites
4. **Check test requirements** - "Test First: Yes" means tests should be written before the code

### Approval Tiers — When Prism Pauses vs Proceeds

Prism uses a three-tier model to balance speed with control. Here's when it will pause and ask you versus when it proceeds automatically:

| Tier | Behavior | Your Experience |
|------|----------|-----------------|
| **Auto** | Agent acts immediately and logs the action | You see the result in a status update |
| **Review** | Agent acts, then flags for your review | You review when convenient; work continues |
| **Approve** | Agent pauses and waits for your explicit approval | Work stops until you approve |

**What falls into each tier:**

| Action | Tier | Notes |
|--------|------|-------|
| Status queries | Auto | — |
| Research tasks | Auto | — |
| Spec drafts | Review | You review before proceeding |
| Clarification questions | Auto | Questions are generated; you provide answers |
| Plan creation | Review | Escalates to Approve if architectural |
| Task breakdown | Auto (≤20 tasks) | Review if >20 tasks |
| Code implementation | Auto | Review if scope changes detected |
| QA validation | Auto | Review if escalated after failures |
| Code review | Review | — |
| Security review | Approve | — |
| Production deployment | Approve | — |
| Database migrations | Approve | — |
| New dependencies | Review | Approve if security-sensitive |

---

## Part 4: Working with Your Team

### The Handoff Process

When specifications are complete, use `/handoff` to create an engineering package.

**What Engineers Receive:**

| Document | Purpose |
|----------|---------|
| Specification | What to build and why |
| Clarifications | Decisions already made |
| Implementation Plan | How to build it |
| Task Breakdown | What to do in what order |

**After Handoff:**

Engineers may still have questions. If they ask something covered in the clarifications document, point them there. If it's a new question, consider whether it should have been caught during clarification - this improves future specifications.

### Making Decisions

Throughout the workflow, you'll make decisions that affect implementation. Here's a framework:

**User Impact Questions** - You should decide:
- Which users is this for?
- What's the priority of conflicting requirements?
- What's acceptable for error messages and edge cases?

**Technical Questions** - Consult your tech lead:
- Which technology approach is better?
- What are the performance implications?
- How does this affect existing systems?

**Business Questions** - Escalate if needed:
- Does this align with company strategy?
- Are there legal or compliance implications?
- What's the budget/timeline trade-off?

---

## Part 5: Status and Tracking

### Checking Progress

Use `/status` anytime to see current state.

**Example Output:**

```
┌─────────────────────────────────────────────────────┐
│ Feature: User Dashboard                             │
│ Track: Standard                                     │
│ Phase: Implementation                               │
├─────────────────────────────────────────────────────┤
│ Progress: ████████████░░░░ 75%                      │
│                                                     │
│ Phases:                                             │
│ [x] Assess                                          │
│ [x] Specify                                         │
│ [x] Clarify                                         │
│ [x] Plan                                            │
│ [x] Tasks                                           │
│ [~] Implement (6/8 tasks complete)                  │
│ [ ] Validate                                        │
│ [ ] Review                                          │
├─────────────────────────────────────────────────────┤
│ Blockers: None                                      │
│ Decisions Pending: None                             │
└─────────────────────────────────────────────────────┘
```

### Understanding Status Information

**Track:** The workflow path (Quick/Standard/Enterprise) determines how much documentation is generated.

**Phase:** Where the feature is in the workflow.

**Progress:** Overall completion percentage.

**Blockers:** Things preventing progress. These need your attention.

**Decisions Pending:** Questions waiting for your answer.

### Managing Blockers

When blockers appear, they require action:

**Common Blockers:**

| Blocker | Action |
|---------|--------|
| Clarification needed | Answer the pending question via `/clarify` |
| Constitution conflict | Review with tech lead, update constitution if needed |
| External dependency | Coordinate with the team that owns that dependency |
| Resource unavailable | Escalate to project leadership |

### Learning Loop

Prism captures learnings automatically as you work. This builds institutional memory that helps avoid repeating mistakes and surfaces validated patterns over time.

**The 4 learning categories:**

| Category | What It Contains | When Loaded |
|----------|------------------|-------------|
| **Patterns** | Validated rules to follow (e.g., "always use server actions for forms") | Every task |
| **Gotchas** | Project-specific traps to avoid (e.g., "API rate limit is 100/min") | Every task |
| **Decisions** | Architectural choices and their rationale | On demand |
| **Feature Notes** | Per-feature task details and context | Current feature only |

**Lifecycle:**

1. **Capture** — Learnings are recorded automatically after each task
2. **Reference** — Relevant learnings are loaded before each task begins
3. **Review** — Periodic pruning and promotion via `/learn --review`
4. **Promote** — Validated patterns move to the permanent patterns file
5. **Archive** — Completed feature notes move to the archive

**Using `/learn --review`:**

Run this periodically to clean up learnings. You'll be prompted to:
- Promote candidates that have proven reliable into permanent patterns
- Archive completed feature notes
- Remove duplicates
- Prune stale entries

Learnings are stored in `/memory/learnings/` and are kept lightweight — typically using only ~3% of context.

---

## Part 6: Troubleshooting

### Quick Diagnosis

| Symptom | Likely Cause | Quick Fix |
|---------|--------------|-----------|
| "Maximum clarification rounds reached" | Requirements too vague or conflicting | Simplify scope, provide direct answers |
| "QA validation failed" | Fundamental design issues | Review with tech lead |
| Unexpected output | Context confusion | Start fresh with `/spec` |

### Getting Help

If you encounter issues not covered here, see the full [Troubleshooting Guide](troubleshooting.md).

---

## Appendices

### Appendix A: Glossary

| Term | Definition |
|------|------------|
| **Acceptance Criteria** | Conditions that must be true for a requirement to be considered complete |
| **Blocker** | Something preventing progress until resolved |
| **Constitution** | Project rulebook containing standards all work must follow |
| **Clarification** | Process of asking questions to remove ambiguity from requirements |
| **Entity** | A type of data the system stores (User, Product, Order, etc.) |
| **Functional Requirement** | What the system must do (specific behavior) |
| **Handoff** | Package of information transferred to engineering for implementation |
| **Non-Functional Requirement** | How well the system must perform (speed, security, accessibility) |
| **P1/P2/P3** | Priority levels: Must have / Should have / Nice to have |
| **Phase** | Stage in workflow (Assess, Specify, Clarify, Plan, Tasks, Implement, Validate, Review) |
| **Specification (Spec)** | Written description of what a feature should do |
| **Track** | Workflow path based on feature complexity: Quick, Standard, or Enterprise |
| **User Scenario** | Story describing who does what and why (As a [user], I want [action], so that [benefit]) |

> For additional terms including Prism-specific concepts like Agent, Skill, Chain, and Orchestrator, see the [full Glossary](glossary.md).

### Appendix B: Quick Reference Card

**Commands:**

| Command | Purpose |
|---------|---------|
| `/constitution` | View or edit project rules |
| `/spec [description]` | Create feature specification |
| `/clarify` | Answer clarification questions |
| `/plan` | Generate implementation plan |
| `/tasks` | Create task breakdown |
| `/status` | Check current progress |
| `/handoff` | Create engineering package |

**Workflow:**

```
/constitution (once) → /spec → /clarify → /plan → /tasks → /handoff
```

**Priorities:**

| Level | Meaning | Action |
|-------|---------|--------|
| P1 | Must have | Include in release |
| P2 | Should have | Include if possible |
| P3 | Nice to have | Consider for future |

### Appendix C: Template Reference

Prism uses templates to structure output. The templates are located in `/templates/` and include:

- `spec-template.md` - Structure for specifications
- `plan-template.md` - Structure for implementation plans
- `tasks-template.md` - Structure for task breakdowns

You generally don't need to modify these, but knowing they exist helps you understand where the output structure comes from.

---

## Further Resources

- [Quick-Start Tutorial](quick-start.md) - Hands-on 30-minute guide
- [Command Reference](command-reference.md) - Complete syntax for all commands
- [Example Walkthrough](examples/user-auth-feature/README.md) - Complete feature example
- [Troubleshooting Guide](troubleshooting.md) - Common issues and solutions

---

*This guide covers Prism usage for PMs, POs, and business stakeholders. For technical documentation, see the developer guides in the `/docs/` directory.*
