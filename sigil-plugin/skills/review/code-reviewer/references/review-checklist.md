# Code Reviewer: Review Checklist

> **Referenced by:** `code-reviewer` SKILL.md and `code-reviewer` agent — used as structured review criteria.

## Review Categories

### 1. Code Style

| Check | Severity | Auto-Detectable |
|-------|----------|-----------------|
| Naming conventions match codebase | Warning | Yes — compare with existing patterns |
| Consistent formatting | Suggestion | Yes — lint/format tools |
| File organization follows project structure | Warning | Yes — compare directory patterns |
| Import ordering consistent | Suggestion | Yes — lint rules |
| No commented-out code | Suggestion | Yes — pattern match |
| No TODO/FIXME without tracking | Suggestion | Yes — pattern match |

### 2. Architecture

| Check | Severity | Auto-Detectable |
|-------|----------|-----------------|
| Follows existing patterns in codebase | Warning | Partially — compare with similar files |
| No unnecessary abstractions (constitution Article 5) | Blocker | No — requires judgment |
| Appropriate separation of concerns | Warning | Partially |
| Dependencies flow in correct direction | Warning | Yes — import analysis |
| Single responsibility per module/class | Warning | Partially |
| No circular dependencies introduced | Blocker | Yes — import analysis |

### 3. Error Handling

| Check | Severity | Auto-Detectable |
|-------|----------|-----------------|
| All error cases handled | Warning | Partially — catch blocks, error returns |
| Errors logged appropriately | Warning | Yes — check for logging calls |
| User-facing errors are helpful | Warning | No — requires judgment |
| No swallowed errors (empty catch) | Warning | Yes — pattern match |
| Appropriate error types used | Suggestion | Partially |
| Async errors properly caught | Blocker | Yes — unhandled promise detection |

### 4. Complexity

| Check | Severity | Threshold |
|-------|----------|-----------|
| Function length | Suggestion | > 30 lines |
| Cyclomatic complexity | Warning | > 10 |
| Nesting depth | Warning | > 4 levels |
| Parameter count | Suggestion | > 4 parameters |
| File length | Suggestion | > 300 lines |

### 5. DRY (Don't Repeat Yourself)

| Check | Severity | Auto-Detectable |
|-------|----------|-----------------|
| No duplicate code blocks (> 5 lines identical) | Warning | Yes — pattern comparison |
| Shared logic extracted when used 3+ times | Suggestion | Partially |
| Not over-abstracted (constitution Article 5) | Warning | No — judgment needed |
| Constants not hardcoded in multiple places | Warning | Yes — literal comparison |

### 6. Security (Quick Checks)

| Check | Severity | Auto-Detectable |
|-------|----------|-----------------|
| No hardcoded secrets or credentials | Blocker | Yes — pattern match |
| Input validation on user data | Warning | Partially |
| No SQL injection vectors | Blocker | Yes — pattern match |
| No XSS vectors in output | Blocker | Partially |
| Auth checks on protected routes | Warning | Partially |

### 7. Performance (Quick Checks)

| Check | Severity | Auto-Detectable |
|-------|----------|-----------------|
| No N+1 query patterns | Warning | Partially — ORM usage patterns |
| No unbounded loops or recursion | Warning | Yes — pattern match |
| Large data sets paginated | Suggestion | Partially |
| No blocking operations in async context | Warning | Partially |

### 8. Testing

| Check | Severity | Auto-Detectable |
|-------|----------|-----------------|
| New code has corresponding tests | Warning | Yes — file pair matching |
| Tests cover happy path | Warning | Partially |
| Tests cover error cases | Suggestion | Partially |
| Test names describe behavior | Suggestion | Yes — naming pattern |
| No test pollution (shared state) | Warning | Partially |

## Severity Levels

### Blocker (Must Fix)
- Security vulnerabilities
- Data loss potential
- Breaking existing functionality
- Hard constitution violations
- Circular dependencies

### Warning (Should Fix)
- Code quality concerns
- Non-critical performance issues
- Pattern inconsistencies
- Missing error handling
- Constitution soft violations

### Suggestion (Nice to Have)
- Style preferences
- Minor refactoring opportunities
- Documentation additions
- Test coverage expansion

## Example Finding Output

```markdown
#### W003: Unhandled error in async operation
**File:** src/services/user.ts:45
**Category:** Error Handling
**Severity:** Warning
**Constitution:** Article 2 (Code Standards)

The `fetchUser` call can reject but the error is not caught, which will result in an unhandled promise rejection.

**Current:**
```typescript
const user = await fetchUser(id);
return user.name;
```

**Suggested:**
```typescript
try {
  const user = await fetchUser(id);
  return user.name;
} catch (error) {
  logger.error('Failed to fetch user', { userId: id, error });
  throw new UserFetchError(id, error);
}
```
```
