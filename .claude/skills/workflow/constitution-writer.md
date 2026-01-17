---
name: constitution-writer
description: Creates project constitution through guided conversation. Invoke when setting up a new project or when user says "constitution", "project principles", or "project setup".
version: 1.0.0
category: workflow
chainable: false
invokes: []
invoked_by: []
tools: Read, Write, Edit, Glob
---

# Skill: Constitution Writer

## Purpose

Guide users through creating their project constitution—the immutable principles that govern all agent decisions. This is typically a one-time setup at project start.

## When to Invoke

- New project setup
- User requests `/constitution`
- User asks about "project principles" or "project rules"
- No constitution exists in `/memory/constitution.md`

## Inputs

**Required:**
- `project_name`: string — Name of the project

**Optional:**
- `tech_preferences`: object — Any known technology preferences
  - `language`: string — Primary programming language
  - `framework`: string — Framework (if any)
  - `database`: string — Database (if any)
- `existing_constitution`: string — Path to existing constitution to update

## Process

### Step 1: Check for Existing Constitution

```
Check if /memory/constitution.md exists:
- If exists and not updating: Confirm user wants to replace
- If exists and updating: Load for modification
- If not exists: Proceed with new creation
```

### Step 2: Guided Conversation

Walk through each article using conversational prompts. For each article:

1. Explain what the article covers and why it matters
2. Ask targeted questions to gather requirements
3. Offer examples for common choices
4. Confirm selections before moving to next article

**Article Order:**
1. Technology Stack (often has clearest answers)
2. Code Standards (build on tech stack)
3. Testing Requirements
4. Security Mandates
5. Architecture Principles
6. Approval Requirements
7. Accessibility Requirements

### Step 3: Generate Constitution

Using gathered responses:
1. Load template from `/templates/constitution-template.md`
2. Fill in responses for each article
3. Add project name and dates
4. Write to `/memory/constitution.md`

### Step 4: Confirm and Explain

- Show summary of constitution
- Explain how it will be used
- Remind that amendments require explicit approval

## Outputs

**Artifact:**
- `/memory/constitution.md` — Complete project constitution

**Handoff Data:**
```json
{
  "constitution_path": "/memory/constitution.md",
  "project_name": "Project Name",
  "articles_completed": 7,
  "key_decisions": [
    "TypeScript as primary language",
    "Next.js framework",
    "PostgreSQL database",
    "80% test coverage required"
  ]
}
```

## Guided Prompts

### Article 1: Technology Stack

**Opening:**
"Let's start with your technology choices. These are the core technologies your project will use—agents will respect these choices and won't suggest alternatives unless you ask."

**Questions:**
- "What programming language will this project use? (e.g., TypeScript, Python, Go)"
- "What version? Or should we use the latest stable?"
- "Are you using a framework? If so, which one?"
- "What database will you use, if any?"
- "Any other core technologies I should know about?"

**Examples:**
- Web app: TypeScript + Next.js + PostgreSQL
- API service: Python + FastAPI + PostgreSQL
- CLI tool: Go + SQLite
- Library: TypeScript (no framework, no database)

### Article 2: Code Standards

**Opening:**
"Now let's define your coding standards. These ensure all generated code follows your team's conventions."

**Questions:**
- "Do you use a formatter like Prettier or Black? What configuration?"
- "What's your maximum line length preference?"
- "Do you require explicit type annotations everywhere?"
- "Any specific naming conventions? (camelCase, snake_case, etc.)"
- "Maximum function length or other complexity limits?"

### Article 3: Testing Requirements

**Opening:**
"Testing requirements ensure quality. Let's define what 'tested' means for your project."

**Questions:**
- "What test coverage percentage do you target? (Common: 80%)"
- "What testing framework do you use? (Jest, pytest, etc.)"
- "Do you require integration tests for all API endpoints?"
- "Do you use end-to-end testing? If so, which framework?"
- "Should we enforce test-first development?"

### Article 4: Security Mandates

**Opening:**
"Security mandates protect your application. These are non-negotiable requirements."

**Questions:**
- "Do all API endpoints require authentication by default?"
- "How do you handle secrets? (Environment variables, vault, etc.)"
- "Any specific input validation requirements?"
- "How quickly must security vulnerabilities be addressed?"
- "Do new dependencies require security review?"

### Article 5: Architecture Principles

**Opening:**
"Architecture principles guide how your system is structured."

**Questions:**
- "Any design principles you follow? (SOLID, composition over inheritance, etc.)"
- "How should layers be organized? (Can UI access database directly?)"
- "How do you handle state management?"
- "Any error handling conventions?"

### Article 6: Approval Requirements

**Opening:**
"Let's define what requires human approval before the AI can proceed."

**Questions:**
- "What code changes require review? (Dependencies, schema, auth?)"
- "Who approves production deployments?"
- "Are there any architecture changes that need special approval?"
- "Any other approval gates I should know about?"

### Article 7: Accessibility Requirements

**Opening:**
"Accessibility ensures your application works for everyone. Let's define your standards."

**Questions:**
- "What WCAG level do you target? (Minimum: AA, Target: AAA)"
- "Any specific contrast or font size requirements?"
- "Do you require keyboard navigation for all features?"
- "Any assistive technology testing requirements?"

## Human Checkpoints

- **Review Tier:** Constitution creation (user reviews final document)
- User confirms each article before proceeding
- Final constitution shown for approval before saving

## Error Handling

- If user skips an article: Note as "To be defined" and flag for follow-up
- If user provides unclear answers: Ask clarifying questions
- If template not found: Use embedded fallback template

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-01-15 | Initial release |

## Example Session

```
User: /constitution