---
name: spec-writer
description: Generates feature specifications from natural language descriptions. Invoke when user describes a feature, says "spec", "specify", or "write spec".
version: 1.0.0
category: workflow
chainable: true
invokes: [clarifier, visual-analyzer]
invoked_by: [orchestrator, business-analyst]
tools: Read, Write, Edit, Glob, Grep
---

# Skill: Spec Writer

## Purpose

Transform natural language feature descriptions into structured specifications. This is the entry point for the spec-first development workflow.

## When to Invoke

- User describes a new feature or enhancement
- User requests `/spec [description]`
- User says "I want...", "We need...", "Build me..."
- Business Analyst agent receives a feature request

## Inputs

**Required:**
- `feature_description`: string — Natural language description of what to build

**Auto-loaded:**
- `constitution_path`: string — `/memory/constitution.md` (loaded automatically)
- `project_context`: string — `/memory/project-context.md` (loaded for context)

**Optional:**
- `visual_assets`: string[] — Paths to mockups, wireframes, or design files
- `existing_specs`: string[] — Paths to related specs for context
- `priority_override`: string — Force P1/P2/P3 classification

## Process

### Step 1: Context Gathering

```
1. Load constitution from /memory/constitution.md
2. Load project context from /memory/project-context.md
3. Scan /specs/ for existing features (avoid conflicts)
4. Determine next feature number (###)
```

### Step 2: Initial Analysis

Analyze the feature description to extract:

1. **Core Intent:** What is the user trying to accomplish?
2. **Target Users:** Who will use this feature?
3. **Key Capabilities:** What must the feature do?
4. **Implicit Requirements:** What's assumed but not stated?
5. **Potential Ambiguities:** What's unclear?

### Step 3: Visual Analysis (if assets provided)

If visual assets are provided:

```
1. Invoke visual-analyzer skill for each asset
2. Extract UI requirements from mockups
3. Identify interactive elements
4. Note accessibility requirements from design
5. Merge findings into requirements
```

### Step 4: Spec Generation

Using the template and analysis:

```
1. Load template from /templates/spec-template.md
2. Generate feature name and ID
3. Write summary (2-3 sentences)
4. Create user scenarios (P1/P2/P3)
5. Define functional requirements (FR-001, FR-002...)
6. Identify key entities
7. Define success criteria
8. List out-of-scope items
9. Flag ambiguities as open questions
```

### Step 5: Constitution Validation

Verify spec against constitution:

```
1. Check technology references match constitution
2. Verify security requirements included
3. Ensure accessibility requirements addressed
4. Flag any constitution conflicts
```

### Step 6: Create Feature Directory

```
1. Create /specs/###-feature-name/ directory
2. Write spec.md to directory
3. Update project-context.md with new feature
```

### Step 7: Ambiguity Assessment

If ambiguities detected:

```
1. List ambiguities in Open Questions section
2. Flag spec as requiring clarification
3. Prepare handoff data for clarifier skill
```

## Outputs

**Artifact:**
- `/specs/###-feature-name/spec.md` — Complete feature specification

**Handoff Data:**
```json
{
  "spec_path": "/specs/001-user-auth/spec.md",
  "feature_id": "001",
  "feature_name": "user-auth",
  "ambiguity_flags": [
    "FR-003: Edge case for expired tokens unclear",
    "Authentication method (session vs JWT) not specified"
  ],
  "requires_clarification": true,
  "priority_requirements": ["FR-001", "FR-002"],
  "constitution_conflicts": [],
  "visual_assets_analyzed": 0,
  "estimated_complexity": "standard"
}
```

## Spec Quality Checklist

Before completing, verify:

- [ ] Summary clearly explains what and why
- [ ] At least one P1 user scenario defined
- [ ] All P1 scenarios have acceptance criteria
- [ ] Key entities identified with attributes
- [ ] Success criteria are measurable
- [ ] Out of scope explicitly lists exclusions
- [ ] Ambiguities flagged, not assumed
- [ ] Constitution requirements reflected

## Human Checkpoints

- **Review Tier:** User reviews spec before proceeding
- Ambiguities trigger clarification phase
- User confirms priority classifications

## Error Handling

| Error | Resolution |
|-------|------------|
| Constitution not found | Prompt user to run `/constitution` first |
| Feature number conflict | Increment to next available number |
| Description too vague | Ask for more detail before generating |
| Template not found | Use embedded fallback template |

## Example Invocations

**Simple:**
```
User: /spec Add user authentication with login and logout
```

**With context:**
```
User: I need a feature that lets users log in with their email and password,
      stay logged in across browser sessions, and log out from any page.
      They should see an error if credentials are wrong.
```

**With visuals:**
```
User: /spec Create the checkout flow based on these mockups
      [attached: checkout-step1.png, checkout-step2.png]
```

## Integration Points

- **Invokes:** `clarifier` when ambiguities detected
- **Invokes:** `visual-analyzer` when visual assets provided
- **Invoked by:** `orchestrator` for feature requests
- **Hands off to:** `clarifier` or `technical-planner`

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-01-15 | Initial release |
