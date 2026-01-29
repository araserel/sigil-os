# Templates Directory

Contains templates for all Prism artifacts and guided prompts for non-technical users.

## Templates

| Template | Purpose |
|----------|---------|
| `constitution-template.md` | Project principles (7 articles) |
| `spec-template.md` | Feature specification |
| `plan-template.md` | Implementation plan |
| `tasks-template.md` | Task breakdown |
| `adr-template.md` | Architecture decision record |
| `handoff-template.md` | Agent-to-agent transition |
| `project-context-template.md` | Session state tracking |
| `technical-review-package-template.md` | Engineer handoff package |

## Guided Prompts

The `prompts/` subdirectory contains conversational scripts that help non-technical users fill out templates:

| Prompt File | Helps With |
|-------------|------------|
| `constitution-prompts.md` | 3-round guided constitution setup (plain language) |
| `constitution-questions.md` | Question bank with tiered questions and cascade configs |
| `constitution-errors.md` | User-friendly error message translations |
| `spec-prompts.md` | Creating feature specifications |
| `plan-prompts.md` | Technical planning decisions |
| `clarify-prompts.md` | Resolving ambiguities |

## Usage

Templates are used by skills when creating artifacts. The skill reads the template, fills in content based on context and user input, and writes the result to the appropriate location.

Guided prompts are used when a skill enters conversational mode to help users provide the information needed for templates.

## Customization

Templates can be customized for your project. Changes to templates affect all future artifacts created from them. Existing artifacts are not modified.
