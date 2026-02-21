---
name: constraint-discovery
description: Progressively discovers project constraints through targeted questions. Uses progressive disclosure to avoid overwhelming users - only asks follow-up questions when relevant based on previous answers.
version: 1.0.0
category: research
chainable: true
invokes: [stack-recommendation]
invoked_by: [problem-framing]
tools: Read, Write, Edit
---

# Skill: Constraint Discovery

## Purpose

Systematically uncover project constraints through progressive, conversational questions. Avoids overwhelming users by:
1. Skipping questions already answered during problem framing
2. Only asking follow-up questions when previous answers make them relevant
3. Grouping related questions together

## When to Invoke

- After problem-framing completes
- When constraint clarification is needed mid-project
- User asks "what constraints matter" or "what do you need to know"

## Inputs

**Required:**
- `problem_statement`: object — Structured output from problem-framing

**From Previous Step:**
- `extracted_preferences`: object — Preferences already captured
- `skip_questions`: string[] — Topics already answered
- `known_skills`: string[] — User's stated technical skills

**Optional:**
- `force_questions`: string[] — Specific questions to ask regardless of skip list

## Process

### Step 1: Determine Critical Questions

Based on what's NOT in skip_questions, identify critical unknowns:

```
CRITICAL (must know for stack recommendation):
  - platform (if not known)
  - budget (if not known)

IMPORTANT (influences stack choice):
  - team_size (if not known)
  - timeline (if not known)
  - deployment_preference

CONTEXTUAL (asked based on previous answers):
  - compliance (only if budget = enterprise)
  - offline_support (only if platform = mobile)
  - real_time (only if features suggest it)
  - scale (only if not "solo" or "hobby")
```

### Step 2: Progressive Question Flow

Questions are asked in waves, with follow-ups based on answers:

```
WAVE 1: Critical Constraints (if not already known)
├── Platform: "Where will this run? (web, mobile, API, CLI, desktop)"
└── Budget: "What's your budget situation?"
    ├── "Free tier only"
    ├── "Low cost (~$0-50/month)"
    ├── "Moderate (~$50-500/month)"
    └── "Enterprise budget"

WAVE 2: Team & Timeline (if not already known)
├── Team Size: "Who will work on this?"
│   ├── "Just me"
│   ├── "Small team (2-5)"
│   ├── "Medium team (5-15)"
│   └── "Large team (15+)"
└── Timeline: "When do you need this?"
    ├── "ASAP / learning project"
    ├── "Standard timeline"
    └── "Flexible / no rush"

WAVE 3: Contextual Follow-ups (based on previous answers)
├── IF budget = "enterprise":
│   └── "Any compliance requirements? (HIPAA, SOC2, GDPR, etc.)"
├── IF platform = "mobile":
│   └── "Does it need to work offline?"
├── IF team_size != "solo":
│   └── "Any existing team skills I should optimize for?"
└── IF features suggest real-time:
    └── "Do you need real-time updates?"
```

### Step 3: Consolidate Constraints

Merge discovered constraints with extracted preferences:

```json
{
  "critical_constraints": {
    "platform": "web",
    "budget": "free"
  },
  "expanded_constraints": {
    "team_size": "solo",
    "timeline": "standard",
    "deployment": "vercel",
    "compliance": null,
    "offline": false,
    "real_time": false
  },
  "technical_constraints": {
    "integration_requirements": [],
    "performance_requirements": null,
    "data_residency": null
  }
}
```

### Step 4: Validate Constraint Compatibility

Check for conflicting constraints:

```
CONFLICT CHECKS:
- budget: "free" + compliance: "HIPAA" → CONFLICT (compliance hosting isn't free)
- platform: "web" + offline: true → POSSIBLE (PWA) but needs clarification
- timeline: "urgent" + team_size: "solo" + complexity: "high" → WARNING
```

## Question Templates

### Platform (if not extracted)

```markdown
**Where will this run?**

- [ ] **Web** — Browser-based application
- [ ] **Mobile** — iOS and/or Android app
- [ ] **API** — Backend service/API only
- [ ] **CLI** — Command-line tool
- [ ] **Desktop** — Native desktop application
```

### Budget (if not extracted)

```markdown
**What's your budget for hosting and services?**

- [ ] **Free tier only** — No paid services, free hosting
- [ ] **Low cost** — Up to ~$50/month for hosting and services
- [ ] **Moderate** — $50-500/month, can use managed services
- [ ] **Enterprise** — Budget available for compliance and scale
```

### Team Size (if not extracted)

```markdown
**Who will work on this?**

- [ ] **Just me** — Solo project
- [ ] **Small team** — 2-5 people
- [ ] **Medium team** — 5-15 people
- [ ] **Large team** — 15+ people
```

### Timeline (if not extracted)

```markdown
**When do you need this working?**

- [ ] **Quick start** — Learning project or need it soon
- [ ] **Standard** — Normal development timeline
- [ ] **Flexible** — No time pressure, quality over speed
```

### Compliance (if budget = enterprise)

```markdown
**Any compliance requirements?**

- [ ] **None** — No specific compliance needs
- [ ] **GDPR** — EU data protection
- [ ] **HIPAA** — Healthcare data (US)
- [ ] **SOC2** — Security compliance
- [ ] **Other:** _______________
```

### Offline Support (if platform = mobile)

```markdown
**Does this need to work offline?**

- [ ] **No** — Always requires internet
- [ ] **Partial** — Some features work offline
- [ ] **Yes** — Core features must work offline
```

### Real-time Features

```markdown
**Do you need real-time updates?**

(Live updates, chat, collaborative editing, notifications, etc.)

- [ ] **No** — Standard request/response is fine
- [ ] **Some** — A few features need live updates
- [ ] **Heavy** — Real-time is core to the app
```

## Outputs

**Consolidated Constraints:**
```json
{
  "constraints": {
    "critical": {
      "platform": "web",
      "budget": "free"
    },
    "expanded": {
      "team_size": "solo",
      "timeline": "standard",
      "deployment_preference": null,
      "compliance": null,
      "offline": false,
      "real_time": false,
      "scale_expectations": "low"
    },
    "technical": {
      "integrations": [],
      "performance": null,
      "data_residency": null
    }
  },
  "compatibility_issues": [],
  "warnings": [],
  "questions_asked": 4,
  "questions_skipped": 3
}
```

**Handoff Data:**
```json
{
  "constraint_discovery_complete": true,
  "all_constraints": {...},
  "compatibility_validated": true,
  "next_skill": "stack-recommendation"
}
```

## Progressive Disclosure Logic

### Skip Logic

```
Skip question IF:
  - Answer already in extracted_preferences
  - Answer already in skip_questions
  - Question not relevant to platform
  - Question not relevant to budget tier

Example:
  User said "no paid services" → skip budget question
  User said "web app" → skip mobile-specific questions
  User said "just me" → skip team skill question
```

### Follow-up Logic

```
Ask follow-up IF:
  - Previous answer triggers it
  - Not already in skip list
  - Relevant to stack selection

Example:
  budget = "enterprise" → ask compliance question
  platform = "mobile" → ask offline question
  features include "chat" → ask real_time question
```

### Conversation Example

```
Assistant: "A few quick questions to find the right tech stack for you.
           I already know you want a web app with React.

           What's your budget for hosting and services?"

User: "Free tier only"

Assistant: "Great\! Since you said free tier, I won't ask about
           compliance requirements - those usually need paid hosting.

           Who will be working on this?"

User: "Just me"

Assistant: "Perfect - solo project. That's all I need\!

           Based on your constraints (web, free tier, solo, React preference),
           I'll now generate stack recommendations."
```

## Human Checkpoints

- **Auto Tier:** Questions generated automatically based on context
- **User provides answers:** User responds to each question
- **Review Tier:** Constraint summary shown for confirmation before proceeding

## Error Handling

| Error | Resolution |
|-------|------------|
| Conflicting constraints | Present conflict, ask user to resolve |
| Incomplete answers | Ask for clarification |
| Unknown constraint value | Ask user to explain |
| Too many unknowns | Prioritize critical constraints first |

## Integration Points

- **Invoked by:** `problem-framing`
- **Receives:** Extracted preferences and skip list
- **Hands off to:** `stack-recommendation` with complete constraints

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-20 | Initial release |
