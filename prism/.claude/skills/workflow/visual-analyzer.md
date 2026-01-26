---
name: visual-analyzer
version: 0.1.0-stub
status: NOT_IMPLEMENTED
description: Figma/design file analyzer (stub)
invoked_by: [spec-writer, business-analyst]
tools: [Read]
---

# Skill: Visual Analyzer

> **Status:** NOT YET IMPLEMENTED
>
> This skill is planned but not yet functional. References exist in:
> - `.claude/agents/business-analyst.md`
> - `.claude/skills/workflow/spec-writer.md`

---

## Purpose

Analyze visual artifacts (mockups, wireframes, screenshots) to extract functional requirements for specification generation.

---

## Intended Behavior

### When Invoked

The Business Analyst invokes this skill when the user provides:
- UI mockups or wireframes
- Screenshots of existing interfaces
- Design system references

### Expected Capabilities

1. **Visual Element Identification**
   - Detect UI components (buttons, forms, navigation)
   - Identify interaction patterns
   - Map user flows

2. **Requirements Extraction**
   - Convert visual elements to functional requirements
   - Identify implied behaviors (hover states, error states)
   - Note accessibility requirements from visual design

3. **Integration with Spec Writer**
   - Output requirements in format consumable by spec-writer
   - Flag ambiguous or unclear visual elements
   - Suggest clarification questions for missing states

---

## Planned Input

```markdown
**Visual Artifact:** [Image or description]
**Context:** [What the user said about this]
**Focus Areas:** [Specific elements to analyze]
```

---

## Planned Output

```markdown
## Visual Analysis: [Artifact Name]

### Identified Elements
- [Component]: [Purpose/behavior]
- [Component]: [Purpose/behavior]

### Extracted Requirements
1. [Requirement derived from visual]
2. [Requirement derived from visual]

### Ambiguities Detected
- [Element] — unclear behavior, needs clarification
- [Element] — missing state (error/loading/empty)

### Accessibility Notes
- [Observation about contrast, sizing, etc.]

### Recommended Clarifications
1. [Question about unclear element]
2. [Question about missing state]
```

---

## Implementation Notes

When implemented, this skill should:
- Use Claude's multimodal capabilities to process images
- Follow existing spec-writer patterns for requirement formatting
- Integrate seamlessly with clarifier for follow-up questions
- Maintain constitution compliance (accessibility requirements)

---

## Related Components

- **Invoked by:** Business Analyst
- **Works with:** spec-writer, clarifier
- **Outputs to:** Specification document

---

*Stub created: 2026-01-16*
*Implementation pending*
