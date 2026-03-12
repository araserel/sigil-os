# QA Fixer: Fix Categories

> **Referenced by:** `qa-fixer` SKILL.md — used to determine what can be auto-fixed vs escalated.

## Fix Category Matrix

### Auto-Fix (No Human Review Needed)

These issues can be fixed automatically with high confidence. Apply the fix and re-validate.

| Category | Examples | Fix Strategy |
|----------|----------|-------------|
| **Lint errors** | Missing semicolons, unused imports, trailing whitespace | Run project linter with `--fix` flag |
| **Format issues** | Indentation, line length, bracket placement | Run project formatter (Prettier, Black, gofmt, etc.) |
| **Import issues** | Unused imports, missing imports, wrong import order | Remove unused, add missing from context, sort |
| **Simple type errors** | Missing return type, wrong primitive type | Infer from usage context |
| **Missing exports** | Module exports not updated after adding new code | Add export statement |
| **Test assertion format** | Wrong assertion method, deprecated API | Replace with current equivalent |

### Auto-Fix with Caution (Review After)

These issues can usually be fixed automatically but the fix should be noted in the QA report for review.

| Category | Examples | Fix Strategy | Why Caution |
|----------|----------|-------------|-------------|
| **Missing null checks** | Accessing property on potentially null value | Add null/undefined guard | May mask real logic error |
| **Missing error handling** | Uncaught promise, missing try-catch | Add basic error handling | May need specific error types |
| **Accessibility attributes** | Missing `aria-label`, `alt` text, `role` | Add from component context | Content may need human review |
| **Test fixture gaps** | Missing test data setup/teardown | Add based on test pattern | May not match intended behavior |

### Escalate (Human Review Required)

These issues cannot be reliably auto-fixed. Describe the issue clearly and escalate.

| Category | Examples | Why Escalate |
|----------|----------|-------------|
| **Logic errors** | Wrong conditional, incorrect algorithm | Requires understanding intent |
| **Architecture issues** | Wrong pattern, circular dependency | Requires design decision |
| **Security vulnerabilities** | SQL injection, XSS, auth bypass | Fixes may introduce new issues |
| **Data integrity** | Wrong data transformation, missing validation | Business logic dependent |
| **Performance issues** | N+1 queries, memory leaks | Requires profiling context |
| **Breaking changes** | API contract changes, schema migrations | Requires coordination |
| **Missing requirements** | Feature gap, unimplemented acceptance criteria | Requires spec clarification |

## Auto-Fix Decision Flowchart

```
Issue detected by qa-validator
  │
  ├─ Is it a lint/format issue?
  │   └─ YES → Auto-fix (run linter/formatter)
  │
  ├─ Is it an import issue?
  │   └─ YES → Auto-fix (add/remove imports)
  │
  ├─ Is it a simple type error?
  │   └─ YES → Can type be inferred from context?
  │       ├─ YES → Auto-fix
  │       └─ NO → Escalate
  │
  ├─ Is it a missing null check?
  │   └─ YES → Auto-fix with caution flag
  │
  ├─ Is it a test failure?
  │   ├─ Assertion format issue → Auto-fix
  │   ├─ Missing test data → Auto-fix with caution
  │   └─ Logic failure → Escalate
  │
  └─ Anything else → Escalate
```

## Fix Attempt Limits

| Track | Max Attempts | Behavior After Limit |
|-------|-------------|---------------------|
| Quick Flow | 1 | Escalate immediately |
| Standard | 5 | Escalate with full issue summary |
| Enterprise | 5 | Escalate with full issue summary |
| Implement-Ready | 1 (Quick) or 5 (Standard) | Depends on track assignment |

## Fix Report Format

After each fix attempt, record:

```markdown
### Fix Attempt [N]

**Issues addressed:** [count]
**Auto-fixed:** [count]
**Escalated:** [count]

| Issue | Category | Action | Result |
|-------|----------|--------|--------|
| Missing semicolons (3 files) | Lint | Auto-fixed | Resolved |
| Unused import in auth.ts | Import | Auto-fixed | Resolved |
| Null pointer in user.ts:42 | Logic | Escalated | Needs human review |
```

## Language-Specific Fix Tools

| Language | Linter | Formatter | Type Checker |
|----------|--------|-----------|-------------|
| TypeScript/JavaScript | ESLint (`--fix`) | Prettier | `tsc --noEmit` |
| Python | Ruff (`--fix`) or Flake8 | Black or Ruff format | mypy |
| Go | golangci-lint (`--fix`) | gofmt / goimports | Go compiler |
| Rust | Clippy (`--fix`) | rustfmt | cargo check |
| Ruby | RuboCop (`-A`) | RuboCop | Sorbet (if configured) |
| Java | Checkstyle + auto-fix | google-java-format | javac |

## Notes

- Always re-run validation after applying fixes to confirm resolution
- Track which files were modified during fixes — these need extra scrutiny in code review (`implementation_modified` flag)
- Classify changed files as `test`, `implementation`, `config`, or `other` for the code reviewer
