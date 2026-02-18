# Sigil OS — Canonical Output Formats

> **Single source of truth** for all visual formatting in Sigil OS commands and skills.
> Before displaying output, verify it matches the templates in this file.

## Icons

| Icon | Meaning |
|------|---------|
| ✅ | Complete |
| 🔄 | In Progress |
| ⬚ | Not Started |
| ⚠️ | Blocked / Needs Attention |

## Separator

Use a 50-character full-width dash for all section separators:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Do NOT use `=`, `-`, or shorter/longer separators.

## Progress Bar

10-block bar with percentage:

```
[██████░░░░] 60%
```

Each `█` represents 10%. Use `░` for remaining.

---

## Welcome Screen (First Run — no `.sigil/` directory)

```
Welcome to Sigil OS! 👋
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sigil helps you build software through structured specifications.
No coding knowledge required — just describe what you want to build.

This project doesn't have Sigil OS set up yet.

Run /sigil-setup to get started.
```

## Status Dashboard (Configured Project)

```
📋 Project: {ProjectName}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Foundation    - {Stack summary}
✅ Constitution  - {N} articles defined

Active Feature: "{Feature Name}"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Specification - Complete ({N} requirements)
✅ Clarification - {N} questions resolved
🔄 Planning      - In progress
⬚ Tasks         - Waiting
⬚ Implementation

Next: {Plain language next step}

Continue with {current phase}? (Y/n)
```

When no active feature:

```
📋 Project: {ProjectName}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Foundation    - {Stack summary}
✅ Constitution  - {N} articles defined

No active feature.

Describe what you want to build, or run /sigil help for options.
```

## Profile View

```
Project Profile: {name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{description}

Tech Stack:
  Languages: {languages}
  Frameworks: {frameworks}
  Infrastructure: {infrastructure}
  Testing: {testing}

Exposes:
  - [{type}] {description}

Consumes:
  - [{type} from {source}] {description}

Depends On:
  - {project}

Contacts: {owner} / {team}
```

## Constitution Summary

```
Your constitution is ready!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Here's what I set up:

**Tech Stack:** {Language} + {Framework} + {Database}

**Quality Level:** {Project Type}
- Testing: {plain description}
- Security: {plain description}
- Reviews: {plain description}

**Accessibility:** {plain description}

This is saved at /.sigil/constitution.md. All AI agents will follow
these rules automatically.

To change it later, run /sigil-constitution edit.
```

## Learnings Summary

```
Project Learnings
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Patterns ({X}/30):
  • {pattern description}
  ...

Gotchas ({Y}/30):
  • {gotcha description}
  ...

Recent Decisions ({Z}/20):
  • [{date}] {decision description}
  ...

Active Features: {N}
  • {feature-id} ({count} notes)
```

## Help Output

```
Sigil OS Commands
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Primary Command:
  /sigil                    Show status and next steps
  /sigil "description"      Start building a new feature
  /sigil continue           Resume where you left off
  /sigil status             Detailed workflow status
  /sigil help               Show this help

Additional Commands:
  /sigil-setup              Set up Sigil OS in this project
  /sigil-handoff            Generate engineer review package
  /sigil-constitution       View/edit project principles
  /sigil-learn              View, search, or review learnings
  /sigil-connect            Connect to shared context repo
  /sigil-profile            Generate or view project profile
  /sigil-update             Check for Sigil updates

Natural Language:
  Just describe what you want! Sigil understands:
  - "I want to add dark mode"
  - "Build me a dashboard"
  - "What am I working on?"
  - "Keep going" / "Continue"
```

## Feature Complete

```
Feature Complete: "{Feature Name}" ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tasks: {N} completed
Code review: {Status} ({blockers} blockers, {warnings} warnings, {suggestions} suggestions)
Spec: {spec_path}
{If learnings captured: Learnings captured: {N} patterns, {N} gotchas}
```

---

## Usage

Before displaying any output to the user, verify:
1. Icons match the canonical set above (✅ 🔄 ⬚ ⚠️)
2. Separators are exactly 50-character `━` lines
3. Progress bars use the 10-block format
4. Overall layout matches the relevant template
