---
name: qa-fixer
description: Attempt automated remediation of validation failures. Invoke when qa-validator finds fixable issues, before escalating to human.
version: 1.0.0
category: qa
chainable: true
invokes: []
invoked_by: [qa-validator, qa-engineer]
tools: Read, Write, Edit, Bash, Glob
---

# Skill: QA Fixer

## Purpose

Attempt automated remediation of validation failures before escalating to human review. This skill handles routine fixes like lint errors, formatting issues, and simple type corrections, allowing the validation loop to complete without human intervention for common issues.

## When to Invoke

- qa-validator reports fixable issues
- Validation loop iteration < 5
- Issues are in fixable categories (lint, format, simple types)

## Inputs

**Required:**
```json
{
  "validation_report_path": "/specs/001-feature/qa/task-T001-validation.md",
  "issues": [
    {
      "type": "lint",
      "file": "src/auth.ts",
      "line": 42,
      "message": "Missing semicolon",
      "rule": "semi",
      "auto_fixable": true
    }
  ],
  "iteration": 1
}
```

**Optional:**
```json
{
  "max_iterations": 5,
  "fix_categories": ["lint", "format", "imports"],
  "dry_run": false
}
```

## Outputs

**Primary Output:**
```json
{
  "status": "fixed | partial | escalate",
  "iteration": 2,
  "fixes_applied": [
    {
      "issue": "lint error line 42",
      "file": "src/auth.ts",
      "fix_type": "auto-format",
      "change": "Added semicolon",
      "verified": true
    }
  ],
  "remaining_issues": [],
  "unfixable_issues": [
    {
      "issue": "Type error",
      "reason": "Requires logic change, not auto-fixable"
    }
  ],
  "next_action": "revalidate | escalate | human_review"
}
```

**Artifact Output:** `/specs/###-feature/qa/task-{id}-fix-{iteration}.md`

## Fix Categories

### 1. Lint Errors (Auto-Fixable)

```bash
# ESLint auto-fix
npx eslint --fix [files]

# Prettier format
npx prettier --write [files]

# Python
ruff check --fix .
black .
```

**Handles:**
- Missing semicolons
- Trailing whitespace
- Import ordering
- Quote style
- Indentation

### 2. Format Issues (Auto-Fixable)

```bash
# Apply project formatter
npm run format
```

**Handles:**
- Line length
- Bracket spacing
- Trailing commas
- Newline at EOF

### 3. Import Issues (Auto-Fixable)

```bash
# Organize imports
npx eslint --fix --rule 'import/order: error'
```

**Handles:**
- Unused imports (remove)
- Missing imports (add if obvious)
- Import ordering
- Duplicate imports

### 4. Simple Type Errors (Semi-Auto)

**Can Fix:**
- Missing return type annotations (infer from usage)
- Unused variable warnings (prefix with _)
- Obvious type mismatches (string vs String)

**Cannot Fix:**
- Logic errors causing type mismatches
- Complex generic type issues
- Structural type incompatibilities

### 5. Test Fixes (Flagged for Review)

**Can Attempt:**
- Generate test stubs for uncovered requirements
- Update test assertions for changed behavior (FLAG)
- Fix import paths in test files

**Always Flag:**
- Any behavioral test changes
- New test generation
- Test removal

### 6. Accessibility Fixes (Semi-Auto)

**Can Fix:**
- Missing alt text (generate placeholder, flag for review)
- Missing labels (add aria-label)
- Color contrast (suggest fix, don't apply)

**Cannot Fix:**
- Structural accessibility issues
- Complex ARIA patterns

## Pre-Execution Check

Before starting, update `memory/project-context.md`:
- Set **Current Phase** to `validate`
- Set **Feature** to the feature being fixed
- Set **Spec Path** to the active spec directory
- Set **Last Updated** to the current timestamp

If `memory/project-context.md` does not exist, create it using the State Tracking format from the `/prism` command.

## Workflow

```
1. Receive issues from qa-validator
2. Categorize by fixability:
   - Auto-fixable → Apply immediately
   - Semi-auto → Attempt with flagging
   - Manual-only → Add to unfixable list
3. For each auto-fixable issue:
   a. Apply fix
   b. Verify fix resolved issue
   c. Log change
4. For semi-auto issues:
   a. Attempt fix
   b. Flag for human review
5. Generate fix report
6. Determine next action:
   - All fixed → Return for re-validation
   - Some remaining → Escalate if iteration >= 5
   - Unfixable found → Escalate immediately
7. Return results
```

## Fix Report Template

```markdown
# Fix Report: T001 (Iteration 2)

**Task:** [Task name]
**Fixed:** [Timestamp]
**Status:** [FIXED | PARTIAL | ESCALATE]

## Fixes Applied

| Issue | File | Fix | Verified |
|-------|------|-----|----------|
| Missing semicolon | auth.ts:42 | Added semicolon | Yes |
| Unused import | auth.ts:3 | Removed import | Yes |

## Changes Made

### auth.ts
```diff
- import { unused } from 'module'
+
  // Line 42
- const x = 5
+ const x = 5;
```

## Remaining Issues

| Issue | File | Reason Not Fixed |
|-------|------|------------------|
| Type error | service.ts:88 | Requires logic change |

## Flagged for Review

1. **Generated test stub** for `loginUser` — needs assertions filled in

## Next Action

[Revalidate] — 1 issue fixed, proceeding to re-validation
```

## Error Handling

### Fix Breaks Other Things
```
Fix caused new issue:
- Original: [Original issue]
- Fix applied: [What was done]
- New issue: [What broke]

Action: Reverting fix, escalating original issue.
```

### Fix Fails to Apply
```
Fix failed to apply:
- Issue: [Issue description]
- Attempted fix: [What was tried]
- Error: [Error message]

Action: Adding to unfixable list.
```

### Iteration Limit Reached
```
Fix loop limit reached (5 iterations).

Persistent issues:
1. [Issue 1] — Attempted [N] times
2. [Issue 2] — Attempted [N] times

Analysis: [Why these can't be auto-fixed]

Escalating to human review.
```

## Escalation Triggers

Escalate to human when:
- Iteration count reaches max (5)
- Security-related issue detected
- Fix would change behavior (not just style)
- Test changes required
- Multiple interrelated issues
- Fix causes new issues

## Safety Guardrails

### Never Auto-Fix
- Security-related code
- Business logic
- Data handling/validation
- Authentication/authorization
- Test assertions (without flagging)
- API contracts

### Always Verify
- Run linter after fix to confirm resolution
- Check for new issues introduced
- Ensure file still parses correctly

### Always Log
- Every change made
- Before/after state
- Verification result

## Integration with Validation Loop

```
┌─────────────────┐
│  qa-validator   │
│  (finds issues) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│   qa-fixer      │────▶│   Revalidate    │
│  (iteration 1)  │     │                 │
└────────┬────────┘     └────────┬────────┘
         │                       │
    (if unfixable)          (if still fails)
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│    Escalate     │     │   qa-fixer      │
│   to human      │     │  (iteration 2)  │
└─────────────────┘     └─────────────────┘
                               ...
                        (max 5 iterations)
```

## Iteration Strategy

### Iteration 1-2: Aggressive Auto-Fix
- Apply all auto-fixable changes
- Attempt semi-auto fixes

### Iteration 3-4: Conservative
- Only auto-fix clear issues
- Flag more for review
- Start documenting persistent issues

### Iteration 5: Final Attempt
- Document all remaining issues
- Prepare escalation report
- Suggest manual fixes

## Notes

- Preserve git history readability (combine related fixes)
- Don't auto-fix in files outside task scope
- Respect project's existing fix configurations
- Log all changes for audit trail

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
