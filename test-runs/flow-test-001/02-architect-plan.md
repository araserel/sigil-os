# Architect: Plan Phase (Simulation)

**Received from:** Business Analyst
**Timestamp:** 2026-01-14T10:02:00Z

## What I Would Do
1. Review specification from Business Analyst
2. Check constitution for constraints (Article 4 Security Mandates, Article 7 Accessibility)
3. Research email service integration patterns (if needed)
4. Invoke `technical-planner` skill
5. Create implementation plan at `/specs/001-password-reset/plan.md`
6. Document ADR for security approach if needed

## Simulated Plan Outline

### Technical Approach
Implement a secure token-based password reset flow using cryptographically random tokens with 1-hour expiration. The system will generate unique tokens stored in the database, send templated emails via the existing email service, and provide a secure form for password update with proper validation and rate limiting at the request layer.

### Files to Create/Modify
| File | Action | Purpose |
|------|--------|---------|
| `src/models/PasswordResetToken.ts` | Create | Define token entity with user relation, token hash, expiry, and used flag |
| `src/services/passwordResetService.ts` | Create | Core logic for token generation, validation, and password update |
| `src/api/routes/auth/reset-password.ts` | Create | API endpoints for request reset and confirm reset |
| `src/email/templates/password-reset.html` | Create | Email template with reset link and accessibility compliance |
| `src/middleware/rateLimiter.ts` | Modify | Add rate limiting configuration for password reset endpoints |
| `src/models/User.ts` | Modify | Add relation to PasswordResetToken entity |
| `src/api/routes/auth/index.ts` | Modify | Register new password reset routes |
| `tests/services/passwordResetService.test.ts` | Create | Unit tests for token generation, validation, expiry logic |

### Dependencies
None - using existing infrastructure. Email service and rate limiting middleware already in place per project context.

### Security Considerations
1. **Cryptographically secure tokens:** Use `crypto.randomBytes(32)` for token generation, store only hashed version in database
2. **Timing-safe comparison:** Use constant-time comparison when validating tokens to prevent timing attacks
3. **Single-use tokens:** Mark tokens as used immediately upon successful password reset, invalidate all other tokens for user
4. **Rate limiting:** Enforce 3 requests per hour per email address to prevent enumeration and abuse
5. **Generic responses:** Return identical responses for valid and invalid email addresses to prevent user enumeration

### Risk Assessment
- **Level:** Low
- **Reason:** Password reset is a well-understood pattern with established security practices. No novel technical challenges; using existing email infrastructure.
- **Mitigations:** Following OWASP guidelines for forgot password functionality, implementing all security considerations above, comprehensive test coverage for edge cases.

## Constitution Gate Check
- [x] Article 4 (Security Mandates): Pass - All security best practices implemented, no secrets in code, tokens properly hashed
- [x] Article 5 (Architecture Principles): Pass - Simple service-based approach, no over-engineering, follows existing patterns
- [x] Article 7 (Accessibility): Pass - Email template will include proper text alternatives, reset form will have proper labels, focus management, and error announcements

## ADR Consideration
An ADR may be warranted for the token storage decision: storing hashed tokens vs. encrypted tokens. The recommendation is hashed (one-way) since we only need to verify equality, not retrieve the original value. This is a security-relevant architectural decision that affects future maintenance.

**ADR Title:** "ADR-001: Password Reset Token Storage Strategy"

## Handoff to Task Planner
- **Artifacts I would pass:** plan.md, ADR-001 (token storage)
- **Context:** Low risk, standard security implementation, no new dependencies required
- **Ready for breakdown:** Yes
