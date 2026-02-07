# Troubleshooting Guide

> Take a breath. Most problems have a quick fix. This page walks you through the common ones step by step.

---

## Quick Diagnosis

Find your symptom in the table below and jump to the matching section.

| Symptom | Likely Cause | Quick Fix | Section |
|---------|--------------|-----------|---------|
| "Maximum clarification rounds reached" | Vague requirements | Simplify scope | [Clarification Limits](#clarification-limits) |
| "QA (quality check) validation failed after 5 attempts" | Design conflict | Review with tech lead | [Quality-Check Loop Issues](#quality-check-loop-issues) |
| Unexpected output format | Context mix-up | Start fresh | [Unexpected Output](#unexpected-output) |
| Missing context from a previous session | Session state issue | Check context files | [Session Recovery](#session-recovery) |
| Feature takes wrong direction | Unclear first description | Rewrite your description | [Wrong Direction](#wrong-direction) |

---

## Clarification Limits

### What You See

```
Clarification round 3 of 3 complete.
Maximum clarification cycles reached.
Some ambiguities may remain unresolved.
```

### Why This Happens

Prism allows up to 3 rounds of back-and-forth questions. After that, it stops asking. This usually means one of four things:

- The first description was too short or vague.
- Two requirements conflict with each other.
- The feature scope is too large for one pass.
- Answers to questions were unclear or partial.

### Fix 1 -- Shrink the Scope

Break the feature into smaller pieces.

Instead of:
> "Build a complete user management system"

Try:
> "Add user sign-up with email and password"

You can create separate features for login, profiles, and admin controls later.

### Fix 2 -- Give Direct Answers

When Prism asks a question, pick one clear option.

Instead of:
> "Maybe option B, but it depends"

Try:
> "Option B. We need password reset via email because our users often forget passwords."

### Fix 3 -- Start Over with More Detail

Run `/spec` again with a richer description. Try to answer common questions before they come up.

Instead of:
> "Add a contact form"

Try:
> "Add a contact form with name, email, and message fields. Show a success notice on submit. Send an email copy to the user. Use honeypot spam protection. The form must work on mobile and meet accessibility standards."

> **Tip:** Before you type `/spec`, write down three things: who uses the feature, what they do, and what they see when it works. That alone prevents most clarification loops.

---

## Quality-Check Loop Issues

### What You See

```
QA fix cycle 5 of 5 complete.
Maximum fix attempts exceeded.
Escalating to human review.
```

QA (quality assurance -- the step where Prism checks each task right after it is built) tried to fix an issue five times on a single task and could not.

### Why This Happens

This usually points to a deeper problem, not a simple bug.

- The requirements may ask for two things that contradict each other.
- The implementation may break a rule in your constitution (the file that holds your project's principles and standards).
- What was requested may not be possible with the current setup.
- The specification (your written feature description) may be missing key details.

### How to Fix

1. Run `/prism-status` and look at which check keeps failing.
2. Share the output with your tech lead.
3. Pick the right action from the table below.

| Problem Type | What to Do |
|--------------|------------|
| Contradicting requirements | Keep one, remove the other |
| Constitution rule conflict | Update the constitution or change approach |
| Technical limit | Adjust the feature to fit what is possible |
| Missing information | Add the missing details to your specification |

4. Run `/prism-plan` and then `/prism-tasks` with the corrected information.

You should now see the quality check pass on the next run.

> **Note:** If you are unsure which problem type applies, share the full `/prism-status` output with your tech lead. They can pinpoint the root cause.

---

## Unexpected Output

### What You See

- Specifications that miss key requirements you asked for.
- Plans that seem unrelated to your feature.
- Tasks that do not match the plan.

### Why This Happens

- Context from an earlier conversation may be leaking in.
- Your description may have been read differently than you meant.
- Your project may not have a constitution (project-principles file) yet.

### Fix 1 -- Start a Fresh Session

Run the command below and type out your full feature description. Do not assume Prism remembers anything from before.

```
/spec [your complete feature description]
```

You should now see a new specification that matches your description.

### Fix 2 -- Check Your Constitution

Run `/constitution` and review the technology choices and standards listed. If they do not match your project, update them.

```
/constitution
```

You should now see a constitution that reflects your real project rules.

### Fix 3 -- Be More Specific

Leave no room for guesswork.

Instead of:
> "Make the dashboard better"

Try:
> "Add a filter to the dashboard that lets users show only items from the last 7 days. The filter should be a dropdown with options: Today, Last 7 Days, Last 30 Days, All Time."

> **Tip:** Use concrete examples with real names, real numbers, and real labels. The more specific you are, the closer the output will be to what you want.

---

## Session Recovery

### What You See

- Prism does not remember your previous work.
- `/prism-status` shows no active features.
- You are asked to set up a constitution again.

### Why This Happens

Prism stores its memory in a `/memory` folder inside your project. If that folder is missing, moved, or damaged, Prism starts with a blank slate. Starting from a different folder can also cause this.

### How to Fix

1. Make sure you opened your terminal in the same project folder you used before.
2. Check that a `/memory` folder exists inside your project.
3. Open the `/memory` folder and confirm it contains files.
4. If the files are gone, run `/constitution` to recreate your project principles.
5. Run `/spec` to restart your feature.

```
$ ls memory/
project-context.md   decisions.md   ...
```

You should now see your project state restored or a clean starting point ready to go.

> **Warning:** Do not delete the `/memory` folder. It holds all of Prism's saved context for your project. Losing it means starting over.

---

## Wrong Direction

### What You See

- The plan includes approaches you did not want.
- Tasks cover features you did not ask for.
- Technical choices do not match your expectations.

### Why This Happens

Prism fills in gaps when your description leaves room for guesses. Rushed answers to clarification questions and unexpected constitution rules can also steer things off course.

### Caught Early (Before Tasks Start)

1. Run `/prism-status` and read the specification carefully.
2. Run `/clarify` to correct the parts that are wrong.
3. Run `/prism-plan` to generate a new plan.

```
$ /prism-plan
Plan generated: 4 tasks across 2 phases.
Ready for review.
```

You should now see a plan that matches your intent.

### Caught Late (During Building)

1. Stop the current implementation.
2. Open the specification and find what went wrong.
3. Update the specification with corrected requirements.
4. Run `/prism-plan` and then `/prism-tasks` to regenerate work items.

```
$ /prism-tasks
Tasks regenerated: 3 tasks.
Ready for implementation.
```

You should now see new tasks that reflect your corrected requirements.

> **Tip:** Before you approve any specification, read it all the way through. A few minutes of review here can save hours of rework later.

---

## Override Options

Sometimes you need to override a Prism decision. Use overrides with care.

### When Overrides Make Sense

| Situation | What to Do |
|-----------|------------|
| A constitution rule does not apply to this feature | Document the exception in your specification |
| Your team prefers a different technical choice | State the preference in the requirements |
| An iteration limit was hit but progress was being made | Review the output and continue by hand |

### When NOT to Override

| Situation | Better Approach |
|-----------|-----------------|
| A security check is failing | Fix the security issue |
| Tests will not pass | Find and fix the root cause |
| A constitution rule conflicts | Update the constitution the right way |

### How to Record an Override

Add a section to your specification like the example below.

```markdown
## Exceptions

**Exception:** Using token-only sessions instead of database sessions.
**Reason:** This feature is read-only and does not need session revocation.
**Approved by:** [Name, Date]
```

---

## Error Categories

Prism groups errors into three types. Knowing which type you are facing helps you respond the right way.

### Soft Errors (Fix Themselves)

These are small problems like formatting issues, minor validation failures, or brief network timeouts. Prism retries up to 3 times on its own.

**Your action:** Usually nothing. These resolve without your help.

### Hard Errors (Need Your Input)

These happen when Prism finds unclear requirements, multiple valid paths, or a scope decision only you can make. Prism pauses and asks you to choose.

**Your action:** Review the options Prism presents and pick one.

### Blocking Errors (Full Stop)

These are serious issues like missing required files, critical security problems, or circular task chains (where task A depends on B and B depends on A). All progress stops until the root cause is fixed.

**Your action:** Address the underlying problem before moving on.

---

## Getting More Help

### Check Existing Docs First

- [User Guide](user-guide.md) -- Full usage guide
- [Command Reference](command-reference.md) -- Every command explained
- [Example Walkthrough](examples/user-auth-feature/README.md) -- A start-to-finish example

### Before You Ask for Help, Gather This

1. What command did you run? Copy the full input.
2. What output did you get? Copy the full response.
3. What did you expect to happen?
4. Run `/constitution` and copy the output.
5. Run `/prism-status` and copy the output.

```
$ /prism-status
Phase: planning
Track: standard
Active Feature: user-auth
Status: blocked — QA fix cycle exceeded
```

Having all five items ready makes it much easier for someone to help you.

### Common Questions

**Q: Can I undo a clarification answer?**
A: Not directly. Run `/spec` again to start fresh if you need to change a key decision.

**Q: How do I change the track (the complexity level -- Quick, Standard, or Enterprise)?**
A: The track is chosen based on feature size. Describe a smaller feature to get a simpler track.

**Q: Why does my feature keep getting split into multiple features?**
A: Your scope is likely too large. This is Prism's way of saying "break it up." Try describing one focused piece at a time.

**Q: Can I skip phases?**
A: No. Each phase builds on the last. Skipping one creates gaps that cause problems later.

---

## Summary

Most issues fall into one of four buckets.

| Category | Common Cause | Solution |
|----------|--------------|----------|
| Clarification loops | Vague requirements | Be more specific up front |
| Quality-check failures | Design conflicts | Review with tech lead |
| Context issues | Session state | Check files or start fresh |
| Wrong direction | Rushed review | Read each phase output carefully |

When in doubt, start here:

1. Run `/prism-status` to see where things stand.
2. Review the specification for accuracy.
3. Ask your tech lead if the issue is technical.
4. Start fresh if context seems corrupted.

You should now have a clear next step for any problem you run into.

---

*For technical error handling details, developers can reference [Error Handling Protocol](dev/error-handling.md).*
