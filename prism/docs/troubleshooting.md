# Troubleshooting Guide

> Solutions for common issues encountered when using Prism.

This guide helps you diagnose and resolve problems you may encounter during your Prism workflow. Each section covers a specific issue with symptoms, causes, and solutions.

---

## Quick Diagnosis

Use this table to quickly identify your issue and find the relevant section:

| Symptom | Likely Cause | Quick Fix | Section |
|---------|--------------|-----------|---------|
| "Maximum clarification rounds reached" | Vague requirements | Simplify scope | [Clarification Limits](#clarification-limits) |
| "QA validation failed after 5 attempts" | Fundamental design issue | Review with tech lead | [QA Loop Issues](#qa-loop-issues) |
| Unexpected output format | Context confusion | Start fresh | [Unexpected Output](#unexpected-output) |
| Missing context from previous session | Session state issue | Check context files | [Session Recovery](#session-recovery) |
| Feature takes wrong direction | Unclear initial description | Restart with better spec | [Wrong Direction](#wrong-direction) |

---

## Clarification Limits

### Problem: "Maximum clarification rounds reached"

**What You See:**

```
Clarification round 3 of 3 complete.
Maximum clarification cycles reached.
Some ambiguities may remain unresolved.
```

**What's Happening:**

Prism allows a maximum of 3 clarification rounds. If ambiguities still exist after 3 rounds, the system cannot proceed automatically.

**Why This Happens:**

1. **Initial description too vague** — Not enough detail to build a complete specification
2. **Conflicting requirements** — Two requirements that can't both be satisfied
3. **Scope too large** — Trying to do too much in one feature
4. **Unclear answers** — Clarification responses that don't fully resolve the question

**How to Fix:**

**Option 1: Simplify the Scope**

Break your feature into smaller pieces. Instead of:
> "Build a complete user management system"

Try:
> "Add user registration with email and password"

Then create separate features for login, profile management, and admin controls.

**Option 2: Provide Direct Answers**

When answering clarification questions, be as specific as possible:

Instead of:
> "Maybe option B, but it depends"

Try:
> "Option B. We need password reset via email because our users frequently forget passwords."

**Option 3: Start Fresh with More Detail**

Re-run `/spec` with a more detailed description that anticipates common questions:

Instead of:
> "Add a contact form"

Try:
> "Add a contact form with name, email, and message fields. Show confirmation on submit. Send email copy to user. Use honeypot spam protection. Form must work on mobile and meet accessibility standards."

**How to Prevent:**

- Write detailed initial descriptions
- Include context about your users and business goals
- Specify constraints you already know
- Answer clarification questions with specific choices, not "it depends"

---

## QA Loop Issues

### Problem: "QA validation failed after 5 attempts"

**What You See:**

```
QA fix cycle 5 of 5 complete.
Maximum fix attempts exceeded.
Escalating to human review.
```

**What's Happening:**

When implementing a feature, the QA validation found issues that couldn't be automatically fixed after 5 attempts. This usually indicates a fundamental problem rather than a simple bug.

**Why This Happens:**

1. **Contradictory requirements** — The spec asks for things that can't both be true
2. **Constitution conflict** — The implementation violates project rules
3. **Technical impossibility** — What's requested can't be done with current technology/constraints
4. **Incomplete specification** — Missing information needed for implementation

**How to Fix:**

**Step 1: Review the Error Details**

Run `/prism-status` to see what's failing:

```
/prism-status
```

Look for the specific validation that's failing repeatedly.

**Step 2: Consult Your Tech Lead**

Share the error details with your technical team. Common resolutions:

| Problem Type | Resolution |
|--------------|------------|
| Contradictory requirements | Prioritize one, remove the other |
| Constitution conflict | Update constitution or change approach |
| Technical limitation | Adjust requirements to what's possible |
| Missing information | Add details to specification |

**Step 3: Update and Retry**

After identifying the issue:
1. Update the specification if requirements need to change
2. Update the constitution if project rules need adjustment
3. Re-run `/prism-plan` and `/prism-tasks` with corrected information

**How to Prevent:**

- Review specifications with tech lead before planning
- Check constitution alignment during planning phase
- Keep individual features small and focused

---

## Unexpected Output

### Problem: Output doesn't match expectations

**What You See:**

- Specifications that miss key requirements you mentioned
- Plans that seem unrelated to your feature
- Tasks that don't align with the plan

**Why This Happens:**

1. **Context confusion** — Previous conversations affecting current output
2. **Ambiguous phrasing** — Your description interpreted differently than intended
3. **Missing constitution** — No project rules to guide output

**How to Fix:**

**Option 1: Start Fresh**

Begin a new session with a clean state:

```
/spec [your complete feature description]
```

Provide the full description without assuming context from previous sessions.

**Option 2: Check Your Constitution**

Ensure your constitution exists and is correct:

```
/constitution
```

Review the technology choices and standards. If they don't match your project, update them.

**Option 3: Be More Explicit**

Rephrase your description to leave no room for interpretation:

Instead of:
> "Make the dashboard better"

Try:
> "Add a filter to the dashboard that lets users show only items from the last 7 days. The filter should be a dropdown with options: Today, Last 7 Days, Last 30 Days, All Time."

**How to Prevent:**

- Always provide complete descriptions without assuming context
- Review specification output before proceeding to clarification
- Use concrete examples in your descriptions

---

## Session Recovery

### Problem: Context lost between sessions

**What You See:**

- Prism doesn't remember your previous work
- `/prism-status` shows no active features
- Asked to set up constitution again

**Why This Happens:**

1. **Context files missing** — The `/memory` directory files were deleted or moved
2. **File corruption** — Context files became corrupted
3. **Different working directory** — Started session from a different location

**How to Fix:**

**Step 1: Check Context Directory**

Your project should have a `/memory` directory containing context files. Verify it exists and contains files.

**Step 2: Check Working Directory**

Ensure you're running Prism from the same directory as before. The context is tied to the project location.

**Step 3: Manual Recovery**

If files are missing, you may need to:
1. Recreate your constitution with `/constitution`
2. Restart your feature with `/spec`

Previous specifications may exist in `/specs/` directory if they were completed.

**How to Prevent:**

- Don't delete the `/memory` directory
- Always start Prism from the same project directory
- Keep backups of important specifications

---

## Wrong Direction

### Problem: Feature implementation going in wrong direction

**What You See:**

- Plan includes approaches you didn't want
- Tasks are for features you didn't request
- Technical choices don't match your expectations

**Why This Happens:**

1. **Unclear initial description** — Prism filled in gaps with assumptions
2. **Missed clarification questions** — Important questions answered too quickly
3. **Constitution defaults** — Project rules guided decisions you didn't expect

**How to Fix:**

**If Caught Early (Before Tasks):**

1. Review the specification carefully with `/prism-status`
2. Run `/clarify` again to address specific concerns
3. Re-run `/prism-plan` after changes

**If Caught Late (During Implementation):**

1. Stop current implementation
2. Review what went wrong in the specification
3. Update the specification with corrected requirements
4. Re-generate plan and tasks

**How to Prevent:**

- Read specifications thoroughly before approving
- Take time with clarification questions — don't rush
- Review plans with your tech lead before creating tasks
- Ask questions if anything in the output is unclear

---

## Override Options

Sometimes you need to override Prism's decisions. Use these carefully.

### When Overrides Are Appropriate

| Situation | Override Action |
|-----------|-----------------|
| Constitution rule doesn't apply to this feature | Document exception in spec |
| Technical recommendation differs from team preference | Update requirements explicitly |
| Iteration limit reached but progress was made | Review and manually proceed |

### When NOT to Override

| Situation | Better Approach |
|-----------|-----------------|
| Security validation failing | Fix the security issue |
| Tests won't pass | Investigate root cause |
| Constitution conflict | Update constitution properly |

### How to Document Overrides

If you override a decision, document it in the specification:

```markdown
## Exceptions

**Exception:** Using JWT-only sessions instead of database sessions.
**Reason:** This feature is read-only and doesn't need session revocation.
**Approved by:** [Name, Date]
```

---

## Error Categories

Understanding error types helps you respond appropriately:

### Soft Errors (Auto-Recoverable)

**Examples:** Formatting issues, minor validation failures, network timeouts

**What Happens:** Prism automatically retries up to 3 times

**Your Action:** Usually none — these resolve automatically

### Hard Errors (Need Your Input)

**Examples:** Ambiguous requirements, multiple valid approaches, scope decisions

**What Happens:** Prism pauses and asks for your decision

**Your Action:** Review options and make a choice

### Blocking Errors (Full Stop)

**Examples:** Missing required files, critical security issues, circular dependencies

**What Happens:** All progress stops until resolved

**Your Action:** Address the root cause before proceeding

---

## Getting More Help

### Check Existing Documentation

- [User Guide](user-guide.md) — Comprehensive usage guide
- [Command Reference](command-reference.md) — Full command syntax
- [Example Walkthrough](examples/user-auth-feature/README.md) — Complete example

### Information to Gather Before Asking for Help

If you need to escalate an issue, gather:

1. **What command did you run?** Include the full input
2. **What output did you get?** Copy the complete response
3. **What did you expect?** Describe the expected behavior
4. **What's in your constitution?** Run `/constitution` and share the output
5. **What phase are you in?** Run `/prism-status` and share the output

### Common Questions

**Q: Can I undo a clarification answer?**
A: Not directly. Start fresh with `/spec` if you need to change fundamental decisions.

**Q: How do I change the track (Quick/Standard/Enterprise)?**
A: The track is selected based on feature complexity. Simplify your feature description for a simpler track.

**Q: Why does my feature keep getting split into multiple features?**
A: Your scope may be too large. This is often a sign to break it into separate, focused features.

**Q: Can I skip phases?**
A: No. The phases ensure completeness. Skipping phases leads to gaps that cause problems later.

---

## Summary

Most issues fall into these categories:

| Category | Common Cause | Solution |
|----------|--------------|----------|
| Clarification loops | Vague requirements | Be more specific upfront |
| QA failures | Design conflicts | Review with tech lead |
| Context issues | Session state | Check files, start fresh if needed |
| Wrong direction | Rushed review | Take time to review each phase output |

When in doubt:
1. Check `/prism-status` for current state
2. Review the specification for accuracy
3. Consult your tech lead for technical issues
4. Start fresh if context is corrupted

---

*For technical error handling details, developers can reference [Error Handling Protocol](error-handling.md).*
