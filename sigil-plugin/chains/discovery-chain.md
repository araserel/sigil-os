---
name: discovery-chain
description: Project initialization workflow for greenfield and scaffolded codebases. Captures problem, constraints, and stack decisions before constitution creation.
version: 1.1.0
track: discovery
entry_skill: codebase-assessment
---

# Chain: Discovery

## Overview

The Discovery chain guides new projects through structured initialization. It captures the problem statement, discovers constraints, recommends technology stacks, and produces a foundation document that feeds into constitution creation.

## When to Use

- New project with no existing code (greenfield)
- Project with minimal setup (scaffolded)
- User says "new project", "start fresh", "build something new"
- No constitution or project-context exists

## When NOT to Use

- Mature codebase with existing infrastructure (skip to standard workflow)
- Adding features to existing project (use full-pipeline)
- User explicitly says "skip discovery" or "I already have a setup"

## Chain Sequence

```
┌─────────────────────────┐
│  codebase-assessment    │ ← Entry point
└─────────────────────────┘
         │
         │ [Classification]
         ▼
    ┌────┴────┐
    │         │
    ▼         ▼
Greenfield  Scaffolded    Mature → Exit to standard workflow
    │         │
    └────┬────┘
         │
         ▼
┌─────────────────────────┐
│    problem-framing      │ ← Capture intent and preferences
└─────────────────────────┘
         │
         │ [Extract preferences, identify unknowns]
         ▼
┌─────────────────────────┐
│  constraint-discovery   │ ← Progressive questions
└─────────────────────────┘
         │
         │ [Complete constraints]
         ▼
┌─────────────────────────┐
│  stack-recommendation   │ ← Generate options
└─────────────────────────┘
         │
         │ [User selects stack]
         ▼
┌─────────────────────────┐
│   foundation-writer     │ ← Compile decisions
└─────────────────────────┘
         │
         │ [User approves]
         ▼
┌─────────────────────────┐
│  constitution-writer    │ ← Pre-populated from foundation
└─────────────────────────┘
         │
         ▼
      Complete → Ready for feature development
```

## Agent Assignment

All skills in the Discovery chain are driven by the **Orchestrator** agent. There is no dedicated Discovery agent — the Orchestrator manages the chain flow and invokes each skill in sequence.

| Skill | Driven By | Rationale |
|-------|-----------|-----------|
| `codebase-assessment` | Orchestrator | Entry point — Orchestrator detects Discovery trigger and invokes |
| `problem-framing` | Orchestrator | Conversational skill — Orchestrator manages user interaction |
| `constraint-discovery` | Orchestrator | Progressive questions — Orchestrator coordinates rounds |
| `stack-recommendation` | Orchestrator | Presents options — Orchestrator manages user selection |
| `foundation-writer` | Orchestrator | Compilation skill — Orchestrator passes accumulated state |
| `constitution-writer` | Orchestrator | Final step — Orchestrator invokes with foundation data |

## State Transitions

### codebase-assessment → problem-framing
**Trigger:** Classification is "greenfield" or "scaffolded"
**Condition:** User confirms classification
**Data Passed:**
```json
{
  "classification": "greenfield",
  "detected_stack": null,
  "recommended_track": "discovery-greenfield"
}
```

### codebase-assessment → Standard Workflow (Exit)
**Trigger:** Classification is "mature"
**Condition:** Codebase has established infrastructure
**Behavior:**
1. Check if `/.sigil/constitution.md` exists
2. **If constitution exists:** Route to `complexity-assessor` → `quick-flow` OR `full-pipeline` based on the user's request complexity
3. **If constitution missing:** Invoke `constitution-writer` first (mature codebases need a constitution too), then route to `complexity-assessor`

This ensures mature codebases aren't blocked from feature work but still get a constitution if they lack one.

### problem-framing → constraint-discovery
**Trigger:** Problem statement captured
**Condition:** User confirms understanding
**Data Passed:**
```json
{
  "problem_statement": {...},
  "extracted_preferences": {...},
  "known_skills": [...],
  "skip_questions": [...]
}
```

### constraint-discovery → stack-recommendation
**Trigger:** All constraints discovered
**Condition:** No blocking compatibility issues
**Data Passed:**
```json
{
  "constraints": {...},
  "extracted_preferences": {...},
  "known_skills": [...]
}
```

### stack-recommendation → foundation-writer
**Trigger:** User selects a stack
**Condition:** Explicit stack selection
**Data Passed:**
```json
{
  "selected_stack": {...},
  "alternatives_considered": [...],
  "problem_statement": {...},
  "constraints": {...}
}
```

### foundation-writer → constitution-writer
**Trigger:** User approves foundation document
**Condition:** Foundation status = "Approved"
**Data Passed:**
```json
{
  "foundation_path": "/.sigil/project-foundation.md",
  "pre_populated_constitution": {
    "article_1": {...}
  }
}
```

## Human Checkpoints

| Checkpoint | Tier | Description |
|------------|------|-------------|
| Classification confirmation | Review | User confirms codebase state |
| Problem understanding | Review | User confirms captured intent |
| Constraint questions | Auto | User answers questions |
| Stack selection | Approve | User chooses from options |
| Foundation approval | Approve | User approves before constitution |
| Constitution creation | Review | User reviews generated constitution |

## Variants

### Greenfield Variant

Full discovery flow for empty projects:

```
codebase-assessment (greenfield)
    → problem-framing (full)
    → constraint-discovery (all waves)
    → stack-recommendation (full comparison)
    → foundation-writer
    → constitution-writer
```

**Characteristics:**
- No detected stack to work from
- All questions asked (nothing pre-answered from codebase)
- Full stack comparison presented

### Scaffolded Variant

Abbreviated flow for partially setup projects:

```
codebase-assessment (scaffolded)
    → problem-framing (with detected preferences)
    → constraint-discovery (skip detected answers)
    → stack-recommendation (validate existing choice)
    → foundation-writer
    → constitution-writer
```

**Characteristics:**
- May have detected stack (e.g., package.json exists)
- Some questions pre-answered from codebase
- Stack recommendation may confirm existing choice

### User Override Variant

When user specifies track explicitly:

```
User: "Treat this as a new project"
    → Force greenfield flow regardless of signals

User: "I already have my stack figured out"
    → Skip to constraint-discovery, then foundation-writer
```

## Error Handling

### Conflicting Constraints

```
If constraint-discovery finds conflicts:
  1. Present conflict to user
  2. Offer resolution options
  3. Wait for user decision
  4. Continue with resolved constraints
```

### No Stack Match

```
If stack-recommendation finds no matches:
  1. Explain why no stacks match
  2. Offer to relax constraints
  3. Present closest options with caveats
  4. Allow user to specify custom stack
```

### User Rejects All Options

```
If user doesn't like any recommended stack:
  1. Ask what's missing
  2. Gather additional preferences
  3. Re-run stack-recommendation
  4. Or allow user to specify custom stack
```

### Classification Disagreement

```
If user disagrees with codebase classification:
  1. Accept user's classification
  2. Route to appropriate variant
  3. Document override in foundation
```

## Context Preservation

Throughout the chain, maintain:

```json
{
  "chain_id": "discovery-xxx-xxx",
  "classification": "greenfield | scaffolded",
  "problem_statement": {...},
  "extracted_preferences": {...},
  "known_skills": [...],
  "constraints": {...},
  "selected_stack": {...},
  "foundation_status": "draft | approved"
}
```

## Example Execution

```
User: "I want to build a task manager app"

1. codebase-assessment
   → Scans directory, finds empty
   → Classification: greenfield (HIGH confidence)
   → "This appears to be a new project. I'll guide you through discovery."

2. problem-framing
   → Extracts: task manager, web app implied, no tech preferences stated
   → "You want to build a task manager. Who will use this?"
   → User: "Just me, for personal use"
   → Captures: solo user, personal tool

3. constraint-discovery
   → Questions: budget, timeline, any specific requirements?
   → User: "Free tier, no rush, nothing special"
   → Captures: free budget, standard timeline, no compliance

4. stack-recommendation
   → Filters: web, free tier, solo
   → Presents: Next.js (recommended), React SPA, Django
   → User: "I'll go with Next.js"

5. foundation-writer
   → Compiles all decisions into project-foundation.md
   → "Here's your project foundation. Approve to continue?"
   → User: "Approved"

6. constitution-writer
   → Pre-populates stack from foundation (Round 1 auto-confirmed)
   → Asks project type in Round 2 (MVP/Production/Enterprise)
   → Optional preferences in Round 3
   → Auto-configures all technical details and creates constitution

7. Complete
   → "Discovery complete! You're ready to start building.
      What's the first feature you want to add?"
```

## Integration with Standard Workflow

After Discovery completes:

1. Foundation document exists at `/.sigil/project-foundation.md`
2. Constitution exists at `/.sigil/constitution.md`
3. Project context initialized at `/.sigil/project-context.md`
4. User can now use standard workflow:
   - `/sigil-spec` to create features
   - Full pipeline chain for implementation

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.1.0 | 2026-02-10 | Audit: Added agent assignment table, clarified mature codebase exit with constitution check |
| 1.0.0 | 2026-01-20 | Initial release |
