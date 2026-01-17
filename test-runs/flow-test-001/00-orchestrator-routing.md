# Orchestrator Routing Decision

**Input:** "I want a feature that allows users to reset their password via email"
**Timestamp:** 2026-01-14T10:00:00Z

## Analysis
- Trigger words detected: "I want" (secondary trigger for Business Analyst), "feature" (primary trigger for Business Analyst)
- Current phase: Assessment
- Track assessment: Standard track - this feature involves email integration, security considerations (password handling), multiple user flows (request reset, receive email, set new password), and authentication system modifications. Not complex enough for Enterprise track, but too involved for Quick Flow.

## Routing Decision
- **Target Agent:** Business Analyst
- **Reason:** The request contains "feature" (primary trigger) and "I want" (secondary trigger), both of which map to Business Analyst with High priority. This is a new feature request that requires specification before any technical planning or implementation can begin. The Specify phase is the correct entry point for new feature development.
- **Phase entering:** Specify

## Handoff Initiated
Passing to Business Analyst with context:
- Feature type: User authentication/security enhancement
- Complexity: Standard track (moderate complexity, security considerations)
- User priority: Not specified (assume standard)

---

## Simulation Notes

This is a DRY-RUN artifact demonstrating the Orchestrator's routing logic. In a live workflow:

1. The Orchestrator would invoke the `complexity-assessor` skill to formally assess the track
2. The user would be asked to confirm the Standard track selection
3. Upon confirmation, the Business Analyst agent would receive this handoff and invoke the `spec-writer` skill
