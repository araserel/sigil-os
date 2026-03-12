---
name: test-generator
description: Generate test files for existing or new code. Detects test framework from project configuration and follows existing test patterns.
version: 1.0.0
category: engineering
chainable: true
invokes: []
invoked_by: [developer, orchestrator, refactoring-backend, refactoring-frontend]
tools: Read, Write, Edit, Bash, Glob, Grep
---

# Skill: Test Generator

## Purpose

Generate high-quality test files for existing or new code. Automatically detects the project's test framework, follows existing test conventions, and produces tests that cover core logic, edge cases, and error paths. Supports unit, integration, and API/endpoint test patterns.

## When to Invoke

- Developer needs tests for new code before or after implementation
- Test coverage gaps identified during code review
- TDD workflow: generate failing tests before writing implementation
- User requests "write tests for X" or "add test coverage"
- Refactoring skill needs test coverage before making changes
- QA agent identifies missing test coverage

## Inputs

**Required:**
- `target_path`: string — Path to file or module to generate tests for

**Optional:**
- `test_type`: string — One of: `unit`, `integration`, `api`, `all` (default: inferred)
- `tdd_mode`: boolean — If true, generate tests that are expected to fail (default: false)
- `coverage_mode`: boolean — If true, analyze existing tests and fill gaps (default: false)
- `specific_functions`: string[] — Limit test generation to specific functions/methods
- `output_path`: string — Override default test file location

**Auto-loaded:**
- `project_context`: string — `/.sigil/project-context.md`
- `constitution`: string — `/.sigil/constitution.md` (for testing standards)

## Process

### Step 1: Detect Test Framework

```
1. Scan project root for framework indicators:
   - package.json → jest, vitest, mocha, @testing-library/*
   - pytest.ini / pyproject.toml / setup.cfg → pytest
   - go.mod → Go standard testing
   - Gemfile → rspec, minitest
   - Cargo.toml → Rust #[cfg(test)]
   - pom.xml / build.gradle → JUnit, TestNG
   - composer.json → PHPUnit
2. Check for test configuration files:
   - jest.config.js/ts, vitest.config.ts
   - .mocharc.yml, cypress.config.ts
   - conftest.py, tox.ini
3. Identify test runner command:
   - npm test, npx jest, npx vitest
   - pytest, python -m pytest
   - go test ./...
   - bundle exec rspec
   - cargo test
4. Detect assertion library:
   - expect (Jest/Vitest), assert (Node/Python), chai
   - testing.T (Go), RSpec expectations
5. Detect mocking library:
   - jest.mock, vi.mock, sinon
   - unittest.mock, pytest-mock
   - gomock, testify/mock
6. If no framework detected:
   - Recommend framework based on project language
   - Ask user before proceeding
```

### Step 2: Analyze Existing Test Patterns

```
1. Find existing test files using project conventions:
   - __tests__/ directory, *.test.ts, *.spec.ts
   - test_*.py, *_test.py, tests/ directory
   - *_test.go
   - *_spec.rb, spec/ directory
2. Read 3-5 existing test files to extract patterns:
   - Import style and organization
   - Describe/it vs test() naming conventions
   - Setup/teardown patterns (beforeEach, setUp, etc.)
   - Mocking patterns and conventions
   - Assertion style preferences
   - Test data/fixture patterns
   - File naming convention (test vs spec, prefix vs suffix)
3. Determine test file location convention:
   - Co-located (same directory as source)
   - Separate test directory mirroring source structure
   - Centralized __tests__ or tests/ folder
4. Store detected patterns as the template for generation
```

### Step 3: Analyze Target Code

```
1. Read the target file(s)
2. Extract testable units:
   - Exported functions and their signatures
   - Class methods (public and protected)
   - API route handlers and middleware
   - React/Vue/Svelte components (props, events, rendering)
3. For each testable unit, identify:
   - Input parameters and their types
   - Return type and possible return values
   - Side effects (API calls, DB queries, file I/O, state mutations)
   - Error conditions and thrown exceptions
   - Conditional branches and edge cases
4. Map dependencies that need mocking:
   - External API calls
   - Database operations
   - File system operations
   - Third-party library calls
   - Environment variables
5. Identify boundary conditions:
   - Null/undefined/empty inputs
   - Maximum/minimum values
   - Type coercion edge cases
   - Concurrent access patterns
```

### Step 4: Generate Test Cases

For each testable unit, generate test cases in these categories:

**Happy Path Tests:**
```
1. Standard input → expected output
2. Common use cases from function purpose
3. Multiple valid input variations
```

**Edge Case Tests:**
```
1. Empty/null/undefined inputs
2. Boundary values (0, -1, MAX_INT, empty string, empty array)
3. Special characters and unicode
4. Very large inputs
5. Type edge cases (NaN, Infinity for numbers)
```

**Error Path Tests:**
```
1. Invalid input types
2. Missing required parameters
3. Network/IO failures (for async operations)
4. Timeout scenarios
5. Permission/authorization failures
```

**Integration Tests (if test_type includes integration):**
```
1. Multi-function workflows
2. Database read/write cycles
3. API request → response chains
4. Event emission and handling
```

**API/Endpoint Tests (if test_type includes api):**
```
1. Valid request → expected response + status code
2. Invalid request body → 400 response
3. Unauthorized request → 401/403 response
4. Not found → 404 response
5. Request validation edge cases
6. Response shape verification
```

### Step 5: Compose Test File

```
1. Generate file header with imports matching project patterns
2. Set up test suite structure (describe blocks or equivalent)
3. Add setup/teardown for shared fixtures
4. Write each test case with:
   - Clear descriptive name (what it tests, not how)
   - Arrange: set up test data and mocks
   - Act: call the function/endpoint
   - Assert: verify the result
5. Add mock definitions at appropriate scope
6. Follow detected naming conventions:
   - "should [expected behavior] when [condition]"
   - "returns [result] for [input]"
   - "[function name] - [scenario]"
7. Group related tests logically
8. Add any necessary type annotations
```

### Step 6: Write Test File

```
1. Determine output path:
   - If output_path provided, use it
   - Otherwise follow detected convention:
     - source.ts → source.test.ts (co-located)
     - src/module.py → tests/test_module.py (separate)
     - pkg/handler.go → pkg/handler_test.go (co-located, Go convention)
2. Write the generated test file
3. Verify file is syntactically valid (basic checks)
```

### Step 7: Verify Tests Execute

```
1. Run the test file using detected test runner
2. Capture output:
   - If tdd_mode: expect failures, verify tests run without syntax errors
   - If not tdd_mode: expect passes for existing code
3. If tests fail unexpectedly:
   - Analyze failure output
   - Fix import paths, mock setup, or assertion issues
   - Re-run to verify
4. Report results:
   - Tests generated: count
   - Tests passing: count
   - Tests failing: count (expected in TDD mode)
   - Coverage delta if available
```

## Outputs

**Artifact:**
- Test file at the appropriate path following project conventions

**Handoff Data:**
```json
{
  "test_path": "src/services/__tests__/auth.test.ts",
  "target_path": "src/services/auth.ts",
  "framework": "vitest",
  "test_count": 15,
  "test_categories": {
    "happy_path": 5,
    "edge_cases": 4,
    "error_paths": 4,
    "integration": 2
  },
  "passing": 15,
  "failing": 0,
  "tdd_mode": false,
  "mocks_created": ["database", "email-service"],
  "coverage_impact": "+12% lines"
}
```

## Coverage-Driven Mode

When `coverage_mode` is true:

```
1. Run existing tests with coverage reporting
2. Parse coverage output for target file
3. Identify uncovered:
   - Lines and branches
   - Functions never called
   - Error handlers never triggered
4. Generate tests specifically targeting uncovered paths
5. Re-run coverage to verify improvement
6. Report before/after coverage delta
```

## Human Checkpoints

| Scenario | Tier | Behavior |
|----------|------|----------|
| Unit tests for existing code | Auto | Generate and run without approval |
| Integration tests | Review | Present test plan for review before generation |
| Tests modifying shared fixtures | Review | Confirm fixture changes with user |
| No test framework detected | Approve | User must choose framework before proceeding |
| TDD mode (tests expected to fail) | Auto | Generate without approval, report expected failures |

## Error Handling

| Error | Resolution |
|-------|------------|
| No test framework detected | Recommend framework based on language, ask user |
| Target file has no exports | Check for side effects to test, or flag as untestable |
| Test runner not installed | Provide install command, ask user to run it |
| Tests fail due to missing env vars | Document required env vars in test comments |
| Cannot determine test location convention | Ask user for preferred test location |
| Circular dependencies prevent mocking | Suggest dependency injection refactor |
| Target is generated code | Skip or flag — generated code changes should not be tested directly |

## Example Invocations

**Generate tests for a service file:**
```
target_path: src/services/user-service.ts
test_type: unit

→ Generates src/services/__tests__/user-service.test.ts
→ 12 tests covering CRUD operations, validation, error handling
→ Mocks database layer
→ All tests passing
```

**TDD mode for new feature:**
```
target_path: src/services/payment-service.ts
tdd_mode: true

→ Generates src/services/__tests__/payment-service.test.ts
→ 8 tests defining expected behavior
→ All tests failing (no implementation yet)
→ Ready for developer to implement
```

**Coverage gap analysis:**
```
target_path: src/utils/validation.ts
coverage_mode: true

→ Detects 62% line coverage
→ Generates 6 new tests for uncovered branches
→ Coverage increases to 91%
```

## Integration Points

- **Invoked by:** `developer` agent, `orchestrator` during task execution
- **Works with:** `refactoring-backend` and `refactoring-frontend` skills (ensure coverage before refactoring)
- **Outputs to:** Test file in project test directory
- **References:** Project test configuration, existing test patterns

## Best Practices

1. **Match existing style** — Generated tests should be indistinguishable from hand-written ones
2. **Test behavior, not implementation** — Focus on what the function does, not how
3. **One assertion per test** — Keep tests focused and failure messages clear
4. **Descriptive names** — Test name should explain what broke when it fails
5. **Minimal mocking** — Only mock external dependencies, not internal modules
6. **Deterministic tests** — No reliance on time, random values, or network without mocking
7. **Fast tests** — Unit tests should run in milliseconds, mock slow operations

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-03-11 | Initial release — full implementation |
