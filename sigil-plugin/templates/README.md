# Templates Directory

Contains templates for all Sigil artifacts.

## Templates

| Template | Purpose |
|----------|---------|
| `constitution-template.md` | Project principles (7 articles) |
| `spec-template.md` | Feature specification |
| `plan-template.md` | Implementation plan |
| `tasks-template.md` | Task breakdown |
| `adr-template.md` | Architecture decision record |
| `project-context-template.md` | Session state tracking |
| `project-foundation.md` | Discovery track output |
| `technical-review-package-template.md` | Engineer handoff package |
| `waiver-template.md` | Override and waiver tracking |
| `output-formats.md` | Canonical output format definitions |
| `skill-template.md` | Template for creating new skills |

## Usage

Templates are used by skills when creating artifacts. The skill reads the template, fills in content based on context and user input, and writes the result to the appropriate location.

## Customization

Templates can be customized for your project. Changes to templates affect all future artifacts created from them. Existing artifacts are not modified.
