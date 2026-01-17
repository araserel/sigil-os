# Phase 5: Integration & Polish — Kickoff Prompt

> Use this prompt to initialize a Claude Code session for Phase 5 work.

---

## Context

You are continuing work on **Prism OS**, an AI-powered spec-driven development operating system. Phases 1-4 are complete:

- **Phase 1 (Foundation):** Project structure, constitution, base CLAUDE.md ✓
- **Phase 2 (Core Workflow):** Skills, templates, guided prompts, skill chains ✓
- **Phase 3 (Agents):** 8 agent definitions, routing, handoffs ✓
- **Phase 4 (Quality & Review):** QA skills, review pipeline, validation loops ✓

Phase 5 focuses on **Integration & Polish**: MCP integration points, context persistence, error handling, and extension documentation.

---

## Project Location

```
/Users/adamriedthaler/Projects/SpecMaster/
```

**Key Files to Reference:**
- `PROJECT_PLAN.md` — Full implementation plan with Phase 5 tasks
- `CLAUDE.md` — Main operating system specification
- `/memory/constitution.md` — Project principles
- `/memory/project-context.md` — Session state template
- `/docs/future-considerations.md` — Deferred enhancements

---

## Phase 5 Objectives

Build integration points, persistence, error handling, and extension documentation so Prism OS is production-ready.

---

## Tasks Overview

### Task 5.1: Implement Project Context Auto-Update
**Goal:** Automatically update `/memory/project-context.md` as work progresses.

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
**Goal:** Document where MCP servers can extend Prism OS.

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
**Goal:** Build robust error handling throughout the system.

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

**Reference:** Flow-test-004 validated the escalation path for constitution violations. Use similar patterns for error escalation.

---

### Task 5.4: Create Status Dashboard Output
**Goal:** Build clear status output for non-technical users.

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

### Task 5.5: Create Skill Extension Documentation
**Goal:** Document how to add new skills and chains to Prism OS.

**Subtasks:**
- [ ] 5.5.1: Create `/docs/extending-skills.md`
- [ ] 5.5.2: Document skill definition format with examples
- [ ] 5.5.3: Document input/output contract requirements
- [ ] 5.5.4: Document skill registration in CLAUDE.md
- [ ] 5.5.5: Document chain definition format
- [ ] 5.5.6: Document skill-to-skill invocation patterns
- [ ] 5.5.7: Provide template for new skill creation
- [ ] 5.5.8: Include troubleshooting section

**Decision:** Documentation only for v1 (no skill generator)

**Acceptance Criteria:**
- Clear instructions for adding skills
- Template available for new skills
- Chain extension documented
- Examples for common extension scenarios

---

### Task 5.6: Implement Skill Versioning
**Goal:** Add version tracking to skills for compatibility management.

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

## Recommended Approach

### Suggested Task Order

1. **Start with 5.1 (Context Auto-Update)** — Foundation for session continuity
2. **Then 5.3 (Error Handling)** — Critical for robustness
3. **Then 5.4 (Status Dashboard)** — User-facing quality of life
4. **Then 5.6 (Skill Versioning)** — Update all skills while touching them
5. **Then 5.5 (Extension Docs)** — Document patterns established
6. **Finally 5.2 (MCP Integration)** — Optional enhancement documentation

### Working Pattern

For each task:
1. Read the relevant existing files first
2. Propose approach before implementing
3. Implement incrementally with checkpoints
4. Verify against acceptance criteria
5. Update project-context.md with progress

---

## Constraints & Principles

From the constitution and project patterns:

- **Non-technical user focus:** All user-facing output must be accessible to PMs/POs
- **Progressive disclosure:** Start simple, add complexity only when needed
- **Constitution compliance:** All changes must respect existing articles
- **Test coverage:** Validate changes work before marking complete

---

## Phase 5 Review Gate

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

## Getting Started

Begin by reading the current state:

```
Read these files to understand current state:
1. PROJECT_PLAN.md (Phase 5 section)
2. CLAUDE.md (current configuration)
3. /memory/project-context.md (current template)
4. /docs/future-considerations.md (deferred items from flow tests)
```

Then propose your approach for Task 5.1 before implementing.

---

## Questions?

If anything is unclear or you need decisions made, pause and ask. Key decision points are marked in the project plan with "DECISION POINT" labels.
