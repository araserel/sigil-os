# Clarifications: User Authentication

**Feature ID:** 001-user-auth
**Clarification Rounds:** 2
**Status:** Complete
**Last Updated:** 2024-01-16

---

## Round 1

### Q1: Password Requirements

**Question:** What are the minimum password requirements?

**Options:**
- A) 8 characters minimum, no other requirements
- B) 8 characters with at least 1 number
- C) 8 characters with 1 number and 1 special character
- D) Custom requirements

**Answer:** C - 8 characters with 1 number and 1 special character

**Rationale:** Balances security with usability. Too strict and users write passwords down; too lenient and accounts are easily compromised.

**Spec Impact:** Updated FR-003 with specific requirements.

---

### Q2: Session Duration

**Question:** How long should user sessions last?

**Options:**
- A) Until browser closes
- B) 24 hours
- C) 7 days
- D) 30 days (with refresh)

**Answer:** B - 24 hours

**Rationale:** Security is more important than convenience for this application. Users on shared computers need protection.

**Spec Impact:** Updated FR-005 with 24-hour session duration.

---

### Q3: Password Reset Flow

**Question:** What should happen when a user requests a password reset?

**Options:**
- A) Send email with reset link, user sets new password
- B) Send email with temporary password
- C) Security questions then reset
- D) Contact support

**Answer:** A - Send email with reset link

**Rationale:** Industry standard approach. Temporary passwords can be intercepted; security questions are often guessable.

**Spec Impact:** Added FR-007 with email-based reset flow.

---

### Q4: Failed Login Handling

**Question:** How should the system handle failed login attempts?

**Options:**
- A) Always show generic "invalid credentials" message
- B) Tell user whether email or password was wrong
- C) Show generic message but rate limit after 5 attempts
- D) Lock account after 3 failed attempts

**Answer:** C - Show generic message but rate limit after 5 attempts

**Rationale:** Specific errors help attackers enumerate valid emails. Rate limiting prevents brute force without frustrating legitimate users who mistype.

**Spec Impact:** Added NFR-004 for rate limiting, updated FR-008 for error messages.

---

## Round 2

### Q5: OAuth Providers

**Question:** Which social login providers should be supported?

**Options:**
- A) Google only
- B) Google and GitHub
- C) Google, GitHub, and Microsoft
- D) None for initial release

**Answer:** A - Google only (as P3)

**Rationale:** Google covers most users. Additional providers add complexity without proportional value. Can add more later.

**Spec Impact:** FR-009 updated to specify Google OAuth only as P3.

---

### Q6: Email Verification

**Question:** Should email verification be required before users can access the app?

**Options:**
- A) Yes, block access until verified
- B) No, but track verification status
- C) Optional, user chooses

**Answer:** B - Track status but don't block

**Rationale:** Verification friction causes drop-off. We'll track for future features (like password reset) but not block initial access.

**Spec Impact:** User entity updated with `emailVerified` field. Added to Out of Scope that verification is not blocking.

---

### Q7: Two-Factor Authentication

**Question:** How should 2FA be implemented?

**Options:**
- A) SMS codes
- B) Authenticator app (TOTP)
- C) Email codes
- D) Skip for initial release

**Answer:** B - Authenticator app (TOTP), as P3

**Rationale:** SMS is less secure (SIM swapping). Authenticator apps are free and widely used. Making it P3 allows focus on core auth first.

**Spec Impact:** Added US-008 and FR-010 as P3 priority.

---

## Summary of Changes

| Spec Section | Change Made |
|--------------|-------------|
| FR-003 | Added specific password requirements |
| FR-005 | Set session duration to 24 hours |
| FR-007 | Added password reset via email |
| FR-008 | Updated error message approach |
| FR-009 | Specified Google OAuth only |
| FR-010 | Added TOTP-based 2FA as P3 |
| NFR-004 | Added rate limiting requirement |
| User Entity | Added emailVerified field |
| Out of Scope | Clarified email verification not blocking |

---

## Remaining Ambiguities

None. All questions resolved. Specification is ready for planning phase.

---

*Clarification complete: 2024-01-16*
