# Skill Versioning Guide

> Strategy for versioning Prism skills, ensuring compatibility, and managing deprecation.

---

## Overview

Prism uses semantic versioning for all skills to ensure:

- **Compatibility** between skills in a chain
- **Clear communication** about breaking changes
- **Safe upgrades** without unexpected failures
- **Deprecation path** for retiring old patterns

---

## Semantic Versioning

All skills follow **Semantic Versioning 2.0.0** (semver):

```
MAJOR.MINOR.PATCH
```

### Version Components

| Component | When to Increment | Example |
|-----------|-------------------|---------|
| **MAJOR** | Breaking changes to inputs/outputs | 1.0.0 → 2.0.0 |
| **MINOR** | New capability (backward compatible) | 1.0.0 → 1.1.0 |
| **PATCH** | Bug fix, documentation | 1.0.0 → 1.0.1 |

---

## What Constitutes a Change

### MAJOR (Breaking)

Increment MAJOR version when:

- **Input schema changes** — Required field added, field removed, type changed
- **Output schema changes** — Field removed, type changed, structure altered
- **Behavior changes** — Same inputs produce different outputs
- **Chain contract broken** — Downstream skills would fail

**Examples:**
```yaml
# Breaking: Required input added
inputs: [spec_path]        # v1.0.0
inputs: [spec_path, track] # v2.0.0 (track now required)

# Breaking: Output field removed
outputs: [plan.md, risks]  # v1.0.0
outputs: [plan.md]         # v2.0.0 (risks removed)

# Breaking: Output type changed
output: { status: "string" }   # v1.0.0
output: { status: "boolean" }  # v2.0.0
```

### MINOR (Feature)

Increment MINOR version when:

- **New optional input** — Backward compatible
- **New output field** — Doesn't change existing outputs
- **New capability** — Additional behavior without breaking existing
- **Performance improvement** — Same contract, better execution

**Examples:**
```yaml
# Feature: New optional input
inputs: [spec_path]                    # v1.0.0
inputs: [spec_path, verbose?]          # v1.1.0 (optional param)

# Feature: Additional output
outputs: [plan.md]                     # v1.0.0
outputs: [plan.md, diagram.mermaid]    # v1.1.0 (new artifact)
```

### PATCH (Fix)

Increment PATCH version when:

- **Bug fix** — Corrects incorrect behavior
- **Documentation** — Improves clarity, fixes typos
- **Internal refactor** — Same contract, different implementation
- **Error message improvement** — Better diagnostics

**Examples:**
```yaml
# Patch: Fixed incorrect validation
# v1.0.0: Allowed empty arrays (bug)
# v1.0.1: Now correctly rejects empty arrays

# Patch: Documentation
# v1.0.0: Unclear example
# v1.0.1: Added clarifying example
```

---

## Compatibility Rules

### Chain Compatibility

Skills in a chain must have compatible versions:

```
skill-a (v1.2.0) → skill-b (v1.1.0) → skill-c (v2.0.0)
```

**Rules:**
1. Output schema of skill N must satisfy input schema of skill N+1
2. MAJOR version mismatch = **warning** (may still work)
3. Missing required inputs = **halt** (cannot proceed)

### Compatibility Matrix

| Upstream | Downstream | Status |
|----------|------------|--------|
| v1.x.x | v1.x.x | Compatible |
| v1.x.x | v2.x.x | Warning — verify contract |
| v2.x.x | v1.x.x | Warning — may have missing outputs |

### Version Checking

When invoking a skill:

```markdown
1. Check upstream skill output schema
2. Check downstream skill input requirements
3. If MAJOR versions differ:
   - Log warning
   - Verify required inputs present
   - Proceed with caution
4. If required input missing:
   - Halt
   - Report missing dependency
```

---

## Version History Section

Every skill should include a Version History section documenting changes:

```markdown
## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-01-15 | Initial release |
```

### Version History Format

```markdown
## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.1.0 | 2024-03-20 | Added optional `verbose` parameter for detailed output |
| 1.0.1 | 2024-02-10 | Fixed edge case in empty input handling |
| 1.0.0 | 2024-01-15 | Initial release |
```

### What to Document

- **MAJOR:** Full description of breaking changes, migration guide
- **MINOR:** Brief description of new capability
- **PATCH:** One-line description of fix

---

## Deprecation Process

### Deprecation Timeline

1. **Announce** — Mark skill/feature as deprecated in docs
2. **Warn** — Log deprecation warning when used
3. **Migrate** — Provide migration path to replacement
4. **Remove** — Delete in next MAJOR version

### Deprecation Markers

In skill files:

```yaml
---
name: old-skill
deprecated: true
deprecated_by: new-skill
deprecated_date: 2024-06-01
---
```

In documentation:

```markdown
> **DEPRECATED:** This skill is deprecated and will be removed in v3.0.0.
> Use `new-skill` instead. See [Migration Guide](#migration).
```

### Minimum Deprecation Period

- **MINOR features:** 1 MINOR version
- **Skills:** 1 MAJOR version
- **Core patterns:** 2 MAJOR versions

---

## Release Process

### Pre-Release

Before releasing a new skill version:

1. **Update version** in frontmatter
2. **Update Version History** section
3. **Update README** if skill list changed
4. **Test chain compatibility** with dependent skills
5. **Document breaking changes** if MAJOR bump

### Release Checklist

```markdown
- [ ] Version number incremented correctly
- [ ] Version History updated
- [ ] Breaking changes documented (if MAJOR)
- [ ] Migration guide provided (if MAJOR)
- [ ] Dependent skills tested
- [ ] README.md updated
```

---

## Current Skill Versions

Most skills are at v1.0.0 (initial release). Skills modified by cross-cutting specs (SX-series), Stage 2 features (S2-series), or earlier releases are noted below.

### Workflow Skills

| Skill | Version | Status |
|-------|---------|--------|
| complexity-assessor | 1.0.0 | Stable |
| spec-writer | 1.0.0 | Stable |
| clarifier | 1.1.0 | Stable |
| technical-planner | 1.1.0 | Stable |
| task-decomposer | 1.0.0 | Stable |
| constitution-writer | 2.0.0 | Stable |
| preflight-check | 2.0.0 | Stable |
| handoff-packager | 1.0.0 | Stable |
| status-reporter | 1.0.0 | Stable |
| foundation-writer | 1.0.0 | Stable |
| visual-analyzer | 1.0.0 | Stable |
| sprint-planner | 1.0.0 | Stable |
| story-preparer | 1.0.0 | Stable |

### Specification Skills

| Skill | Version | Status |
|-------|---------|--------|
| quick-spec | 1.1.0 | Stable |

### Design Skills

| Skill | Version | Status |
|-------|---------|--------|
| framework-selector | 1.0.0 | Stable |
| ux-patterns | 1.0.0 | Stable |
| ui-designer | 1.0.0 | Stable |
| accessibility | 1.0.0 | Stable |
| design-system-reader | 1.0.0 | Stable |
| figma-review | 1.0.0 | Stable |

### UI Implementation Skills

| Skill | Version | Status |
|-------|---------|--------|
| react-ui | 1.0.0 | Stable |
| react-native-ui | 1.0.0 | Stable |
| flutter-ui | 1.0.0 | Stable |
| vue-ui | 1.0.0 | Stable |
| swift-ui | 1.0.0 | Stable |
| design-skill-creator | 1.0.0 | Stable |

### Quality Skills

| Skill | Version | Status |
|-------|---------|--------|
| qa-validator | 1.1.0 | Stable |
| qa-fixer | 1.2.0 | Stable |
| qa-escalation-policy | 1.1.0 | Stable |
| code-reviewer | 1.1.0 | Stable |
| security-reviewer | 1.0.0 | Stable |
| deploy-checker | 1.0.0 | Stable |

### Learning Skills

| Skill | Version | Status |
|-------|---------|--------|
| learning-capture | 1.2.0 | Stable |
| learning-reader | 1.2.0 | Stable |
| learning-review | 1.0.0 | Stable |

### Shared Context Skills

| Skill | Version | Status |
|-------|---------|--------|
| shared-context-sync | 1.2.0 | Stable |
| connect-wizard | 1.1.0 | Stable |
| profile-generator | 1.0.0 | Stable |

### Research Skills

| Skill | Version | Status |
|-------|---------|--------|
| researcher | 1.0.0 | Stable |
| codebase-assessment | 1.1.0 | Stable |
| knowledge-search | 1.0.0 | Stable |
| problem-framing | 1.0.0 | Stable |
| constraint-discovery | 1.0.0 | Stable |
| stack-recommendation | 1.0.0 | Stable |

---

## Best Practices

### For Skill Authors

1. **Start at 1.0.0** — Don't use 0.x.x for production skills
2. **Document contracts** — Clear input/output schemas
3. **Maintain history** — Update Version History on every change
4. **Think about chains** — Consider upstream/downstream impacts
5. **Deprecate gracefully** — Never break without warning

### For Skill Users

1. **Pin versions** — Be explicit about expected versions
2. **Read changelogs** — Check Version History before updating
3. **Test upgrades** — Verify chains work after version changes
4. **Report issues** — File bugs for version compatibility problems

---

## Related Documents

- [Extending Skills](extending-skills.md) — Creating new skills
- [Skills README](../../skills/README.md) — Skill catalog
- [Error Handling](error-handling.md) — Handling version mismatches
