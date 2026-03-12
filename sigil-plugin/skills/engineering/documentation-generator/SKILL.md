---
name: documentation-generator
description: Generate documentation from code analysis. Produces README files, API references, and module documentation following detected project patterns.
version: 1.0.0
category: engineering
chainable: true
invokes: []
invoked_by: [developer, orchestrator]
tools: Read, Write, Edit, Glob, Grep
---

# Skill: Documentation Generator

## Purpose

Generate and update documentation by analyzing source code. Produces README files, API references, module documentation, and changelog entries. Detects existing documentation patterns and inline doc standards per language to ensure consistency.

## When to Invoke

- New module or service needs documentation
- API endpoints added or changed
- User requests "document this" or "generate docs"
- Code review identifies missing documentation
- Release preparation requires updated API reference
- Codebase assessment reveals documentation gaps

## Inputs

**Required:**
- `target`: string — Path to file, directory, or module to document

**Optional:**
- `doc_type`: string — One of: `readme`, `api`, `module`, `changelog`, `inline`, `all` (default: inferred)
- `output_path`: string — Override default documentation location
- `audience`: string — One of: `developer`, `user`, `contributor` (default: `developer`)
- `update_mode`: boolean — Update existing docs rather than regenerate (default: false)

**Auto-loaded:**
- `project_context`: string — `/.sigil/project-context.md`
- `constitution`: string — `/.sigil/constitution.md` (for documentation standards)

## Process

### Step 1: Analyze Codebase Structure

```
1. Scan target path to understand scope:
   - Single file: document that file's exports
   - Directory: document the module/package
   - Project root: generate project-level docs

2. Identify project language and ecosystem:
   - Package manager files (package.json, pyproject.toml, go.mod, Cargo.toml)
   - Entry points (index.ts, main.py, main.go, lib.rs)
   - Build configuration

3. Map the public API surface:
   - Exported functions, classes, types, constants
   - Route handlers and endpoints
   - CLI commands and flags
   - Configuration options

4. Identify existing documentation:
   - README.md files at various levels
   - API doc files (openapi.yaml, swagger.json)
   - Doc comments in source code
   - docs/ directory contents
   - Wiki or external doc references
```

### Step 2: Detect Documentation Patterns

```
1. Analyze existing inline documentation style:

   JavaScript/TypeScript:
   - JSDoc: /** @param {string} name - Description */
   - TSDoc: /** @param name - Description */
   - No inline docs (flag as gap)

   Python:
   - Google-style docstrings
   - NumPy-style docstrings
   - Sphinx/reST-style docstrings
   - No docstrings (flag as gap)

   Go:
   - GoDoc comments (// FunctionName does X)
   - Package-level doc.go files

   Rust:
   - /// doc comments with markdown
   - //! module-level documentation

   Java/Kotlin:
   - Javadoc /** comments */
   - KDoc /** comments */

   Ruby:
   - YARD @param, @return tags
   - RDoc format

2. Analyze existing README patterns:
   - Header structure (badges, title, description)
   - Section ordering (install, usage, API, contributing)
   - Code example style
   - Link and reference format

3. Check for doc generation tools:
   - TypeDoc, JSDoc site generator
   - Sphinx, MkDocs, pdoc
   - Godoc, pkg.go.dev format
   - rustdoc
   - Storybook (for component docs)

4. Store detected patterns as generation template
```

### Step 3: Extract Public API Surface

```
1. For each exported symbol, extract:
   - Name and type (function, class, type, constant)
   - Signature (parameters, return type)
   - Existing doc comment (if any)
   - Usage examples from tests
   - Deprecation notices

2. For route handlers / API endpoints:
   - HTTP method and path
   - Request parameters (path, query, body)
   - Request/response types or schemas
   - Authentication requirements
   - Status codes and error responses
   - Rate limiting or pagination

3. For configuration options:
   - Option name and type
   - Default value
   - Description and constraints
   - Environment variable mapping

4. For CLI commands:
   - Command name and aliases
   - Flags and arguments
   - Description and examples
```

### Step 4: Generate Documentation

Based on `doc_type`, generate the appropriate output:

**README Generation (doc_type: readme):**
```
1. Project/module title and description
2. Badges (if project-level: build status, version, license)
3. Quick start / installation:
   - Prerequisites
   - Install command
   - Minimal usage example
4. Usage section:
   - Primary use cases with code examples
   - Configuration options
5. API overview (brief, link to full reference)
6. Development section (if audience is contributor):
   - Setup instructions
   - Test commands
   - Contributing guidelines
7. License and links
```

**API Reference Generation (doc_type: api):**
```
1. For REST/HTTP APIs:
   - Group endpoints by resource/domain
   - For each endpoint: method, path, description
   - Request parameters with types and constraints
   - Request body schema with examples
   - Response schema with examples
   - Error responses and codes
   - Authentication requirements
   - Code examples (curl, language-specific)

2. For library/module APIs:
   - Group by class or module
   - For each export: signature, description, parameters
   - Return values and types
   - Thrown exceptions
   - Usage examples (extracted from tests when possible)
   - Related functions/methods
```

**Module Documentation (doc_type: module):**
```
1. Module purpose and responsibility
2. Architecture overview (how it fits in the system)
3. Key concepts and terminology
4. Public API summary
5. Internal structure (for contributor audience)
6. Dependencies and integration points
7. Examples and common patterns
```

**Changelog Entry (doc_type: changelog):**
```
1. Analyze git diff or staged changes
2. Categorize changes: Added, Changed, Fixed, Removed, Deprecated
3. Write entries in Keep a Changelog format
4. Reference relevant tickets or PRs
5. Note breaking changes prominently
```

**Inline Documentation (doc_type: inline):**
```
1. For each undocumented export:
   - Infer purpose from name, usage, and implementation
   - Generate doc comment in detected project style
   - Include parameter descriptions
   - Include return value description
   - Add @throws / Raises for error conditions
   - Add usage example where non-obvious
2. Write doc comments directly into source files
3. Preserve existing documentation — only add missing docs
```

### Step 5: Validate Documentation

```
1. Link validation:
   - Internal links point to existing files/sections
   - Code references match actual exports
   - Image/asset references are valid

2. Completeness check:
   - All public exports documented
   - All API endpoints covered
   - No placeholder text remaining
   - Examples are syntactically valid

3. Accuracy check:
   - Parameter names match actual signatures
   - Return types match actual returns
   - Default values are current
   - Deprecated items are marked

4. Style consistency:
   - Heading levels are consistent
   - Code block language tags present
   - Formatting matches existing docs
```

### Step 6: Write Output

```
1. If update_mode:
   - Diff new content against existing documentation
   - Merge changes preserving manual additions
   - Mark sections that need human review

2. If new documentation:
   - Write to output_path or conventional location
   - README.md → project/module root
   - API docs → docs/api/ or conventional location
   - Inline docs → directly in source files

3. Report what was generated:
   - Files created or updated
   - Coverage metrics (documented vs total exports)
   - Sections that need human review
```

## Outputs

**Artifacts:**
- Documentation files at appropriate locations

**Handoff Data:**
```json
{
  "generated_files": [
    {
      "path": "docs/api/user-service.md",
      "type": "api",
      "exports_documented": 12,
      "exports_total": 12
    }
  ],
  "doc_type": "api",
  "target": "src/services/user-service.ts",
  "coverage": {
    "functions": "12/12",
    "types": "5/5",
    "endpoints": "8/8"
  },
  "needs_review": [
    "Authentication section — verify token format description"
  ],
  "update_mode": false
}
```

## Human Checkpoints

| Scenario | Tier | Behavior |
|----------|------|----------|
| Inline doc generation | Auto | Add doc comments without approval |
| Module README | Review | Present draft for user review |
| Project-level README | Review | Present draft, user may want custom sections |
| API reference | Auto | Generate from code — factual, low risk |
| Changelog entries | Review | User confirms entries before adding to changelog |
| Update mode (modifying existing docs) | Review | Show diff of proposed changes |

## Error Handling

| Error | Resolution |
|-------|------------|
| No exports found in target | Check for non-standard export patterns, or flag as internal module |
| Inline doc style not detected | Ask user for preferred style, default to language standard |
| Existing README has custom structure | Preserve structure, update individual sections |
| Target file has no types/signatures | Infer from usage and implementation, mark as approximate |
| OpenAPI/Swagger spec exists | Use as authoritative source, supplement with code analysis |
| Generated docs exceed reasonable length | Split into multiple files, add table of contents |
| Conflicting doc sources | Flag conflict, prefer code as source of truth |

## Example Invocations

**Generate module README:**
```
target: src/services/auth/
doc_type: readme
audience: developer

→ Generates src/services/auth/README.md
→ Includes: purpose, API surface, usage examples, configuration
→ Follows project's existing README style
```

**Generate API reference:**
```
target: src/routes/
doc_type: api

→ Generates docs/api/routes.md
→ Documents 15 endpoints grouped by resource
→ Includes request/response schemas, examples, error codes
```

**Add inline documentation:**
```
target: src/utils/validation.ts
doc_type: inline

→ Adds JSDoc comments to 8 undocumented functions
→ Preserves 3 existing doc comments unchanged
→ Includes @param, @returns, @throws tags
```

**Generate changelog entry:**
```
target: . (project root)
doc_type: changelog

→ Analyzes git diff since last tag
→ Generates: Added (2), Changed (1), Fixed (3)
→ Presents entries for user review
```

## Integration Points

- **Invoked by:** `developer` agent, `orchestrator` during finalization
- **Works with:** Code review skill (documentation quality), codebase assessment
- **Outputs to:** Documentation files in project
- **References:** Existing documentation, test files (for usage examples), OpenAPI specs

## Best Practices

1. **Code is the source of truth** — Documentation derived from code stays accurate longer
2. **Examples from tests** — Real test cases make the best usage examples
3. **Update, don't replace** — In update mode, preserve human-written content
4. **Match the project style** — Generated docs should feel native to the project
5. **Document the "why"** — Code shows "what"; documentation should explain "why"
6. **Keep it scannable** — Use headers, tables, and code blocks for quick navigation
7. **Link, don't repeat** — Reference other docs rather than duplicating content

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-03-11 | Initial release — full implementation |
