# Test: Standard Flow End-to-End

## Scenario

**Request:** "Add user authentication to the TaskFlow application with email/password login, registration, and password reset"

**Expected Track:** Standard (moderate complexity, multiple components)

**Reference Example:** `/docs/examples/user-auth-feature/`

---

## Preconditions

- [x] Constitution exists at `/memory/constitution.md`
- [x] Project context exists at `/memory/project-context.md`
- [x] No active workflow in progress
- [x] Example artifacts available for reference

---

## Phase 0: Assessment

### Step 1: Request Receipt

**Action:** User submits authentication feature request

**Expected:** Orchestrator routes to complexity assessment

**Verified:** ✓
- Trigger words: "feature", "I want", "we need" → High priority match
- Routes to Business Analyst domain
- First action: invoke complexity-assessor

---

### Step 2: Complexity Assessment

**Action:** `complexity-assessor` evaluates request

**Expected Scoring (per complexity-assessor.md):**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Scope | 2 | Multiple capabilities (login, logout, register, reset) |
| Files | 2 | 10-15 files estimated |
| Dependencies | 2 | Auth library needed (NextAuth.js) |
| Data Changes | 2 | User table, Session table |
| Integration | 2 | Session management, email service |
| Risk | 2 | Security-related |
| Ambiguity | 2 | Several questions to resolve |
| **Total** | **14** | |

**Track Determination:** 14/21 → Standard (per complexity-assessor.md:80-83)

**Verified:** ✓
- Score 14 correctly maps to Standard
- Security-related → Minimum Standard (override trigger satisfied)
- Example in complexity-assessor.md:255-267 matches this pattern

**Human Checkpoint:** Review tier — user confirms track
- Per complexity-assessor.md:221-226

**Output:**
```json
{
  "recommended_track": "standard",
  "confidence": "high",
  "total_score": 14,
  "rationale": "Multiple related capabilities, moderate file changes, security-related"
}
```

---

## Phase 1: Specify

### Step 3: Spec Generation

**Action:** Business Analyst invokes `spec-writer`

**Inputs:**
- Feature description from user
- Constitution loaded from `/memory/constitution.md`
- Track: Standard

**Process (per spec-writer.md:40-86):**
1. Context gathering — load constitution, scan /specs/
2. Initial analysis — extract intent, users, capabilities
3. Spec generation — use template
4. Constitution validation — verify alignment
5. Create feature directory — `/specs/001-user-auth/`
6. Ambiguity assessment — flag unclear items

**Expected Output:** Specification matching `docs/examples/user-auth-feature/spec.md`

**Verification Against Example:**

| Section | Template Required | Example Has | Status |
|---------|------------------|-------------|--------|
| Summary | Yes | ✓ Lines 11-13 | OK |
| User Scenarios P1 | Yes | ✓ Lines 19-24 | OK |
| User Scenarios P2 | Yes | ✓ Lines 26-29 | OK |
| User Scenarios P3 | Optional | ✓ Lines 31-34 | OK |
| Functional Requirements | Yes | ✓ Lines 38-53 | OK |
| Non-Functional Requirements | Yes | ✓ Lines 55-63 | OK |
| Key Entities | Yes | ✓ Lines 67-86 | OK |
| Success Criteria | Yes | ✓ Lines 90-99 | OK |
| Out of Scope | Yes | ✓ Lines 103-110 | OK |
| Technical Constraints | Optional | ✓ Lines 114-119 | OK |
| Security Considerations | Optional | ✓ Lines 133-139 | OK |
| Accessibility Considerations | Optional | ✓ Lines 143-149 | OK |

**Verified:** ✓ — Example spec follows template structure

**Artifacts Created:**
- `/specs/001-user-auth/spec.md`

**Ambiguity Flags Detected:**
- Password requirements unspecified
- Session duration unclear
- Password reset flow not detailed
- Failed login handling undefined
- OAuth providers not specified
- Email verification blocking?
- 2FA approach?

**Handoff to Clarify:**
```markdown
## Handoff: Business Analyst → Business Analyst (Clarify Mode)

### Completed
- Initial specification created

### Artifacts
- /specs/001-user-auth/spec.md

### For Your Action
- Resolve 7 identified ambiguities
- Update spec with clarifications
```

---

## Phase 2: Clarify

### Step 4: Clarification Round 1

**Action:** `clarifier` skill generates questions

**Questions Generated (matching example clarifications.md):**

1. Password Requirements — Options A-D
2. Session Duration — Options A-D
3. Password Reset Flow — Options A-D
4. Failed Login Handling — Options A-D

**User Answers:**
- Q1: C (8 chars + number + special)
- Q2: B (24 hours)
- Q3: A (Email reset link)
- Q4: C (Generic message + rate limit)

**Verified:** ✓ — Question format matches clarifier skill pattern

### Step 5: Clarification Round 2

**Questions Generated:**

5. OAuth Providers — Options A-D
6. Email Verification — Options A-C
7. Two-Factor Authentication — Options A-D

**User Answers:**
- Q5: A (Google only, as P3)
- Q6: B (Track but don't block)
- Q7: B (Authenticator app TOTP, as P3)

**Verified:** ✓

**Iteration Count:** 2/3 rounds — within limit

**Artifacts Created:**
- `/specs/001-user-auth/clarifications.md`
- Updated `spec.md` with resolved items

**Handoff to Plan:**
```markdown
## Handoff: Business Analyst → Architect

### Completed
- Specification finalized
- 7 clarifications resolved

### Artifacts
- /specs/001-user-auth/spec.md
- /specs/001-user-auth/clarifications.md

### For Your Action
- Create implementation plan
- Research any technical unknowns
- Identify ADR-worthy decisions

### Context
- Track: Standard
- User priorities: Security, usability balance
```

---

## Phase 3: Plan

### Step 6: Technical Planning

**Action:** Architect invokes `technical-planner`

**Inputs:**
- Spec path: `/specs/001-user-auth/spec.md`
- Clarifications: `/specs/001-user-auth/clarifications.md`
- Constitution: `/memory/constitution.md`

**Process (per architect.md:44-77):**
1. Receive spec from Business Analyst
2. Research (if needed) — NextAuth.js patterns
3. Create plan — file changes, dependencies, approach
4. Document decisions — Session storage ADR
5. Present plan for review

**Constitution Gate Checks (per architect.md:139-160):**
- [x] Article 5: Anti-Abstraction — Using NextAuth.js directly, no wrapper
- [x] Article 6: Simplicity — Standard patterns, max 3 new packages
- [x] Article 7: Accessibility — WCAG requirements identified

**Verification Against Example plan.md:**

| Section | Required | Example Has | Status |
|---------|----------|-------------|--------|
| Technical Context | Yes | ✓ Lines 11-25 | OK |
| Constitution Gate Checks | Yes | ✓ Lines 29-49 | OK |
| Project Structure | Yes | ✓ Lines 53-93 | OK |
| API Contracts | Yes | ✓ Lines 99-171 | OK |
| Data Model Changes | Yes | ✓ Lines 175-214 | OK |
| Dependencies | Yes | ✓ Lines 218-234 | OK |
| Risk Assessment | Yes | ✓ Lines 238-246 | OK |
| Testing Strategy | Yes | ✓ Lines 250-272 | OK |
| Implementation Phases | Yes | ✓ Lines 276-304 | OK |
| Architecture Decisions | Conditional | ✓ Lines 308-327 | OK |

**Verified:** ✓ — Example plan follows template structure

**ADR Created:**
- ADR-001: Session Storage (Database vs JWT-only)
- Decision: Database sessions for revocation capability

**Note:** `adr-writer` skill is referenced but **not implemented** (per consistency audit AGT-002)

**Human Checkpoint:** Review tier — user approves plan

**Handoff to Tasks:**
```markdown
## Handoff: Architect → Task Planner

### Completed
- Implementation plan created: /specs/001-user-auth/plan.md
- Constitution gates passed
- 1 ADR documented

### For Your Action
- Break plan into executable tasks
- Identify dependencies
- Mark parallelization opportunities

### Context
- Risk level: Medium (security-related)
- Key decisions: Database sessions, NextAuth.js
```

---

## Phase 4: Tasks

### Step 7: Task Decomposition

**Action:** Task Planner invokes `task-decomposer`

**Inputs:**
- Plan path: `/specs/001-user-auth/plan.md`
- Spec path: `/specs/001-user-auth/spec.md`

**Process (per task-planner.md:44-72):**
1. Receive plan from Architect
2. Decompose into tasks
3. Organize by phase
4. Identify dependencies
5. Mark parallelization

**Verification Against Example tasks.md:**

| Aspect | Expected | Example | Status |
|--------|----------|---------|--------|
| Task Count | ≤20 for Standard | 18 | ✓ OK |
| Phase Structure | 4 phases | 3 phases | ✓ OK (acceptable) |
| Dependencies | Explicit | ✓ "Depends On" field | OK |
| Parallelization | Marked | ✓ [P] notation | OK |
| Blocking Tasks | Marked | ✓ [B] notation | OK |
| Acceptance Criteria | Per task | ✓ Checkboxes | OK |
| Test First Indicator | Yes | ✓ "Test First: Yes/No" | OK |

**Task Summary from Example:**

| Phase | Tasks | Parallelizable |
|-------|-------|----------------|
| Foundation | 4 | T001, T002, T004 can parallel |
| Core Auth | 10 | T006, T007 can parallel |
| Password Mgmt | 4 | T015 parallel with others |

**Dependency Map Verified:**
```
T001 → T005 → T013 → T014 → T018
T002 → T003 ↗
T004 → T008, T010, T015
T006 → T011
T007 → T008, T010
```

**Verified:** ✓ — Task structure matches template

**Human Checkpoint:** Auto tier (18 ≤ 20 tasks)

**Handoff to Developer:**
```markdown
## Handoff: Task Planner → Developer

### Completed
- 18 tasks created
- Dependencies identified
- First task prepared

### First Task Ready
**T001: Set up NextAuth.js configuration [B]**
- Description: Install NextAuth.js and create initial configuration
- Files: src/lib/auth.ts (new), package.json (modify)
- Acceptance: NextAuth installed, config created, types configured

### For Your Action
- Execute T001 using test-first approach (if applicable)
- Mark complete when acceptance criteria met
- Proceed to next unblocked task
```

---

## Phase 5: Implement

### Step 8: Task Execution

**Action:** Developer agent implements tasks

**Per-Task Pattern (per developer.md:52-91):**

1. **Receive task** — Task details from Task Planner
2. **Understand** — Read files, check patterns
3. **Test first** — Write failing tests (if applicable)
4. **Implement** — Minimal code to pass
5. **Verify** — Tests pass, lint clean
6. **Complete** — Mark done, proceed

**Sample Execution: T001**

```
Starting T001: Set up NextAuth.js configuration

**Understanding:**
- Task requires: Install package, create config file
- Will modify: package.json, create src/lib/auth.ts
- Test-first: No (configuration task)

**Approach:**
- npm install next-auth
- Create configuration following NextAuth patterns
- Add TypeScript types

Beginning implementation...
```

**Handoff to QA (per task):**
```markdown
## Handoff: Developer → QA Engineer

### Completed
- Task T001 implemented
- 2 files changed
- 0 tests added (configuration)

### Artifacts
- package.json (modified)
- src/lib/auth.ts (created)

### For Your Action
- Validate implementation meets requirements
- Run full test suite
- Check for regressions
```

---

## Phase 6: Validate

### Step 9: QA Validation

**Action:** QA Engineer invokes `qa-validator`

**Checks (per qa-validator.md:100-178):**

1. **Unit Tests** — Run npm test
2. **Lint/Format** — Run npm lint
3. **Type Check** — Run tsc --noEmit
4. **Requirements Coverage** — Map to spec
5. **Regression Check** — Existing tests pass
6. **Accessibility** — (if UI changes)
7. **Constitution Compliance** — Check articles

**Validation Loop (per qa-validator.md:285-307):**

```
qa-validator
    ↓
Pass? ── Yes ──→ Handoff to Review
    │
   No
    ↓
qa-fixer (auto-fix attempt)
    ↓
Re-validate (loop max 5x)
    ↓
Still failing? → Escalate to human
```

**Verified:** ✓ — Loop behavior documented and consistent

**Handoff to Review:**
```markdown
## Handoff: QA Engineer → Security / Code Reviewer

### Completed
- All tasks validated successfully
- [N] fix cycles completed
- Quality gates passed

### Artifacts
- /specs/001-user-auth/qa/validation-summary.md

### For Your Action
- Perform code review (code-reviewer)
- Perform security review (security-reviewer)
- Final approval
```

---

## Phase 7: Review

### Step 10: Code Review

**Action:** `code-reviewer` skill examines changes

**Checks (per code-reviewer.md — inferred):**
- Code quality
- Pattern consistency
- Documentation
- Test coverage

**Verified:** ✓ — Skill exists at `.claude/skills/review/code-reviewer.md`

### Step 11: Security Review

**Action:** `security-reviewer` skill examines security aspects

**Checks (per security.md:49-61):**
- OWASP Top 10
- Auth patterns
- Dependency vulnerabilities
- Data handling

**Human Checkpoint:** Approve tier — security findings require acknowledgment

**Per security.md:67-72:**
- Critical findings block deployment
- High findings require acknowledgment
- Medium/Low can be accepted with documentation

**Verified:** ✓ — Security review follows defined patterns

---

## Phase 8: Complete

### Step 12: Workflow Completion

**Action:** Workflow concludes

**Final State:**
- All tasks implemented
- All validations passed
- Code review complete
- Security review approved

**Context Update:**
```markdown
## Current Work
- **Feature:** User Authentication
- **Status:** Complete
- **Phase:** Review (complete)

## Progress Summary
- [x] Assess — Standard track selected
- [x] Specify — Spec complete
- [x] Clarify — 7 questions resolved
- [x] Plan — Plan approved
- [x] Tasks — 18 tasks created
- [x] Implement — All tasks done
- [x] Validate — All checks pass
- [x] Review — Approved
```

---

## Artifacts Produced

| Artifact | Location | Example Verified |
|----------|----------|------------------|
| Specification | `/specs/001-user-auth/spec.md` | ✓ Matches template |
| Clarifications | `/specs/001-user-auth/clarifications.md` | ✓ Format correct |
| Plan | `/specs/001-user-auth/plan.md` | ✓ Matches template |
| Tasks | `/specs/001-user-auth/tasks.md` | ✓ Matches template |
| ADR | `/specs/001-user-auth/adr/` | ⚠ Skill missing |
| QA Reports | `/specs/001-user-auth/qa/` | ✓ Format defined |
| Code Changes | Various src/ files | N/A (simulation) |

---

## Handoff Data Flow

```
User Request
    ↓
Orchestrator
    ↓ [invoke]
complexity-assessor → Standard track
    ↓
Business Analyst
    ↓ [invoke]
spec-writer → spec.md
    ↓ [invoke]
clarifier → clarifications.md (2 rounds)
    ↓
Architect
    ↓ [invoke]
technical-planner → plan.md
    ↓ [invoke - MISSING]
adr-writer → adr/*.md
    ↓
Task Planner
    ↓ [invoke]
task-decomposer → tasks.md
    ↓
Developer
    ↓ [per task]
    ↓
QA Engineer
    ↓ [invoke]
qa-validator ←→ qa-fixer (loop)
    ↓
code-reviewer + security-reviewer (parallel)
    ↓
Complete
```

---

## Issues Found

| ID | Severity | Description | Location | Status |
|----|----------|-------------|----------|--------|
| STD-001 | Major | `adr-writer` skill missing — referenced but not implemented | full-pipeline.md:59-61 | Open (from audit) |
| STD-002 | Minor | Example plan.md has 5 implementation phases, template implies 4 | plan.md:276-304 | Acceptable variance |

---

## Validation Summary

| Phase | Agent | Skills Invoked | Handoffs | Status |
|-------|-------|----------------|----------|--------|
| Assess | Orchestrator | complexity-assessor | → Business Analyst | ✓ |
| Specify | Business Analyst | spec-writer | → clarifier | ✓ |
| Clarify | Business Analyst | clarifier (2x) | → Architect | ✓ |
| Plan | Architect | technical-planner, (adr-writer) | → Task Planner | ⚠ |
| Tasks | Task Planner | task-decomposer | → Developer | ✓ |
| Implement | Developer | (native Claude Code) | → QA Engineer | ✓ |
| Validate | QA Engineer | qa-validator, qa-fixer | → Review | ✓ |
| Review | Security, Code Reviewer | security-reviewer, code-reviewer | → Complete | ✓ |

---

## Result

**PASS** (with noted exception)

The Standard Flow chain is fully traceable from request to completion. All 8 phases have defined agents, skills, and handoffs. The example artifacts match expected templates.

**Exception:** `adr-writer` skill is referenced but not implemented. This affects Enterprise track more significantly but is noted for Standard track architectural decisions.

---

*Test completed: 2026-01-16*
