---
name: skill-name
description: Brief description of what this skill does (< 100 chars)
version: 1.0.0
category: workflow|qa|review|research
chainable: true|false
invokes: []
invoked_by: []
tools: Read, Write, Glob
inputs: [required_input]
outputs: [output_artifact]
---

# Skill: [Skill Name]

## Purpose

[1-3 sentences explaining what this skill accomplishes and why it exists in the Prism OS workflow.]

## When Invoked

**Trigger phrases:**
- "[phrase that triggers this skill]"
- "[another trigger phrase]"

**Context:** [When/why this skill is used in the workflow]

## Workflow

### Step 1: [Step Name]

[Description of what happens in this step]

```
1. [Sub-step]
2. [Sub-step]
3. [Sub-step]
```

### Step 2: [Step Name]

[Description of what happens in this step]

### Step 3: [Step Name]

[Description of what happens in this step]

## Input Schema

```json
{
  "required_field": "string — Description of this field",
  "another_required": "enum — Option1 | Option2 | Option3",
  "optional_field?": "boolean — Description (default: false)"
}
```

**Required:**
- `required_field`: string — [Detailed description]
- `another_required`: enum — [Detailed description]

**Optional:**
- `optional_field?`: boolean — [Description] (default: false)

**Auto-loaded:**
- `constitution`: Loaded from `/specs/000-constitution/spec.md`

## Output Schema

```json
{
  "status": "complete | partial | failed",
  "artifact_path": "/path/to/output",
  "summary": "Brief description of what was produced",
  "next_skill": "skill-name or null",
  "metadata": {}
}
```

## Output Artifact

`/specs/###-feature/[artifact-name].md`

[Description of what this artifact contains and how it's structured]

## Error Handling

| Error | Category | Resolution |
|-------|----------|------------|
| [Error case 1] | Soft | [How to handle] |
| [Error case 2] | Hard | [How to handle] |
| [Error case 3] | Blocking | [How to handle] |

### [Specific Error Scenario]

"[Error message format]

**Options:**
A) [Recovery option]
B) [Alternative option]
C) [Escalation option]"

## Human Tier

**Tier:** [Auto | Review | Approve]

[Description of when human intervention is needed and what they review/approve]

- [Specific condition requiring human]
- [Another condition]

## Integration Points

- **Invoked by:** `[skill-name]` when [condition]
- **Invokes:** `[skill-name]` when [condition]
- **Hands off to:** `[skill-name]` with [data]

## Example

### Input

```json
{
  "required_field": "example value",
  "another_required": "Option1"
}
```

### Output

```json
{
  "status": "complete",
  "artifact_path": "/specs/001-feature/output.md",
  "summary": "Generated output artifact",
  "next_skill": "next-skill-name"
}
```

## Notes

- [Important implementation note]
- [Another note about behavior]
- [Edge case to be aware of]

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | YYYY-MM-DD | Initial release |
