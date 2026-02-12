---
name: foundation-writer
description: Compiles discovery outputs into a project-foundation.md document. Captures one-time decisions that inform the constitution and all subsequent development.
version: 1.0.0
category: workflow
chainable: true
invokes: [constitution-writer]
invoked_by: [stack-recommendation]
tools: Read, Write, Edit, Glob
---

# Skill: Foundation Writer

## Purpose

Compile all Discovery phase outputs into a comprehensive project-foundation.md document. This document captures the one-time decisions made during project initialization and serves as the source of truth for constitution creation.

## When to Invoke

- After user selects a stack from stack-recommendation
- When completing the Discovery chain
- User requests `/foundation` to view or update foundation document

## Inputs

**Required:**
- `problem_statement`: object — From problem-framing
- `constraints`: object — From constraint-discovery
- `selected_stack`: object — User's chosen stack from stack-recommendation
- `alternatives_considered`: object[] — Other stacks that were presented

**From Previous Steps:**
- `extracted_preferences`: object — Technology preferences captured
- `known_skills`: string[] — User's technical skills
- `skip_questions`: string[] — Questions that were pre-answered

**Optional:**
- `project_name`: string — If user specified a project name
- `additional_notes`: string — Any extra context from the conversation

## Process

### Step 1: Load Template

```
1. Load template from /templates/project-foundation.md
2. Verify all required sections exist
3. Prepare for population
```

### Step 2: Populate Problem Statement

Fill the Problem Statement section:

```markdown
## Problem Statement

### What We're Building

[problem_statement.description]

### Target Users

- **Primary:** [problem_statement.target_users.primary]
- **Secondary:** [problem_statement.target_users.secondary or "None identified"]

### Core Value Proposition

[problem_statement.core_value]

### Success Metrics

- [problem_statement.success_metrics[0]]
- [problem_statement.success_metrics[1]]
```

### Step 3: Populate Constraints

Fill the Constraints section:

```markdown
## Constraints

### Critical Constraints

| Constraint | Value | Impact |
|------------|-------|--------|
| **Platform** | [constraints.critical.platform] | Determines stack options |
| **Budget** | [constraints.critical.budget] | Limits hosting and services |
| **Timeline** | [constraints.expanded.timeline or "Standard"] | Affects complexity tolerance |
| **Team Size** | [constraints.expanded.team_size or "Solo"] | Influences architecture |

### Expanded Constraints

#### Technical Constraints

- **Deployment Environment:** [constraints.expanded.deployment_preference or "To be determined"]
- **Performance Requirements:** [constraints.technical.performance or "Standard"]
- **Integration Requirements:** [constraints.technical.integrations or "None"]
- **Offline Requirements:** [constraints.expanded.offline or "No"]

#### Business Constraints

- **Compliance Requirements:** [constraints.expanded.compliance or "None"]
- **Data Residency:** [constraints.technical.data_residency or "No restrictions"]

#### Team Constraints

- **Known Skills:** [known_skills.join(", ")]
- **Learning Budget:** [Inferred from timeline and skills]
```

### Step 4: Populate Technology Stack

Fill the Technology Stack section:

```markdown
## Technology Stack

### Selected Stack

> **Pattern:** [selected_stack.pattern]

| Layer | Technology | Version | Rationale |
|-------|------------|---------|-----------|
| **Language** | [selected_stack.language] | [version] | [rationale] |
| **Framework** | [selected_stack.framework] | [version] | [rationale] |
| **Database** | [selected_stack.database] | [version] | [rationale] |
| **ORM** | [selected_stack.orm] | [version] | [rationale] |
| **Hosting** | [selected_stack.hosting] | — | [rationale] |

### Alternatives Considered

| Stack | Why Not Selected |
|-------|------------------|
| [alternative_1.name] | [alternative_1.trade_off] |
| [alternative_2.name] | [alternative_2.trade_off] |
```

### Step 5: Document Preferences

Fill the Preferences Captured section:

```markdown
## Preferences Captured

### Explicit Preferences

[List preferences user stated directly]

### Inferred Preferences

[List preferences inferred from context]

### Things NOT Asked

[List questions that were skipped because they were already answered]
```

### Step 6: Set Metadata

```markdown
# Project Foundation: [project_name or "Untitled Project"]

> **Created:** [current date]
> **Status:** Draft
> **Discovery Track:** [Greenfield | Scaffolded]
```

### Step 7: Write Foundation Document

```
1. Create /.sigil/ directory if not exists
2. Write to /.sigil/project-foundation.md
3. Return path for confirmation
```

### Step 8: Present for Approval

Show summary and request approval:

```markdown
## Foundation Document Created

I've compiled your project foundation at `/.sigil/project-foundation.md`.

### Summary

**Project:** [project_name]
**Stack:** [selected_stack.name]
**Platform:** [constraints.critical.platform]
**Budget:** [constraints.critical.budget]

### Key Decisions Recorded

1. [Decision 1 - e.g., "Using Next.js for fullstack development"]
2. [Decision 2 - e.g., "PostgreSQL as primary database"]
3. [Decision 3 - e.g., "Free tier deployment on Vercel"]

### Next Steps

Once you approve this foundation:
1. I'll generate your project constitution from these decisions
2. Article 1 (Technology Stack) will be pre-populated
3. You can then start building features

**Approve this foundation?** (Yes / Let me review / Make changes)
```

## Outputs

**Artifact:**
- `/.sigil/project-foundation.md` — Complete foundation document

**Handoff Data:**
```json
{
  "foundation_path": "/.sigil/project-foundation.md",
  "foundation_status": "draft",
  "awaiting_approval": true,
  "pre_populated_constitution": {
    "article_1": {
      "language": "TypeScript",
      "framework": "Next.js",
      "database": "PostgreSQL"
    }
  },
  "next_skill": "constitution-writer"
}
```

## Foundation Quality Checklist

Before presenting for approval:

- [ ] Problem statement clearly describes what and why
- [ ] All critical constraints are documented
- [ ] Selected stack matches constraints
- [ ] Alternatives are listed with trade-offs
- [ ] Preferences captured accurately
- [ ] No contradictions in document
- [ ] Metadata is complete

## Human Checkpoints

- **Approve Tier:** Foundation document requires explicit user approval
- User can request changes before approval
- Approval triggers constitution generation

## Post-Approval Actions

When user approves foundation:

```
1. Update foundation status to "Approved"
2. Add approval timestamp
3. Trigger constitution-writer skill
4. Pass pre-populated constitution data
```

## Error Handling

| Error | Resolution |
|-------|------------|
| Missing problem statement | Ask user to describe project again |
| Missing constraints | Run constraint-discovery first |
| No stack selected | Return to stack-recommendation |
| Template not found | Use embedded fallback template |
| Write permission denied | Ask user to create /.sigil/ directory |

## Integration Points

- **Invoked by:** `stack-recommendation` after user selection
- **Invokes:** `constitution-writer` after approval
- **Passes:** Pre-populated constitution data

## Example Foundation

```markdown
# Project Foundation: TaskFlow

> **Created:** 2026-01-20
> **Status:** Approved
> **Discovery Track:** Greenfield

---

## Problem Statement

### What We're Building

A personal task management application that helps individuals track their daily tasks, set priorities, and maintain focus on what matters most.

### Target Users

- **Primary:** Individual professionals who want simple task tracking
- **Secondary:** Students managing coursework and deadlines

### Core Value Proposition

Simple, distraction-free task management without the complexity of enterprise tools.

### Success Metrics

- Users can create and complete tasks in under 10 seconds
- 80% of users return within a week

---

## Constraints

### Critical Constraints

| Constraint | Value | Impact |
|------------|-------|--------|
| **Platform** | Web | Browser-based SPA |
| **Budget** | Free tier | Vercel, Supabase free tiers |
| **Timeline** | Standard | 2-4 weeks MVP |
| **Team Size** | Solo | Single developer |

### Expanded Constraints

#### Technical
- **Offline:** No (always online)
- **Real-time:** No (standard refresh)
- **Performance:** Standard web app expectations

#### Business
- **Compliance:** None required
- **Data residency:** No restrictions

#### Team
- **Known Skills:** React, JavaScript
- **Learning Budget:** Moderate (willing to learn TypeScript)

---

## Technology Stack

### Selected Stack

> **Pattern:** fullstack-nextjs

| Layer | Technology | Version | Rationale |
|-------|------------|---------|-----------|
| **Language** | TypeScript | 5.x | Type safety, builds on JS knowledge |
| **Framework** | Next.js | 14.x | React-based, excellent DX |
| **Database** | PostgreSQL | 15+ | Reliable, Supabase free tier |
| **ORM** | Prisma | Latest | Type-safe, great DX |
| **Hosting** | Vercel | — | Free tier, Next.js optimized |

### Alternatives Considered

| Stack | Why Not Selected |
|-------|------------------|
| React SPA + Express | More setup complexity for solo project |
| Django | Would require learning Python |

---

## Preferences Captured

### Explicit
- "I want to use React" → Selected Next.js (React-based)
- "No paid services" → Chose free tier stack

### Inferred
- JavaScript experience → TypeScript recommended
- Solo project → Chose simpler architecture

### Not Asked
- Framework (React preference captured)
- Budget (stated "no paid services")
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
