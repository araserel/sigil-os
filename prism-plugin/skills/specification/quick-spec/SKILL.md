---
name: quick-spec
version: 1.0.0
description: Rapid specification for simple, well-understood features
invoked_by: [orchestrator]
invokes: [spec-writer]
tools: [Read, Write]
---

# Quick Spec

## Purpose

Streamlined spec generation when:
- Feature is small (1-3 day implementation)
- Requirements are clear and unambiguous
- No architectural decisions needed

## Behavior

Invokes `spec-writer` with constraints:
1. **Skip Clarifier** — Assume requirements complete
2. **Single Story Output** — One Outcome or System story (not PRD)
3. **Inline AC** — Acceptance criteria in requirements
4. **No Technical Spec** — Skip architecture docs

## Invocation

```
Input: {
  request: string,
  story_type: "outcome" | "system",  // Default: "outcome"
  context_file?: string
}
```

## Output

Single story file to `/specs/stories/`.

## When NOT to Use

- Feature touches multiple systems
- Requirements are ambiguous
- User requests full specification process
- Complexity exceeds "Simple" threshold

Route to Standard or Enterprise track instead.
