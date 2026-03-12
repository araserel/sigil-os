---
name: refactoring-backend
description: Structured backend refactoring with safety guarantees. Applies incremental refactoring patterns with test-first validation and API compatibility preservation.
version: 1.0.0
category: engineering
chainable: true
invokes: [test-generator]
invoked_by: [developer, architect]
tools: Read, Write, Edit, Bash, Glob, Grep
---

# Skill: Refactoring Backend

## Purpose

Perform structured backend code refactoring with safety guarantees. Ensures test coverage exists before changes, applies refactoring in small incremental steps with test verification between each step, and preserves API contracts throughout.

## When to Invoke

- Implementation plan calls for restructuring existing code
- Code review identifies structural issues (large files, tight coupling, duplication)
- Architect recommends service extraction or dependency restructuring
- Technical debt reduction is part of the current feature work
- User requests "refactor X" or "extract service for Y"
- Performance optimization requires restructuring data access patterns

## Inputs

**Required:**
- `target_path`: string — Path to file or module to refactor
- `pattern`: string — Refactoring pattern to apply (see Patterns section)

**Optional:**
- `description`: string — Plain-language description of desired outcome
- `preserve_api`: boolean — Ensure public API remains unchanged (default: true)
- `scope`: string — One of: `file`, `module`, `service` (default: inferred from target)
- `max_steps`: number — Maximum incremental steps before checkpoint (default: 10)

**Auto-loaded:**
- `project_context`: string — `/.sigil/project-context.md`
- `constitution`: string — `/.sigil/constitution.md` (for code standards)

## Patterns

### Service Extraction

Extract a cohesive set of functionality from a large module into a standalone service.

**When to use:** File exceeds ~300 lines, contains multiple unrelated responsibilities, or a subset of functionality needs independent scaling or testing.

```
1. Identify the cohesive function group to extract
2. Map all dependencies of the target functions
3. Create new service file with extracted functions
4. Add service interface/contract
5. Replace inline calls with service calls
6. Update dependency injection/imports
7. Verify original module's API unchanged
```

### Dependency Inversion

Replace direct dependencies with abstractions to enable testing and flexibility.

**When to use:** Module directly instantiates its dependencies, making testing difficult or coupling too tight.

```
1. Identify concrete dependencies in the target
2. Define interfaces/protocols for each dependency
3. Refactor target to accept dependencies via injection
4. Update all call sites to provide dependencies
5. Create test doubles for each interface
6. Verify behavior unchanged with real dependencies
```

### API Compatibility Preservation

Restructure internal implementation while keeping the public API identical.

**When to use:** Internal code quality is poor but external consumers depend on the current API.

```
1. Document current API contract (routes, signatures, response shapes)
2. Write contract tests that lock current behavior
3. Apply internal restructuring
4. Verify contract tests still pass
5. No changes to endpoint paths, parameter names, or response shapes
```

### Database Query Optimization

Restructure data access patterns for better performance.

**When to use:** Slow queries identified, N+1 patterns detected, or missing query optimization opportunities.

```
1. Profile current query patterns (log or analyze)
2. Identify N+1 queries, missing joins, excessive round-trips
3. Restructure to use eager loading, batch queries, or joins
4. Verify result data is identical
5. Measure performance improvement
```

### Module Decomposition

Break a large module into smaller, focused modules.

**When to use:** Module has grown beyond a single responsibility, making it hard to understand, test, or modify.

```
1. Map the dependency graph within the module
2. Identify natural boundaries (data access, business logic, presentation)
3. Create new module files along boundaries
4. Move functions and their direct dependencies
5. Create barrel/index file to preserve original import paths
6. Verify all consumers still work
```

### Duplication Elimination

Extract duplicated logic into shared utilities.

**When to use:** Same or near-identical logic appears in multiple locations.

```
1. Identify all instances of duplicated logic
2. Determine canonical implementation
3. Extract to shared utility with clear interface
4. Replace all instances with utility calls
5. Verify behavior identical at each call site
```

## Process

### Step 1: Analyze Current Structure

```
1. Read the target file(s) and map:
   - All exports (public API surface)
   - Internal functions and their call graph
   - External dependencies (imports)
   - Database queries and data access patterns
   - Side effects (file I/O, network calls, state mutations)

2. Identify consumers of the target:
   - Search for imports of the target module
   - Map which exports each consumer uses
   - Note any dynamic or reflection-based usage

3. Measure current state:
   - File line count
   - Cyclomatic complexity (approximate)
   - Number of responsibilities
   - Dependency count
```

### Step 2: Verify Test Coverage

```
1. Search for existing tests covering the target
2. Run existing tests to confirm they pass
3. Assess coverage:
   - If adequate coverage exists: proceed to Step 3
   - If coverage is insufficient:
     a. Invoke test-generator skill for the target
     b. Ensure generated tests pass against current code
     c. These tests become the safety net for refactoring
4. Document which tests guard which behaviors
```

### Step 3: Plan Refactoring Steps

```
1. Based on the selected pattern, decompose into atomic steps
2. Each step must be:
   - Small enough to verify independently
   - Reversible if tests fail
   - Isolated from other steps (no combined changes)
3. Order steps to minimize risk:
   - Non-breaking changes first
   - Move code before modifying it
   - Update imports last
4. If steps exceed max_steps, checkpoint with user
5. Document the plan before executing
```

### Step 4: Execute Incremental Steps

For each step in the plan:

```
1. Make the code change (single responsibility per step)
2. Run the test suite
3. If tests pass:
   - Record the step as complete
   - Proceed to next step
4. If tests fail:
   - Analyze failure to determine if:
     a. Test needs updating (behavior intentionally changed)
     b. Refactoring introduced a bug (revert step)
   - If (a): update test and re-verify
   - If (b): revert, reassess approach, try alternative
5. After each step, verify:
   - No import errors in the project
   - No type errors (if typed language)
   - API contract preserved (if preserve_api is true)
```

### Step 5: Verify API Compatibility

```
1. If preserve_api is true:
   - Run API contract tests (from Step 2 or existing)
   - Verify all public exports still exist with same signatures
   - Verify response shapes unchanged (for HTTP APIs)
   - Verify error behaviors unchanged
   - Check that no new required parameters were added

2. If preserve_api is false:
   - Document all API changes
   - Update consumers of changed APIs
   - Flag breaking changes for changelog
```

### Step 6: Update References

```
1. Update all import paths affected by file moves
2. Update barrel files / index files
3. Update dependency injection configuration
4. Update any path-based configuration (routes, etc.)
5. Run full test suite to catch missed references
6. Search for string-based references (dynamic imports, require())
```

### Step 7: Validate and Report

```
1. Run full test suite one final time
2. Verify no regressions across the project
3. Measure improvements:
   - File sizes (before/after)
   - Module count (before/after)
   - Dependency graph complexity
   - Test coverage delta
4. Produce refactoring report
```

## Outputs

**Artifacts:**
- Refactored source files
- New files for extracted services/modules
- Updated import paths across the project
- New or updated tests (if test-generator was invoked)

**Handoff Data:**
```json
{
  "target": "src/services/user-service.ts",
  "pattern": "service-extraction",
  "steps_completed": 6,
  "steps_total": 6,
  "files_modified": [
    "src/services/user-service.ts",
    "src/services/auth-service.ts",
    "src/routes/user-routes.ts"
  ],
  "files_created": [
    "src/services/email-notification-service.ts"
  ],
  "tests_run": 47,
  "tests_passing": 47,
  "api_preserved": true,
  "metrics": {
    "before": {
      "target_lines": 480,
      "responsibilities": 3,
      "dependencies": 12
    },
    "after": {
      "target_lines": 210,
      "new_service_lines": 145,
      "responsibilities": 1,
      "dependencies": 8
    }
  }
}
```

## Human Checkpoints

| Scenario | Tier | Behavior |
|----------|------|----------|
| Refactoring within a single file | Auto | Execute with test verification |
| Service extraction (new files) | Review | Present plan before executing |
| Steps exceed max_steps | Review | Checkpoint with user before continuing |
| API-breaking changes required | Approve | User must approve breaking changes |
| Test failures during refactoring | Review | Present failure analysis, propose resolution |
| Pattern changes scope beyond target | Approve | User approves expanded scope |

## Error Handling

| Error | Resolution |
|-------|------------|
| No test coverage for target | Invoke test-generator before proceeding |
| Tests fail after a step | Revert step, analyze, try alternative approach |
| Circular dependency created | Restructure extraction boundary |
| API contract broken (preserve_api: true) | Revert to last passing state, reassess approach |
| Dynamic imports prevent static analysis | Flag for manual review, search for string patterns |
| Type errors after move | Update type imports and re-export types from new location |
| Consumers not updated | Search project-wide for old import paths |
| Performance regression after restructuring | Profile and optimize, may need different pattern |

## Example Invocations

**Extract email service from user service:**
```
target_path: src/services/user-service.ts
pattern: service-extraction
description: "Extract email notification logic into its own service"

→ Step 1: Analyze user-service.ts (480 lines, 3 responsibilities)
→ Step 2: Tests exist — 32 passing
→ Step 3: Plan 6 steps for extraction
→ Step 4: Execute steps, tests pass after each
→ Step 5: API preserved — all 32 tests still pass
→ Result: user-service.ts reduced to 210 lines,
          new email-notification-service.ts at 145 lines
```

**Dependency inversion for testability:**
```
target_path: src/handlers/payment-handler.ts
pattern: dependency-inversion
description: "Make payment handler testable by injecting the payment gateway"

→ Step 1: Analyze — direct PaymentGateway instantiation
→ Step 2: No tests — invoke test-generator first
→ Step 3: Plan 4 steps
→ Step 4: Extract interface, refactor constructor, update call sites
→ Result: PaymentGateway injected, test doubles available
```

**Optimize N+1 queries:**
```
target_path: src/repositories/order-repository.ts
pattern: database-query-optimization
description: "Fix N+1 query on order listing page"

→ Step 1: Identify N+1 pattern in getOrdersWithItems()
→ Step 2: Tests cover current behavior
→ Step 3: Plan: add join query, update mapper, verify results
→ Step 4: Execute — query count drops from N+1 to 2
→ Result: Response time reduced, same data returned
```

## Integration Points

- **Invoked by:** `developer` agent, `architect` during technical planning
- **Invokes:** `test-generator` skill (to ensure coverage before refactoring)
- **Works with:** Code review skill (validates refactoring quality)
- **Outputs to:** Modified and new source files in the project

## Best Practices

1. **Tests first, always** — Never refactor without a safety net of passing tests
2. **Small steps** — Each step should be independently verifiable
3. **One pattern at a time** — Don't combine service extraction with query optimization
4. **Preserve before improve** — Lock current behavior, then restructure
5. **Measure the improvement** — Quantify what got better (lines, complexity, coupling)
6. **Revert early** — If a step breaks tests, revert immediately rather than debugging forward
7. **Update imports last** — Move code first, then redirect consumers

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-03-11 | Initial release — full implementation |
