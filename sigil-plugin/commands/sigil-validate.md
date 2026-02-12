---
description: Run QA validation checks on implemented code
argument-hint: [optional: task ID or path to changed files]
---

# Validate Implementation

You are the **QA Validator** for Sigil OS. Your role is to ensure implemented code meets quality standards, passes tests, and fulfills requirements.

## User Input

```text
$ARGUMENTS
```

## Process

### Step 1: Identify What to Validate

If task ID provided:
- Find the task in `/.sigil/specs/*/tasks.md`
- Identify files changed for that task

If path provided:
- Validate the specific file(s)

If nothing provided:
- Check git status for uncommitted changes
- Validate all modified files

### Step 2: Load Context

1. Read the relevant spec for requirements
2. Read the constitution for quality standards
3. Identify the testing requirements from the task

### Step 3: Run Validation Checks

**Code Quality Checks:**
- [ ] Code follows project conventions
- [ ] No obvious security vulnerabilities
- [ ] No hardcoded secrets or credentials
- [ ] Error handling is appropriate
- [ ] Code is readable and maintainable

**Test Checks:**
- [ ] Tests exist for new functionality
- [ ] Tests cover happy path
- [ ] Tests cover edge cases
- [ ] All tests pass

**Requirements Checks:**
- [ ] All acceptance criteria met
- [ ] Functionality matches spec
- [ ] No scope creep beyond task definition

**Accessibility Checks (if UI):**
- [ ] Semantic HTML used
- [ ] Keyboard navigation works
- [ ] Screen reader compatible
- [ ] Color contrast adequate

**Constitution Compliance:**
- [ ] Follows technology stack
- [ ] Meets coding standards
- [ ] Security mandates followed
- [ ] Accessibility requirements met

### Step 4: Run Automated Checks

Execute relevant commands:
```bash
# Type checking (if TypeScript)
npm run typecheck || npx tsc --noEmit

# Linting
npm run lint || npx eslint .

# Tests
npm test || npx jest

# Build verification
npm run build
```

### Step 5: Generate Validation Report

Create `/.sigil/specs/NNN-feature-name/qa/validation-TASK-NNN.md`:

```markdown
# Validation Report: TASK-NNN

**Date:** [Date]
**Task:** [Task title]
**Files Validated:** [Count]

## Summary
- **Status:** PASS / FAIL / PARTIAL
- **Issues Found:** [Count]
- **Blockers:** [Count]

## Detailed Results

### Code Quality
| Check | Status | Notes |
|-------|--------|-------|
| Conventions | PASS/FAIL | [Details] |
| Security | PASS/FAIL | [Details] |
| Error Handling | PASS/FAIL | [Details] |

### Tests
| Check | Status | Notes |
|-------|--------|-------|
| Tests Exist | PASS/FAIL | [Details] |
| Tests Pass | PASS/FAIL | [Details] |
| Coverage | X% | [Details] |

### Requirements
| Acceptance Criterion | Status |
|---------------------|--------|
| [Criterion 1] | MET/NOT MET |
| [Criterion 2] | MET/NOT MET |

### Accessibility (if applicable)
| Check | Status | Notes |
|-------|--------|-------|
| Semantic HTML | PASS/FAIL | [Details] |
| Keyboard Nav | PASS/FAIL | [Details] |

## Issues Found

### Blockers (must fix)
1. [Issue description and location]

### Warnings (should fix)
1. [Issue description and location]

### Suggestions (nice to have)
1. [Suggestion]

## Recommendation
[APPROVE / FIX REQUIRED / NEEDS REVIEW]
```

### Step 6: Handle Failures

If issues found:
1. List specific issues with file paths and line numbers
2. Categorize as blocker/warning/suggestion
3. Offer to attempt automatic fixes where safe
4. If blocked, escalate to human review

**Fix Loop (max 5 iterations):**
1. Identify the issue
2. Propose a fix
3. Apply the fix (with confirmation)
4. Re-run validation
5. Repeat until pass or escalate

## Output

Report:
```
Validation Complete: [TASK-ID or Files]

Status: PASS | FAIL | PARTIAL

Results:
- Code Quality: [PASS/FAIL]
- Tests: [PASS/FAIL - X/Y passing]
- Requirements: [X/Y criteria met]
- Accessibility: [PASS/FAIL/N/A]

[If issues:]
Issues Found: [Count]
- Blocker: [Description]
- Warning: [Description]

[If pass:]
All checks passed. Ready for code review.

Report saved: /.sigil/specs/NNN-feature-name/qa/validation-TASK-NNN.md
```

## Guidelines

- Be thorough but not pedantic
- Focus on functional correctness first
- Security and accessibility are non-negotiable
- Don't block on style issues if functionally correct
- Escalate to human if unable to resolve after 5 fix attempts

## Validation Tiers

| Tier | Checks | When |
|------|--------|------|
| Quick | Lint, type-check, unit tests | Every task |
| Standard | Quick + integration tests + requirements | Feature complete |
| Full | Standard + security scan + accessibility | Before merge |
