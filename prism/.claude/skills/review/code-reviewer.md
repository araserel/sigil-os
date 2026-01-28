---
name: code-reviewer
description: Perform structured code review against project standards and best practices. Invoke after qa-validator passes to review code quality before deployment.
version: 1.0.0
category: review
chainable: true
invokes: []
invoked_by: [security, qa-engineer, orchestrator]
tools: Read, Glob, Grep
---

# Skill: Code Reviewer

## Purpose

Perform structured code review against project standards, constitution principles, and software engineering best practices. This skill provides a thorough review of code quality, architecture adherence, and maintainability before changes proceed to security review or deployment.

## When to Invoke

- qa-validator passes all checks
- User requests `/review` or "review code"
- Entering Review phase from Validate phase
- Changes are ready for final quality assessment

## Inputs

**Required:**
```json
{
  "changed_files": ["src/services/auth.ts", "src/models/user.ts"],
  "spec_path": "/specs/001-feature/spec.md"
}
```

**Optional:**
```json
{
  "plan_path": "/specs/001-feature/plan.md",
  "constitution_path": "/memory/constitution.md",
  "review_depth": "standard | thorough",
  "focus_areas": ["error_handling", "architecture"],
  "previous_review": "/specs/001-feature/reviews/code-review-v1.md"
}
```

**Auto-loaded:**
- Constitution from `/memory/constitution.md`
- Project coding standards
- Existing codebase patterns

## Outputs

**Primary Output:**
```json
{
  "status": "approved | changes_requested | blocked",
  "review_id": "CR-001",
  "timestamp": "2025-01-14T10:30:00Z",
  "files_reviewed": 3,
  "findings": [
    {
      "id": "F001",
      "severity": "suggestion | warning | blocker",
      "category": "style | architecture | error_handling | performance | security",
      "file": "src/auth.ts",
      "line": 42,
      "code_snippet": "...",
      "message": "Consider extracting this to a separate function",
      "suggested_fix": "...",
      "constitution_reference": "Article 5"
    }
  ],
  "summary": {
    "total_findings": 5,
    "blockers": 0,
    "warnings": 2,
    "suggestions": 3
  },
  "approval_conditions": [],
  "commendations": ["Good error handling in auth service"]
}
```

**Artifact Output:** `/specs/###-feature/reviews/code-review.md`

## Review Criteria

### 1. Code Style (Constitution Article 2)

**Checks:**
- Naming conventions followed
- Consistent formatting
- File organization
- Import structure
- Comment quality (not quantity)

**Examples:**
```
SUGGESTION: Variable 'x' should have a descriptive name
  File: auth.ts:42
  Current: const x = getUserById(id)
  Suggested: const user = getUserById(id)
```

### 2. Architecture (Constitution Article 5)

**Checks:**
- Follows existing patterns in codebase
- No unnecessary abstractions
- Appropriate separation of concerns
- Dependencies in correct direction
- Single responsibility principle

**Examples:**
```
WARNING: This creates a new pattern inconsistent with existing code
  File: services/auth.ts
  Issue: Using class-based service when codebase uses functions
  Recommendation: Follow existing functional pattern or document why different
```

### 3. Error Handling

**Checks:**
- All error cases handled
- Errors logged appropriately
- User-facing errors are helpful
- No swallowed errors
- Appropriate error types used

**Examples:**
```
WARNING: Error is caught but not logged
  File: auth.ts:88
  Code: catch (e) { return null; }
  Suggested: Log error before returning, or re-throw with context
```

### 4. Complexity

**Checks:**
- Functions reasonably sized (guideline: ~20 lines)
- Cyclomatic complexity reasonable
- Nesting depth manageable (max 3-4 levels)
- No overly clever solutions

**Examples:**
```
SUGGESTION: Function is complex (cyclomatic complexity: 12)
  File: validator.ts:validateInput()
  Recommendation: Consider breaking into smaller functions
```

### 5. DRY Principle

**Checks:**
- No duplicate code
- Shared logic extracted appropriately
- But not over-abstracted (per Article 5)

**Examples:**
```
SUGGESTION: Similar code in 3 locations
  Files: auth.ts:45, user.ts:67, session.ts:23
  Pattern: Error formatting logic
  Recommendation: Extract to shared utility if used 3+ times
```

### 6. Testability

**Checks:**
- Code is testable (dependencies injectable)
- No hidden dependencies
- Side effects isolated
- Pure functions where possible

### 7. Documentation

**Checks:**
- Public APIs documented
- Complex logic has comments explaining "why"
- No redundant comments explaining "what"
- README updated if needed

### 8. Constitution Compliance

**Checks:**
- Article 2: Code style standards
- Article 5: Anti-abstraction principle
- Article 6: Simplicity preference
- Any project-specific rules

## Review Report Template

```markdown
# Code Review: [Feature Name]

**Review ID:** CR-001
**Reviewer:** Code Reviewer Skill
**Date:** [Timestamp]
**Status:** [APPROVED | CHANGES REQUESTED | BLOCKED]

## Summary

| Category | Blockers | Warnings | Suggestions |
|----------|----------|----------|-------------|
| Style | 0 | 1 | 2 |
| Architecture | 0 | 0 | 1 |
| Error Handling | 0 | 1 | 0 |
| Complexity | 0 | 0 | 1 |
| **Total** | **0** | **2** | **4** |

## Findings

### Warnings

#### W001: Error not logged before return
**File:** src/auth.ts:88
**Category:** Error Handling
**Constitution:** Article 2 (Code Standards)

```typescript
// Current
catch (e) {
  return null;
}

// Suggested
catch (e) {
  logger.error('Authentication failed', { error: e });
  return null;
}
```

### Suggestions

#### S001: Consider descriptive variable name
**File:** src/auth.ts:42
**Category:** Style

```typescript
// Current
const x = getUserById(id);

// Suggested
const user = getUserById(id);
```

## Commendations

- Good separation of concerns in service layer
- Comprehensive error types defined
- Tests cover edge cases well

## Approval Status

[APPROVED] — No blocking issues found. Warnings are recommendations for improvement.

**Conditions:** None

**Next Step:** Proceed to security review
```

## Pre-Execution Check

Before starting, update `memory/project-context.md`:
- Set **Current Phase** to `review`
- Set **Feature** to the feature being reviewed
- Set **Spec Path** to the active spec directory
- Set **Last Updated** to the current timestamp

If `memory/project-context.md` does not exist, create it using the State Tracking format from the `/prism` command.

## Workflow

```
1. Receive files and spec for review
2. Load constitution and project standards
3. For each file:
   a. Parse and analyze structure
   b. Check against review criteria
   c. Compare with existing codebase patterns
   d. Generate findings
4. Cross-file analysis:
   a. Check for duplicated code
   b. Verify architecture consistency
   c. Check dependency directions
5. Compile findings by severity
6. Determine approval status:
   - No blockers → Approved (may have warnings/suggestions)
   - Has blockers → Changes Requested
7. Generate review report
8. Return results
```

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

## Error Handling

### File Not Found
```
Cannot review file: [Path]
Reason: File not found or inaccessible

Options:
A) Verify file path and retry
B) Exclude from review scope
C) Escalate
```

### Large File Warning
```
File exceeds review threshold: [Path]
Size: [N] lines (threshold: 500)

Recommendation: Consider breaking into smaller modules.
Proceeding with focused review on changed sections only.
```

## Integration

### Receiving from qa-validator
```json
{
  "handoff_from": "qa-validator",
  "validation_status": "pass",
  "changed_files": ["..."],
  "validation_report": "/specs/.../qa/validation.md"
}
```

### Passing to security-reviewer
```json
{
  "handoff_to": "security-reviewer",
  "review_status": "approved",
  "review_report": "/specs/.../reviews/code-review.md",
  "security_relevant_files": ["src/auth.ts"],
  "findings_for_security": [...]
}
```

## Notes

- Review is read-only; no code changes made
- Focus on significant issues, not nitpicks
- Consider developer experience in feedback tone
- Reference constitution for authority
- Be specific with line numbers and code snippets

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
