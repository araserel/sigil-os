---
name: problem-framing
description: Captures and structures the core problem statement, target users, and value proposition for a new project. Extracts technology preferences from natural language to avoid redundant questions.
version: 1.0.0
category: research
chainable: true
invokes: [constraint-discovery]
invoked_by: [orchestrator, codebase-assessment]
tools: Read, Write, Edit
---

# Skill: Problem Framing

## Purpose

Transform a user's natural language project description into a structured problem statement while extracting any implicit technology preferences, constraints, or requirements. This prevents asking questions the user has already answered.

## When to Invoke

- After codebase assessment routes to Discovery track
- User describes what they want to build
- User says "I want to build...", "Create a...", "Help me make..."

## Inputs

**Required:**
- `user_description`: string — Natural language description of what the user wants to build

**From Previous Step:**
- `codebase_classification`: string — "greenfield" | "scaffolded" | "mature"
- `detected_stack`: object | null — Any stack already detected in codebase

**Optional:**
- `conversation_history`: string[] — Prior messages for context

## Process

### Step 1: Natural Language Analysis

Parse the user's description to extract:

```
1. Problem Domain
   - What category of software? (e-commerce, productivity, social, etc.)
   - What industry vertical? (healthcare, finance, education, etc.)

2. Core Functionality
   - Primary features mentioned
   - User actions described
   - Data types referenced

3. Target Users
   - Who is mentioned as the user?
   - B2C, B2B, or internal tool?
   - Technical or non-technical users?

4. Value Proposition
   - Why build this?
   - What problem does it solve?
   - What existing solution does it replace/improve?
```

### Step 2: Preference Extraction

Identify technology preferences stated or implied:

```
EXPLICIT PREFERENCES (stated directly):
- "I want to use React" → framework_preference: "React"
- "Build it in Python" → language_preference: "Python"
- "Use PostgreSQL" → database_preference: "PostgreSQL"
- "Deploy to Vercel" → hosting_preference: "Vercel"

IMPLICIT PREFERENCES (inferred from context):
- "web app" → platform: "web"
- "mobile app" → platform: "mobile"
- "API for my service" → platform: "api"
- "command line tool" → platform: "cli"
- "desktop application" → platform: "desktop"

SKILL INDICATORS (experience signals):
- "I know React" → known_skills: ["React"]
- "I've used Django before" → known_skills: ["Django", "Python"]
- "I'm familiar with Node" → known_skills: ["Node.js", "JavaScript"]
- "I'm new to programming" → experience_level: "beginner"

CONSTRAINT INDICATORS:
- "Free tier only" → budget: "free"
- "No paid services" → budget: "free"
- "Startup budget" → budget: "low"
- "Enterprise requirements" → budget: "enterprise"
- "Need it soon" → timeline: "urgent"
- "Just me working on it" → team_size: "solo"
```

### Step 3: Ambiguity Detection

Identify what's NOT clear from the description:

```
MUST ASK if not stated:
- Platform (if can't be inferred)
- Primary user type (if ambiguous)

SHOULD ASK if relevant:
- Scale expectations
- Integration requirements
- Specific feature priorities

SKIP if already stated:
- Any technology preferences captured
- Budget if indicated
- Team size if mentioned
```

### Step 4: Generate Problem Statement

Structure the captured information:

```markdown
## Problem Statement: [Short Name]

### What We're Building
[2-3 sentences synthesized from user description]

### Target Users
- Primary: [Extracted or "To be clarified"]
- Use case: [Inferred from description]

### Core Value
[Why this matters - synthesized from description]

### Key Features Mentioned
1. [Feature 1]
2. [Feature 2]
...
```

### Step 5: Present Extraction Summary

Show user what was captured to confirm understanding:

```markdown
## I Understood

From your description, I captured:

**Building:** [Summary]
**Platform:** [web/mobile/api/cli/desktop]
**Target Users:** [Who]

**Preferences Detected:**
- [List any technology preferences found]
- [List any constraints found]
- [List any skills mentioned]

**I Won't Re-Ask About:**
- [Things already answered]

**I Still Need to Know:**
- [List of remaining questions]

Is this correct?
```

## Outputs

**Structured Problem:**
```json
{
  "problem_statement": {
    "short_name": "Task Manager App",
    "description": "A personal task management application...",
    "target_users": {
      "primary": "Individual professionals",
      "secondary": null,
      "technical_level": "non-technical"
    },
    "core_value": "Simple, focused task management without complexity",
    "features_mentioned": [
      "Create and organize tasks",
      "Set due dates",
      "Mark tasks complete"
    ]
  },
  "extracted_preferences": {
    "platform": "web",
    "language": "TypeScript",
    "framework": "React",
    "database": null,
    "hosting": null
  },
  "known_skills": ["JavaScript", "React"],
  "constraints_detected": {
    "budget": "free",
    "team_size": "solo",
    "timeline": null
  },
  "ambiguities": [
    "Database preference not stated",
    "Hosting preference not stated"
  ],
  "skip_questions": [
    "platform",
    "framework",
    "budget"
  ]
}
```

**Handoff Data:**
```json
{
  "problem_framing_complete": true,
  "problem_statement": "...",
  "extracted_preferences": {...},
  "known_skills": [...],
  "constraints_detected": {...},
  "skip_questions": [...],
  "next_skill": "constraint-discovery"
}
```

## Preference Extraction Patterns

### Language Patterns

| User Says | Extract |
|-----------|---------|
| "React app", "React Native" | framework: React/React Native |
| "Vue project", "Nuxt" | framework: Vue/Nuxt |
| "Next.js", "Remix" | framework: Next.js/Remix |
| "Django", "FastAPI" | language: Python, framework: Django/FastAPI |
| "Rails", "Ruby" | language: Ruby, framework: Rails |
| "Express", "Node" | language: JavaScript, framework: Express |
| "Go", "Golang" | language: Go |
| "Rust" | language: Rust |

### Platform Patterns

| User Says | Extract |
|-----------|---------|
| "web app", "website", "browser" | platform: web |
| "mobile app", "iPhone", "Android" | platform: mobile |
| "API", "backend", "service" | platform: api |
| "CLI", "command line", "terminal" | platform: cli |
| "desktop app", "Mac app", "Windows" | platform: desktop |

### Budget Patterns

| User Says | Extract |
|-----------|---------|
| "free", "no budget", "hobby" | budget: free |
| "startup", "low cost", "cheap" | budget: low |
| "professional", "some budget" | budget: moderate |
| "enterprise", "compliance" | budget: enterprise |

### Skill Patterns

| User Says | Infer Skills |
|-----------|--------------|
| "I know React" | JavaScript, React |
| "I've used Python" | Python |
| "Comfortable with Node" | JavaScript, Node.js |
| "New to programming" | experience_level: beginner |
| "Experienced developer" | experience_level: experienced |

## Conversational Approach

### Opening (After Assessment)

```
Great! Let's figure out exactly what you need.

Tell me about what you want to build - what problem are you trying to solve
and who will use it? Feel free to mention any technologies you'd like to use
or constraints you're working with.
```

### Confirmation Response

```
Here's what I understood:

**You want to build:** A personal task manager web app
**For:** Individual professionals who want simple task tracking
**Using:** React (you mentioned this)

**I captured these preferences:**
- Platform: Web
- Framework: React
- Budget: Free tier (you mentioned "no paid services")

**I won't ask about:**
- Framework choice (React is set)
- Budget level (free tier confirmed)

**I still need to clarify:**
- Database preference
- Any specific features that are must-haves

Does this capture your intent correctly?
```

## Human Checkpoints

- **Auto Tier:** Preference extraction happens automatically
- **Review Tier:** User confirms captured understanding before proceeding
- User can correct any misunderstandings

## Error Handling

| Error | Resolution |
|-------|------------|
| Description too vague | Ask for more detail: "Could you tell me more about..." |
| Conflicting preferences | Ask to clarify: "You mentioned both X and Y..." |
| No preferences found | Normal - proceed to constraint discovery |
| Unknown technology mentioned | Ask for clarification about the technology |

## Integration Points

- **Invoked by:** `orchestrator`, `codebase-assessment`
- **Hands off to:** `constraint-discovery` with preferences pre-populated
- Extracted preferences reduce questions in constraint-discovery

## Example Sessions

### Example 1: Rich Description

**User:** "I want to build a task manager web app using React. It's just for me, no budget for paid services. I know JavaScript pretty well."

**Extraction:**
```json
{
  "platform": "web",
  "framework": "React",
  "budget": "free",
  "team_size": "solo",
  "known_skills": ["JavaScript", "React"],
  "skip_questions": ["platform", "framework", "budget", "team_size"]
}
```

### Example 2: Minimal Description

**User:** "I need an app to track my expenses"

**Extraction:**
```json
{
  "platform": null,  // Must ask
  "framework": null,
  "budget": null,
  "features_mentioned": ["expense tracking"],
  "skip_questions": []
}
```

**Follow-up:** "Will this be a web app, mobile app, or something else?"

### Example 3: Technical User

**User:** "Building a REST API for my mobile app. I've been using FastAPI at work and love it. Need something I can deploy cheaply."

**Extraction:**
```json
{
  "platform": "api",
  "language": "Python",
  "framework": "FastAPI",
  "budget": "low",
  "known_skills": ["Python", "FastAPI"],
  "integration": "mobile app",
  "skip_questions": ["platform", "framework", "language"]
}
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
