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

### Visual UI Layer (Auto Claude Integration)
**Context:** Auto Claude is a community-built desktop application that wraps Claude Code with a visual UI (Electron + React) and multi-agent orchestration. It provides features like Kanban boards, parallel terminal sessions, and visual progress tracking that could benefit non-technical Prism users.

**Key Insight:** Auto Claude's approach mirrors VS Code's model — it presents a terminal UI to the user rather than making API calls directly. This means it uses the user's existing Claude Code authentication (Pro/Max subscription) rather than requiring separate API keys, which keeps it compliant with Anthropic's terms.

**Integration Approach:**
- Prism OS remains a pure Claude Code workflow system (agents, skills, chains, templates)
- Auto Claude (or similar UI) wraps the Claude Code CLI that runs Prism
- UI layer is optional — power users can still use terminal directly
- No changes needed to Prism OS core; it's a presentation layer choice

**Potential Benefits:**
- Visual Kanban for spec/task tracking
- Multiple parallel terminal sessions for complex workflows
- Progress visualization for non-technical users
- Git worktree isolation per feature (Auto Claude's model)

**Evaluation Criteria:**
- Does the UI layer actually help non-technical users, or add confusion?
- Is Auto Claude stable enough for production use?
- Are there simpler UI options (VS Code extension, web dashboard)?
- Does this create support burden for a community project we don't control?

**Notes:** This is a presentation layer decision, not a core architecture change. Prism should work identically whether accessed via terminal, VS Code, or a visual wrapper like Auto Claude.

---

## Phase 7 Validation Findings

The following minor issues were identified during Phase 7 validation (2026-01-16). They don't block functionality but should be addressed in future iterations.

---

### Documentation Jargon: API Endpoint

**Context:** Non-technical user journey test found "API endpoint" used without definition in quick-start.md (around line 167).
**Issue:** PM/PO users may not understand technical terms.
**Options:**
- Add inline definition
- Add glossary reference
- Create hover tooltips in rendered docs

**Evaluation Criteria:**
- Does this actually confuse users in practice?
- Is the inline definition approach scalable?

---

### Documentation Jargon: Lint/Format

**Context:** "Lint/format" mentioned in user-guide.md (around line 183) without explanation.
**Issue:** Technical terminology unexplained for non-technical audience.
**Options:**
- Add brief explanation inline
- Add to glossary
- Remove or simplify references

**Evaluation Criteria:**
- Should user docs mention lint/format at all?
- Is glossary the right approach vs inline definitions?

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

**Context:** Section 6 workflow skills list doesn't include `constitution-writer` and `status-reporter`.
**Issue:** Documentation doesn't reflect actual implementation.
**Options:**
- Update CLAUDE.md skills list
- Generate skills list dynamically from files

**Evaluation Criteria:**
- How often does skills list drift from implementation?
- Should this be part of automated workflow linting?

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
