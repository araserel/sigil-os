---
name: handoff-packager
description: Generates a Technical Review Package for engineer handoff. Bundles all feature artifacts into a single, well-organized document that provides full context for technical review.
version: 1.0.0
category: workflow
chainable: false
invokes: []
invoked_by: [orchestrator]
tools: Read, Write, Glob
inputs: [spec_path, feature_id]
outputs: [technical-review-package.md]
---

# Skill: Handoff Packager

## Purpose

Generate a comprehensive Technical Review Package when a non-technical user requests engineer involvement. This skill bundles all feature artifacts into a single document optimized for technical review, providing full context without requiring the engineer to hunt through multiple files.

## When Invoked

**Trigger phrases:**
- "I need an engineer to review this"
- "Get this ready for technical review"
- "I want a developer to look at this"
- "Can someone technical review this?"
- "Prepare handoff for engineering"

**Context:** User has been working through the spec-driven workflow and wants to bring in technical expertise before proceeding (typically before production deployment).

## Workflow

### Step 1: Gather Artifacts
Collect all artifacts for the feature:

```
/.sigil/specs/###-feature/
├── spec.md
├── clarifications.md
├── plan.md
├── tasks.md
├── qa/
│   └── *.md (validation reports)
├── reviews/
│   ├── code-review.md
│   ├── security-review.md
│   └── deploy-readiness.md
└── adr/
    └── *.md (architecture decisions)
```

### Step 2: Extract Key Information
From each artifact, extract:
- **Spec:** Requirements table, key entities, success criteria
- **Plan:** Files changed, technical approach, dependencies
- **Reviews:** Status, findings, recommendations
- **ADRs:** Decisions made and rationale

### Step 3: Generate Package
Assemble the Technical Review Package using the template at `/templates/technical-review-package-template.md`:
1. Quick Context (for engineer orientation)
2. Requirements & Intent (what was asked for)
3. Technical Approach (how it was built)
4. Code Changes (what changed)
5. Quality Reports (what checks found)
6. Flagged Items (what needs attention)
7. How to Proceed (clear next steps)
8. Appendix (links to full artifacts)

### Step 4: Write Plain-English Summary
Generate a brief (3-5 sentence) summary for the non-technical user to include when sharing with the engineer.

**Example summary:**
> "This package has everything an engineer needs to review the password reset feature. It includes what we asked for, how it was built, and what the automated checks found. Share it with them and ask them to let you know if anything needs changing before you go live."

## Input Schema

```json
{
  "feature_id": "001-password-reset",
  "spec_path": "/.sigil/specs/001-password-reset/",
  "requested_by": "User name (optional)",
  "reason": "Pre-production review (optional)"
}
```

## Output Schema

```json
{
  "package_path": "/.sigil/specs/001-password-reset/technical-review-package.md",
  "summary_for_user": "Plain-English description to share with engineer",
  "artifacts_included": ["spec.md", "plan.md", "..."],
  "missing_artifacts": [],
  "status": "complete | partial"
}
```

## Output Artifact

`/.sigil/specs/###-feature/technical-review-package.md`

## Writing Guidelines

### For the Non-Technical Summary
- No jargon
- Focus on "what it does" not "how it works"
- Include why they might want a review (e.g., "before going to production")
- Suggest what to tell the engineer ("I'd like you to review this before we launch")

### For the Technical Package
- Assume the engineer has zero context
- Front-load the most important information
- Make it scannable — use tables and clear headers
- Include links to full artifacts, don't duplicate everything
- Highlight decisions that were made and why
- Flag anything unusual or risky

## Error Handling

### Missing Artifacts
If expected artifacts are missing:
1. Note them in `missing_artifacts` output
2. Include a "Missing Information" section in the package
3. Don't fail — generate what's possible

### Incomplete Reviews
If reviews haven't run yet:
1. Include placeholder sections
2. Note: "Review not yet completed"
3. Warn user that package is incomplete

## Human Tier

**Tier:** Auto

This skill runs automatically when triggered. No approval needed — user explicitly requested the package.

## Notes

This skill is a documentation generator, not a workflow gate. It:
- Does NOT block any workflow
- Does NOT require engineer approval to proceed
- Provides an OFF-RAMP for users who want technical input

The user remains in control of whether to share the package and how to act on engineer feedback.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
