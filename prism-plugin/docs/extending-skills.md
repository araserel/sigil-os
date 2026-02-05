# Extending Skills Guide

> Complete guide for creating new Prism skills.

---

## Overview

Skills are reusable, chainable units of work that encapsulate specific capabilities. This guide covers everything you need to create new skills for Prism.

---

## Skill Categories

Prism organizes skills into 8 categories. Before creating a new skill, review existing ones to avoid duplication.

| Category | Purpose | Skills |
|----------|---------|--------|
| **Workflow** | Core development workflow | `spec-writer`, `clarifier`, `technical-planner`, `task-decomposer`, `complexity-assessor`, `handoff-packager`, `constitution-writer`, `status-reporter`, `foundation-writer`, `visual-analyzer` |
| **Design** | UI/UX design and accessibility | `framework-selector`, `ux-patterns`, `ui-designer`, `accessibility`, `design-system-reader`, `figma-review` |
| **UI Implementation** | Framework-specific UI code | `react-ui`, `react-native-ui`, `flutter-ui`, `vue-ui`, `swift-ui`, `design-skill-creator` |
| **Engineering** | Code and architecture | `adr-writer` |
| **Quality** | Validation and fixing | `qa-validator`, `qa-fixer` |
| **Review** | Code, security, deploy checks | `code-reviewer`, `security-reviewer`, `deploy-checker` |
| **Research** | Information gathering | `researcher`, `knowledge-search`, `codebase-assessment`, `problem-framing`, `constraint-discovery`, `stack-recommendation` |
| **Learning** | Institutional memory | `learning-capture`, `learning-reader`, `learning-review` |

---

## Skill Chain Overview

Skills are often invoked in sequences called **chains**. Understanding these helps you design skills that integrate smoothly.

**Chain 1: Full Pipeline** (Standard and Enterprise tracks)
```
complexity-assessor → spec-writer ←→ clarifier (loop) → technical-planner ← researcher (parallel)
    → task-decomposer → [Per Task: Developer → qa-validator ←→ qa-fixer (loop)]
    → code-reviewer + security-reviewer (parallel) → Complete
```

**Chain 2: Quick Flow** (Bug fixes, small changes)
```
complexity-assessor → quick-spec → task-decomposer → implement → qa-validator → Complete
```

**Chain 3: Research-First** (New technology decisions)
```
researcher (parallel) → technical-planner → adr-writer → [continue to implementation]
```

**Chain 4: Validate → Review** (Quality gate before deployment)
```
qa-validator → qa-fixer ←→ qa-validator (loop max 5) → code-reviewer + security-reviewer (parallel)
    → deploy-checker → Human Approval (if production)
```

When creating a new skill, determine which chain(s) it fits into and update your `invokes` / `invoked_by` fields accordingly.

---

## Skill Anatomy

Every skill file consists of two parts:

### 1. Frontmatter (YAML)

```yaml
---
name: skill-name
description: One-line description of what this skill does
version: 1.0.0
category: workflow|design|ui|qa|review|research|learning|engineering
chainable: true|false
invokes: [list, of, skills, this, calls]
invoked_by: [list, of, skills, that, call, this]
tools: Tool1, Tool2, Tool3
inputs: [required_input1, required_input2]
outputs: [output_artifact1, output_artifact2]
---
```

### 2. Body (Markdown)

The skill definition including purpose, workflow, inputs/outputs, and version history.

---

## Required Frontmatter Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Kebab-case identifier (e.g., `my-new-skill`) |
| `description` | string | Brief description (< 100 chars) |
| `version` | string | Semantic version (start at `1.0.0`) |
| `category` | enum | One of: `workflow`, `design`, `ui`, `qa`, `review`, `research`, `learning`, `engineering` |
| `chainable` | boolean | Can output feed into another skill? |
| `invokes` | array | Skills this skill may call |
| `invoked_by` | array | Skills that may call this skill |
| `tools` | string | Comma-separated Claude Code tools used |
| `inputs` | array | Required input identifiers |
| `outputs` | array | Output artifact identifiers |

---

## Required Body Sections

### 1. Purpose

```markdown
## Purpose

[1-3 sentences explaining what this skill accomplishes and why it exists]
```

### 2. When Invoked

```markdown
## When Invoked

**Trigger phrases:**
- "phrase that triggers this skill"
- "another trigger phrase"

**Context:** [When/why this skill is used in the workflow]
```

### 3. Workflow

```markdown
## Workflow

### Step 1: [Step Name]
[What happens in this step]

### Step 2: [Step Name]
[What happens in this step]

...
```

### 4. Input Schema

```markdown
## Input Schema

```json
{
  "required_field": "description and type",
  "optional_field?": "description (optional)"
}
```
```

### 5. Output Schema

```markdown
## Output Schema

```json
{
  "output_field": "description and type",
  "artifact_path": "path to created file"
}
```
```

### 6. Error Handling

```markdown
## Error Handling

| Error | Resolution |
|-------|------------|
| [Error case] | [How to handle] |
```

### 7. Human Tier

```markdown
## Human Tier

**Tier:** [Auto | Review | Approve]

[Description of when human intervention is needed]
```

### 8. Version History

```markdown
## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | YYYY-MM-DD | Initial release |
```

---

## Step-by-Step Creation Guide

### Step 1: Identify the Need

Before creating a skill, answer:

1. **What problem does this solve?**
2. **Is this reusable?** (If one-time, don't create a skill)
3. **Does a similar skill exist?** (Check `.claude/skills/`)
4. **Where does it fit in the workflow?**

### Step 2: Choose the Category

| Category | Use When |
|----------|----------|
| `workflow` | Core workflow operations (spec, plan, tasks) |
| `design` | UI/UX design, component architecture, accessibility |
| `ui` | Framework-specific UI implementation (React, Flutter, etc.) |
| `qa` | Validation and fixing operations |
| `review` | Code, security, or deployment review |
| `research` | Information gathering and analysis |
| `learning` | Institutional memory and knowledge management |
| `engineering` | Architecture and code patterns (ADRs, etc.) |

### Step 3: Define the Contract

Determine:

- **Inputs:** What data does this skill need?
- **Outputs:** What does it produce?
- **Dependencies:** What skills call this or does this call?

### Step 4: Write the Skill

1. Copy the template from `/templates/skill-template.md`
2. Fill in all required sections
3. Add examples and edge cases
4. Include version history

### Step 5: Register the Skill

1. Place file in appropriate category directory
2. Update `.claude/skills/README.md`
3. Add to any agent that invokes it

### Step 6: Test the Skill

1. Invoke manually with test inputs
2. Verify outputs match schema
3. Test error handling
4. Verify chain compatibility

---

## Input/Output Contract Format

### Input Contract

```markdown
## Inputs

**Required:**
- `spec_path`: string — Path to feature specification
- `track`: enum — "Quick" | "Standard" | "Enterprise"

**Optional:**
- `verbose?`: boolean — Enable detailed output (default: false)
- `max_items?`: number — Maximum items to process (default: 10)

**Auto-loaded:**
- `constitution`: string — Loaded from `/specs/000-constitution/spec.md`
```

### Output Contract

```markdown
## Outputs

**Artifact:**
- `/specs/###-feature/output.md` — Primary output document

**Handoff Data:**
```json
{
  "status": "complete | partial | failed",
  "artifact_path": "/path/to/output",
  "next_skill": "skill-name",
  "metadata": {}
}
```
```

---

## Chain Integration Patterns

### Sequential Chain

```
skill-a → skill-b → skill-c
```

Each skill's output becomes the next skill's input.

```yaml
# skill-a
outputs: [plan.md]

# skill-b
inputs: [plan_path]  # Receives skill-a's output
outputs: [tasks.md]
```

### Parallel Chain

```
         ┌→ skill-b ─┐
skill-a ─┤           ├→ skill-d
         └→ skill-c ─┘
```

Multiple skills process the same input independently.

```yaml
# skill-a
outputs: [spec.md]
invokes: [skill-b, skill-c]

# skill-b and skill-c both receive spec.md
# skill-d receives outputs from both
```

### Conditional Chain

```
skill-a → condition? → skill-b (if true)
                    → skill-c (if false)
```

Skill output determines next skill in chain.

```yaml
# skill-a
outputs: [result]
# Output includes next_skill field based on condition
```

---

## Worked Example: Changelog Writer

Let's create a new skill that generates changelogs from git commits.

### Step 1: Define the Need

- **Problem:** Need consistent changelog generation
- **Reusable:** Yes, used for every release
- **Similar:** No existing skill
- **Workflow fit:** Review phase, before deployment

### Step 2: Choose Category

`workflow` — It's a core workflow operation

### Step 3: Define Contract

- **Inputs:** Version number, date range, feature paths
- **Outputs:** CHANGELOG.md entries
- **Dependencies:** Invoked by orchestrator, invokes none

### Step 4: Write the Skill

```markdown
---
name: changelog-writer
description: Generates changelog entries from git commits and feature specs
version: 1.0.0
category: workflow
chainable: false
invokes: []
invoked_by: [orchestrator]
tools: Read, Bash, Glob
inputs: [version, since_date]
outputs: [changelog_entry]
---

# Skill: Changelog Writer

## Purpose

Generate formatted changelog entries from git history and completed feature specifications. Produces human-readable release notes following Keep a Changelog format.

## When Invoked

**Trigger phrases:**
- "generate changelog"
- "write release notes"
- "prepare changelog for release"

**Context:** User is preparing a release and needs changelog documentation.

## Workflow

### Step 1: Gather Changes

1. Read git log since last release tag
2. Find all feature specs completed since then
3. Identify breaking changes, features, and fixes

### Step 2: Categorize

Group changes by type:
- **Added** — New features
- **Changed** — Modifications to existing features
- **Deprecated** — Features marked for removal
- **Removed** — Deleted features
- **Fixed** — Bug fixes
- **Security** — Security-related changes

### Step 3: Generate Entry

Create changelog entry following Keep a Changelog format:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- Feature description (#PR)

### Changed
- Change description (#PR)

### Fixed
- Fix description (#PR)
```

### Step 4: Integrate

Prepend entry to CHANGELOG.md (or create if not exists).

## Input Schema

```json
{
  "version": "1.2.0",
  "since_date": "2024-01-01",
  "since_tag?": "v1.1.0"
}
```

## Output Schema

```json
{
  "changelog_path": "CHANGELOG.md",
  "entry_content": "[Full markdown entry]",
  "categories": {
    "added": 3,
    "changed": 2,
    "fixed": 5
  }
}
```

## Error Handling

| Error | Resolution |
|-------|------------|
| No git history | Create minimal entry from specs only |
| No changes found | Report "no changes" to user |
| Invalid date format | Parse common formats, ask if unclear |

## Human Tier

**Tier:** Review

Changelog entry shown to user for review before writing to file.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-01-15 | Initial release |
```

---

## Troubleshooting

### Common Issues

**Skill not found**
- Verify file is in correct directory
- Check filename matches `name` in frontmatter
- Ensure README.md is updated

**Chain breaks**
- Verify output schema matches next skill's input
- Check for version compatibility
- Ensure required fields are populated

**Human tier not triggered**
- Verify `human_tier` is set correctly
- Check if error escalation is working

**Skill invokes wrong tool**
- Verify `tools` list in frontmatter
- Check tool names are valid Claude Code tools

### Debugging Steps

1. **Check frontmatter validity**
   ```bash
   # Validate YAML syntax
   head -20 skill-file.md
   ```

2. **Trace chain flow**
   - Check `invokes` and `invoked_by` in each skill
   - Verify data flows correctly

3. **Test in isolation**
   - Invoke skill manually with known inputs
   - Verify outputs before testing in chain

---

## Best Practices

1. **Single Responsibility** — One skill, one job
2. **Clear Contracts** — Explicit inputs/outputs
3. **Graceful Errors** — Handle edge cases
4. **Version Discipline** — Update version on any change
5. **Documentation** — Include examples and edge cases
6. **Human Tiers** — Default to review for uncertain cases
7. **Chainability** — Design for integration from the start

---

## Related Documents

- [Skill Template](/templates/skill-template.md) — Blank template
- [Versioning Guide](/docs/versioning.md) — Version management
- [Error Handling](/docs/error-handling.md) — Error taxonomy
- [Skills README](/.claude/skills/README.md) — Skill catalog
