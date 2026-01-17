# Test: Non-Technical User Journey

## Scenario

**Persona:** Sarah, a Product Manager with no coding experience, first time using Prism.

**Goal:** Create a feature specification and hand it off to engineering.

**Duration Target:** 30 minutes following quick-start guide.

---

## Preconditions

- [x] Prism documentation available
- [x] User has no prior exposure to the system
- [x] Constitution already exists (typical onboarding scenario)

---

## Journey Step 1: Finding the Right Starting Point

### User Action
Sarah opens the documentation looking for "how to get started."

### Documentation Path
1. Opens `/docs/` directory
2. Sees file list:
   - command-reference.md
   - context-management.md
   - error-handling.md
   - extending-skills.md
   - mcp-integration.md
   - quick-start.md ← **Entry point**
   - troubleshooting.md
   - user-guide.md
   - versioning.md

3. **quick-start.md** title: "Quick-Start Tutorial" with subtitle "Build your first feature specification in 30 minutes."

### Verification

**Can Sarah identify the right starting doc?**
- ✓ `quick-start.md` is clearly named for beginners
- ✓ Subtitle explicitly states "first feature" and "30 minutes"
- ✓ No technical jargon in title

**Alternative paths if confused:**
- `user-guide.md` also has "Getting Started" section
- Both docs cross-reference each other

**Result:** ✓ PASS — Clear entry point

---

## Journey Step 2: Understanding Prerequisites

### User Action
Sarah reads quick-start.md prerequisites section.

### Documentation Check

**quick-start.md lines 13-19:**
```markdown
## Prerequisites

- Prism OS installed and running
- 30 minutes of uninterrupted time
- No technical knowledge required
```

### Verification

**Is this accessible to a PM?**
- ✓ No jargon
- ✓ Time commitment clear
- ✓ Explicitly says no technical knowledge needed
- ✓ Doesn't assume prior experience

**What's missing:**
- Assumes "Prism OS installed" — how?
- Doesn't explain installation

**Mitigation:** Quick-start focuses on usage, not installation. Installation would be a separate doc or handled by technical setup.

**Result:** ✓ PASS (with noted assumption)

---

## Journey Step 3: Constitution Setup

### User Action
Sarah follows Part 1: First-Time Setup.

### Documentation Check

**quick-start.md lines 25-73:**

| Instruction | Clarity | Technical Level | Result |
|-------------|---------|-----------------|--------|
| "What is a Constitution?" | Explained with examples | Low | ✓ |
| "Setting Up Your Constitution" | Step-by-step | Low | ✓ |
| "Step 1: Start the wizard" | `/constitution` command | Low | ✓ |
| "Step 2: Answer questions" | Table of example questions | Low | ✓ |
| "Step 3: Review and confirm" | Shows example output | Low | ✓ |
| "Tip: If unsure..." | Offers skip option | Considerate | ✓ |

### Jargon Check

| Term | Defined? | Location |
|------|----------|----------|
| Constitution | Yes, with analogy "rulebook" | Line 29-35 |
| Database | Used in example, not defined | — |
| Accessibility compliance | Mentioned, not explained | — |

### Verification

**Can Sarah complete this without help?**
- ✓ Clear wizard command
- ✓ Example questions shown
- ✓ Escape hatch if unsure ("skip and come back with tech lead")

**Potential confusion points:**
- ⚠ Technical questions (database, framework) may confuse
- ✓ Mitigated by "skip if unsure" guidance

**Result:** ✓ PASS — Adequate guidance for non-technical users

---

## Journey Step 4: Creating First Feature

### User Action
Sarah follows Part 2: Creating Your Feature.

### Documentation Check

**quick-start.md lines 79-176:**

| Section | Purpose | Clarity |
|---------|---------|---------|
| "The Scenario" | Sets concrete example (contact form) | ✓ Clear |
| "Step 1: Describe Your Feature" | Shows command and example input | ✓ Clear |
| "What to Include" | Guidance on good descriptions | ✓ Clear |
| "What Prism Produces" | Shows expected output | ✓ Clear |
| "What the Priorities Mean" | Explains P1/P2/P3 | ✓ Clear |

### Example Used

**Contact Form feature:**
- Universal understanding (everyone knows contact forms)
- Simple enough for first feature
- Has realistic requirements

### Verification

**Can Sarah write a good feature description?**
- ✓ Example input provided
- ✓ "What to Include" gives explicit guidance
- ✓ Output preview sets expectations

**Does the example match actual system output?**
- ✓ Output format matches spec-template.md structure
- ✓ Priorities explained inline

**Result:** ✓ PASS — Clear, concrete guidance

---

## Journey Step 5: Answering Clarification Questions

### User Action
Sarah follows Step 2: Answer Clarification Questions.

### Documentation Check

**quick-start.md lines 134-162:**

| Instruction | Guidance Quality |
|-------------|------------------|
| "Prism may have questions" | Sets expectation |
| Example Q1: Spam Protection | Shows format with options |
| "Your Answer" guidance | Explains reasoning |
| Example Q2: Email Recipients | Second example |

### Verification

**Does Sarah understand how to answer?**
- ✓ Multiple-choice format shown
- ✓ Reasoning explained ("Consider your users")
- ✓ Specific recommendation given

**Does the format match actual clarifier output?**
- ✓ Matches clarifier.md question format
- ✓ Options labeled A/B/C/D

**Result:** ✓ PASS — Clear question answering process

---

## Journey Step 6: Understanding Status Output

### User Action
Sarah wants to check progress later.

### Documentation Check

**quick-start.md lines 186-211:**

```markdown
### Check Progress Later

**Command:**

/status

**Example Output:**

Feature: Contact Form
Phase: Implementation
Progress: ████████░░ 80%

Completed: 7/9 tasks
├── [x] T001: Create validation schemas
...
```

### Verification

**Can Sarah interpret status output?**
- ✓ Progress bar visual is intuitive
- ✓ Task list with checkmarks clear
- ✓ Phase name understandable

**Does example match actual status-reporter output?**
- ✓ Format consistent with status-reporter.md

**Result:** ✓ PASS — Status is interpretable

---

## Journey Step 7: Responding to Decision Points

### User Action
Sarah encounters a decision point during workflow.

### Documentation Check

**Where is this documented?**
- user-guide.md "Making Decisions" section
- troubleshooting.md (if issues arise)

**user-guide.md lines 253-274:**

```markdown
### Making Decisions

**User Impact Questions** - You should decide:
- Which users is this for?
- What's the priority of conflicting requirements?
...

**Technical Questions** - Consult your tech lead:
- Which technology approach is better?
...
```

### Verification

**Does Sarah know when to decide vs. consult?**
- ✓ Clear categorization of decision types
- ✓ Explicit "consult tech lead" for technical questions

**Is decision format explained?**
- ✓ CLAUDE.md:943-968 shows presentation format
- ⚠ Not replicated in user docs (user sees it, doesn't need to know format)

**Result:** ✓ PASS — Decision guidance clear

---

## Journey Step 8: Handling a Blocker

### User Action
Sarah encounters an error message about clarification limit.

### Documentation Check

**troubleshooting.md "Clarification Limits" section (lines 21-67):**

| Element | Present | Clarity |
|---------|---------|---------|
| "What You See" | ✓ Example error message | ✓ |
| "What's Happening" | ✓ Plain explanation | ✓ |
| "Why This Happens" | ✓ 4 common causes | ✓ |
| "How to Fix" | ✓ 3 options with steps | ✓ |
| "How to Prevent" | ✓ Proactive guidance | ✓ |

### Verification

**Can Sarah diagnose and resolve?**
- ✓ Error message quoted so she can match it
- ✓ Causes are non-technical
- ✓ Solutions are actionable by PM

**Is the language accessible?**
- ✓ "Simplify scope" is understandable
- ✓ "Provide direct answers" is actionable

**Result:** ✓ PASS — Troubleshooting accessible

---

## Journey Step 9: Cross-Reference Navigation

### User Action
Sarah needs more detail on a topic mentioned in quick-start.

### Documentation Check

**Cross-references in quick-start.md (lines 221-227):**

```markdown
## What's Next?

- **See a complete example:** Read the [User Authentication Walkthrough](examples/user-auth-feature/README.md)
- **Learn all commands:** See the [Command Reference](command-reference.md)
- **Deep dive:** Read the [User Guide](user-guide.md)
- **Troubleshooting:** See [Troubleshooting](troubleshooting.md)
```

### Verification

**Are links working?**
- ✓ Relative paths correct
- ✓ All referenced files exist

**Is navigation intuitive?**
- ✓ Clear descriptions of what each doc covers
- ✓ Progressive detail (quick-start → user-guide → command-reference)

**Result:** ✓ PASS — Navigation clear

---

## Journey Step 10: Finding Specific Command Syntax

### User Action
Sarah wants to know exact syntax for `/spec` command.

### Documentation Check

**command-reference.md `/spec` section:**

| Element | Present | Accessible |
|---------|---------|------------|
| Syntax | ✓ `/spec [feature description]` | ✓ |
| What it does | ✓ Plain explanation | ✓ |
| Example input | ✓ Full example | ✓ |
| Example output | ✓ What to expect | ✓ |
| When to use | ✓ Guidance | ✓ |
| Common mistakes | ✓ Avoidance tips | ✓ |

### Verification

**Can Sarah use this as reference?**
- ✓ Quick lookup table at top
- ✓ Detailed sections for each command
- ✓ Practical examples

**Result:** ✓ PASS — Reference is usable

---

## Documentation Cross-Reference Verification

### Do docs match system behavior?

| Doc Claim | System Implementation | Match? |
|-----------|----------------------|--------|
| /spec creates specification | spec-writer.md | ✓ |
| /clarify asks 3-5 questions per round | clarifier.md | ✓ |
| Max 3 clarification rounds | error-handling.md:230 | ✓ |
| /status shows progress | status-reporter.md | ✓ |
| P1/P2/P3 priority system | spec-template.md | ✓ |

### Are examples consistent?

| Example | Quick-start | Command-reference | User-guide | Match? |
|---------|-------------|-------------------|------------|--------|
| Contact form | Primary example | — | — | N/A |
| User auth | — | Mentioned | Full walkthrough | ✓ |
| Workflow phases | Abbreviated | Full list | Full list | ✓ |

---

## Jargon and Clarity Issues

### Terms Used Without Definition

| Term | Location | Impact | Recommendation |
|------|----------|--------|----------------|
| "API endpoint" | quick-start.md:167 | Low — context clear | Consider footnote |
| "Lint/format" | user-guide.md:183 | Medium — PM may not know | Add brief explanation |
| "WCAG 2.1 AA" | constitution example | Low — optional section | Keep as-is |

### Potentially Confusing Sections

| Section | Issue | Recommendation |
|---------|-------|----------------|
| "Constitution" setup | Technical questions may confuse | ✓ Already has "skip" guidance |
| "Understanding Technical Output" | Reading plans | ✓ Explicitly says "don't need to understand file paths" |

---

## Issues Found

| ID | Severity | Description | Location | Status |
|----|----------|-------------|----------|--------|
| USR-001 | Minor | "API endpoint" used without definition | quick-start.md:167 | Open |
| USR-002 | Minor | "Lint/format" not explained | user-guide.md:183 | Open |
| USR-003 | Minor | Installation not covered | quick-start.md prerequisites | Open (separate concern) |

---

## Result

**PASS**

A non-technical Product Manager can:

1. ✓ Find the right starting documentation (quick-start.md)
2. ✓ Understand prerequisites (no technical knowledge needed)
3. ✓ Complete constitution setup (with skip option if unsure)
4. ✓ Create a feature specification (concrete examples provided)
5. ✓ Answer clarification questions (format and reasoning explained)
6. ✓ Check progress with /status (visual output intuitive)
7. ✓ Make decisions (categorization by type provided)
8. ✓ Handle blockers (troubleshooting guide accessible)
9. ✓ Navigate between docs (cross-references working)
10. ✓ Look up command syntax (reference guide usable)

**Minor Issues:** 3 jargon terms could be clarified, but don't block usability.

---

## Recommendations

1. Add glossary tooltips or footnotes for technical terms that appear in PM-facing docs
2. Consider a separate "Installation Guide" for technical setup
3. Add "stuck?" callouts in quick-start linking to troubleshooting

---

*Test completed: 2026-01-16*
