# Orchestrator: Escalation Handler

**Received from:** QA Engineer (qa-fixer)
**Timestamp:** 2026-01-14T16:10:00Z
**Escalation Type:** Constitution Violation - Architectural Decision Required

## Escalation Context

| Field | Value |
|-------|-------|
| Feature | Password Reset (001-password-reset) |
| Task | T007 - POST /auth/forgot-password |
| Phase | Validate |
| Issue | CONST-001 - Direct DB access in route handler |
| Blocker | Cannot auto-fix - requires human decision |

## Escalation Path

```
Developer (submitted code)
    ↓
qa-validator (detected violation)
    ↓
qa-fixer (analyzed, cannot fix autonomously)
    ↓
Orchestrator (you are here)
    ↓
Human (decision required)
```

## What I Would Do

1. Receive escalation from qa-fixer
2. Validate escalation is appropriate (not premature)
3. Format decision request for human readability
4. Present options with clear trade-offs
5. Pause workflow until human responds
6. Route decision back to qa-fixer

## Escalation Validation

### Is This Escalation Appropriate?

| Check | Result | Notes |
|-------|--------|-------|
| Is issue real? | YES | Constitution Article 5 clearly violated |
| Was auto-fix attempted? | YES | qa-fixer analyzed but could not resolve |
| Are there options? | YES | 4 options identified with trade-offs |
| Is human judgment needed? | YES | Architectural choice required |
| Is loop budget exhausted? | NO | 1 of 5 iterations used |

**Escalation validated:** This is a legitimate escalation, not a premature exit.

### Why Not Just Pick an Option?

The QA Engineer recommended Option A, but cannot execute because:

1. **Constitution Principle:** "Agents respect boundaries without being reminded" - but violations require explicit human acknowledgment
2. **Human Tier Classification:** Constitution violations are "Review" tier minimum
3. **Scope Impact:** Creating a new service affects project structure
4. **Precedent Setting:** Decision affects how future features are implemented

## Workflow State

```json
{
  "chain_id": "flow-test-004",
  "feature": "001-password-reset",
  "task": "T007",
  "phase": "Validate",
  "status": "PAUSED",
  "paused_reason": "awaiting_human_decision",
  "qa_iteration": 1,
  "escalation": {
    "type": "constitution_violation",
    "issue_id": "CONST-001",
    "options": ["A", "B", "C", "D"],
    "recommendation": "A"
  }
}
```

## Human Decision Request

Formatting decision request for human review...

---

## Handoff to Human

**Escalation ID:** ESC-004-001
**Priority:** Medium (blocks task completion, not critical path)
**Timeout:** None (will wait for human response)

### Decision Request Format

The following will be presented to the human:

```
┌─────────────────────────────────────────────────────────────────┐
│  DECISION REQUIRED: Architecture Pattern for Password Reset     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Task T007 (forgot-password endpoint) violates the project      │
│  constitution. The developer used direct database queries       │
│  instead of the service layer pattern.                          │
│                                                                 │
│  Constitution Article 5 states:                                 │
│  "No direct database access from route handlers"                │
│                                                                 │
│  This needs to be fixed, but there are multiple valid           │
│  approaches. Please choose one:                                 │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  OPTION A: Create PasswordResetService (Recommended)            │
│  ─────────────────────────────────────────────────              │
│  Create a new dedicated service for password reset logic.       │
│  • Pros: Clean separation, matches existing patterns            │
│  • Cons: New file, more initial setup                           │
│  • Effort: Medium                                               │
│                                                                 │
│  OPTION B: Extend AuthService                                   │
│  ─────────────────────────────────────────────────              │
│  Add password reset methods to existing auth service.           │
│  • Pros: Fewer files, keeps auth together                       │
│  • Cons: AuthService grows larger                               │
│  • Effort: Low                                                  │
│                                                                 │
│  OPTION C: Use Repositories Directly                            │
│  ─────────────────────────────────────────────────              │
│  Call repositories from route (no service layer).               │
│  • Pros: Simpler, less indirection                              │
│  • Cons: May not satisfy constitution intent                    │
│  • Effort: Low                                                  │
│                                                                 │
│  OPTION D: Waive Violation                                      │
│  ─────────────────────────────────────────────────              │
│  Accept current code as-is (exception to constitution).         │
│  • Pros: No code changes needed                                 │
│  • Cons: Sets precedent, weakens constitution                   │
│  • Effort: None                                                 │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  AI Recommendation: Option A                                    │
│  Rationale: Best matches existing codebase patterns and         │
│  provides clean separation for future password features.        │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Your choice: [A] [B] [C] [D]                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## After Human Decision

Once human chooses, the flow continues:

| Human Choice | Next Action |
|--------------|-------------|
| A | qa-fixer creates PasswordResetService, refactors route |
| B | qa-fixer adds methods to AuthService, refactors route |
| C | qa-fixer uses repositories in route (with justification) |
| D | qa-validator marks violation as waived, proceeds |

Then: qa-validator re-runs → should PASS → continue to Review phase

## Observation

This escalation demonstrates:
1. Orchestrator validates escalation before forwarding to human
2. Decision formatted for non-technical readability
3. Clear options with trade-offs presented
4. AI recommendation included but human decides
5. Workflow paused (not failed) pending input
6. Clear next steps defined for each possible decision
