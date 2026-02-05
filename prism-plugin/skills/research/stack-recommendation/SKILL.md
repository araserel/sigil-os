---
name: stack-recommendation
description: Generates 2-3 viable technology stack options based on constraints, preferences, and team skills. Presents options with trade-offs for user selection.
version: 1.0.0
category: research
chainable: true
invokes: []
invoked_by: [constraint-discovery]
tools: Read, Write, Edit
---

# Skill: Stack Recommendation

## Purpose

Generate 2-3 viable stack options based on discovered constraints and extracted preferences. Each option includes trade-offs explained in plain language, allowing non-technical users to make informed decisions.

## When to Invoke

- After constraint-discovery completes
- User asks "what stack should I use" or "recommend a technology"
- User wants to compare technology options

## Inputs

**Required:**
- `constraints`: object — Complete constraints from constraint-discovery
- `extracted_preferences`: object — Preferences from problem-framing
- `known_skills`: string[] — User's stated technical skills

**Auto-loaded:**
- `stack_patterns`: file — `.claude/reference/stack-patterns.yaml`

**Optional:**
- `exclude_stacks`: string[] — Stacks to exclude from recommendations
- `prioritize`: string — "learning" | "productivity" | "performance"

## Process

### Step 1: Load Stack Patterns

```
1. Load .claude/reference/stack-patterns.yaml
2. Parse platform-to-stack mappings
3. Parse stack definitions with all metadata
```

### Step 2: Filter by Platform

```
1. Get platform from constraints (web, mobile, api, cli, desktop)
2. Filter stacks to only those supporting the platform
3. Keep stacks from platforms[platform] list
```

### Step 3: Filter by Budget

```
1. Get budget tier from constraints (free, free_to_low, moderate, enterprise)
2. Filter stacks to those compatible with budget
3. For "free" budget, exclude stacks requiring paid services
```

### Step 4: Rank by Skill Match

```
For each remaining stack:
  score = 0

  For each skill in known_skills:
    IF skill in stack.common_skills:
      score += 3  # Exact match
    ELSE IF skill category matches (e.g., "React" → "JavaScript"):
      score += 2  # Category match
    ELSE IF skill language matches:
      score += 1  # Language match

  stack.skill_score = score
```

### Step 5: Apply Preference Boosts

```
IF extracted_preferences.framework != null:
  Boost stacks matching the framework preference

IF extracted_preferences.language != null:
  Boost stacks using that language

IF prioritize == "learning":
  Boost stacks with low learning_curve

IF prioritize == "productivity":
  Boost stacks with high common_skills match

IF prioritize == "performance":
  Boost stacks marked as high-performance
```

### Step 6: Select Top Options

```
1. Sort stacks by combined score
2. Select top 3 options
3. Ensure diversity (don't recommend 3 similar stacks)
4. Mark highest-scored as "Recommended"
```

### Step 7: Generate Comparison

For each selected stack, prepare:

```
- Plain language description
- Why it fits the constraints
- Pros and cons
- Learning curve assessment
- Skill match explanation
```

## Outputs

**Stack Recommendations:**
```json
{
  "recommended_stack": {
    "pattern": "fullstack-nextjs",
    "name": "Next.js Fullstack",
    "language": "TypeScript",
    "framework": "Next.js",
    "database": "PostgreSQL",
    "orm": "Prisma",
    "hosting": "Vercel",
    "skill_match_score": 8,
    "constraint_fit": "excellent"
  },
  "alternatives": [
    {
      "pattern": "spa-react",
      "name": "React SPA + API",
      "language": "TypeScript",
      "framework": "React + Vite",
      "database": "PostgreSQL",
      "skill_match_score": 7,
      "constraint_fit": "good",
      "trade_off": "More setup, but cleaner separation"
    },
    {
      "pattern": "traditional-django",
      "name": "Django Fullstack",
      "language": "Python",
      "framework": "Django",
      "database": "PostgreSQL",
      "skill_match_score": 4,
      "constraint_fit": "good",
      "trade_off": "Different language, but excellent for rapid development"
    }
  ],
  "recommendation_rationale": "Next.js matches your React skills and free tier budget. It provides the best developer experience for solo web projects."
}
```

**Handoff Data:**
```json
{
  "stack_recommendation_complete": true,
  "selected_stack": null,
  "awaiting_user_selection": true,
  "next_skill": "foundation-writer"
}
```

## Presentation Format

### Recommendation Display

```markdown
## Stack Recommendations

Based on your constraints:
- **Platform:** Web
- **Budget:** Free tier
- **Team:** Solo
- **Skills:** React, JavaScript

I've identified 3 suitable options:

---

### Option A: Next.js Fullstack (Recommended)

**What it is:** A React framework that handles both frontend and backend in one project.

**Why it fits:**
- You know React - Next.js is React with superpowers
- Free tier deployment on Vercel
- Perfect for solo developers
- Great for the features you described

**Tech Stack:**
- TypeScript (improves on your JavaScript skills)
- Next.js 14
- PostgreSQL + Prisma
- Vercel hosting

**Trade-offs:**
- (+) Fast to get started, excellent DX
- (+) SEO-friendly out of the box
- (-) Tied to React ecosystem
- (-) Learning TypeScript if you haven't used it

**Learning curve:** Low-Medium (you already know React)

---

### Option B: React SPA + Separate API

**What it is:** Traditional separation - React frontend talks to a backend API.

**Why it fits:**
- Uses your React skills directly
- More flexibility in backend choice
- Cleaner architecture for larger apps

**Tech Stack:**
- TypeScript + React + Vite (frontend)
- Express.js or FastAPI (backend)
- PostgreSQL
- Vercel + Railway hosting

**Trade-offs:**
- (+) Clear separation of concerns
- (+) Can swap backend later
- (-) More setup and configuration
- (-) Two deployments to manage

**Learning curve:** Medium

---

### Option C: Django Fullstack

**What it is:** Python web framework with batteries included.

**Why it fits:**
- Excellent for rapid development
- Built-in admin panel
- Great if you want to learn Python

**Tech Stack:**
- Python 3.11
- Django 5
- PostgreSQL
- Railway hosting

**Trade-offs:**
- (+) Fastest path to working product
- (+) Excellent documentation
- (-) You'd need to learn Python
- (-) Different from your React background

**Learning curve:** Medium (new language)

---

## My Recommendation

**Go with Option A (Next.js)** because:
1. Builds on your existing React skills
2. Minimal new concepts to learn
3. Best free tier hosting options
4. Perfect match for solo web projects

**Your choice?** (A, B, or C)
```

## Scoring Algorithm

### Skill Match Score (0-10)

```
Base score = 0

For each common_skill in stack:
  IF exact match in known_skills: +3
  IF category match: +2
  IF language match: +1

Cap at 10
```

### Constraint Fit Score (0-10)

```
Base score = 10

IF budget mismatch: -5
IF platform mismatch: -10 (disqualify)
IF timeline urgent AND learning_curve high: -3
IF team_size large AND complexity low: -2
IF compliance required AND not supported: -10 (disqualify)
```

### Combined Score

```
combined_score = (skill_match * 0.4) + (constraint_fit * 0.6)
```

## Edge Cases

### No Matching Stacks

If filters eliminate all options:

```
1. Relax budget constraint first
2. Then relax skill match requirements
3. Present options with caveats
4. Ask user if constraints can be adjusted
```

### User Has No Skills Listed

If known_skills is empty:

```
1. Rank by learning_curve (prefer low)
2. Rank by community size (prefer large)
3. Present as "beginner-friendly options"
```

### Conflicting Preferences

If stated preference conflicts with constraints:

```
Example: User wants "enterprise compliance" but budget is "free"

Response: "You mentioned needing [compliance], but that typically requires
paid hosting. Would you like me to:
A) Recommend enterprise-budget stacks
B) Proceed with free tier (compliance later)
C) Discuss compliance requirements further"
```

## Human Checkpoints

- **Review Tier:** Recommendations presented for user selection
- **Approve Tier:** User must explicitly select a stack
- User can ask for more options or different criteria

## Error Handling

| Error | Resolution |
|-------|------------|
| Stack patterns file missing | Use embedded fallback patterns |
| No stacks match constraints | Relax constraints, explain trade-offs |
| User rejects all options | Ask what's missing, gather more preferences |
| Ambiguous selection | Confirm with user |

## Integration Points

- **Invoked by:** `constraint-discovery`
- **Receives:** Complete constraints and preferences
- **Hands off to:** `foundation-writer` with selected stack
- User selection triggers handoff

## Example Sessions

### Example 1: Clear Match

**Input:**
```json
{
  "constraints": { "platform": "web", "budget": "free" },
  "known_skills": ["React", "JavaScript"],
  "extracted_preferences": { "framework": "React" }
}
```

**Output:** Next.js as clear recommendation (React + free tier match)

### Example 2: No Skills

**Input:**
```json
{
  "constraints": { "platform": "web", "budget": "free" },
  "known_skills": [],
  "extracted_preferences": {}
}
```

**Output:** Recommend by learning curve - Django or Next.js with explanation

### Example 3: Enterprise Needs

**Input:**
```json
{
  "constraints": { "platform": "api", "budget": "enterprise", "compliance": "HIPAA" },
  "known_skills": ["Python", "Go"],
  "extracted_preferences": {}
}
```

**Output:** Go API or FastAPI with compliance-focused recommendations

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
