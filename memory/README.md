# Memory Directory

Contains persistent context files that maintain state across sessions.

## Core Files

| File | Purpose | Update Frequency |
|------|---------|------------------|
| `constitution.md` | Immutable project principles | Once (at project setup) |
| `project-context.md` | Current project state | Auto-updated on significant actions |

## Constitution

The constitution defines immutable principles that guide all agent decisions:
- Technology stack
- Code standards
- Testing requirements
- Security mandates
- Architecture principles
- Approval requirements
- Accessibility requirements

Once created, the constitution should rarely change. Modifications require explicit human approval.

## Project Context

The project context tracks:
- Current feature being worked on
- Current workflow phase
- Recent activity log (last 5 significant actions)
- Open decisions awaiting input
- Active blockers

This file is automatically updated as work progresses and loaded at the start of each session to maintain continuity.

## Usage

These files are loaded by Claude Code at session start and referenced throughout the workflow. Agents check the constitution before making decisions and update project-context.md as work progresses.
