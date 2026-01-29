# Prism OS Key Decisions

> Architectural decisions and their rationale for use as Claude.ai project knowledge.

**Last Updated:** 2026-01-28

---

## Decision Log Format

Each decision follows this structure:
- **Decision:** What was decided
- **Options Considered:** Alternatives evaluated
- **Choice Made:** The selected option
- **Rationale:** Why this choice was made

---

## System Architecture Decisions

### D001: File-Based State Management

**Decision:** Use file-based storage for all state (specs, plans, learnings) rather than external databases.

**Options Considered:**
1. SQLite database
2. External memory service (Graphiti, etc.)
3. File-based markdown documents
4. JSON state files

**Choice Made:** File-based markdown documents

**Rationale:**
- No external dependencies for users to install
- Human-readable artifacts that can be version-controlled
- Works with any project structure
- Enables easy debugging and manual editing
- Pattern borrowed from BMAD-METHOD framework
- Self-contained distribution

---

### D002: 9 Core Agents (Updated from 8)

**Decision:** Use 9 core agents that map to real engineering team roles, including UI/UX Designer.

**Options Considered:**
1. Single monolithic agent
2. 8 role-based agents (engineering team model)
3. 9 role-based agents (adding UI/UX Designer)
4. 137-agent specialist pool (awesome-subagents pattern)
5. Dynamic agent spawning

**Choice Made:** 9 role-based agents (updated v1.1.0)

**Rationale:**
- Maps to familiar engineering team structure (PM, Designer, Architect, Dev, QA, etc.)
- Manageable cognitive load for non-technical users
- Clear ownership of workflow phases
- UI/UX Designer provides dedicated owner for accessibility (D010)
- The 137-agent model from awesome-subagents was deemed overwhelming
- See ADR-019 for full analysis of adding the 9th agent

---

### D003: Scale-Adaptive Tracks

**Decision:** Implement 4 workflow tracks (Quick, Standard, Enterprise, Discovery) selected automatically based on complexity.

**Options Considered:**
1. Single workflow for all requests
2. User-selected workflow depth
3. Automatic complexity-based track selection
4. Per-request ad-hoc workflow building

**Choice Made:** Automatic complexity-based track selection with user override

**Rationale:**
- "Right-sizes" methodology overhead
- Bug fixes don't need 30-page PRDs
- New products need proper research phase
- Reduces user decision fatigue
- Complexity score (1-10) provides objective selection
- Pattern borrowed from BMAD-METHOD

---

### D004: 3-Tier Human Oversight Model

**Decision:** Implement Auto/Review/Approve tiers rather than requiring approval at every step.

**Options Considered:**
1. Approve everything (fully supervised)
2. Approve nothing (fully autonomous)
3. 3-tier model (Auto/Review/Approve)
4. Per-action permission system

**Choice Made:** 3-tier model

**Rationale:**
- Balances autonomy with control
- Non-consequential actions proceed automatically
- Consequential actions (deploy, security) require explicit approval
- Async review tier allows work to continue
- Pattern borrowed from cc-dev-team-agents and Auto-Claude

---

### D005: Spec-First Development

**Decision:** Require written specifications before any code generation.

**Options Considered:**
1. Direct code generation from prompts
2. Spec-optional workflow
3. Mandatory spec-first approach
4. Parallel spec/code development

**Choice Made:** Mandatory spec-first approach

**Rationale:**
- Specs are the source of truth for what gets built
- Reduces costly rework from misunderstood requirements
- Creates audit trail for decisions
- Non-technical users can review specs (not code)
- "If the spec is wrong, the code will be wrong"
- Pattern borrowed from spec-kit and agent-os

---

### D006: Constitutional Boundaries

**Decision:** Each project defines immutable principles in a constitution file.

**Options Considered:**
1. Per-request instructions
2. Session-based preferences
3. Persistent constitution file
4. No constraints (AI decides everything)

**Choice Made:** Persistent constitution file

**Rationale:**
- Ensures cross-session consistency
- Project rules enforced without reminders
- Examples: "We use TypeScript", "All APIs require auth"
- Prevents drift from established patterns
- Reduces repetitive instruction
- Pattern borrowed from spec-kit

---

### D007: Skill-Based Architecture

**Decision:** Implement chainable skills rather than monolithic agent logic.

**Options Considered:**
1. Monolithic agent scripts
2. Chainable skill units
3. Plugin-based extensibility
4. Hardcoded workflow logic

**Choice Made:** Chainable skill units

**Rationale:**
- Single responsibility per skill
- Skills can be composed into chains
- Easy to add new capabilities
- Clear input/output contracts
- Testable in isolation
- Extensible without modifying core

---

### D008: Trigger-Based Agent Routing

**Decision:** Route requests to agents based on keyword triggers.

**Options Considered:**
1. User explicitly names agent
2. Keyword-based automatic routing
3. Intent classification model
4. Phase-based routing only

**Choice Made:** Keyword-based automatic routing with phase context

**Rationale:**
- Reduces cognitive load ("I want a feature" routes to Business Analyst)
- Natural language friendly
- Phase context provides fallback ("in Validate phase" → QA Engineer)
- Users don't need to know agent names
- Pattern borrowed from cc-dev-team-agents

---

### D009: Learning Loop Implementation

**Decision:** Automatically capture and recall project learnings.

**Options Considered:**
1. No persistent learning
2. External memory graph (Graphiti)
3. File-based learning loop
4. Session-only memory

**Choice Made:** File-based learning loop

**Rationale:**
- Builds institutional memory automatically
- Patterns, gotchas, decisions captured after tasks
- Loaded before each task (~2,400 tokens)
- No external infrastructure required
- Human-reviewable and editable
- Graphiti pattern deemed too complex for core use

---

### D010: WCAG 2.1 AA Accessibility Default

**Decision:** All generated code and interfaces must meet WCAG 2.1 AA accessibility standards by default.

**Options Considered:**
1. No accessibility requirements
2. Accessibility on request
3. AA minimum, AAA target
4. Full AAA requirement

**Choice Made:** AA minimum, AAA target where feasible

**Rationale:**
- "Build for everyone from the start"
- Accessibility is validated by UI/UX Designer (v1.1.0) and QA phase
- Prevents costly retrofitting
- Inclusive design as default, not afterthought
- UI/UX Designer agent now owns accessibility (ADR-019)

---

## Framework Pattern Decisions

### D011: What We Adopted (and Why)

| Pattern | Source Framework | Why Adopted |
|---------|-----------------|-------------|
| Spec-First Development | spec-kit, agent-os | Fundamental to quality AI output |
| Constitutional Principles | spec-kit | Cross-session consistency |
| Scale-Adaptive Tracks | BMAD-METHOD | Right-sizes methodology |
| 3-Tier Human Oversight | cc-dev-team-agents | Balances autonomy/control |
| QA Validation Loop | Auto-Claude | Autonomous quality assurance |
| 9-Agent Core Team | cc-dev-team-agents | Maps to real teams |
| Trigger-Based Routing | cc-dev-team-agents | Reduces cognitive load |
| Handoff Protocol | cc-dev-team-agents, BMAD | Clear agent transitions |
| Concise Templates | agent-os | Accessible without overwhelming |
| Clarification Taxonomy | spec-kit | Systematic ambiguity reduction |
| Tool Permission Stratification | awesome-subagents | Security via least privilege |
| File-Based Persistence | BMAD-METHOD | No external infrastructure |

---

### D012: What We Explicitly Rejected (and Why)

| Pattern | Source | Why Rejected |
|---------|--------|--------------|
| 137-agent default roster | awesome-subagents | Overwhelming for non-technical users |
| Graphiti memory graph | Auto-Claude, Archon | Complex setup, not essential for MVP |
| 40+ item mandatory checklist | spec-kit | Intimidating; made optional instead |
| External CLI dependencies | BMAD-METHOD | Prefer native Claude Code capabilities |
| Framework coupling (VoltAgent) | awesome-subagents | Keep system self-contained |
| Human approval every step | BMAD (strict mode) | Too slow; use 3-tier instead |

---

## Implementation Decisions

### D013: Product/Development Separation

**Decision:** Separate distributable product (`prism/`) from development artifacts (root level).

**Options Considered:**
1. Single mixed directory
2. Product in `prism/`, dev files at root
3. Multiple output builds
4. Git submodules

**Choice Made:** Product in `prism/`, development files at root

**Rationale:**
- Clean distribution: copy `prism/` to any project
- Development files (STATUS.md, PROJECT_PLAN.md) stay out of user projects
- Local config (`.claude/settings.local.json`) gitignored
- Clear mental model: "everything in prism/ is what users get"

---

### D014: Unified Entry Point (`/prism`)

**Decision:** Single command for all common operations.

**Options Considered:**
1. Separate commands for each action
2. Unified `/prism` command
3. Natural language only
4. GUI-based interaction

**Choice Made:** Unified `/prism` command with natural language fallback

**Rationale:**
- Reduces command memorization
- `/prism` handles: status, starting features, continuing work
- Natural language also works ("I want to add...")
- Specific commands available for power users
- Lower barrier for non-technical users

---

### D015: Semantic Versioning for Skills

**Decision:** Use semantic versioning (MAJOR.MINOR.PATCH) for all skills.

**Options Considered:**
1. No versioning
2. Date-based versioning
3. Semantic versioning
4. Git commit-based versioning

**Choice Made:** Semantic versioning

**Rationale:**
- MAJOR: Breaking changes to input/output contracts
- MINOR: New features, backward compatible
- PATCH: Bug fixes
- Enables chain compatibility tracking
- Industry standard approach

---

## Trade-off Decisions

### D016: Concise Templates vs. Comprehensive Checklists

**Decision:** Make templates concise by default with optional extended sections.

**Trade-off:** Completeness vs. accessibility

**Choice Made:** Concise core + optional extensions

**Rationale:**
- A PM should fill out core template in 10 minutes
- Extended sections available but never required
- Spec-kit's 40+ item checklist was intimidating
- "If it's too much, no one will use it"

---

### D017: Auto-Routing vs. Explicit Agent Selection

**Decision:** Automatically route to agents based on keywords, with explicit override available.

**Trade-off:** Convenience vs. control

**Choice Made:** Auto-routing with override

**Rationale:**
- Most users don't want to think about agents
- Power users can specify agent directly
- Phase context provides sensible defaults
- Natural language feels more accessible

---

### D018: Token Budget for Learnings

**Decision:** Cap learnings at ~2,400 tokens (~3% of context).

**Trade-off:** Memory richness vs. context efficiency

**Choice Made:** Conservative token budget with structured pruning

**Rationale:**
- Patterns: 30 items (~900 tokens)
- Gotchas: 30 items (~900 tokens)
- Decisions: 20 items (~800 tokens)
- Preserves context for actual work
- Pruning keeps most relevant items

---

## Recent Decisions (v1.1.0+)

### D019: UI/UX Designer as 9th Core Agent

**Decision:** Add UI/UX Designer as dedicated agent for design, accessibility, and UI framework selection.

**Options Considered:**
1. Add design to Architect
2. Add design to Developer
3. Add UI/UX Designer as 9th agent (selected)
4. Separate UI and UX agents (10 agents)

**Choice Made:** UI/UX Designer as 9th agent

**Rationale:**
- Clear separation of concerns from technical architecture
- Dedicated owner for accessibility (D010)
- Systematic UI framework selection
- Natural home for Figma integration
- Mirrors real design → development handoff
- See ADR-019 for full analysis

---

### D020: Smart Constitution for Established Repos

**Decision:** Auto-detect technology stack from manifests when creating constitutions for existing codebases.

**Options Considered:**
1. Always require manual stack specification
2. Suggest stack based on file extensions
3. Parse manifests (package.json, requirements.txt, etc.) for exact versions
4. Hybrid: detect what we can, ask for what we can't

**Choice Made:** Parse manifests with hybrid fallback

**Rationale:**
- Reduces friction for established repos (user doesn't re-specify what's in package.json)
- More accurate than file extension guessing
- Fallback to manual for ambiguous cases
- Constitution Article 1 pre-populated with detected stack
- Pattern: `codebase-assessment` skill (v1.1.0) detects language, framework, database, ORM, test framework

---

### D021: Preflight Check with Enforcement Injection

**Decision:** `/prism` runs Step 0 verification before any workflow, injecting enforcement rules into project CLAUDE.md.

**Options Considered:**
1. Trust users to follow instructions manually
2. Check installation only, no enforcement
3. Full preflight check with CLAUDE.md enforcement injection (selected)
4. External process monitoring

**Choice Made:** Preflight check with enforcement injection

**Rationale:**
- Verifies global installation is intact (blocks if missing core files)
- Injects versioned enforcement section into project CLAUDE.md
- Enforcement rules ensure Claude Code invokes Prism skills via Skill tool
- Prevents Claude Code from defaulting to inline behavior
- Self-healing: re-injects if enforcement section missing or outdated
- Non-destructive: preserves user's existing CLAUDE.md content

---

## Pending Decisions

### D022: Team Memory Sync Architecture (Draft)

**Status:** Spec complete (TMS-001), implementation pending

**Question:** How should team learnings be shared across developers?

**Leading Option:** Supabase + pgvector with GitHub OAuth, git hook-based sync

**Considerations:**
- Offline support via local queue
- RLS policies for repo isolation
- Automatic relevance matching via embeddings
- Token budget management via synthesis
