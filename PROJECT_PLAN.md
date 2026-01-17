# Prism OS Implementation Plan

> Roadmap for building the Prism OS AI Development Operating System

---

## Overview

| Phase | Name | Status | Key Deliverables |
|-------|------|--------|------------------|
| 1 | Foundation | ✓ Complete | Constitution, project structure, base CLAUDE.md |
| 2 | Core Workflow | ✓ Complete | Skills, templates, guided prompts, skill chains |
| 3 | Agents | ✓ Complete | 8 agent definitions, routing, handoffs |
| 4 | Quality & Review | ✓ Complete | QA skills, review pipeline, validation loops, handoff-packager |
| 5 | Integration & Polish | Pending | MCP points, context persistence, skill extension docs |
| 6 | Documentation | Pending | User guide, tutorials, troubleshooting |
| 7 | Validation | Pending | End-to-end testing, refinement |

> **Note:** Progress is gated by human decisions, not calendar time. Each phase completes when its Review Gate passes.
>
> **Current Status:** Phases 1-4 complete. Ready to begin Phase 5 (Integration & Polish).

---

## Phase 1: Foundation ✓ COMPLETE

**Objective:** Establish project structure, constitutional framework, and base configuration.

### Task 1.1: Create Project Directory Structure ✓

**Description:** Set up the standardized directory layout for Prism OS.

**Subtasks:**
- [x] 1.1.1: Create `.claude/` directory for Claude Code configuration
- [x] 1.1.2: Create `.claude/agents/` directory for agent definitions
- [x] 1.1.3: Create `.claude/skills/` directory structure (workflow/, engineering/, quality/, research/)
- [x] 1.1.4: Create `.claude/chains/` directory for skill chain definitions
- [x] 1.1.5: Create `/memory/` directory for persistent context files
- [x] 1.1.6: Create `/specs/` directory for feature specifications
- [x] 1.1.7: Create `/templates/` directory structure (including prompts/)
- [x] 1.1.8: Create `/docs/` directory for documentation

**Acceptance Criteria:**
- [x] All directories exist with appropriate `.gitkeep` files
- [x] Directory structure matches CLAUDE.md specification
- [x] README.md in each major directory explaining its purpose

---

### Task 1.2: Create Constitution Template ✓

**Description:** Build the project constitution template that defines immutable project principles.

**Subtasks:**
- [x] 1.2.1: Create `/templates/constitution-template.md` with all 7 articles
- [x] 1.2.2: Add guidance comments explaining each article's purpose
- [x] 1.2.3: Include example values for common technology stacks
- [x] 1.2.4: Create `/memory/constitution.md` as the active constitution location

**Acceptance Criteria:**
- [x] Template covers: Technology Stack, Code Standards, Testing Requirements, Security Mandates, Architecture Principles, Approval Requirements
- [x] Each article has clear instructions for customization
- [x] Example values provided for TypeScript/React and Python/FastAPI stacks

---

### Task 1.3: Create Constitution Writer Skill ✓

**Description:** Build the skill that helps users create their project constitution through guided conversation.

**Subtasks:**
- [x] 1.3.1: Create `.claude/skills/workflow/constitution-writer.md`
- [x] 1.3.2: Define skill metadata (name, description, tools, chainable)
- [x] 1.3.3: Write system prompt for constitution creation guidance
- [x] 1.3.4: Define input contract (project name, optional tech preferences)
- [x] 1.3.5: Define output contract (constitution.md path)
- [x] 1.3.6: Add conversational prompts for each article

**Acceptance Criteria:**
- [x] Skill follows standard skill definition format
- [x] Can be invoked via `/constitution` command
- [x] Produces valid constitution.md in /memory/
- [x] Guides non-technical users through each article

---

### Task 1.4: Create Base CLAUDE.md Configuration ✓

**Description:** Set up the foundational CLAUDE.md with project context and basic routing.

**Subtasks:**
- [x] 1.4.1: Create initial CLAUDE.md with Purpose & Audience section
- [x] 1.4.2: Add Core Principles section (placeholder for full content)
- [x] 1.4.3: Add basic slash command definitions
- [x] 1.4.4: Add constitution reference and loading instructions
- [x] 1.4.5: Add project context loading from /memory/project-context.md

**DECISION:** Option A selected — Single file (simpler, all context in one place)

**Acceptance Criteria:**
- [x] Claude Code recognizes and loads CLAUDE.md on session start
- [x] Constitution is referenced and respected
- [x] Basic routing to Orchestrator works

---

### Task 1.5: Create Project Context Template ✓

**Description:** Build the template for tracking current project state across sessions.

**Subtasks:**
- [x] 1.5.1: Create `/templates/project-context-template.md`
- [x] 1.5.2: Include sections: Current Feature, Phase, Recent Activity, Open Decisions
- [x] 1.5.3: Create `/memory/project-context.md` as active location
- [x] 1.5.4: Document auto-update triggers and format

**Acceptance Criteria:**
- [x] Template captures all state needed for session continuity
- [x] Format is parseable by agents for context loading
- [x] Manual and auto-update paths defined

---

### Phase 1 Review Gate ✓ PASSED

**Definition of Done:**
- [x] All directories created and documented
- [x] Constitution template complete with examples
- [x] Constitution writer skill functional
- [x] Base CLAUDE.md loads correctly
- [x] Project context template ready
- [x] Manual test: Create a new project constitution using the skill

**Deliverables:**
- [x] `/templates/constitution-template.md`
- [x] `/memory/constitution.md` (sample)
- [x] `.claude/skills/workflow/constitution-writer.md`
- [x] `/templates/project-context-template.md`
- [x] `CLAUDE.md` (base version)

---

## Phase 2: Core Workflow ✓ COMPLETE

**Objective:** Build the core workflow skills, templates, and guided prompts that enable spec-driven development.

### Task 2.1: Create Spec Template ✓

**Description:** Build the feature specification template with core and optional sections.

**Subtasks:**
- [x] 2.1.1: Create `/templates/spec-template.md` with core sections
- [x] 2.1.2: Add Summary, User Scenarios (P1/P2/P3), Requirements table
- [x] 2.1.3: Add Key Entities, Success Criteria, Out of Scope sections
- [x] 2.1.4: Add optional extended sections (Technical Constraints, Dependencies, Security, Visuals)
- [x] 2.1.5: Include inline guidance comments

**Acceptance Criteria:**
- [x] Core sections fillable in <10 minutes
- [x] Extended sections clearly marked as optional
- [x] Consistent with CLAUDE.md specification

---

### Task 2.2: Create Spec Writer Skill ✓

**Description:** Build the skill that generates specifications from natural language descriptions.

**Subtasks:**
- [x] 2.2.1: Create `.claude/skills/workflow/spec-writer.md`
- [x] 2.2.2: Define skill metadata and tool permissions
- [x] 2.2.3: Write system prompt for spec generation
- [x] 2.2.4: Define input contract per SKILLS-ANALYSIS.md
- [x] 2.2.5: Define output contract (spec.md path, ambiguity flags, handoff data)
- [x] 2.2.6: Add constitution reference checking
- [x] 2.2.7: Add visual asset analysis capability (if images provided)
- [x] 2.2.8: Implement feature numbering (###-feature-name pattern)

**Acceptance Criteria:**
- [x] Skill produces valid spec.md from description
- [x] References constitution for constraints
- [x] Identifies ambiguities and flags them
- [x] Creates properly numbered feature directory

---

### Task 2.3: Create Clarifier Skill ✓

**Description:** Build the skill that reduces specification ambiguity through structured Q&A.

**Subtasks:**
- [x] 2.3.1: Create `.claude/skills/workflow/clarifier.md`
- [x] 2.3.2: Define skill metadata with iteration tracking
- [x] 2.3.3: Write system prompt for clarification questioning
- [x] 2.3.4: Define input contract (spec path, ambiguity flags, iteration count)
- [x] 2.3.5: Define output contract (clarifications.md path, resolution status)
- [x] 2.3.6: Implement question categorization (scope, behavior, edge cases, etc.)
- [x] 2.3.7: Implement max 3 iteration limit with escalation

**Acceptance Criteria:**
- [x] Generates targeted questions for flagged ambiguities
- [x] Tracks question/answer pairs in clarifications.md
- [x] Respects iteration limits
- [x] Updates spec with resolved clarifications

---

### Task 2.4: Create Plan Template ✓

**Description:** Build the implementation plan template.

**Subtasks:**
- [x] 2.4.1: Create `/templates/plan-template.md`
- [x] 2.4.2: Add Technical Context section (language, framework, dependencies)
- [x] 2.4.3: Add Constitution Gate Checks section
- [x] 2.4.4: Add Project Structure Changes section
- [x] 2.4.5: Add Risk Assessment section
- [x] 2.4.6: Add optional API Contracts and Data Model sections

**Acceptance Criteria:**
- [x] Template covers all planning needs
- [x] Gate checks reference constitution articles
- [x] Risk levels clearly defined

---

### Task 2.5: Create Technical Planner Skill ✓

**Description:** Build the skill that generates implementation plans from clarified specs.

**Subtasks:**
- [x] 2.5.1: Create `.claude/skills/workflow/technical-planner.md`
- [x] 2.5.2: Define skill metadata and tool permissions
- [x] 2.5.3: Write system prompt for technical planning
- [x] 2.5.4: Define input contract per SKILLS-ANALYSIS.md
- [x] 2.5.5: Define output contract (plan.md, optional research.md, data-model.md)
- [x] 2.5.6: Implement constitution gate checking
- [x] 2.5.7: Add complexity estimation output
- [x] 2.5.8: Integrate with researcher skill (parallel invocation)

**Acceptance Criteria:**
- [x] Produces comprehensive plan.md from spec
- [x] Validates against constitution gates
- [x] Identifies files to modify/create
- [x] Flags ADR-worthy decisions

---

### Task 2.6: Create Tasks Template ✓

**Description:** Build the task breakdown template.

**Subtasks:**
- [x] 2.6.1: Create `/templates/tasks-template.md`
- [x] 2.6.2: Add phase structure (Setup, Foundation, Feature, Testing)
- [x] 2.6.3: Add task ID format (T001, T002...)
- [x] 2.6.4: Add parallelization markers ([P])
- [x] 2.6.5: Add dependency notation
- [x] 2.6.6: Add test-first markers

**Acceptance Criteria:**
- [x] Template supports all task metadata
- [x] Parallelization clearly indicated
- [x] Dependencies trackable

---

### Task 2.7: Create Task Decomposer Skill ✓

**Description:** Build the skill that breaks plans into executable tasks.

**Subtasks:**
- [x] 2.7.1: Create `.claude/skills/workflow/task-decomposer.md`
- [x] 2.7.2: Define skill metadata and tool permissions
- [x] 2.7.3: Write system prompt for task decomposition
- [x] 2.7.4: Define input contract per SKILLS-ANALYSIS.md
- [x] 2.7.5: Define output contract (tasks.md, task count, blocking tasks)
- [x] 2.7.6: Implement >20 task threshold for human review
- [x] 2.7.7: Identify parallelization opportunities
- [x] 2.7.8: Generate first task detail for immediate handoff

**Acceptance Criteria:**
- [x] Produces valid tasks.md from plan
- [x] Tasks properly sequenced with dependencies
- [x] Parallelization opportunities identified
- [x] Threshold alerts work correctly

---

### Task 2.8: Create Complexity Assessor Skill ✓

**Description:** Build the skill that determines the appropriate workflow track.

**Subtasks:**
- [x] 2.8.1: Create `.claude/skills/workflow/complexity-assessor.md`
- [x] 2.8.2: Define assessment criteria (scope, risk, unknowns, affected systems)
- [x] 2.8.3: Implement track recommendation (Quick/Standard/Enterprise)
- [x] 2.8.4: Add override capability for user to select different track
- [x] 2.8.5: Document assessment rationale in output

**Acceptance Criteria:**
- [x] Accurately categorizes requests by complexity
- [x] Provides clear rationale for recommendation
- [x] Supports user override

---

### Task 2.9: Create Researcher Skill ✓

**Description:** Build the skill for technical research and investigation.

**Subtasks:**
- [x] 2.9.1: Create `.claude/skills/research/researcher.md`
- [x] 2.9.2: Define research scope parameters
- [x] 2.9.3: Implement internal codebase search
- [x] 2.9.4: Implement external documentation lookup (WebFetch, WebSearch)
- [x] 2.9.5: Define output format (research.md)
- [x] 2.9.6: Add source attribution requirements

**Acceptance Criteria:**
- [x] Can research both internal code and external docs
- [x] Produces structured research.md
- [x] Sources properly attributed

---

### Task 2.10: Create ADR Template and Skill ✓

**Description:** Build Architecture Decision Record template and writer skill.

**Subtasks:**
- [x] 2.10.1: Create `/templates/adr-template.md`
- [x] 2.10.2: Include Context, Decision, Consequences, Alternatives sections
- [x] 2.10.3: Create `.claude/skills/engineering/adr-writer.md`
- [x] 2.10.4: Implement ADR numbering (ADR-001, ADR-002...)
- [x] 2.10.5: Add decision categorization (architecture, technology, process)

**Acceptance Criteria:**
- [x] ADR template follows standard format
- [x] ADRs properly numbered and categorized
- [x] Skill produces valid ADRs from planning decisions

---

### Task 2.11: Create Guided Prompts for Templates ✓

**Description:** Build conversational prompt scripts that help non-technical users fill out templates.

**Subtasks:**
- [x] 2.11.1: Create `/templates/prompts/` directory
- [x] 2.11.2: Create `spec-prompts.md` with questions for spec creation
- [x] 2.11.3: Create `plan-prompts.md` with questions for planning
- [x] 2.11.4: Create `clarify-prompts.md` with clarification question templates
- [x] 2.11.5: Create `constitution-prompts.md` with setup questions
- [x] 2.11.6: Ensure all prompts use plain language suitable for PMs/POs
- [x] 2.11.7: Include example answers for each prompt

**DECISION:** Option A selected — Skills load prompts dynamically when entering conversational mode

**Acceptance Criteria:**
- [x] Prompts exist for all major templates
- [x] Language is non-technical and accessible
- [x] Example answers demonstrate expected format
- [x] Integration path with skills documented

---

### Task 2.12: Define Core Skill Chain ✓

**Description:** Wire up the Specify → Clarify → Plan → Tasks skill chain.

**Subtasks:**
- [x] 2.12.1: Create `.claude/chains/full-pipeline.md` with chain definition
- [x] 2.12.2: Define handoff data format between each skill
- [x] 2.12.3: Implement chain state tracking
- [x] 2.12.4: Create `.claude/chains/quick-flow.md` for simplified chain
- [x] 2.12.5: Document chain invocation patterns

**Acceptance Criteria:**
- [x] Full pipeline chain executes end-to-end
- [x] Quick flow chain works for simple requests
- [x] State properly passed between skills
- [x] Human checkpoints respected

---

### Phase 2 Review Gate ✓ PASSED

**Definition of Done:**
- [x] All templates created and documented
- [x] All 7 core workflow skills functional
- [x] Guided prompts complete for all templates
- [x] Full pipeline and quick flow chains defined
- [x] Manual test: Create spec → clarify → plan → tasks for a sample feature
- [x] Non-technical user can complete guided prompt flow

**Deliverables:**
- [x] `/templates/spec-template.md`
- [x] `/templates/plan-template.md`
- [x] `/templates/tasks-template.md`
- [x] `/templates/adr-template.md`
- [x] `/templates/prompts/` (all prompt files)
- [x] `.claude/skills/workflow/` (all workflow skills)
- [x] `.claude/skills/research/researcher.md`
- [x] `.claude/skills/engineering/adr-writer.md`
- [x] `.claude/chains/full-pipeline.md`
- [x] `.claude/chains/quick-flow.md`

---

## Phase 3: Agents ✓ COMPLETE

**Objective:** Create the 8 core agent definitions with routing, delegation, and handoff protocols.

> **Note:** Agent names were refined during implementation:
> - "Product Owner" → "Business Analyst" (better reflects spec/requirements focus)
> - "Scrum Master" → "Task Planner" (more descriptive of actual function)

### Task 3.1: Create Orchestrator Agent ✓

**Description:** Build the central routing and coordination agent.

**Subtasks:**
- [x] 3.1.1: Create `.claude/agents/orchestrator.md`
- [x] 3.1.2: Define agent metadata (name, description, tools)
- [x] 3.1.3: Write system prompt for request analysis and routing
- [x] 3.1.4: Implement trigger word matching logic
- [x] 3.1.5: Define delegation protocol to other agents
- [x] 3.1.6: Implement workflow state tracking
- [x] 3.1.7: Add status reporting capability
- [x] 3.1.8: Define escalation triggers and paths
- [x] 3.1.9: Add engineer handoff triggers and handoff-packager skill invocation

**Acceptance Criteria:**
- [x] Orchestrator correctly routes requests based on keywords
- [x] Maintains workflow state across interactions
- [x] Provides clear status updates
- [x] Escalates appropriately when blocked

---

### Task 3.2: Create Business Analyst Agent ✓

**Description:** Build the agent responsible for requirements and specifications.

**Subtasks:**
- [x] 3.2.1: Create `.claude/agents/business-analyst.md`
- [x] 3.2.2: Define agent metadata and tool permissions
- [x] 3.2.3: Write system prompt emphasizing user advocacy and clarity
- [x] 3.2.4: Define trigger words (feature, requirement, user story, spec)
- [x] 3.2.5: Link to spec-writer, clarifier, visual-analyzer skills
- [x] 3.2.6: Define handoff protocol to Architect

**Acceptance Criteria:**
- [x] Agent invokes correct skills for spec creation
- [x] Drives clarification until ambiguities resolved
- [x] Produces complete handoff to Architect

---

### Task 3.3: Create Architect Agent ✓

**Description:** Build the agent responsible for technical design and planning.

**Subtasks:**
- [x] 3.3.1: Create `.claude/agents/architect.md`
- [x] 3.3.2: Define agent metadata and expanded tool permissions
- [x] 3.3.3: Write system prompt emphasizing pragmatic design
- [x] 3.3.4: Define trigger words (architecture, design, approach, technical)
- [x] 3.3.5: Link to technical-planner, researcher, adr-writer skills
- [x] 3.3.6: Define handoff protocol to Task Planner

**Acceptance Criteria:**
- [x] Agent produces sound technical plans
- [x] Documents significant decisions as ADRs
- [x] Validates against constitution gates

---

### Task 3.4: Create Task Planner Agent ✓

**Description:** Build the agent responsible for task breakdown and sprint coordination.

**Subtasks:**
- [x] 3.4.1: Create `.claude/agents/task-planner.md`
- [x] 3.4.2: Define agent metadata and tool permissions
- [x] 3.4.3: Write system prompt emphasizing organization and tracking
- [x] 3.4.4: Define trigger words (break down, tasks, sprint, stories)
- [x] 3.4.5: Link to task-decomposer, story-preparer, sprint-planner skills
- [x] 3.4.6: Define handoff protocol to Developer

**Acceptance Criteria:**
- [x] Agent produces well-organized task breakdowns
- [x] Identifies dependencies and parallelization
- [x] Prepares clear handoffs to Developer

---

### Task 3.5: Create Developer Agent ✓

**Description:** Build the agent responsible for code implementation.

**Subtasks:**
- [x] 3.5.1: Create `.claude/agents/developer.md`
- [x] 3.5.2: Define agent metadata with full code tools
- [x] 3.5.3: Write system prompt emphasizing clean, tested code
- [x] 3.5.4: Define trigger words (implement, build, code, fix)
- [x] 3.5.5: Implement test-first workflow (tests fail → implement → tests pass)
- [x] 3.5.6: Define handoff protocol to QA Engineer

**Acceptance Criteria:**
- [x] Agent follows test-first pattern
- [x] Produces code meeting constitution standards
- [x] Properly marks tasks complete

---

### Task 3.6: Create QA Engineer Agent ✓

**Description:** Build the agent responsible for validation and quality assurance.

**Subtasks:**
- [x] 3.6.1: Create `.claude/agents/qa-engineer.md`
- [x] 3.6.2: Define agent metadata and tool permissions
- [x] 3.6.3: Write system prompt emphasizing thorough validation
- [x] 3.6.4: Define trigger words (test, validate, check, quality)
- [x] 3.6.5: Link to qa-validator, qa-fixer skills
- [x] 3.6.6: Implement validation loop with max iterations
- [x] 3.6.7: Define escalation path when fixes fail

**Acceptance Criteria:**
- [x] Agent runs comprehensive quality checks
- [x] Coordinates fix loops effectively
- [x] Escalates appropriately when iteration limit reached

---

### Task 3.7: Create Security Agent ✓

**Description:** Build the agent responsible for security review.

**Subtasks:**
- [x] 3.7.1: Create `.claude/agents/security.md`
- [x] 3.7.2: Define agent metadata with read-focused permissions
- [x] 3.7.3: Write system prompt emphasizing security vigilance
- [x] 3.7.4: Define trigger words (security, vulnerability, auth, OWASP)
- [x] 3.7.5: Link to security-reviewer skill
- [x] 3.7.6: Define Approve tier requirement for findings

**Acceptance Criteria:**
- [x] Agent identifies security issues effectively
- [x] Produces actionable security reports
- [x] Requires human approval for security-sensitive changes

---

### Task 3.8: Create DevOps Agent ✓

**Description:** Build the agent responsible for deployment and infrastructure.

**Subtasks:**
- [x] 3.8.1: Create `.claude/agents/devops.md`
- [x] 3.8.2: Define agent metadata and tool permissions
- [x] 3.8.3: Write system prompt emphasizing reliability and safety
- [x] 3.8.4: Define trigger words (deploy, CI/CD, pipeline, infrastructure)
- [x] 3.8.5: Link to deploy-checker skill
- [x] 3.8.6: Define Approve tier for production deployments

**Acceptance Criteria:**
- [x] Agent validates deployment readiness
- [x] Produces deployment checklists
- [x] Requires approval for production changes

---

### Task 3.9: Implement Trigger-Based Routing ✓

**Description:** Build the routing logic in CLAUDE.md that matches requests to agents.

**Subtasks:**
- [x] 3.9.1: Update CLAUDE.md with agent routing section
- [x] 3.9.2: Define trigger word matrix for all 8 agents
- [x] 3.9.3: Implement fallback routing to Orchestrator
- [x] 3.9.4: Add context-aware routing (phase affects agent selection)
- [x] 3.9.5: Document routing precedence rules

**DECISION:** Option B selected — Route to most specific match, with Orchestrator fallback

**Acceptance Criteria:**
- [x] Requests route to correct agents based on keywords
- [x] Ambiguous requests handled gracefully
- [x] Fallback to Orchestrator works

---

### Task 3.10: Implement Handoff Protocol ✓

**Description:** Standardize the transition format between agents.

**Subtasks:**
- [x] 3.10.1: Create `/templates/handoff-template.md`
- [x] 3.10.2: Define required fields (Completed, Artifacts, For Your Action, Context)
- [x] 3.10.3: Update each agent to produce handoffs in standard format
- [x] 3.10.4: Implement handoff validation (receiving agent confirms receipt)
- [x] 3.10.5: Add handoff logging for audit trail

**Acceptance Criteria:**
- [x] All agent transitions use standard handoff format
- [x] Receiving agents acknowledge handoffs
- [x] Audit trail maintained

---

### Task 3.11: Implement Human Oversight Tiers ✓

**Description:** Configure the Auto/Review/Approve tier system.

**Subtasks:**
- [x] 3.11.1: Update CLAUDE.md with tier definitions
- [x] 3.11.2: Map each agent action to default tier
- [x] 3.11.3: Define escalation triggers (scope change, security, production)
- [x] 3.11.4: Implement tier override capability
- [x] 3.11.5: Add tier indicators to status output

**Acceptance Criteria:**
- [x] Tiers correctly applied to all actions
- [x] Escalation triggers work as defined
- [x] Users can see current tier in status

---

### Phase 3 Review Gate ✓ PASSED

**Definition of Done:**
- [x] All 8 agent definitions complete
- [x] Trigger-based routing functional
- [x] Handoff protocol implemented and tested
- [x] Human oversight tiers configured
- [x] Manual test: Request flows through Orchestrator → Business Analyst → Architect → Task Planner
- [x] Status command shows correct agent and phase

**Deliverables:**
- [x] `.claude/agents/` (all 8 agents)
- [x] `/templates/handoff-template.md`
- [x] Updated CLAUDE.md with routing and tiers

---

## Phase 4: Quality & Review ✓ COMPLETE

**Objective:** Build the QA validation loop and review pipeline skills.

> **Note:** Directory structure refined during implementation:
> - QA skills placed in `.claude/skills/qa/` (not `quality/`)
> - Review skills placed in `.claude/skills/review/` (not `engineering/`)
> - Added `handoff-packager` workflow skill for engineer handoff packages

### Task 4.1: Create QA Validator Skill ✓

**Description:** Build the skill that runs automated quality checks.

**Subtasks:**
- [x] 4.1.1: Create `.claude/skills/qa/qa-validator.md`
- [x] 4.1.2: Define validation checklist (tests, lint, types, coverage)
- [x] 4.1.3: Implement requirement coverage checking against spec
- [x] 4.1.4: Define issue categorization (blocker, major, minor)
- [x] 4.1.5: Define input contract per SKILLS-ANALYSIS.md
- [x] 4.1.6: Define output contract (validation report, pass/fail, issues)
- [x] 4.1.7: Implement iteration tracking (current attempt, max 5)

**Acceptance Criteria:**
- [x] Validates all quality dimensions
- [x] Produces structured validation reports
- [x] Correctly categorizes issues by severity

---

### Task 4.2: Create QA Fixer Skill ✓

**Description:** Build the skill that attempts to fix validation failures.

**Subtasks:**
- [x] 4.2.1: Create `.claude/skills/qa/qa-fixer.md`
- [x] 4.2.2: Define fixable issue types (lint errors, simple test failures)
- [x] 4.2.3: Define non-fixable issues (require human intervention)
- [x] 4.2.4: Implement fix attempt logic
- [x] 4.2.5: Track fixes applied for validation re-run
- [x] 4.2.6: Define escalation criteria

**Acceptance Criteria:**
- [x] Fixes common validation failures automatically
- [x] Correctly identifies unfixable issues
- [x] Escalates when max iterations reached

---

### Task 4.3: Implement QA Validation Loop ✓

**Description:** Wire up the validator ↔ fixer loop with iteration limits.

**Subtasks:**
- [x] 4.3.1: Define chain in QA Engineer agent and skill docs
- [x] 4.3.2: Implement iteration counter (max 5)
- [x] 4.3.3: Define exit conditions (all pass, max reached, unfixable blocker)
- [x] 4.3.4: Implement escalation to human with full context
- [x] 4.3.5: Add loop status to progress reporting

**Acceptance Criteria:**
- [x] Loop executes correctly up to 5 iterations
- [x] Exits appropriately on success or failure
- [x] Escalation provides full context

---

### Task 4.4: Create Code Reviewer Skill ✓

**Description:** Build the skill for structured code review.

**Subtasks:**
- [x] 4.4.1: Create `.claude/skills/review/code-reviewer.md`
- [x] 4.4.2: Define review checklist (readability, patterns, performance, security)
- [x] 4.4.3: Implement diff-based review (focus on changes)
- [x] 4.4.4: Define output format (review comments, approval status)
- [x] 4.4.5: Integrate with constitution standards checking

**Acceptance Criteria:**
- [x] Produces useful code review feedback
- [x] Focuses on changed code
- [x] Respects constitution standards

---

### Task 4.5: Create Security Reviewer Skill ✓

**Description:** Build the skill for security-focused code review.

**Subtasks:**
- [x] 4.5.1: Create `.claude/skills/review/security-reviewer.md`
- [x] 4.5.2: Define OWASP-based security checklist (A01-A10)
- [x] 4.5.3: Implement vulnerability pattern detection
- [x] 4.5.4: Define severity levels for findings
- [x] 4.5.5: Require Approve tier for any findings

**Acceptance Criteria:**
- [x] Identifies common security vulnerabilities
- [x] Produces actionable security findings
- [x] Requires human approval for all findings

---

### Task 4.6: Create Deploy Checker Skill ✓

**Description:** Build the skill for deployment readiness validation.

**Subtasks:**
- [x] 4.6.1: Create `.claude/skills/review/deploy-checker.md`
- [x] 4.6.2: Define pre-deployment checklist
- [x] 4.6.3: Define post-deployment verification steps
- [x] 4.6.4: Implement environment-specific checks (dev/staging/production)
- [x] 4.6.5: Require Approve tier for production

**Acceptance Criteria:**
- [x] Comprehensive deployment checklist
- [x] Environment-aware validation
- [x] Production deployments require approval

---

### Task 4.7: Implement Review Pipeline Chain ✓

**Description:** Wire up parallel code + security + QA review.

**Subtasks:**
- [x] 4.7.1: Define Chain 4 in CLAUDE.md (Validate → Review)
- [x] 4.7.2: Define parallel execution of review skills
- [x] 4.7.3: Implement result aggregation
- [x] 4.7.4: Create summary output for human review
- [x] 4.7.5: Define approval requirements based on findings

**Acceptance Criteria:**
- [x] Reviews execute in parallel
- [x] Results aggregated into single summary
- [x] Approval requirements clear

---

### Task 4.8: Create Handoff Packager Skill ✓ (ADDED)

**Description:** Build the skill that generates Technical Review Packages for engineer handoff.

**Subtasks:**
- [x] 4.8.1: Create `.claude/skills/workflow/handoff-packager.md`
- [x] 4.8.2: Create `/templates/technical-review-package-template.md`
- [x] 4.8.3: Define input contract (spec_path, feature_id)
- [x] 4.8.4: Define 8-section output structure
- [x] 4.8.5: Add trigger detection to Orchestrator
- [x] 4.8.6: Update CLAUDE.md skill categories and data contracts

**Acceptance Criteria:**
- [x] Generates comprehensive Technical Review Package
- [x] Bundles all feature artifacts
- [x] Provides plain-English summary for non-technical users

---

### Phase 4 Review Gate ✓ PASSED

**Definition of Done:**
- [x] All quality and review skills functional
- [x] QA validation loop works with proper iteration limits
- [x] Review pipeline executes parallel reviews
- [x] Manual test: Implement task → validate → fix loop → review
- [x] Security findings require human approval
- [x] Handoff packager generates engineer review packages

**Deliverables:**
- [x] `.claude/skills/qa/qa-validator.md`
- [x] `.claude/skills/qa/qa-fixer.md`
- [x] `.claude/skills/review/code-reviewer.md`
- [x] `.claude/skills/review/security-reviewer.md`
- [x] `.claude/skills/review/deploy-checker.md`
- [x] `.claude/skills/workflow/handoff-packager.md`
- [x] `/templates/technical-review-package-template.md`
- [x] `/docs/future-considerations.md`

---

## Phase 5: Integration & Polish

**Objective:** Add integration points, context persistence, error handling, and extension documentation.

### Task 5.1: Implement Project Context Auto-Update

**Description:** Automatically update project-context.md as work progresses.

**Subtasks:**
- [ ] 5.1.1: Define update triggers (phase transitions, task completion, decisions)
- [ ] 5.1.2: Implement context capture at each trigger
- [ ] 5.1.3: Add current feature and phase tracking
- [ ] 5.1.4: Add recent activity log (last 5 significant actions)
- [ ] 5.1.5: Add open decisions tracking
- [ ] 5.1.6: Ensure context loads on session start

**Acceptance Criteria:**
- Context file stays current automatically
- Session continuity works across restarts
- Open decisions visible

---

### Task 5.2: Define MCP Integration Points

**Description:** Document where MCP servers can extend Prism OS.

**Subtasks:**
- [ ] 5.2.1: Create `/docs/mcp-integration.md`
- [ ] 5.2.2: Document Jira integration point (issue tracking)
- [ ] 5.2.3: Document Confluence integration point (documentation)
- [ ] 5.2.4: Document Context7 integration point (library docs)
- [ ] 5.2.5: Define MCP tool registration in CLAUDE.md
- [ ] 5.2.6: Mark all MCP integrations as optional

**Acceptance Criteria:**
- Clear documentation for each integration point
- Integration does not break base functionality
- Optional nature clearly communicated

---

### Task 5.3: Implement Error Handling and Escalation

**Description:** Build robust error handling throughout the system.

**Subtasks:**
- [ ] 5.3.1: Define error categories (soft failure, hard failure)
- [ ] 5.3.2: Implement retry logic for soft failures (max 3)
- [ ] 5.3.3: Implement immediate escalation for hard failures
- [ ] 5.3.4: Create error context capture (what failed, why, state)
- [ ] 5.3.5: Add error recovery suggestions
- [ ] 5.3.6: Update status reporting to show blockers

**Acceptance Criteria:**
- Soft failures retry automatically
- Hard failures escalate with context
- Users see clear error information

---

### Task 5.4: Create Status Dashboard Output

**Description:** Build clear status output for non-technical users.

**Subtasks:**
- [ ] 5.4.1: Define status output format per CLAUDE.md specification
- [ ] 5.4.2: Implement phase progress visualization
- [ ] 5.4.3: Show current activity in plain language
- [ ] 5.4.4: Highlight blockers prominently
- [ ] 5.4.5: Show next human touchpoint
- [ ] 5.4.6: Wire to `/status` command

**Acceptance Criteria:**
- Status output is clear to non-technical users
- Progress is visually trackable
- Next steps are obvious

---

### Task 5.5: Create Skill Extension Documentation (AMENDMENT)

**Description:** Document how to add new skills and chains to Prism OS.

**Subtasks:**
- [ ] 5.5.1: Create `/docs/extending-skills.md`
- [ ] 5.5.2: Document skill definition format with examples
- [ ] 5.5.3: Document input/output contract requirements
- [ ] 5.5.4: Document skill registration in CLAUDE.md
- [ ] 5.5.5: Document chain definition format
- [ ] 5.5.6: Document skill-to-skill invocation patterns
- [ ] 5.5.7: Provide template for new skill creation
- [ ] 5.5.8: Include troubleshooting section

**DECISION POINT:** Should we provide a skill generator helper?
- Option A: Documentation only
- Option B: Create `skill-generator` skill that scaffolds new skills
- Recommendation: Option A for v1, add generator in future iteration

**Acceptance Criteria:**
- Clear instructions for adding skills
- Template available for new skills
- Chain extension documented
- Examples for common extension scenarios

---

### Task 5.6: Implement Skill Versioning

**Description:** Add version tracking to skills for compatibility management.

**Subtasks:**
- [ ] 5.6.1: Add version field to skill metadata
- [ ] 5.6.2: Document versioning strategy (MAJOR.MINOR.PATCH)
- [ ] 5.6.3: Implement version compatibility checking in chains
- [ ] 5.6.4: Add deprecation warnings for old versions
- [ ] 5.6.5: Document upgrade path for skill changes

**Acceptance Criteria:**
- All skills have version numbers
- Chains respect version compatibility
- Upgrade paths documented

---

### Phase 5 Review Gate

**Definition of Done:**
- [ ] Project context auto-updates correctly
- [ ] MCP integration points documented
- [ ] Error handling works for soft and hard failures
- [ ] Status command produces clear output
- [ ] Skill extension documentation complete
- [ ] Skill versioning implemented
- [ ] Manual test: Session restart maintains context

**Deliverables:**
- Updated `/memory/project-context.md` (auto-updating)
- `/docs/mcp-integration.md`
- `/docs/extending-skills.md`
- Updated CLAUDE.md with error handling
- Updated all skills with version numbers

---

## Phase 6: Documentation

**Objective:** Create comprehensive documentation for non-technical users.

### Task 6.1: Create User Guide for PMs/POs

**Description:** Write the primary user documentation for non-technical stakeholders.

**Subtasks:**
- [ ] 6.1.1: Create `/docs/user-guide.md`
- [ ] 6.1.2: Write "Getting Started" section (first session, constitution setup)
- [ ] 6.1.3: Write "Creating Features" section (spec workflow)
- [ ] 6.1.4: Write "Understanding Status" section (phases, progress, blockers)
- [ ] 6.1.5: Write "Making Decisions" section (how to respond to technical choices)
- [ ] 6.1.6: Write "Troubleshooting" section (common issues, how to get help)
- [ ] 6.1.7: Include screenshots/diagrams where helpful
- [ ] 6.1.8: Use plain language throughout—no jargon

**Acceptance Criteria:**
- A PM can use Prism after reading this guide
- No unexplained technical terms
- All common workflows covered

---

### Task 6.2: Create Quick-Start Tutorial

**Description:** Build a hands-on tutorial for first-time users.

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

**Description:** Document a complete example project from start to finish.

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

**Description:** Document common issues and solutions.

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

**Description:** Document all slash commands and their usage.

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

### Phase 6 Review Gate

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

## Phase 7: Validation

**Objective:** Test the complete system end-to-end and refine based on feedback.

### Task 7.1: End-to-End Test: Quick Flow

**Description:** Test the simplified workflow for a bug fix scenario.

**Subtasks:**
- [ ] 7.1.1: Define test scenario (simple bug fix)
- [ ] 7.1.2: Execute full Quick Flow workflow
- [ ] 7.1.3: Verify complexity assessment selects Quick Flow
- [ ] 7.1.4: Verify quick spec generation
- [ ] 7.1.5: Verify task decomposition
- [ ] 7.1.6: Verify implementation and validation
- [ ] 7.1.7: Document any issues found
- [ ] 7.1.8: Fix issues and re-test

**Acceptance Criteria:**
- Quick Flow completes successfully
- Time from request to implementation < 15 minutes
- No manual intervention required (except human checkpoints)

---

### Task 7.2: End-to-End Test: Standard Flow

**Description:** Test the full workflow for a typical feature.

**Subtasks:**
- [ ] 7.2.1: Define test scenario (medium-complexity feature)
- [ ] 7.2.2: Execute full Standard workflow (all 7 phases)
- [ ] 7.2.3: Verify each phase transition
- [ ] 7.2.4: Verify handoffs between agents
- [ ] 7.2.5: Verify QA validation loop
- [ ] 7.2.6: Verify review pipeline
- [ ] 7.2.7: Document any issues found
- [ ] 7.2.8: Fix issues and re-test

**Acceptance Criteria:**
- Standard Flow completes successfully
- All phases execute in correct order
- Handoffs contain complete information
- QA loop resolves issues or escalates correctly

---

### Task 7.3: Non-Technical User Testing

**Description:** Have a PM/PO test the system without developer assistance.

**Subtasks:**
- [ ] 7.3.1: Recruit non-technical tester (PM, PO, or Project Manager)
- [ ] 7.3.2: Provide only user documentation (no verbal guidance)
- [ ] 7.3.3: Observe tester completing quick-start tutorial
- [ ] 7.3.4: Observe tester creating a new feature specification
- [ ] 7.3.5: Record confusion points, questions, and blockers
- [ ] 7.3.6: Collect feedback on documentation clarity
- [ ] 7.3.7: Prioritize improvements based on feedback

**Acceptance Criteria:**
- Non-technical user completes tutorial successfully
- Non-technical user creates valid specification
- Critical confusion points identified and documented

---

### Task 7.4: Session Continuity Testing

**Description:** Test that context persists correctly across sessions.

**Subtasks:**
- [ ] 7.4.1: Start a feature workflow, complete through Plan phase
- [ ] 7.4.2: End session
- [ ] 7.4.3: Start new session
- [ ] 7.4.4: Verify context loads correctly
- [ ] 7.4.5: Verify can continue from Tasks phase
- [ ] 7.4.6: Test multiple session breaks at different phases
- [ ] 7.4.7: Document any context loss issues

**Acceptance Criteria:**
- Context persists across session breaks
- Work can resume from any phase
- No context loss observed

---

### Task 7.5: Edge Case Testing

**Description:** Test handling of unusual or error scenarios.

**Subtasks:**
- [ ] 7.5.1: Test ambiguous request routing
- [ ] 7.5.2: Test QA loop max iterations reached
- [ ] 7.5.3: Test constitution violation detection
- [ ] 7.5.4: Test scope change detection during implementation
- [ ] 7.5.5: Test human override of agent decisions
- [ ] 7.5.6: Test recovery from hard failures
- [ ] 7.5.7: Document unexpected behaviors

**Acceptance Criteria:**
- Edge cases handled gracefully
- Escalation works when needed
- Error messages are helpful

---

### Task 7.6: Refinement Sprint

**Description:** Address issues identified during testing.

**Subtasks:**
- [ ] 7.6.1: Prioritize issues by severity (blocker, major, minor)
- [ ] 7.6.2: Fix all blocker issues
- [ ] 7.6.3: Fix major issues (time permitting)
- [ ] 7.6.4: Document minor issues for future iteration
- [ ] 7.6.5: Update documentation based on testing feedback
- [ ] 7.6.6: Re-run failed tests to verify fixes

**Acceptance Criteria:**
- All blocker issues resolved
- Major issues addressed or documented
- Documentation updated per feedback

---

### Task 7.7: Final Documentation Review

**Description:** Final review of all documentation for accuracy post-refinement.

**Subtasks:**
- [ ] 7.7.1: Review CLAUDE.md against actual behavior
- [ ] 7.7.2: Review user guide for accuracy
- [ ] 7.7.3: Verify quick-start tutorial still works
- [ ] 7.7.4: Update command reference with any changes
- [ ] 7.7.5: Final proofread for clarity and typos

**Acceptance Criteria:**
- All documentation matches actual system behavior
- No outdated information
- Non-technical language maintained

---

### Phase 7 Review Gate

**Definition of Done:**
- [ ] Quick Flow test passes
- [ ] Standard Flow test passes
- [ ] Non-technical user successfully uses system
- [ ] Session continuity works correctly
- [ ] Edge cases handled appropriately
- [ ] All blocker issues resolved
- [ ] Documentation accurate and complete

**Deliverables:**
- Test results documentation
- Issue tracking with resolution status
- Updated system based on testing feedback
- Final documentation

---

## Project Completion Criteria

Prism OS v1.0 is complete when:

1. **All 7 phases pass review gates**
2. **Non-technical user can complete tutorial unassisted**
3. **Full workflow executes from spec to implementation**
4. **QA validation loop resolves or escalates correctly**
5. **Session continuity works reliably**
6. **Documentation is complete and accurate**
7. **No blocker issues remain open**

---

## Risk Register

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Skill chains too complex | High | Medium | Start with minimal chains, add complexity gradually |
| Agent routing confusion | Medium | Medium | Extensive trigger word testing, clear fallback |
| Non-technical users overwhelmed | High | Medium | Guided prompts, simple defaults, optional complexity |
| Session context loss | High | Low | Thorough testing, robust auto-save |
| QA loop infinite | Medium | Low | Hard iteration limit, escalation path |
| Constitution too restrictive | Medium | Medium | Easy constitution updates, override capability |

---

## Appendix: File Inventory

### Configuration Files
- `CLAUDE.md` — Main operating system specification ✓
- `/memory/constitution.md` — Project principles ✓
- `/memory/project-context.md` — Session state ✓

### Templates
- `/templates/constitution-template.md` ✓
- `/templates/spec-template.md` ✓
- `/templates/plan-template.md` ✓
- `/templates/tasks-template.md` ✓
- `/templates/adr-template.md` ✓
- `/templates/handoff-template.md` ✓
- `/templates/project-context-template.md` ✓
- `/templates/technical-review-package-template.md` ✓
- `/templates/prompts/spec-prompts.md` ✓
- `/templates/prompts/plan-prompts.md` ✓
- `/templates/prompts/clarify-prompts.md` ✓
- `/templates/prompts/constitution-prompts.md` ✓

### Agents
- `.claude/agents/orchestrator.md` ✓
- `.claude/agents/business-analyst.md` ✓ (renamed from product-owner)
- `.claude/agents/architect.md` ✓
- `.claude/agents/task-planner.md` ✓ (renamed from scrum-master)
- `.claude/agents/developer.md` ✓
- `.claude/agents/qa-engineer.md` ✓
- `.claude/agents/security.md` ✓
- `.claude/agents/devops.md` ✓

### Skills
**Workflow:**
- `.claude/skills/workflow/constitution-writer.md` ✓
- `.claude/skills/workflow/spec-writer.md` ✓
- `.claude/skills/workflow/clarifier.md` ✓
- `.claude/skills/workflow/technical-planner.md` ✓
- `.claude/skills/workflow/task-decomposer.md` ✓
- `.claude/skills/workflow/complexity-assessor.md` ✓
- `.claude/skills/workflow/handoff-packager.md` ✓

**Research:**
- `.claude/skills/research/researcher.md` ✓

**QA:**
- `.claude/skills/qa/qa-validator.md` ✓
- `.claude/skills/qa/qa-fixer.md` ✓

**Review:**
- `.claude/skills/review/code-reviewer.md` ✓
- `.claude/skills/review/security-reviewer.md` ✓
- `.claude/skills/review/deploy-checker.md` ✓

### Chains
- Defined in CLAUDE.md (Chain 1-4 documented) ✓

### Documentation
- `/docs/future-considerations.md` ✓
- `/docs/user-guide.md` — Phase 6
- `/docs/quick-start.md` — Phase 6
- `/docs/command-reference.md` — Phase 6
- `/docs/troubleshooting.md` — Phase 6
- `/docs/extending-skills.md` — Phase 5
- `/docs/mcp-integration.md` — Phase 5
- `/docs/examples/user-auth-feature/` — Phase 6
