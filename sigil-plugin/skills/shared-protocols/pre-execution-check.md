# Shared Protocol: Pre-Execution Check

> **Referenced by:** Skills that update project-context.md before starting work.

## Purpose

Standardize how skills update `.sigil/project-context.md` at the start of execution. This protocol ensures context tracking remains current across all workflow phases.

## Protocol

Before starting any process steps, the invoking skill MUST:

1. **Read** `.sigil/project-context.md`
   - If the file does not exist, create it using the State Tracking format from the `/sigil` command

2. **Update** the following fields:
   - **Current Phase** → Set to the phase this skill represents (e.g., `specify`, `clarify`, `plan`, `tasks`, `implement`, `validate`, `review`)
   - **Feature** → Set to the feature being worked on
   - **Spec Path** → Set to the active spec directory (e.g., `/.sigil/specs/###-feature/`)
   - **Last Updated** → Set to the current timestamp

3. **Preserve** all other fields (do not overwrite unrelated sections)

## When to Reference

Any skill that:
- Represents a distinct workflow phase
- Is the first skill invoked in a chain step
- Needs to record its activity for resume/continue functionality

## Skills Using This Protocol

- `spec-writer` (phase: specify)
- `clarifier` (phase: clarify)
- `technical-planner` (phase: plan)
- `task-decomposer` (phase: tasks)
- `code-reviewer` (phase: review)
- `qa-validator` (phase: validate)

## Notes

- This protocol replaces inline Pre-Execution Check sections in individual skills
- Skills should reference this file rather than duplicating the instructions
- The `/sigil continue` command relies on accurate phase tracking to resume correctly
