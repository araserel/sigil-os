---
name: story-preparer
description: Converts Prism OS tasks to user story format for Jira, Linear, or story-based workflows. Invoke when user requests stories, mentions Jira/Linear, or needs exportable format.
version: 1.0.0
category: workflow
chainable: true
invokes: []
invoked_by: [task-planner, orchestrator]
tools: Read, Write, Glob
---

# Skill: Story Preparer

## Purpose

Transform Prism OS task breakdowns into user story format compatible with external project management tools. Enables seamless handoff to teams using Jira, Linear, Asana, or other story-based workflows.

## When to Invoke

- User requests "convert to stories" or "export to Jira"
- User mentions Linear, Jira, Asana, or similar tools
- User asks for "story format" or "user stories"
- Task Planner identifies story-based workflow preference
- Enterprise track requires formal story documentation

## Inputs

**Required:**
- `tasks_path`: string — Path to tasks.md file from task-decomposer

**Optional:**
- `spec_path`: string — Path to spec for requirement context
- `story_format`: string — "standard" | "jira" | "linear" | "csv" (default: "standard")
- `include_estimates`: boolean — Add story point estimates (default: true)
- `epic_name`: string — Parent epic name for grouping

**Auto-loaded:**
- `project_context`: string — `/memory/project-context.md`

## Process

### Step 1: Load Tasks

```
1. Read tasks.md from tasks_path
2. Parse task structure (ID, description, dependencies, phase)
3. Load spec if provided for additional context
4. Group tasks by logical feature area
```

### Step 2: Story Conversion

For each task or task group, create a user story:

```
1. Identify the user type (from spec or infer)
2. Extract the action (what they want to do)
3. Determine the benefit (why it matters)
4. Format as: "As a [user], I want [action], so that [benefit]"
```

**Conversion Rules:**

| Task Type | Story Approach |
|-----------|----------------|
| Single atomic task | One story per task |
| Related tasks (same feature) | Group into one story |
| Infrastructure/setup tasks | Technical story format |
| Test tasks | Include in parent story AC |

### Step 3: Acceptance Criteria

Convert task acceptance criteria to Given-When-Then format:

```
Original: "Tests pass, user can log in"

Converted:
- Given a registered user
- When they enter valid credentials
- Then they are logged in and redirected to dashboard
```

### Step 4: Story Estimation

Apply relative sizing based on task complexity:

| Complexity Indicators | Points |
|----------------------|--------|
| Single file, simple change | 1 |
| 2-3 files, moderate logic | 2 |
| Multiple files, integration | 3 |
| Complex logic, new patterns | 5 |
| Cross-system, architectural | 8 |
| Uncertain scope, research needed | 13 |

### Step 5: Dependency Mapping

```
1. Convert T### dependencies to story dependencies
2. Identify blocking relationships
3. Mark stories that can be parallelized
4. Create epic/story hierarchy if needed
```

### Step 6: Format Output

Generate output in requested format (standard, Jira JSON, CSV).

## Outputs

### Standard Story Format

```markdown
## User Stories: [Feature Name]

**Epic:** [Epic name]
**Total Points:** [Sum]
**Story Count:** [Count]

---

### STORY-001: User Login

**Story:**
As a registered user,
I want to log in with my email and password,
So that I can access my personalized dashboard.

**Acceptance Criteria:**
- [ ] Given a registered user with valid credentials
      When they submit the login form
      Then they are authenticated and redirected to dashboard
- [ ] Given a user with invalid credentials
      When they submit the login form
      Then they see an error message
- [ ] Given a logged-in user
      When they close and reopen the browser
      Then they remain logged in (session persistence)

**Metadata:**
| Field | Value |
|-------|-------|
| Points | 3 |
| Priority | P1 |
| Epic | User Authentication |
| Blocked By | — |
| Prism Tasks | T001, T002, T003 |

**Technical Notes:**
- Uses NextAuth with credentials provider
- Session stored in database
- Rate limiting on failed attempts

---

### STORY-002: User Logout
[Same structure...]
```

### Jira JSON Export

```json
{
  "issues": [
    {
      "fields": {
        "project": {"key": "PROJ"},
        "summary": "User Login",
        "description": "As a registered user,\nI want to log in with my email and password,\nSo that I can access my personalized dashboard.\n\n*Acceptance Criteria:*\n* Given valid credentials, user is authenticated\n* Given invalid credentials, error is shown\n* Session persists across browser restarts",
        "issuetype": {"name": "Story"},
        "priority": {"name": "High"},
        "customfield_10016": 3,
        "labels": ["user-auth", "p1"],
        "components": [{"name": "Authentication"}]
      }
    }
  ]
}
```

### Linear CSV Export

```csv
Title,Description,Priority,Estimate,Labels,Parent
"User Login","As a registered user, I want to log in...","High",3,"user-auth,p1","User Authentication Epic"
"User Logout","As a logged-in user, I want to log out...","Medium",1,"user-auth,p2","User Authentication Epic"
```

### Handoff Data

```json
{
  "stories_path": "/specs/001-feature/stories.md",
  "tasks_path": "/specs/001-feature/tasks.md",
  "total_stories": 8,
  "total_points": 21,
  "export_format": "standard",
  "exports_generated": {
    "markdown": "/specs/001-feature/stories.md",
    "jira_json": "/specs/001-feature/stories-jira.json",
    "csv": "/specs/001-feature/stories.csv"
  },
  "story_mapping": {
    "STORY-001": ["T001", "T002", "T003"],
    "STORY-002": ["T004"],
    "STORY-003": ["T005", "T006"]
  },
  "blocked_stories": ["STORY-003"],
  "parallel_groups": [
    ["STORY-001", "STORY-002"],
    ["STORY-004", "STORY-005"]
  ]
}
```

## Story Templates

### Feature Story (Default)

```markdown
As a [user type],
I want to [action],
So that [benefit].
```

### Technical Story

```markdown
As a developer,
I need to [technical action],
So that [technical benefit/enablement].
```

### Bug Fix Story

```markdown
As a [affected user],
I expect [expected behavior],
But currently [actual behavior],
So that [impact of fix].
```

## Grouping Strategy

### When to Group Tasks

- Tasks share the same user scenario
- Tasks are sequential steps in one flow
- Combined tasks < 8 points

### When to Keep Separate

- Tasks can be developed independently
- Different team members could work in parallel
- Individual task > 5 points

## Human Checkpoints

- **Tier:** Auto (conversion runs automatically)
- User reviews stories before export
- User confirms point estimates

## Error Handling

| Error | Resolution |
|-------|------------|
| Tasks file not found | Request task decomposition first |
| No spec context | Use task descriptions only, note missing context |
| Circular dependencies | Flag and request clarification |
| Tasks too granular | Suggest grouping into larger stories |

## Example Invocations

**Basic conversion:**
```
User: Convert these tasks to user stories

→ story-preparer reads tasks.md
→ Generates stories.md in standard format
→ Returns story count and total points
```

**Jira export:**
```
User: Export to Jira format for the auth feature

→ story-preparer reads tasks.md
→ Generates stories-jira.json
→ Ready for Jira import API or manual upload
```

**With estimates:**
```
User: Create stories with point estimates for sprint planning

→ story-preparer analyzes task complexity
→ Applies fibonacci point scale
→ Includes estimates in story metadata
```

## Integration Points

- **Invoked by:** `task-planner` for story-based teams
- **Receives from:** `task-decomposer`
- **Works with:** `sprint-planner` for sprint organization
- **Outputs to:** External tools (Jira, Linear, Asana)

## Tool-Specific Notes

### Jira

- Use `customfield_10016` for story points (may vary by instance)
- Epic link requires existing epic ID
- Labels and components should exist in project

### Linear

- Import via CSV or API
- Estimate uses linear scale, not fibonacci
- Parent creates cycle/project link

### Asana

- Use task format, not story format
- Subtasks for acceptance criteria
- Tags for priority and labels

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-25 | Initial release - full implementation |
| 0.1.0-stub | 2026-01-16 | Stub created |
