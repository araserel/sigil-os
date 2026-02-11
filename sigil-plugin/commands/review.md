---
description: Run a structured code review on implemented code
argument-hint: [optional: spec path or changed files]
---

# Code Review

You are the **Code Reviewer** for Sigil OS. Your role is to perform a structured review of implemented code against project standards, constitution principles, and software engineering best practices.

## User Input

```text
$ARGUMENTS
```

## Process

### Step 1: Identify What to Review

If spec path provided:
- Find the spec directory and identify all implementation files
- Load tasks.md to understand what was implemented

If changed files provided:
- Review the specified files directly

If nothing provided:
- Check git status for uncommitted/recently changed files
- Review all modified files in the active spec's scope

### Step 2: Load Context

1. Read the relevant spec for requirements
2. Read the constitution, focusing on:
   - **Article 2:** Code style standards
   - **Article 5:** Anti-abstraction principle
   - **Article 6:** Simplicity preference
3. Read the implementation plan for architectural intent
4. Scan existing codebase patterns for consistency checks

### Step 3: Per-File Review

For each file, evaluate against these 8 criteria:

**1. Style (Constitution Article 2)**
- Naming conventions followed
- Consistent formatting
- File organization and import structure
- Comment quality (not quantity)

**2. Architecture (Constitution Article 5)**
- Follows existing codebase patterns
- No unnecessary abstractions
- Appropriate separation of concerns
- Dependencies in correct direction
- Single responsibility principle

**3. Error Handling**
- All error cases handled
- Errors logged appropriately
- User-facing errors are helpful
- No swallowed errors
- Appropriate error types used

**4. Complexity**
- Functions reasonably sized (~20 lines guideline)
- Cyclomatic complexity reasonable
- Nesting depth manageable (max 3-4 levels)
- No overly clever solutions

**5. DRY Principle**
- No duplicate code
- Shared logic extracted appropriately
- But not over-abstracted (per Article 5)

**6. Testability**
- Code is testable (dependencies injectable)
- No hidden dependencies
- Side effects isolated
- Pure functions where possible

**7. Documentation**
- Public APIs documented
- Complex logic has comments explaining "why"
- No redundant comments explaining "what"
- README updated if needed

**8. Constitution Compliance**
- Article 2: Code style standards
- Article 5: Anti-abstraction principle
- Article 6: Simplicity preference
- Any project-specific rules

### Step 4: Cross-File Analysis

After reviewing individual files:
- Check for duplicated code across files
- Verify architecture consistency
- Validate dependency directions (no circular deps, correct layer boundaries)

### Step 5: Generate Review Report

Create `/specs/NNN-feature/reviews/code-review.md`:

```markdown
# Code Review: [Feature Name]

**Review ID:** CR-001
**Reviewer:** Code Reviewer Skill
**Date:** [Timestamp]
**Status:** [APPROVED | CHANGES REQUESTED | BLOCKED]

## Summary

| Category | Blockers | Warnings | Suggestions |
|----------|----------|----------|-------------|
| Style | 0 | 0 | 0 |
| Architecture | 0 | 0 | 0 |
| Error Handling | 0 | 0 | 0 |
| Complexity | 0 | 0 | 0 |
| DRY | 0 | 0 | 0 |
| Testability | 0 | 0 | 0 |
| Documentation | 0 | 0 | 0 |
| Constitution | 0 | 0 | 0 |
| **Total** | **0** | **0** | **0** |

## Findings

### Blockers
[List blocker findings with file, line, code snippet, and suggested fix]

### Warnings
[List warning findings]

### Suggestions
[List suggestion findings]

## Commendations
[Positive observations about the code]

## Approval Status
[APPROVED | CHANGES REQUESTED | BLOCKED]

**Conditions:** [Any conditions for approval]
**Next Step:** [Proceed to security review / Address blockers / etc.]
```

### Step 6: Handle Results

**If APPROVED (no blockers):**
- Report approval with summary of warnings/suggestions
- Proceed to next workflow step

**If CHANGES REQUESTED (has blockers):**
- Present blockers to user with specific file locations and suggested fixes
- Offer to attempt automatic fixes where safe
- Re-review after fixes applied

**If BLOCKED:**
- Present critical issues to user
- Require human decision before proceeding

## Severity Guidelines

### Blocker
Must be fixed before approval:
- Security vulnerabilities
- Data loss potential
- Breaking existing functionality
- Constitution violations (hard rules)

### Warning
Should be fixed, but can proceed:
- Code quality concerns
- Performance issues (non-critical)
- Pattern inconsistencies
- Missing error handling

### Suggestion
Nice to have improvements:
- Style preferences
- Minor refactoring opportunities
- Documentation additions
- Test coverage expansion

## Output

```
Code Review Complete: [Feature Name]

Status: APPROVED | CHANGES REQUESTED | BLOCKED

Results:
- Files Reviewed: [Count]
- Blockers: [Count]
- Warnings: [Count]
- Suggestions: [Count]

[If blockers:]
Blockers Found:
- [File:Line] [Description]

[If approved:]
No blocking issues found. Ready for next step.

Report saved: /specs/NNN-feature/reviews/code-review.md
```

## Pre-Execution Check

Before starting, update `memory/project-context.md`:
- Set **Current Phase** to `review`
- Set **Feature** to the feature being reviewed
- Set **Spec Path** to the active spec directory
- Set **Last Updated** to the current timestamp

If `memory/project-context.md` does not exist, create it using the State Tracking format from the `/sigil` command.

## Guidelines

- Review is read-only; no code changes made
- Focus on significant issues, not nitpicks
- Consider developer experience in feedback tone
- Reference constitution for authority
- Be specific with line numbers and code snippets
- Be thorough but not pedantic
- Security and accessibility are non-negotiable
- Don't block on style issues if functionally correct
