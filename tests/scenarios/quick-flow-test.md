# Test: Quick Flow End-to-End

## Scenario

**Request:** "Fix the typo in the login button where it says 'Pasword' instead of 'Password'"

**Expected Track:** Quick Flow (simple, single-file fix)

---

## Preconditions

- [x] Constitution exists at `/memory/constitution.md`
- [x] Project context exists at `/memory/project-context.md`
- [x] No active workflow in progress

---

## Step 1: Request Receipt

**Action:** User submits: "Fix the typo in the login button where it says 'Pasword'"

**Expected:** Orchestrator receives and routes to complexity assessment.

**Verified:** ✓
- Orchestrator trigger words: None match specifically
- Default behavior: New request → invoke complexity-assessor
- Per `orchestrator.md:134-139`: "When starting a new feature, invoke complexity-assessor"

**Notes:** Request routed correctly to assessment phase.

---

## Step 2: Complexity Assessment

**Action:** `complexity-assessor` skill evaluates request

**Expected Scoring (per complexity-assessor.md:66-76):**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Scope | 1 | Single capability (fix typo) |
| Files | 1 | 1 file affected |
| Dependencies | 1 | No new dependencies |
| Data Changes | 1 | No data changes |
| Integration | 1 | No integration points |
| Risk | 1 | Easily reversible |
| Ambiguity | 1 | Crystal clear requirement |
| **Total** | **7** | |

**Track Determination:** 7/21 → Quick Flow (per complexity-assessor.md:80-83)

**Verified:** ✓
- Score 7 correctly maps to Quick Flow
- No override triggers apply (not security, database, etc.)
- Example in complexity-assessor.md:237-251 matches this pattern exactly

**Output:**
```json
{
  "recommended_track": "quick",
  "confidence": "high",
  "total_score": 7,
  "user_confirmed": true,
  "rationale": "Single file, single change, no dependencies, crystal clear"
}
```

**Notes:** Track confirmation is Auto tier (per quick-flow.md:148) — no blocking approval needed.

---

## Step 3: Quick Spec Generation

**Action:** Generate lightweight specification (inline, not persisted)

**Expected Format (per quick-flow.md:67-87):**

```markdown
# Quick Spec: Fix Login Button Typo

**Type:** Bug Fix
**Files Affected:** 1 file (login component)

## What
Fix typo in login button text where "Pasword" should be "Password".

## Why
User-facing spelling error affects perceived quality.

## Acceptance
- [ ] Button displays "Password" correctly
- [ ] No other text changes

## Out of Scope
- Any functionality changes
- Any other UI modifications
```

**Verified:** ✓
- Format matches quick-flow.md template
- Inline generation (not persisted to `/specs/`)
- All fields populated appropriately

**Notes:** Quick spec is intentionally lightweight — no separate clarification phase.

---

## Step 4: Task Decomposition

**Action:** `task-decomposer` breaks spec into tasks

**Expected (per quick-flow.md:91-104):**

```markdown
## Tasks

- [ ] T1: Locate typo in login component
- [ ] T2: Fix "Pasword" → "Password"
- [ ] T3: Verify fix displays correctly
```

**Constraints Applied:**
- Maximum 5 tasks (per quick-flow.md:95)
- No phase structure (flat list)
- Minimal documentation

**Verified:** ✓
- 3 tasks < 5 maximum
- Flat list format correct
- Dependencies implicit (sequential)

**Notes:** Task count well within Quick Flow limits.

---

## Step 5: Implementation

**Action:** Developer agent executes tasks

**Process (per developer.md):**

1. **Receive Task:** T1 - Locate typo
   - Read file structure
   - Find login component
   - Identify string with "Pasword"

2. **Execute Fix:** T2 - Fix typo
   - Modify file: Change "Pasword" to "Password"
   - Single line change

3. **Verify:** T3 - Visual check
   - Confirm text displays correctly

**Test-First Applicability:**
- Per task.md: "Test First: No" for copy changes
- No new tests required for typo fix

**Verified:** ✓
- Developer follows established patterns
- Minimal change principle applied
- No scope expansion

**Expected Artifacts:**
- Single file modified (e.g., `LoginButton.tsx`)
- No new files created
- No tests added (appropriate for typo fix)

**Notes:** Implementation straightforward, stays within scope.

---

## Step 6: QA Validation

**Action:** `qa-validator` runs checks

**Checks Performed (per qa-validator.md):**

1. **Unit Tests:** Run existing tests
   - Expected: All pass (change doesn't affect behavior)

2. **Lint/Format:** Check code style
   - Expected: Clean (string change only)

3. **Type Check:** Verify types
   - Expected: Pass (no type changes)

4. **Requirements Coverage:** Verify acceptance criteria
   - Expected: Button displays "Password" ✓

**Quick Flow Behavior (per quick-flow.md:106-113):**
- Abbreviated validation
- Single fix attempt if issues
- No formal requirements coverage map

**Verified:** ✓
- Validation checks appropriate for change type
- Quick Flow allows single fix attempt before escalation
- Acceptance criteria verifiable

**Expected Output:**
```json
{
  "status": "pass",
  "checks": [
    {"name": "unit_tests", "status": "pass"},
    {"name": "lint", "status": "pass"},
    {"name": "type_check", "status": "pass"}
  ],
  "next_action": "complete"
}
```

**Notes:** No QA fix loop expected for clean typo fix.

---

## Step 7: Completion

**Action:** Workflow completes

**Expected (per quick-flow.md:57-60):**
- No code review phase (Quick Flow skips formal review)
- No security review (not security-related)
- Direct completion

**Completion Message:**
```
Quick Flow complete.

**Change:** Fixed login button typo ("Pasword" → "Password")
**Files Modified:** LoginButton.tsx
**Tests:** All passing

Change is ready for deployment.
```

**Verified:** ✓
- Workflow terminates correctly
- No unnecessary review phases
- User informed of completion

**Context Update:**
- Project context updated with completion status
- Recent Activity logged

---

## Artifacts Produced

| Artifact | Location | Status |
|----------|----------|--------|
| Quick Spec | Inline (not persisted) | Generated |
| Task List | Inline (not persisted) | Generated |
| Code Change | `LoginButton.tsx` | Modified |
| Validation Report | N/A (Quick Flow skips) | Skipped |

---

## Handoff Data Flow

```
User Request
    ↓
Orchestrator
    ↓ [invoke]
complexity-assessor
    ↓ [returns: track=quick]
Orchestrator
    ↓ [Quick Flow chain]
quick-spec (inline in spec-writer)
    ↓
task-decomposer (simplified)
    ↓
Developer Agent
    ↓ [task complete]
qa-validator (abbreviated)
    ↓ [pass]
Complete
```

**State Transfer (if formalized):**
```json
{
  "chain_id": "qf-001",
  "track": "quick",
  "iteration_counts": {
    "clarifier": 0,
    "qa_fixer": 0
  }
}
```

---

## Issues Found

| ID | Severity | Description | Location | Status |
|----|----------|-------------|----------|--------|
| None | — | No issues found in Quick Flow trace | — | — |

---

## Edge Cases Tested

### 1. Scope Expansion Detection

**Scenario:** During implementation, developer finds multiple typos.

**Expected Behavior (per quick-flow.md:157-163):**
1. Pause implementation
2. Notify: "This looks more complex than expected"
3. Offer: Switch to Standard track OR continue with risk

**Verified:** ✓ — Escalation path documented

### 2. Single Fix Failure

**Scenario:** Validation fails after fix.

**Expected Behavior (per quick-flow.md:165-171):**
1. Don't loop — escalate immediately
2. Present issue summary
3. Options: Human fixes OR switch to Standard

**Verified:** ✓ — Quick Flow limits to 1 fix attempt

### 3. Missing Tests

**Scenario:** No existing tests for login component.

**Expected Behavior (per quick-flow.md:173-179):**
1. Note: "No existing tests to verify"
2. Suggest manual verification
3. Don't block completion

**Verified:** ✓ — Graceful handling for untested code

---

## Result

**PASS**

The Quick Flow chain is fully traceable from request to completion. All components are properly defined, handoffs are clear, and edge cases are handled appropriately.

---

## Validation Summary

| Aspect | Status |
|--------|--------|
| Complexity Assessment | ✓ Correctly identifies Quick Flow |
| Quick Spec Generation | ✓ Format matches template |
| Task Decomposition | ✓ Within limits, appropriate structure |
| Implementation | ✓ Follows developer patterns |
| QA Validation | ✓ Abbreviated checks, single fix policy |
| Completion | ✓ Proper workflow termination |
| Edge Case Handling | ✓ Escalation paths defined |

---

*Test completed: 2026-01-16*
