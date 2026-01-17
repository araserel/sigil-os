# Test: Edge Case Scenario Testing

## Overview

This test validates handling of unusual or error scenarios that may occur during Prism OS workflows.

---

## Edge Case 1: Ambiguous Request Routing

### Scenario

**Request:** "Help me with the thing we discussed"

**Problem:** No context, no clear trigger words, ambiguous intent.

---

### Expected Handling

**Per orchestrator.md:289-299 (Error Handling - Unknown Request Type):**

```markdown
"I'm not sure which agent should handle this. Could you clarify:
- Are you asking about requirements/specifications? (Business Analyst)
- Are you asking about technical design? (Architect)
- Are you asking about task breakdown? (Task Planner)
- Something else?"
```

**Per CLAUDE.md:574 (Ambiguous Request Handling):**
- Option A: Route to phase owner (if in active phase)
- Option B: Route to most specific keyword match
- Option C: Ask user to clarify intent

**Default:** Option B, with Option C for truly ambiguous cases.

---

### Trace

1. **Orchestrator receives request**
   - Trigger words: "help" → matches Orchestrator (fallback)
   - Context: "the thing we discussed" — no specificity

2. **Check workflow state**
   - If active phase exists → Route to phase owner
   - If no active phase → Request clarification

3. **Response:**
   ```
   I don't have context for "the thing we discussed."

   Could you clarify what you're looking for?
   - A feature specification
   - Technical design help
   - Task breakdown
   - Status on current work
   ```

**Verified:** ✓ — Clarification path documented

---

### Issues Found

| ID | Severity | Description | Status |
|----|----------|-------------|--------|
| None | — | Handling properly defined | — |

---

## Edge Case 2: QA Loop Max Iterations

### Scenario

**Situation:** QA validation fails 5 consecutive times.

**Problem:** Automated fix attempts exhausted.

---

### Expected Handling

**Per error-handling.md:224-235 (Iteration Limits):**

| Operation | Limit | On Exceed |
|-----------|-------|-----------|
| QA fix cycles | 5 | Escalate to Orchestrator |

**Per qa-engineer.md:309-321 (Escalation):**

```markdown
"T### validation failing after 5 fix attempts.

**Persistent issues:**
- [Issue 1]: Tried [approaches], still failing
- [Issue 2]: Root cause unclear

**Analysis:**
This appears to be [code problem / test problem / environment / requirement issue].

**Recommendation:**
[Specific recommendation based on analysis]

Escalating for human review."
```

**Per full-pipeline.md:192-200 (Error Handling - QA Loop Exceeded):**

```
If qa_iteration >= 5 AND issues remain:
  1. Generate summary of persistent issues
  2. Categorize as: code problem vs. test problem vs. environment
  3. Escalate to human with recommendations
```

---

### Trace

1. **qa-validator detects issues** → Iteration 1
2. **qa-fixer attempts fix** → Re-validate
3. **Still failing** → Iterations 2-5 repeat
4. **Iteration 5 fails**:
   - qa-validator returns `iteration: 5, status: fail`
   - Check: `iteration >= 5` → TRUE

5. **Escalation triggered:**
   - Generate issue summary
   - Categorize root cause
   - Format for human review
   - Update context: Add to Blockers section

6. **Human receives:**
   ```markdown
   ## Escalation Required

   **From:** QA Engineer
   **Issue:** Validation failing after 5 attempts
   **Tried:** Auto-fix on lint errors, test adjustments, ...

   **Options:**
   1. Review code manually for deeper issues
   2. Revise requirements that may be conflicting
   3. Escalate to Architect for design review

   **Recommendation:** Option 1 — code may have logic error
   ```

**Verified:** ✓ — Escalation path complete

---

### Issues Found

| ID | Severity | Description | Status |
|----|----------|-------------|--------|
| None | — | Loop limit and escalation properly defined | — |

---

## Edge Case 3: Constitution Violation

### Scenario

**Situation:** Plan proposes using MongoDB, but constitution specifies PostgreSQL.

**Problem:** Technical approach violates project rules.

---

### Expected Handling

**Per architect.md:254-268 (Error Handling - Constitution Conflict):**

```markdown
"The requested approach conflicts with your project constitution:
- Request: [What was asked]
- Constitution: [What's required]
- Options:
  - A) Adjust approach to meet constitution
  - B) Consider amending constitution (significant)

I recommend Option A: [adjusted approach]."
```

**Per full-pipeline.md:203-208 (Constitution Not Found):**
- Prompts for constitution creation if missing
- But if constitution exists, violations are flagged

**Per CLAUDE.md:590 (Escalation Protocol):**
- Constitution violation requires escalation
- Work pauses until resolved

---

### Trace

1. **Architect receives spec** for feature requiring database

2. **technical-planner generates plan:**
   - Proposes MongoDB for document storage

3. **Constitution gate check (per architect.md:139-160):**
   - Article 1: Technology Stack
   - Check: Does MongoDB match constitution?
   - Constitution states: "Database: PostgreSQL 15"
   - Result: **VIOLATION**

4. **Architect responds:**
   ```markdown
   ## Constitution Conflict Detected

   **Issue:** Proposed database doesn't match constitution

   **Proposed:** MongoDB (document store)
   **Constitution (Article 1):** PostgreSQL 15

   **Options:**
   A) Adjust approach — Use PostgreSQL with JSONB for document-like storage
   B) Amend constitution — Change database technology (requires approval)

   **Recommendation:** Option A

   PostgreSQL's JSONB type can handle document-like storage while
   maintaining constitution compliance. This is the simpler path.

   Would you like to proceed with Option A, or discuss amending
   the constitution?
   ```

5. **Human decides:**
   - If Option A → Architect revises plan
   - If Option B → Constitution amendment process (significant change)

**Verified:** ✓ — Violation detection and resolution path defined

---

### Issues Found

| ID | Severity | Description | Status |
|----|----------|-------------|--------|
| None | — | Constitution compliance checking properly defined | — |

---

## Edge Case 4: Scope Creep Detection

### Scenario

**Situation:** During T010 implementation, developer discovers need for a new API endpoint not in original spec.

**Problem:** Scope expansion during implementation.

---

### Expected Handling

**Per developer.md:345-358 (Escalation Triggers):**

> Escalate to Orchestrator when:
> - Breaking changes to unrelated code needed
> - Task significantly more complex than estimated

**Per developer.md:46-49 (Guiding Principles - Minimal Changes):**

> - Change only what the task requires
> - Don't add "improvements" beyond scope
> - If you see issues, note them for later tasks

**Per CLAUDE.md:977-978 (Escalation Triggers):**

> Scope change detected: Implementation would modify files outside approved scope

---

### Trace

1. **Developer working on T010:** Build RegisterForm component

2. **Discovery:** Realizes registration needs a new API endpoint `/api/auth/check-email` to verify email uniqueness

3. **Scope check:**
   - Is `/api/auth/check-email` in the plan? → No
   - Is it in the spec? → Not explicitly
   - Would adding it expand scope? → Yes

4. **Developer response:**
   ```markdown
   ## Scope Expansion Detected

   **Task:** T010 - Build RegisterForm component
   **Discovery:** Registration form needs email uniqueness check

   **Required but not in plan:**
   - New endpoint: `/api/auth/check-email`
   - New validation logic

   **Options:**
   A) Add as new task (T019) and update plan
   B) Include in current task (scope expansion)
   C) Defer — implement without uniqueness check now, add later

   **Impact of each option:**
   - A: Adds 1 task, maintains clean boundaries
   - B: Current task grows, but stays cohesive
   - C: Technical debt, potential duplicate registrations

   **Recommendation:** Option A — Add as T019 after T005 (API route),
   before T010 resumes.
   ```

5. **Escalation to Task Planner:**
   - Task Planner adds T019
   - Updates dependency graph
   - T010 paused, T019 inserted
   - Developer resumes after T019 complete

**Verified:** ✓ — Scope creep detection and handling defined

---

### Issues Found

| ID | Severity | Description | Status |
|----|----------|-------------|--------|
| None | — | Scope management properly addressed | — |

---

## Edge Case 5: Hard Failure Recovery

### Scenario

**Situation:** `technical-planner` skill encounters a fatal error — cannot read required file.

**Problem:** Blocking error prevents workflow continuation.

---

### Expected Handling

**Per error-handling.md:87-113 (Blocking Errors):**

```
On blocking error:
1. HALT all workflow operations
2. Document error with full context
3. Notify human immediately
4. Do NOT attempt workarounds
5. Resume only when blocker resolved
```

**Error Context JSON (per error-handling.md:119-158):**

```json
{
  "error_id": "ERR-20250116-001",
  "error_category": "blocking",
  "error_code": "BLOCK-001",
  "error_source": {
    "agent": "Architect",
    "skill": "technical-planner",
    "phase": "Plan"
  },
  "error_details": {
    "message": "Cannot read required file",
    "location": "/specs/001-user-auth/spec.md",
    "expected": "File accessible and readable",
    "actual": "File not found or permission denied"
  },
  "recovery_attempted": [],
  "suggested_recovery": [
    {
      "option": "A",
      "description": "Verify file exists and has correct permissions",
      "impact": "Workflow can resume immediately if file found",
      "recommended": true
    },
    {
      "option": "B",
      "description": "Regenerate spec from Business Analyst",
      "impact": "Returns to Specify phase, loses any existing spec",
      "recommended": false
    }
  ]
}
```

---

### Trace

1. **Architect invokes technical-planner**

2. **Skill attempts to read spec.md:**
   - File operation fails
   - Error: "ENOENT: no such file or directory"

3. **Error categorization:**
   - Missing artifact → BLOCK-001
   - Category: Blocking

4. **Immediate response:**
   ```markdown
   ## Blocking Error

   **What happened:**
   The implementation plan cannot be created because the specification
   file is missing or inaccessible.

   **Impact:**
   Planning cannot proceed. Work is halted.

   **Options:**
   A) Check if /specs/001-user-auth/spec.md exists and fix if needed
   B) Return to Specify phase and regenerate specification

   **Recommendation:** Option A — file may have been moved or renamed.

   **To proceed:**
   Please verify the specification file exists at the expected location.
   ```

5. **Context update:**
   - Blockers section: Add blocking error
   - Status: Blocked
   - Next Human Touchpoint: Resolve file issue

6. **Resolution flow:**
   - Human fixes file issue
   - Architect re-attempts technical-planner
   - Success → Continue workflow
   - Blocker moved to Resolved Blockers

**Verified:** ✓ — Blocking error handling defined

---

### Issues Found

| ID | Severity | Description | Status |
|----|----------|-------------|--------|
| None | — | Error recovery path properly defined | — |

---

## Edge Case 6: Human Override

### Scenario

**Situation:** User disagrees with Architect's database session recommendation (ADR-001).

**Problem:** User wants JWT-only despite agent recommendation.

---

### Expected Handling

**Per CLAUDE.md:86-87 (Core Principle 5 - Human-in-the-Loop):**

> - **Approve:** Production deployments, security changes... work pauses until approved

**Per architect.md:270-280 (Human Checkpoint):**

> Plans require user review before implementation:
> - Technical feasibility confirmed
> - Approach acceptable to user
> - Risks acknowledged

**Per CLAUDE.md:943-968 (Presenting Technical Choices):**

> When a technical decision is needed, present it as options with trade-offs.

---

### Trace

1. **Architect presents ADR-001:**
   ```markdown
   ## Decision Needed: Session Storage

   **Context:** How should user sessions be stored?

   **Options:**

   ### Option A: Database Sessions (Recommended)
   - **What it means:** Session data stored in PostgreSQL
   - **Pros:** Immediate revocation, "log out all devices" capability
   - **Cons:** Slightly more database load
   - **Best for:** Applications requiring session control

   ### Option B: JWT-Only
   - **What it means:** All session data in encrypted token
   - **Pros:** Stateless, no database queries for auth
   - **Cons:** Cannot revoke sessions until token expires
   - **Best for:** Simple applications, microservices

   **My Recommendation:** Option A because your constitution
   requires PostgreSQL and security is a priority.

   **Your choice?**
   ```

2. **User responds:** "I want JWT-only (Option B)"

3. **Architect acknowledges override:**
   ```markdown
   ## Decision Recorded: JWT-Only Sessions

   You've chosen Option B (JWT-only) for session management.

   **Noted trade-offs:**
   - Sessions cannot be revoked until token expires
   - "Log out all devices" not possible without additional work
   - Token expiry will be the only logout mechanism

   **Impact on plan:**
   - Remove session table from data model
   - Simplify auth configuration
   - Add token expiry handling

   **Constitution check:** This is still compatible — JWT is a valid
   auth approach within your stack.

   Proceeding with JWT-only sessions as directed.
   ```

4. **Context update:**
   - Session Notes → Key Decisions Made: "JWT-only sessions (user override)"
   - Plan updated to reflect user choice
   - ADR-001 updated with decision and rationale

5. **Override respected:**
   - Architect proceeds with user's choice
   - No blocking or repeated warnings
   - Trade-offs documented for future reference

**Verified:** ✓ — Human override path respected

---

### Issues Found

| ID | Severity | Description | Status |
|----|----------|-------------|--------|
| None | — | Override mechanism properly handles user autonomy | — |

---

## Summary

| Edge Case | Scenario | Expected Handling | Status |
|-----------|----------|-------------------|--------|
| 1 | Ambiguous request | Ask for clarification | ✓ Pass |
| 2 | QA loop exhausted | Escalate with analysis | ✓ Pass |
| 3 | Constitution violation | Present options, recommend compliant path | ✓ Pass |
| 4 | Scope creep | Detect, propose task addition | ✓ Pass |
| 5 | Hard failure | Halt, document, notify human | ✓ Pass |
| 6 | Human override | Acknowledge, document trade-offs, proceed | ✓ Pass |

---

## Issues Found (Overall)

| ID | Severity | Description | Location | Status |
|----|----------|-------------|----------|--------|
| None | — | All edge cases have defined handling | — | — |

---

## Result

**PASS**

All 6 edge case scenarios have properly defined handling paths. The system:

1. **Handles ambiguity** by requesting clarification
2. **Respects iteration limits** with proper escalation
3. **Enforces constitution** while offering alternatives
4. **Detects scope creep** and proposes controlled expansion
5. **Recovers from failures** with clear guidance
6. **Respects human decisions** even when overriding recommendations

---

*Test completed: 2026-01-16*
