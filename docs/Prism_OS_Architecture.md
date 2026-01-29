# Prism OS Architecture

> A comprehensive guide to Prism OS system structure for use as Claude.ai project knowledge.

**Version:** 1.3.0  
**Last Updated:** 2026-01-28

---

## What is Prism OS?

Prism OS is a **specification-driven development framework** designed for non-technical users to direct AI-assisted software development. Instead of requiring users to understand code, file structures, or implementation details, Prism lets you describe *what* you want in plain language while the system handles *how* to build it.

**Primary Users:** Product Managers, Business Analysts, Project Managers  
**Secondary Users:** Developers wanting structured AI workflows

---

## Directory Structure

```
prism/                        # The distributable product
├── CLAUDE.md                 # Product brain (operational manual)
├── README.md                 # Quick start guide
│
├── .claude/                  # AI definitions
│   ├── agents/               # 9 core agents
│   ├── skills/               # 46 chainable skills
│   ├── chains/               # 4 workflow chains
│   ├── commands/             # 12 slash commands
│   └── reference/            # Stack patterns, ADRs
│
├── templates/                # Document templates
│   ├── spec-template.md      # Feature specifications
│   ├── plan-template.md      # Implementation plans
│   ├── tasks-template.md     # Task breakdowns
│   ├── constitution-template.md
│   └── prompts/              # Guided Q&A scripts
│
├── memory/                   # Persistent context
│   ├── constitution.md       # Project principles (immutable)
│   ├── project-context.md    # Current state
│   └── learnings/            # Institutional memory
│       ├── active/
│       │   ├── patterns.md   # Rules to follow
│       │   ├── gotchas.md    # Traps to avoid
│       │   └── decisions.md  # Key choices made
│       └── archived/         # Historical learnings
│
├── docs/                     # User documentation
│   ├── quick-start.md
│   ├── user-guide.md
│   ├── command-reference.md
│   └── extending-skills.md
│
└── specs/                    # Feature specifications (created per project)
    └── ###-feature-name/
        ├── spec.md
        ├── clarifications.md
        ├── plan.md
        └── tasks.md
```

---

## The 9 Core Agents

Prism uses 9 specialized AI agents, each with defined responsibilities and automatic routing based on trigger words.

### Agent Inventory

| Agent | Primary Role | Active Phases | Trigger Words |
|-------|--------------|---------------|---------------|
| **Orchestrator** | Central router, progress tracker | All | "help", "start", "status", "what should", "where are we" |
| **Business Analyst** | Requirements, specs, clarification | Specify, Clarify | "feature", "requirement", "spec", "I want", "we need" |
| **UI/UX Designer** | Component design, accessibility, UI frameworks | Design | "design", "UI", "UX", "component", "accessibility", "Figma" |
| **Architect** | Technical design, research, ADRs | Plan, Research | "architecture", "design", "how should", "technical" |
| **Task Planner** | Task breakdown, sprint planning | Tasks | "break down", "tasks", "sprint", "stories" |
| **Developer** | Code implementation, bug fixes | Implement | "implement", "build", "code", "fix", "bug" |
| **QA Engineer** | Validation, quality checks | Validate | "test", "validate", "check", "quality", "QA" |
| **Security** | Security review, OWASP checks | Review | "security", "vulnerability", "auth", "OWASP" |
| **DevOps** | Deployment, CI/CD, infrastructure | Review (deploy) | "deploy", "CI/CD", "pipeline", "release" |

### Agent Relationships

```
                         ORCHESTRATOR
                    (Routes all requests)
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
  BUSINESS ANALYST     UI/UX DESIGNER      ARCHITECT
  (Specs, Clarity)    (Design, A11y)    (Tech Design)
         │                   │                   │
         └───────────────────┼───────────────────┘
                             │
                             ▼
                       TASK PLANNER
                      (Tasks, Stories)
                             │
                             ▼
                        DEVELOPER
                    (Implementation)
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
    QA ENGINEER          SECURITY            DEVOPS
    (Validation)      (Security Review)   (Deployment)
```

### Agent File Format

Each agent is defined in `.claude/agents/[agent-name].md`:

```yaml
---
name: agent-name
description: Role summary
version: 1.0.0
tools: [Read, Write, Bash, ...]  # Permitted tools
active_phases: [Phase1, Phase2]
human_tier: Auto|Review|Approve
---

[System prompt defining behavior]

## Trigger Words
[Keywords for automatic routing]

## Skills Invoked
[Skills this agent can call]

## Handoff Protocol
[How to transition work to other agents]
```

---

## The 46 Skills

Skills are reusable, chainable workflow units. Each has defined inputs, outputs, and can invoke other skills.

### Skills by Category

#### Workflow Skills (13)
Core development pipeline operations:

| Skill | Purpose |
|-------|---------|
| `complexity-assessor` | Determine workflow track (Quick/Standard/Enterprise) |
| `spec-writer` | Generate feature specifications |
| `clarifier` | Reduce ambiguity through Q&A |
| `technical-planner` | Create implementation plans |
| `task-decomposer` | Break plans into executable tasks |
| `foundation-writer` | Compile Discovery track outputs |
| `constitution-writer` | Create project principles (v1.2.0: smart stack detection) |
| `visual-analyzer` | Analyze mockups/wireframes |
| `story-preparer` | Convert tasks to user story format |
| `sprint-planner` | Organize tasks into sprints |
| `status-reporter` | Generate workflow status reports |
| `handoff-packager` | Generate technical review packages |
| `preflight-check` | Verify install, inject enforcement rules (v1.3.0) |

#### Design Skills (6) — NEW v1.1.0
UI/UX design and accessibility:

| Skill | Purpose |
|-------|---------|
| `framework-selector` | Recommend UI framework based on platforms |
| `ux-patterns` | Define user flows and interaction patterns |
| `ui-designer` | Create component hierarchies and specifications |
| `accessibility` | Generate WCAG 2.1 accessibility requirements |
| `design-system-reader` | Analyze existing UI patterns |
| `figma-review` | Extract design tokens from Figma (requires MCP) |

#### UI Implementation Skills (6) — NEW v1.1.0
Framework-specific component generation:

| Skill | Purpose |
|-------|---------|
| `react-ui` | Generate React components |
| `react-native-ui` | Generate React Native components |
| `flutter-ui` | Generate Flutter widgets |
| `vue-ui` | Generate Vue 3 components |
| `swift-ui` | Generate SwiftUI views |
| `design-skill-creator` | Meta-skill to create new framework skills |

#### QA Skills (2)
Validation and fixing:

| Skill | Purpose |
|-------|---------|
| `qa-validator` | Run quality checks (tests, lint, requirements coverage) |
| `qa-fixer` | Attempt automated fixes for validation failures |

#### Review Skills (3)
Code and deployment review:

| Skill | Purpose |
|-------|---------|
| `code-reviewer` | Perform code review |
| `security-reviewer` | Security vulnerability assessment |
| `deploy-checker` | Deployment readiness validation |

#### Research Skills (6)
Information gathering:

| Skill | Purpose |
|-------|---------|
| `researcher` | Technical research and investigation |
| `codebase-assessment` | Analyze existing codebase state (v1.1.0: stack detection) |
| `problem-framing` | Capture problem statement for Discovery |
| `constraint-discovery` | Progressive constraint gathering |
| `stack-recommendation` | Generate tech stack options |
| `knowledge-search` | Search project knowledge base |

#### Learning Skills (3)
Institutional memory:

| Skill | Purpose |
|-------|---------|
| `learning-capture` | Record learnings after each task |
| `learning-reader` | Load relevant learnings before tasks |
| `learning-review` | Prune, promote, archive learnings |

#### Engineering Skills (1)
Technical documentation:

| Skill | Purpose |
|-------|---------|
| `adr-writer` | Create Architecture Decision Records |

### Skill File Format

Each skill is defined in `.claude/skills/[category]/[skill-name].md`:

```yaml
---
name: skill-name
description: Brief description
version: 1.0.0
category: workflow|qa|review|research|design|ui
chainable: true|false
invokes: [skills-this-calls]
invoked_by: [skills-that-call-this]
tools: Read, Write, Glob
inputs: [required_inputs]
outputs: [output_artifacts]
---

## Purpose
[What this skill accomplishes]

## When Invoked
[Trigger phrases and context]

## Workflow
[Step-by-step execution]

## Input Schema
[Required and optional inputs]

## Output Schema
[What gets produced]

## Human Tier
[Auto|Review|Approve]
```

---

## The 4 Workflow Tracks

Prism automatically selects the appropriate workflow depth based on request complexity.

### Track Comparison

| Track | Complexity Score | For | Phases |
|-------|-----------------|-----|--------|
| **Quick Flow** | 7-10 (Simple) | Bug fixes, small tweaks | Spec → Tasks → Implement → Validate |
| **Standard** | 4-6 (Medium) | Features, enhancements | Specify ↔ Clarify → Design → Plan → Tasks → Implement ↔ Validate → Review |
| **Enterprise** | 1-3 (Complex) | Architectural changes | Research → Specify ↔ Clarify → Design → Architecture → Plan → Tasks → Implement ↔ Validate → Review |
| **Discovery** | Greenfield | New projects | Assessment → Problem → Constraints → Options → Decision → Foundation |

### Workflow Chains

Chains orchestrate multi-skill workflows. Defined in `.claude/chains/`:

| Chain | File | Entry Skill |
|-------|------|-------------|
| Full Pipeline | `full-pipeline.md` | complexity-assessor |
| Quick Flow | `quick-flow.md` | complexity-assessor |
| Discovery | `discovery-chain.md` | codebase-assessment |
| Design | `design-chain.md` | framework-selector |

---

## The 12 Slash Commands

### Primary Command

**`/prism`** is the unified entry point:

| Usage | Effect |
|-------|--------|
| `/prism` | Run preflight check, show status, suggest next action |
| `/prism "description"` | Start building a feature |
| `/prism continue` | Resume where you left off |
| `/prism status` | Detailed workflow status |
| `/prism help` | Show available commands |

### All Commands

| Command | Purpose |
|---------|---------|
| `/spec` | Create new feature specification |
| `/clarify` | Start clarification Q&A |
| `/plan` | Generate implementation plan |
| `/tasks` | Break plan into tasks |
| `/validate` | Run QA validation |
| `/status` | Show workflow status |
| `/constitution` | View/edit project principles |
| `/learn` | View, search, or review learnings |
| `/prime` | Load project context for session |
| `/handoff` | Generate implementation package |
| `/design` | Start UI/UX design phase |

---

## Key Files and Their Roles

### Core Configuration

| File | Purpose | Update Frequency |
|------|---------|------------------|
| `CLAUDE.md` | Complete operational manual | Rarely (system changes) |
| `memory/constitution.md` | Immutable project principles | Once at setup |
| `memory/project-context.md` | Current project state | Per significant action |

### Learning System

| File | Purpose | Max Items |
|------|---------|-----------|
| `memory/learnings/active/patterns.md` | Validated rules to follow | 30 (~900 tokens) |
| `memory/learnings/active/gotchas.md` | Project-specific traps | 30 (~900 tokens) |
| `memory/learnings/active/decisions.md` | Architectural choices | 20 (~800 tokens) |

### Templates

| Template | Used For |
|----------|----------|
| `templates/spec-template.md` | Feature specifications |
| `templates/plan-template.md` | Implementation plans |
| `templates/tasks-template.md` | Task breakdowns |
| `templates/constitution-template.md` | Project principles |
| `templates/adr-template.md` | Architecture decisions |
| `templates/handoff-template.md` | Agent transitions |
| `templates/design-spec-template.md` | UI component specifications |

---

## Human Interaction: 3-Tier Model

Prism uses three tiers for human involvement:

| Tier | Behavior | When Used |
|------|----------|-----------|
| **Auto** | Agent acts immediately, logs action | Status queries, research, safe operations |
| **Review** | Agent acts, flags for async review | Spec drafts, plans, code review |
| **Approve** | Agent pauses until explicit approval | Production deploy, security changes, migrations |

### Tier by Action Type

| Action | Default Tier |
|--------|-------------|
| Status queries | Auto |
| Research tasks | Auto |
| Spec drafts | Review |
| Plan creation | Review |
| UI design specs | Review |
| Task breakdown (≤20) | Auto |
| Code implementation | Auto |
| Security review | Approve |
| Production deployment | Approve |

---

## Core Principles

The system is built on 7 principles:

1. **Spec-First Development** - Specifications before code
2. **Guided Decision-Making** - Technical choices presented with context
3. **Scale-Adaptive Tracks** - Right process for right size work
4. **Constitutional Boundaries** - Project rules enforced always
5. **Human-in-the-Loop, Not Human-in-the-Way** - Automate routine, pause for consequential
6. **Visible Progress** - Users can see where work stands
7. **Accessibility by Default** - WCAG 2.1 AA minimum for all output

---

## Recent Enhancements

### v1.1.0: UI/UX Designer Agent
- Added 9th core agent for design, accessibility, and UI framework selection
- 12 new skills (6 design, 6 UI implementation)
- Design phase added to Standard and Enterprise tracks

### v1.2.0: Smart Constitution
- `codebase-assessment` skill detects technology stack from manifests
- `constitution-writer` pre-populates Article 1 for established repos
- Supports: package.json, requirements.txt, Gemfile, go.mod, Cargo.toml, etc.

### v1.3.0: Preflight Check
- `/prism` runs Step 0 verification before any workflow
- Verifies global installation integrity
- Injects enforcement rules into project CLAUDE.md
- Self-healing: re-injects if enforcement section missing or outdated

---

## Source Attribution

Prism synthesizes patterns from 7 frameworks:

| Pattern | Source |
|---------|--------|
| Spec-First Development | spec-kit, agent-os |
| Constitutional Principles | spec-kit |
| Scale-Adaptive Tracks | BMAD-METHOD |
| 3-Tier Human Oversight | cc-dev-team-agents |
| QA Validation Loop | Auto-Claude |
| 9-Agent Team | cc-dev-team-agents (extended) |
| File-Based Persistence | BMAD-METHOD |
