# Waivers and Overrides

This file records exceptions to constitution rules and shared standards. Managed by Sigil — edits between markers are overwritten.

## Active Overrides

<!-- Active overrides are checked at session start. Expired overrides are automatically marked. -->

| Article | Override | Reason | Approved By | Tracking | Expires | Status |
|---------|----------|--------|-------------|----------|---------|--------|
<!-- OVERRIDE_TABLE_START -->
<!-- OVERRIDE_TABLE_END -->

### Field Documentation

- **Article:** The constitution article being overridden (e.g., "Article 4: Security Mandates")
- **Override:** What the override changes (e.g., "Allow public endpoints without auth for /health and /status")
- **Reason:** Business justification for the exception
- **Approved By:** Who approved the override (email or name)
- **Tracking:** Link to ticket or decision record (e.g., "PROJ-456" or "ADR-023")
- **Expires:** Date the override expires (ISO format: YYYY-MM-DD), or "permanent"
- **Status:** `active`, `expired`, or `revoked`

### Example

| Article | Override | Reason | Approved By | Tracking | Expires | Status |
|---------|----------|--------|-------------|----------|---------|--------|
| Article 4: Security Mandates | Allow unauthenticated /health endpoint | Required by load balancer health checks | jane@example.com | PROJ-456 | permanent | active |
| Article 3: Testing Requirements | Reduce coverage target to 50% for MVP phase | Shipping deadline pressure, will restore after launch | pm@example.com | PROJ-789 | 2026-03-15 | active |

## Waiver Log

<!-- Historical record of all waivers. Append-only. -->

<!-- WAIVER_LOG_START -->
<!-- WAIVER_LOG_END -->
