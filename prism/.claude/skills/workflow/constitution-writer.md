---
name: constitution-writer
description: Creates project constitution through guided conversation. Invoke when setting up a new project or when user says "constitution", "project principles", or "project setup". Can be pre-populated from project foundation or codebase assessment.
version: 1.2.0
category: workflow
chainable: true
invokes: [codebase-assessment]
invoked_by: [foundation-writer, orchestrator, codebase-assessment]
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
- After Discovery chain completes (invoked by foundation-writer)

## Inputs

**Required:**
- `project_name`: string — Name of the project

**Optional:**
- `tech_preferences`: object — Any known technology preferences
  - `language`: string — Primary programming language
  - `framework`: string — Framework (if any)
  - `database`: string — Database (if any)
- `existing_constitution`: string — Path to existing constitution to update

**From Discovery Chain (when invoked by foundation-writer):**
- `foundation_path`: string — Path to approved foundation document
- `pre_populated_constitution`: object — Pre-filled data from Discovery
  ```json
  {
    "article_1": {
      "language": "TypeScript",
      "language_version": "5.x",
      "framework": "Next.js",
      "framework_version": "14.x",
      "database": "PostgreSQL",
      "database_version": "15+",
      "orm": "Prisma"
    }
  }
  ```

**From Assessment Path (when invoked by codebase-assessment):**
- `detected_stack`: object — Stack detected from codebase analysis
  ```json
  {
    "language": { "name": "TypeScript", "version": "5.x", "confidence": "confident", "source": "package.json" },
    "framework": { "name": "Next.js", "version": "14.x", "confidence": "confident", "source": "package.json" },
    "database": { "name": "PostgreSQL", "confidence": "confident", "source": "prisma/schema.prisma" },
    "orm": { "name": "Prisma", "version": "5.x", "confidence": "confident", "source": "package.json" },
    "test_framework": { "name": "Jest", "confidence": "confident", "source": "package.json:devDependencies" }
  }
  ```
- `classification`: string — "scaffolded" | "mature" (from codebase-assessment)

## Process

### Step 0: Check for Pre-Population Sources

```
Determine pre-population path (in priority order):

1. IF foundation_path provided:
   → Use Foundation Path (from Discovery chain)
   - Load /memory/project-foundation.md
   - Extract pre_populated_constitution data
   - Pre-fill Article 1 (Technology Stack)
   - Note which questions can be skipped

2. ELSE IF detected_stack provided:
   → Use Assessment Path (from codebase-assessment)
   - Use detected_stack for Article 1 pre-population
   - Show detection table for user confirmation
   - Handle uncertain fields with clarifying questions

3. ELSE IF no constitution exists AND repo appears established:
   → Invoke codebase-assessment first
   - Run assessment to detect stack
   - If stack detected, continue with Assessment Path
   - If no stack detected, fall through to Standard Path

4. ELSE:
   → Use Standard Path (guided conversation)
   - Ask all questions interactively
```

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

**Opening (Standard):**
"Let's start with your technology choices. These are the core technologies your project will use—agents will respect these choices and won't suggest alternatives unless you ask."

**Opening (From Foundation):**
"I have your technology stack from the Discovery phase. Let me confirm these choices for your constitution:

- **Language:** [pre_populated.language] [pre_populated.language_version]
- **Framework:** [pre_populated.framework] [pre_populated.framework_version]
- **Database:** [pre_populated.database] [pre_populated.database_version]
- **ORM:** [pre_populated.orm]

Is this correct, or would you like to make changes?"

**Questions (if not pre-populated):**
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

## Foundation Integration

When invoked from the Discovery chain (via `foundation-writer`):

### Pre-Population Behavior

| Article | Pre-Populated Data | User Action |
|---------|-------------------|-------------|
| Article 1 | Language, framework, database, ORM, hosting | Confirm or modify |
| Article 2 | Framework-appropriate defaults suggested | Answer remaining questions |
| Article 3 | Framework-appropriate test framework suggested | Answer remaining questions |
| Article 4 | Standard security defaults | Answer remaining questions |
| Article 5 | Based on stack patterns | Answer remaining questions |
| Article 6 | Standard defaults | Answer remaining questions |
| Article 7 | WCAG 2.1 AA default | Confirm or upgrade to AAA |

### Abbreviated Flow

When foundation data is available:

```
1. Present Article 1 with pre-filled values
   → User confirms or modifies

2. For Articles 2-7:
   → Present smart defaults based on selected stack
   → Ask only questions that aren't answered by foundation
   → User confirms or customizes

3. Generate constitution
   → Show summary highlighting what came from foundation
   → User approves
```

### Conversation Example (From Foundation)

```
Assistant: "Great news! Since we went through Discovery, I already have your
           technology stack figured out:

           **Article 1: Technology Stack**
           - Language: TypeScript 5.x
           - Framework: Next.js 14.x
           - Database: PostgreSQL 15+ with Prisma

           Does this look correct?"

User: "Yes, that's right"
Assistant: "Perfect! Moving on to coding standards for TypeScript/Next.js.
           I will suggest some sensible defaults - just let me know what to change.

           **Article 2: Code Standards**
           Suggested for your stack:
           - Prettier with default config
           - ESLint with Next.js rules
           - Strict TypeScript (no any types)

           Any customizations?"

User: "Looks good, use those"
Assistant: "Great! For testing, Jest is standard for Next.js...
           [continues with remaining articles]"
```

## Assessment Path Integration

When invoked from `codebase-assessment` (or when self-invoking assessment for established repos without constitution):

### Trigger Conditions

The Assessment Path is triggered when ALL of these are true:
1. No `/memory/constitution.md` exists
2. No `/memory/project-foundation.md` exists (not from Discovery chain)
3. Codebase-assessment classifies repo as "scaffolded" or "mature"

### Assessment Path Flow

**Step A: Show Analysis Message**
```
## Analyzing Your Codebase...

I am scanning your project to detect the technology stack.
```

**Step B: Present Detection Table**
```
## Technology Stack Detected

I analyzed your codebase and found the following:

| Setting | Detected | Confidence | Source |
|---------|----------|------------|--------|
| Language | TypeScript 5.x | confident | package.json |
| Framework | Next.js 14.x | confident | package.json |
| Database | PostgreSQL | confident | prisma/schema.prisma |
| ORM | Prisma 5.x | confident | package.json |
| Test Framework | Jest | confident | package.json:devDependencies |

Does this look right? If anything is wrong, just tell me what to change.
```

**Step C: Handle User Response**

*If confirmed ("Yes", "Looks good", "Correct"):*
- Lock Article 1 with detected values
- Continue to Article 2

*If corrections needed ("Actually...", "No", user provides corrections):*
- Accept inline corrections
- Update the value and set source to "user correction"
- Re-display updated table for confirmation
- Example: "Actually we use MySQL" -> Update database row, confirm again

**Step D: Handle Uncertain Fields**

Fields with `confidence: "uncertain"` are marked in the table:

```
| Setting | Detected | Confidence | Source |
|---------|----------|------------|--------|
| Language | TypeScript 5.x | confident | package.json |
| Test Framework | Jest or Vitest | uncertain | conflicting deps |
```

After initial confirmation, ask specifically about uncertain fields:
```
I found both Jest and Vitest in your dependencies. Which is your primary test framework?
```

**Step E: Handle Missing Fields**

Fields not detected show "Not detected":

```
| Setting | Detected | Confidence | Source |
|---------|----------|------------|--------|
| Language | TypeScript 5.x | confident | package.json |
| Framework | Next.js 14.x | confident | package.json |
| Database | Not detected | - | - |
| ORM | Not detected | - | - |
| Test Framework | Jest | confident | package.json:devDependencies |
```

After confirming detected fields, ask standard questions for missing fields:
```
I did not detect a database in your project. Are you using one? If so, which database?
```

**Step F: Continue to Remaining Articles**

After Article 1 is confirmed (with detections + corrections + missing field answers):
- Proceed with Articles 2-7 using standard guided conversation
- Suggest smart defaults based on detected stack (same as Foundation path)

### Assessment Path Conversation Examples

#### Happy Path (All Confident)

```
User: /constitution
Assistant: "Analyzing your codebase...

           I found an established TypeScript/Next.js project. Here is what I detected:

           | Setting | Detected | Source |
           |---------|----------|--------|
           | Language | TypeScript 5.x | package.json |
           | Framework | Next.js 14.x | package.json |
           | Database | PostgreSQL | prisma/schema.prisma |
           | ORM | Prisma | package.json |
           | Test Framework | Jest | package.json |

           Does this look right?"

User: "Looks good"
Assistant: "Great! I will lock those in for Article 1 of your constitution.

           Now let us talk about **Code Standards**. Do you use a formatter
           like Prettier? What about a linter?"

[Continues with standard guided conversation for Articles 2-7]
```

#### Mixed Path (Some Uncertain)

```
Assistant: "Analyzing your codebase...

           I found an established Python project. Here is what I detected:

           | Setting | Detected | Source |
           |---------|----------|--------|
           | Language | Python 3.11 | pyproject.toml |
           | Framework | FastAPI | pyproject.toml |
           | Database | *Not detected* | - |
           | ORM | SQLAlchemy | pyproject.toml |
           | Test Framework | pytest | pyproject.toml |

           I could not confidently detect your database. What database does
           this project use?"

User: "PostgreSQL"
Assistant: "Got it. Here is your confirmed stack:

           - Language: Python 3.11
           - Framework: FastAPI
           - Database: PostgreSQL
           - ORM: SQLAlchemy
           - Test Framework: pytest

           Moving on to **Code Standards**..."
```

#### Correction Path

```
Assistant: "Analyzing your codebase...

           I found an established Node.js project. Here is what I detected:

           | Setting | Detected | Source |
           |---------|----------|--------|
           | Language | TypeScript 5.x | package.json |
           | Framework | Express | package.json |
           | Database | PostgreSQL | pg in package.json |
           | ORM | None detected | - |
           | Test Framework | Jest | package.json |

           Does this look right?"

User: "The database is actually MySQL, not PostgreSQL. We use the pg package
      for a different service."
Assistant: "Thanks for the correction. Updated:

           - Database: MySQL

           And you mentioned no ORM was detected. Do you use an ORM, or do
           you write raw SQL?"

User: "Raw SQL with a query builder"
Assistant: "Got it. I will note 'Raw SQL / Query Builder' for your data access layer.

           Your confirmed stack:
           - Language: TypeScript 5.x
           - Framework: Express
           - Database: MySQL
           - Data Access: Raw SQL / Query Builder
           - Test Framework: Jest

           Now let us move to **Code Standards**..."
```

#### Greenfield Redirect

```
Assistant: "Analyzing your codebase...

           This looks like a new project without much code yet. I would
           recommend going through the Discovery flow first to help you
           choose your stack.

           Would you like to start Discovery, or do you already know your
           stack and want to proceed directly?"

User: "I know my stack, let us proceed"
Assistant: "Sounds good. Let us set up your constitution.

           **Article 1: Technology Stack**

           What programming language will this project use?"

[Falls back to standard guided conversation]
```

## Error Handling

| Error | Resolution |
|-------|------------|
| User skips an article | Note as "To be defined" and flag for follow-up |
| User provides unclear answers | Ask clarifying questions |
| Template not found | Use embedded fallback template |
| Foundation data conflicts with user input | User input takes precedence |
| Assessment detection wrong | User correction updates value, source becomes "user correction" |
| Monorepo with multiple manifests | Use root manifest; note uncertainty for sub-packages |
| Conflicting signals in assessment | Mark as uncertain, ask user to clarify |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
| 1.1.0 | 2026-01-20 | Added Foundation integration, pre-population support |
| 1.2.0 | 2026-01-27 | Added Assessment Path integration for established repos, codebase-assessment invocation |
