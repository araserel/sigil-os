# Future Considerations

Ideas and enhancements to evaluate in future iterations. These are explicitly out of scope for MVP but worth revisiting as the system matures.

---

## Security & Tooling

### External Security Tool Integration
**Context:** Currently `security-reviewer` uses Claude-based analysis only.

**Future Options to Evaluate:**
- npm audit / yarn audit integration for Node.js projects
- Snyk integration for dependency vulnerability scanning
- OWASP ZAP for dynamic security testing
- Trivy for container image scanning

**Evaluation Criteria:**
- Does it reduce false negatives vs Claude-only analysis?
- Setup complexity vs value added
- Cost implications (some tools require licenses)

---

## Workflow & Governance

### Constitution Waiver Tracking
**Context:** Flow-test-004 validated escalation for constitution violations. When a human chooses to waive a violation (Option D), there's no artifact tracking this exception. Over time, waivers could accumulate without visibility.

**Options:**
- Create `/memory/waivers.md` to track all constitution exceptions
- Add waiver metadata to the spec's review artifacts
- Build a waiver registry with expiration dates (waivers auto-expire after N days/releases)

**Evaluation Criteria:**
- How often do waivers occur in practice?
- Do teams need to audit exceptions for compliance?
- Should waivers require periodic re-approval?

---

### Code Review Suggestions Backlog
**Context:** Flow-test-002 showed code reviewer producing non-blocking suggestions (e.g., "extract validation to middleware"). These suggestions aren't tracked anywhere after the review passes.

**Options:**
- Auto-create tech debt tickets in issue tracker (requires MCP integration)
- Append to a `/memory/tech-debt.md` file
- Include in handoff package as "future improvements" section

**Evaluation Criteria:**
- Do teams actually follow up on non-blocking suggestions?
- Is manual tracking sufficient or does it need automation?
- Should suggestions have priority/severity for triage?

---

### Spec Clarification Source Tracking
**Context:** Flow-test-003 showed qa-fixer deferring a fix because spec behavior was unclear. Clarification appeared in the next iteration, but the source wasn't explicit (auto-resolved from spec doc vs. human input).

**Options:**
- Tag clarifications with source: `[auto]` vs `[human]`
- Require explicit human confirmation for ambiguous spec interpretations
- Build clarification audit trail in `/specs/{feature}/clarifications.md`

**Evaluation Criteria:**
- How often are clarifications auto-resolvable vs requiring human input?
- Does source tracking improve decision quality?
- Is this overhead worth the traceability?

---

### Human Response SLA for Escalations
**Context:** Flow-test-004 escalation flow pauses indefinitely awaiting human input. No timeout or SLA is defined.

**Options:**
- Add `human_response_sla` field to escalation state (e.g., 24h expected)
- Implement reminder notifications after SLA breach
- Auto-proceed with AI recommendation after extended timeout (risky)
- Escalate to secondary approver if primary doesn't respond

**Evaluation Criteria:**
- What's acceptable wait time for different escalation types?
- Should SLA vary by severity (blocking vs informational)?
- Is auto-proceed ever acceptable, or always require human?

---

### Implementation Change Visibility in QA Loop
**Context:** Flow-test-003 showed qa-fixer discovering an implementation bug while writing tests, then fixing both. The files_changed array tracked this, but downstream reviewers may not realize implementation changed (not just tests added).

**Options:**
- Add `implementation_modified` flag to QA handoff when fixes touch non-test files
- Require re-review if implementation changes during fix loop
- Highlight impl changes prominently in code review input

**Evaluation Criteria:**
- How often does QA fix loop modify implementation vs just tests?
- Does this create review fatigue if flagged too often?
- Is the current files_changed list sufficient for reviewers?

---

## Enterprise & Scaling

### Supabase Integration for Team/Enterprise Use

**Context:** Prism OS currently uses file-based storage (`memory/`, `specs/`, `templates/`). This works well for solo/personal use but limits collaboration and enterprise features. Research conducted (2026-01-20) analyzing Archon's Supabase architecture identified patterns applicable to Prism OS.

**What Supabase Would Unlock:**

| Capability | File-Based (Current) | Supabase-Enabled |
|------------|---------------------|------------------|
| Multi-user collaboration | Git merge conflicts on shared files | Real-time sync, row-level security |
| Audit trail | Git history (if committed) | Automatic `created_at`, `updated_by`, change logs |
| Cross-project learning | Manual copy-paste between repos | Query patterns across all projects |
| Permissions | All-or-nothing repo access | Role-based: PM edits specs, Dev reads only |
| Analytics | None | Cycle times, clarification rates, spec quality scores |
| Integration API | Read files via filesystem | REST/GraphQL endpoints for Jira, Slack, dashboards |
| Disaster recovery | Hope someone committed | Automatic backups, point-in-time restore |

**Proposed Data Model:**

```
STAYS IN FILES (repo-local):
├── CLAUDE.md              # Claude Code needs this locally
├── .claude/               # Skills, agents, commands (code-like)
├── templates/             # Document templates (code-like)
└── specs/drafts/          # Work-in-progress specs

MOVES TO SUPABASE (shared state):
├── constitutions          # project_id, version, content, approved_by
├── specs                  # id, project_id, status, content, created_by
├── decisions              # spec_id, question, answer, decided_by
├── projects               # id, name, foundation_json, stack_json
├── project_members        # project_id, user_id, role
├── audit_log              # action, entity, user_id, timestamp, diff
└── embeddings             # entity_id, vector (for cross-project RAG)
```

**Hybrid Architecture Approach:**

Design storage layer to work both ways:
- Solo/personal use: File-based only, zero setup
- Team use: Add Supabase connection string, enable collaboration
- Enterprise: Self-host Supabase, add SSO, audit everything

```
┌─────────────────────────────────────────────────────────────┐
│                     Developer Workstation                    │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │ Claude Code │    │  Git Repo   │    │ Prism CLI   │     │
│  │  + Prism OS │◄──►│  (local)    │◄──►│  (optional) │     │
│  └──────┬──────┘    └─────────────┘    └──────┬──────┘     │
└─────────┼──────────────────────────────────────┼────────────┘
          │                                      │
          ▼                                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    Supabase (Cloud/Self-hosted)              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │ Projects │  │  Specs   │  │ Decisions│  │  Audit   │    │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │           Supabase Edge Functions                     │   │
│  │  • Spec validation webhooks                          │   │
│  │  • Slack/Teams notifications                         │   │
│  │  • Jira/Linear sync                                  │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

**Implementation Phases:**

| Phase | Focus | Supabase? |
|-------|-------|-----------|
| Current | Validate workflow (personal use) | No — file-based |
| Early adopters | Test with 2-3 trusted users | No — separate repos |
| Team pilot | One real team uses it daily | **Yes** — need shared state |
| Enterprise | Multiple teams, compliance needs | **Yes** — add RLS, audit, SSO |

**Trigger for Implementation:** When you hear "we need two PMs to work on specs together" — that's the signal to add Supabase.

**Evaluation Criteria:**
- Is multi-user collaboration actually requested?
- Does file-based + git provide sufficient collaboration for small teams?
- What's the minimum viable Supabase schema?
- Should Prism OS offer hosted Supabase or require self-setup?

**Reference:** Archon project (`/Public Spec Driven Repos/Archon/`) uses Supabase for knowledge base, project/task management, settings persistence, and vector search (pgvector). Their `docker-compose.yml` and `/python/src/server/` provide implementation patterns.

---

### Distribution Strategy Options

**Context:** Research conducted (2026-01-20) comparing Auto-Claude and Archon installation patterns. Current `install.sh` is functional but lacks versioning and update mechanisms.

**Tier 1 (Current): Shell Installer**
```bash
curl -sSL https://prism-os.dev/install.sh | sh
```
- Zero dependencies beyond git and Claude Code CLI
- Works in any git repository
- Suitable for personal/private use

**Tier 2 (Future): GitHub Template Repository**
- "Use this template" button creates new repo with Prism OS pre-installed
- Zero command-line knowledge required
- Ideal for greenfield projects
- Requires public repository

**Tier 3 (Future): npx Initializer**
```bash
npx create-prism-os
```
- Interactive setup with prompts
- Could run Discovery questions during install
- Generates constitution from answers
- Requires npm package publication

**Install.sh Improvements Needed:**
- `--version X.X.X` flag to pin specific releases
- `--verify` flag to validate installation completeness
- `--local /path` flag for offline/private installation
- `.prism-os-version` file to track installed version
- `--help` flag with usage documentation

**Evaluation Criteria:**
- Is public distribution actually desired?
- What's the minimum viable installer for team adoption?
- Should versioning match semantic versioning or date-based?

---

## Testing & Validation

### Enterprise Track Flow Test
**Context:** Flow-tests 001-004 cover Standard track comprehensively. Enterprise track (with Research and Architecture phases) hasn't been explicitly tested.

**Options:**
- Create flow-test-005 for Enterprise track happy path
- Create flow-test-006 for Research phase with external dependencies
- Test Architecture phase with ADR generation

**Evaluation Criteria:**
- Are Enterprise track flows different enough to warrant separate tests?
- What percentage of real usage will be Enterprise vs Standard?
- Can we defer until Enterprise track is actually used?

---

### Fix Quality Metric
**Context:** Flow-test-003 validated fixes resolving issues, but doesn't track whether fixes stay fixed or regress in future iterations.

**Options:**
- Track issue IDs across iterations to detect regression
- Add "fix stability" metric to QA reports
- Flag issues that reappear after being marked resolved

**Evaluation Criteria:**
- How common are regressions in practice?
- Is this overkill for the fix loop's 5-iteration budget?
- Does this add meaningful signal or just noise?

---

## Developer Experience & Tooling

### Automated Workflow Linting
**Context:** Phase 7 validation is essentially a manual "lint" pass over the Prism OS system — verifying that agents reference skills that exist, handoff schemas are compatible, docs match actual behavior, etc. This is tedious and error-prone when done by hand.

**Concept:** Build a linter that statically analyzes the Prism OS interconnected markdown files and validates they connect properly before runtime. Same concept as code linting, different domain.

**Potential Checks:**
- Agent → Skill references: Do referenced skill paths exist?
- Skill → Template references: Do referenced template paths exist?
- Chain → Skill references: Are chained skills compatible?
- CLAUDE.md → Component mapping: Do command routes match actual files?
- Handoff schema compatibility: Does upstream output match downstream input?
- Error code consistency: Are codes defined and used consistently across docs?
- Cross-document terminology: Are phase names, tier definitions consistent?
- Dead workflow paths: Are there paths that dead-end without escalation?

**Implementation Options:**
- Simple: Bash/Python script that parses markdown, extracts references, checks file existence
- Medium: AST-style parser that understands skill/agent/chain schemas
- Advanced: Type system for handoff contracts with compile-time validation

**Evaluation Criteria:**
- How often do reference errors slip through manual review?
- Is the markdown structure consistent enough to parse reliably?
- Could this run as pre-commit hook or CI check?
- Does value justify build/maintenance cost?

**Notes:** This emerged from Phase 7 planning. The manual validation tasks (7.1-7.6) are essentially what a linter would automate.

**Status:** IMPLEMENTED in `/tools/workflow-linter.py`. See `/docs/contributing.md` for change management instructions.

---

### Visual UI Layer Options

**Context:** Research conducted (2026-01-20) comparing Auto-Claude and Archon projects to understand UI integration patterns for AI-assisted development tools.

#### Option A: Full Electron Desktop App (Auto-Claude Pattern)

**Architecture:**
- Electron 39 + React 19 + TypeScript
- Python backend subprocess spawned by Electron main process
- xterm.js for multiple parallel agent terminals
- IPC communication between processes
- OAuth token stored in `.env` as `CLAUDE_CODE_OAUTH_TOKEN`

**Features:**
- Visual Kanban board for task management
- Multiple parallel agent terminals visible simultaneously
- Git worktree isolation per feature
- Roadmap and insights chat interfaces
- Graphiti + LadybugDB for memory/knowledge graph (embedded, no Docker)

**Installation:**
- Pre-built installers (exe/dmg/AppImage)
- First launch triggers OAuth setup wizard
- User selects git repository folder

**Pros:**
- Polished desktop experience
- Multiple terminals visible at once
- Works offline once authenticated

**Cons:**
- High complexity (Electron + Python + IPC)
- Separate installation from Claude Code
- Maintenance burden
- Contradicts Prism's "no external dependencies" principle

#### Option B: Web Dashboard (Archon Pattern)

**Architecture:**
- React 18 + Vite + TanStack Query
- Python FastAPI backend (Docker-based)
- Supabase PostgreSQL + pgvector for persistence
- MCP server on port 8051 for tool integration

**Features:**
- Glassmorphism UI with Radix UI primitives
- Real-time updates via Socket.IO
- Knowledge base with RAG search
- Project and task management exposed as MCP tools

**Installation:**
- Docker-first: `docker compose up --build -d`
- Requires Supabase account setup
- Hybrid mode for development

**Pros:**
- Web-based, no desktop install
- MCP integration enables cross-tool access
- Powerful knowledge base features

**Cons:**
- Requires Docker and database
- More infrastructure to maintain
- Higher barrier to entry

#### Option C: Minimal Read-Only Dashboard (Recommended for Future)

**Architecture:**
- Single-file HTML + vanilla JS (~500 lines)
- Express for serving, chokidar for file watching
- Reads existing markdown files, no database

**Features:**
- Current workflow status visualization
- Spec and task progress display
- Links to open markdown files
- Runs via `npx prism-os ui`

**Pros:**
- Minimal complexity
- No new dependencies
- Supplements CLI, doesn't replace it
- Maintains file-first philosophy

**Cons:**
- Read-only (can't edit from UI)
- Less sophisticated than Electron option

**Evaluation Criteria:**
- Does the UI layer actually help non-technical users, or add confusion?
- Which option provides best value/complexity ratio?
- Can we iterate from Option C toward Option A if demand exists?
- Should UI be a separate project or part of Prism OS?

**Decision (v1):** CLI-only. Revisit after user feedback indicates UI is needed.

**Notes:** This is a presentation layer decision, not a core architecture change. Prism should work identically whether accessed via terminal, VS Code, or a visual wrapper.

---

## Phase 7 Validation Findings

The following minor issues were identified during Phase 7 validation (2026-01-16). They don't block functionality but should be addressed in future iterations.

---

### Documentation Jargon: API Endpoint

**Status:** ✅ RESOLVED (2026-01-21)

**Context:** Non-technical user journey test found "API endpoint" used without definition in quick-start.md (around line 167).
**Resolution:** Term defined in `/docs/glossary.md` with plain-language explanation: "A URL where your application receives or sends data (like a mailbox address for software)".

---

### Documentation Jargon: Lint/Format

**Status:** ✅ RESOLVED (2026-01-21)

**Context:** "Lint/format" mentioned in user-guide.md (around line 183) without explanation.
**Resolution:** Term defined in `/docs/glossary.md` with plain-language explanation: "Automated tools that check and fix code style — like spell-check for code".

---

### Installation Guide Missing

**Context:** Quick-start.md assumes Prism is already installed but doesn't explain how.
**Issue:** Users can't complete quick-start without knowing installation steps.
**Options:**
- Add installation section to quick-start
- Create separate `/docs/installation.md`
- Assume installation is out of scope (handled by technical setup)

**Evaluation Criteria:**
- Who installs Prism (PM or technical lead)?
- Is this a documentation gap or intentional separation?

---

### CLAUDE.md Skills List Incomplete

**Status:** ✅ RESOLVED (2026-01-21)

**Context:** Section 6 workflow skills list didn't include `constitution-writer`, `status-reporter`, `foundation-writer`, `visual-analyzer`, and Discovery skills.
**Resolution:** Updated CLAUDE.md Section 6 Skills Framework table to include all implemented skills:
- Workflow: Added `constitution-writer`, `status-reporter`, `foundation-writer`, `visual-analyzer`
- Research: Added `codebase-assessment`, `problem-framing`, `constraint-discovery`, `stack-recommendation`

---

### Stub Skills Implementation Priority

**Context:** Five skills were identified as referenced but missing during consistency audit. Stubs were created in Phase 7 refinement.

| Skill | Priority | Rationale |
|-------|----------|-----------|
| adr-writer | High | Required for Enterprise track decision documentation |
| visual-analyzer | Medium | Valuable for design-first workflows |
| knowledge-search | Medium | Improves context as project grows |
| story-preparer | Low | Only needed for external story-based tools |
| sprint-planner | Low | Only needed for sprint-based methodology |

**Options:**
- Implement high-priority skills in next iteration
- Defer until actual usage demand
- Remove references instead of implementing

**Evaluation Criteria:**
- Which skills are blocking real workflows?
- What's the implementation cost vs usage frequency?

---

## Add New Ideas Below

[Template for adding new considerations]

### [Idea Name]
**Context:** [Why this came up]
**Options:** [What we might do]
**Evaluation Criteria:** [How to decide if/when to implement]
