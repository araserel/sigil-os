# Skills Directory

Contains reusable, chainable skill definitions organized by category.

## Categories

### workflow/
Core orchestration and handoff skills:
- `complexity-assessor.md` — Determine workflow track
- `constitution-writer.md` — Create project principles
- `clarifier.md` — Reduce ambiguity
- `handoff-packager.md` — Generate technical review packages
- `handoff-back.md` — Auto-update originating tickets after completion
- `status-reporter.md` — Generate workflow status reports
- `visual-analyzer.md` — Analyze mockups and wireframes
- `story-preparer.md` — Convert tasks to user story format
- `ticket-loader.md` — Load and categorize external tickets
- `specialist-selection.md` — Assign specialist agents to tasks
- `preflight-check.md` — Verify installation and enforcement
- `routing-rules/` — Reference skill for orchestrator routing logic

### specification/
Spec authoring skills:
- `spec-writer.md` — Generate feature specifications
- `quick-spec.md` — Rapid specification mode for Quick Flow

### engineering/
Technical implementation skills:
- `technical-planner.md` — Create implementation plans
- `task-decomposer.md` — Break plans into tasks
- `foundation-writer.md` — Compile Discovery outputs into foundation document
- `adr-writer.md` — Architecture Decision Records
- `commit-conventions.md` — Commit message conventions reference
- `test-generator.md` — Framework-agnostic test generation
- `database-migration.md` — Tool-agnostic migration generation
- `documentation-generator.md` — Code-analysis-based doc generation
- `refactoring-backend.md` — Structured backend refactoring
- `refactoring-frontend.md` — Structured frontend refactoring

### shared-protocols/
Reusable cross-skill protocols:
- `pre-execution-check.md` — Standardized project-context.md update protocol

### design/
UI/UX design and accessibility skills (invoked by UI/UX Designer agent):
- `framework-selector.md` — Recommend UI framework based on target platforms
- `ux-patterns.md` — Design user flows and interaction patterns
- `ui-designer.md` — Create component hierarchies and specifications
- `accessibility.md` — Generate WCAG 2.1 accessibility requirements
- `design-system-reader.md` — Analyze existing UI patterns in codebase
- `figma-review.md` — Extract design tokens from Figma (requires MCP)

### ui/
Framework-specific UI implementation skills (invoked by Developer agent):
- `react-ui.md` — Generate React components from design specs
- `react-native-ui.md` — Generate React Native components
- `flutter-ui.md` — Generate Flutter widgets
- `vue-ui.md` — Generate Vue 3 components
- `swift-ui.md` — Generate SwiftUI views
- `design-skill-creator.md` — Meta-skill to create new framework skills

### qa/
Validation and fixing skills:
- `qa-validator.md` — Run quality checks
- `qa-fixer.md` — Fix validation failures
- `qa-escalation-policy.md` — Escalation rules for validation failures

### review/
Code and deployment review skills:
- `code-reviewer.md` — Code review
- `security-reviewer.md` — Security review
- `deploy-checker.md` — Deployment readiness

### research/
Information gathering and Discovery skills:
- `researcher.md` — Technical research
- `codebase-assessment.md` — Analyze codebase state for Discovery
- `problem-framing.md` — Capture problem statement and user preferences
- `constraint-discovery.md` — Progressive constraint gathering
- `stack-recommendation.md` — Generate technology stack options
- `knowledge-search.md` — Search project knowledge base

### learning/
Institutional memory and learning loop skills:
- `learning-capture.md` — Record learnings after task completion
- `learning-reader.md` — Load relevant learnings before tasks
- `learning-review.md` — Prune, promote, and archive learnings

### shared-context/
Cross-project sync skills:
- `shared-context-sync/` — Push/pull learnings and profiles via GitHub MCP
- `connect-wizard/` — Interactive setup for shared context connection
- `profile-generator/` — Auto-detect tech stack and generate project profile

## Skill Definition Format

Each skill file follows this structure:

```markdown
---
name: skill-name
description: What this skill does
version: 1.0.0
category: workflow|specification|engineering|design|ui|qa|review|research|learning|shared-context|integration
chainable: true|false
invokes: [skills this may call]
invoked_by: [skills that may call this]
tools: [tools this skill uses]
inputs: [required inputs]
outputs: [produced outputs]
model: haiku|sonnet  # Optional — request a specific model for this skill
---

# Skill: [Name]

## Purpose
[What this skill accomplishes]

## When Invoked
[Trigger conditions]

## Inputs
[Required and optional inputs with types]

## Process
[Step-by-step execution]

## Outputs
[Artifacts and handoff data produced]

## Human Checkpoints
[Where human approval is needed]

## Version History
[Changelog of skill versions]
```

## Versioning

All skills use semantic versioning (MAJOR.MINOR.PATCH):

| Change | Version Bump |
|--------|--------------|
| Breaking input/output change | MAJOR |
| New capability (backward compatible) | MINOR |
| Bug fix, documentation | PATCH |

Current versions: Most skills at **v1.0.0** (initial release). Several have been bumped by cross-cutting specs and Stage 2 features. See `/docs/dev/versioning.md` for the full version table.

See `/docs/dev/versioning.md` for detailed versioning strategy.

## Model Selection

The optional `model` frontmatter field requests a specific model tier for skill execution. Use it when a skill's workload doesn't require the default model:

| Value | When to Use | Examples |
|-------|-------------|---------|
| `haiku` | Lightweight read/write, file loading, simple classification | learning-reader, learning-capture, shared-context-sync |
| `sonnet` | Moderate analysis, interactive wizards, structured generation | learning-review, connect-wizard, profile-generator |
| *(omitted)* | Default model — complex reasoning, planning, code generation | Most skills |

Only add `model` when there's a clear cost/speed benefit. When in doubt, omit it and use the default.

## Creating New Skills

See `/docs/extending-skills.md` for detailed guidance on creating new skills.
