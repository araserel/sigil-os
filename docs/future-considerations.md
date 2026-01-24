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

## MVP Development Path

> Consolidated four-phase plan for productizing Prism OS as a standalone CLI tool with progressive enhancement.

### Open Architecture Decision

Before implementation, we need to decide between two models:

#### Option A: Skills Model (spec-kit approach)

```
User runs Claude Code → Claude Code reads CLAUDE.md →
CLAUDE.md points to .prism/ skills → Claude Code executes workflow
```

**Prism is:** A framework of skills and templates that Claude Code uses.

**User experience:**
```bash
prism init                    # One-time setup
claude                        # User runs Claude Code directly
# Claude Code uses Prism skills automatically
```

**Pros:**
- Simpler to build (less code)
- Leverages Claude Code's existing capabilities
- No subprocess management
- Natural integration with Claude Code ecosystem

**Cons:**
- Less control over the execution loop
- Harder to add features Claude Code doesn't support
- User must understand Claude Code

#### Option B: CLI Orchestrator Model (Auto-Claude approach)

```
User runs `prism run` → Prism CLI invokes Claude Code →
Prism manages loop externally → Claude Code does individual tasks
```

**Prism is:** A standalone CLI that orchestrates Claude Code.

**User experience:**
```bash
prism init                    # One-time setup
prism run "add user auth"     # Prism drives everything
```

**Pros:**
- Full control over execution flow
- Can add features beyond Claude Code's capabilities
- Cleaner UX for non-technical users
- Better progress tracking and state management

**Cons:**
- More complex to build
- Subprocess management overhead
- Must handle Claude Code errors/edge cases

**Recommendation:** Start with Option A (Skills Model) for Phase 1. It's faster to build and proves the core value. Add orchestrator capabilities in later phases if needed.

---

### Phase 1: CLI + File Storage + Learning Loop

**Goal:** Non-technical user can initialize projects and run spec-driven development through Claude Code with accumulated learnings.

#### Commands

##### `prism init`

**Purpose:** Prepare a project folder to work with Prism.

**What it does:**
1. Check prerequisites (git repo, Claude Code installed)
2. Gather project info via prompts
3. Detect tech stack from project files
4. Create folder structure
5. Generate CLAUDE.md with Prism instructions
6. Generate constitution from user input

**User interaction:**
```
$ cd ~/Projects/my-app
$ prism init

Welcome to Prism! Let's set up your project.

? Project name: (my-app)
? Describe this project in one sentence: E-commerce platform for handmade goods

Detected:
  ✔ Tech stack: Next.js, TypeScript, Tailwind
  ✔ Package manager: npm
  ✔ Test framework: Jest

? Is this correct? (Y/n)

? Any constraints or rules the AI should follow?
  (e.g., "use Postgres", "no new dependencies", "follow existing patterns")
  > Must use Supabase for all database operations

Creating Prism structure...
  ✔ /memory/constitution.md
  ✔ /memory/project-context.md
  ✔ /memory/learnings.md
  ✔ /specs/
  ✔ /.prism/
  ✔ CLAUDE.md

Done! Run 'claude' and describe what you want to build.
```

**Files created:**
```
my-app/
├── .prism/                    # Prism config (hidden)
│   ├── config.json            # Project settings
│   └── skills/                # Prism skills for Claude Code
│       ├── spec-writer.md
│       ├── task-decomposer.md
│       ├── quality-gate.md
│       └── learning-capture.md
├── memory/
│   ├── constitution.md        # Project rules/constraints
│   ├── project-context.md     # Current state tracking
│   └── learnings.md           # Accumulated knowledge
├── specs/                     # Feature specs (empty initially)
└── CLAUDE.md                  # Instructions for Claude Code
```

##### `prism status`

**Purpose:** Show current project state without changing anything.

**Output when feature in progress:**
```
$ prism status

Project: My App
Feature: User Authentication
Status:  In Progress

Progress: ████████░░░░░░░░ 3/5 tasks

  ✔ Create users table and auth schema
  ✔ Build registration API endpoint
  ✔ Build login API endpoint
  ○ Add password reset flow
  ○ Create login/register UI pages

Learnings captured: 7 entries, 2 patterns

Recent specs:
  - /specs/001-user-auth/spec.md (in progress)
```

**Output when nothing in progress:**
```
$ prism status

Project: My App
Status:  Ready

No feature in progress.

Learnings captured: 12 entries, 4 patterns

Recent specs:
  - /specs/001-user-auth/ (complete)
  - /specs/002-product-catalog/ (complete)

Run 'claude' and describe what you want to build next.
```

##### `prism learn`

**Purpose:** View and search accumulated learnings.

**Output:**
```
$ prism learn

Learnings: 12 entries, 4 patterns

Patterns (reusable across features):
  1. Use Supabase RLS policies for all user-scoped queries
  2. Always add loading states to async UI components
  3. Use zod for API request validation
  4. Run `npm run typecheck` before committing

Recent learnings:
  - [001-user-auth] Password reset requires email service config
  - [001-user-auth] Session tokens stored in httpOnly cookies
  - [002-product-catalog] Image uploads need size validation

$ prism learn --search "supabase"

Found 3 matches:
  1. [Pattern] Use Supabase RLS policies for all user-scoped queries
  2. [001-user-auth] Supabase auth.users() requires service role key
  3. [002-product-catalog] Supabase storage has 50MB default limit
```

#### Installation

**Method:** Git clone + install script (private distribution)

```bash
# Clone the repo (requires access)
git clone git@github.com:your-org/prism-os.git
cd prism-os

# Run install script
./install.sh
```

#### Functional Requirements

| ID | Requirement |
|----|-------------|
| FR-1 | Install globally via git clone + ./install.sh |
| FR-2 | Verify Claude Code installed, warn if missing |
| FR-3 | `prism --version` and `prism --help` work |
| FR-4 | `prism init` scaffolds /memory/, /specs/, /.prism/, CLAUDE.md |
| FR-5 | `prism init` prompts for project name, description, constraints |
| FR-6 | `prism init` detects tech stack from project files |
| FR-7 | `prism init` is idempotent (safe to run twice) |
| FR-8 | `prism status` shows current feature and task progress |
| FR-9 | `prism status` shows learnings count |
| FR-10 | `prism learn` displays accumulated learnings |
| FR-11 | `prism learn --search` filters learnings |
| FR-12 | CLAUDE.md instructs Claude Code to use Prism workflow |
| FR-13 | Constitution captures project rules and constraints |
| FR-14 | Learnings persist across Claude Code sessions |

#### Non-Functional Requirements

| Requirement |
|-------------|
| Works offline (no network required for core functionality) |
| Works on macOS, Linux, Windows (WSL) |
| No Docker required |
| No database required |
| Init completes in < 30 seconds |
| All state files are human-readable markdown |
| All state files are git-friendly |

#### Dependencies

| Dependency | Required? | Purpose |
|------------|-----------|---------|
| Node.js 18+ | Yes | Runtime |
| Claude Code CLI | Yes | AI execution |
| Git | Yes | Version control |

#### Out of Scope for Phase 1

- Web UI
- Database storage
- Team collaboration
- Multi-repo support
- Custom skill creation
- MCP integrations
- External orchestration (Prism driving Claude Code)

---

### Phase 2: Local Web UI

**Goal:** Visual dashboard for users who prefer GUI over terminal.

#### New Command: `prism ui`

**Purpose:** Open a visual dashboard in the browser.

**What it does:**
1. Start local web server on port 3737 (or next available)
2. Auto-open browser to http://localhost:3737
3. Serve React dashboard
4. Keep running until Ctrl+C

**User interaction:**
```
$ prism ui

Starting Prism dashboard...
Server running at http://localhost:3737

Press Ctrl+C to stop.
```

#### Dashboard Features

| Feature | Description |
|---------|-------------|
| Project overview | Name, tech stack, current status |
| Spec browser | View all specs, their status |
| Spec viewer | Read spec content with formatting |
| Task progress | Visual progress of current feature |
| Learnings browser | Search and view learnings |
| Activity feed | Recent actions and changes |

#### Tech Stack

- **Framework:** Vite + React
- **Styling:** Tailwind CSS
- **Server:** Express (minimal)
- **State:** File system (reads same files as CLI)

#### Functional Requirements

| ID | Requirement |
|----|-------------|
| FR-15 | `prism ui` starts local server |
| FR-16 | Auto-opens browser to dashboard |
| FR-17 | Dashboard shows project status |
| FR-18 | Dashboard shows spec list and content |
| FR-19 | Dashboard shows task progress |
| FR-20 | Dashboard shows learnings with search |
| FR-21 | Graceful shutdown on Ctrl+C |

#### Out of Scope for Phase 2

- User accounts/authentication
- Cloud hosting
- Multi-user collaboration
- Mobile support
- Real-time log streaming from Claude Code

---

### Phase 3: Supabase Sync

**Goal:** Enable team collaboration and cross-project learnings via cloud persistence.

#### New Commands

##### `prism connect`

**Purpose:** Link project to Supabase for cloud sync.

**User interaction:**
```
$ prism connect

? Supabase project URL: https://xyz.supabase.co
? Supabase anon key: eyJ...

Testing connection...
✔ Connected successfully!

? Sync learnings to cloud? (Y/n) Y
? Sync specs to cloud? (Y/n) n

Configuration saved.
Learnings will sync automatically.
```

##### `prism disconnect`

**Purpose:** Remove cloud connection, return to local-only.

#### Sync Behavior

| Data | Sync Direction | Conflict Resolution |
|------|---------------|---------------------|
| Learnings | Bidirectional | Latest write wins |
| Specs | Optional, up | Manual merge |
| Constitution | Up only | Local authoritative |
| Project context | Local only | Not synced |

#### Data Model

```
organizations
  └── projects (repos)
        ├── learnings
        │     └── patterns (promoted)
        ├── specs
        │     └── tasks
        └── constitution
```

#### Functional Requirements

| ID | Requirement |
|----|-------------|
| FR-22 | `prism connect` prompts for Supabase credentials |
| FR-23 | Credentials stored securely (keychain or encrypted) |
| FR-24 | Learnings sync to Supabase after capture |
| FR-25 | Learnings pull from Supabase on Claude Code start |
| FR-26 | Works offline (queues writes, syncs when connected) |
| FR-27 | `prism disconnect` removes cloud connection |
| FR-28 | Graceful degradation to file-only if offline |

#### Out of Scope for Phase 3

- Self-hosted Supabase
- Real-time collaboration
- Billing/subscription management
- Role-based access control (basic only)

---

### Phase 4: Desktop App

**Goal:** Native desktop experience with system integration.

#### Application

- **Framework:** Tauri (Rust + Web)
- **Platforms:** macOS, Windows, Linux
- **Wraps:** Same React UI from Phase 2

#### Features

| Feature | Description |
|---------|-------------|
| System tray | Icon shows status, quick actions |
| Notifications | Native alerts for completion, errors |
| Auto-update | Check and install updates |
| Deep links | `prism://open?project=my-app` |
| Multi-project | Switch between projects in sidebar |

#### Functional Requirements

| ID | Requirement |
|----|-------------|
| FR-29 | Installable app for macOS, Windows, Linux |
| FR-30 | System tray icon with status indicator |
| FR-31 | Native notifications |
| FR-32 | Auto-update mechanism |
| FR-33 | Project switcher in sidebar |
| FR-34 | Deep link support |

#### Out of Scope for Phase 4

- Mobile apps
- Browser extension
- IDE plugins

---

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER                                     │
└───────────────────────────┬─────────────────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
┌─────────────────────────┐   ┌─────────────────────────┐
│     Terminal (CLI)      │   │    Browser / Desktop    │
│                         │   │                         │
│  prism init             │   │  ┌─────────────────┐   │
│  prism status           │   │  │   Dashboard     │   │
│  prism learn            │   │  │   (React)       │   │
│  prism ui ──────────────┼───┼─►│                 │   │
│  prism connect          │   │  └─────────────────┘   │
└───────────┬─────────────┘   └───────────┬───────────┘
            │                             │
            └─────────────┬───────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                     PRISM CORE                                   │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐         │
│  │ Config      │  │ State       │  │ Skills          │         │
│  │ Manager     │  │ Reader      │  │ (templates)     │         │
│  └─────────────┘  └─────────────┘  └─────────────────┘         │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                     FILE SYSTEM                                  │
│                                                                 │
│  /memory/               /specs/              /.prism/            │
│  ├── constitution.md    └── 001-feature/     ├── config.json    │
│  ├── project-context.md     ├── spec.md      └── skills/        │
│  └── learnings.md           └── tasks.md                        │
│                                                                 │
│  CLAUDE.md (root)                                               │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ reads instructions from
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                     CLAUDE CODE                                  │
│                                                                 │
│  User runs 'claude' directly                                    │
│  Claude Code reads CLAUDE.md                                    │
│  CLAUDE.md points to .prism/ skills and /memory/                │
│  Claude Code follows Prism workflow                             │
│                                                                 │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ (Phase 3+)
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                     SUPABASE                                     │
│                                                                 │
│  Learnings sync                                                 │
│  Specs sync (optional)                                          │
│  Team collaboration                                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

### MVP Summary

| Phase | Focus | Key Deliverables |
|-------|-------|------------------|
| 1 | CLI + Files | `prism init`, `prism status`, `prism learn`, CLAUDE.md generation |
| 2 | Web UI | `prism ui`, React dashboard |
| 3 | Cloud Sync | `prism connect`, Supabase integration |
| 4 | Desktop | Tauri app, native features |

**Critical decision needed:** Confirm Skills Model (Option A) vs CLI Orchestrator Model (Option B) before starting Phase 1.

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
