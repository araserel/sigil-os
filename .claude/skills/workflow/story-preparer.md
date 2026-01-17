# Skill: Story Preparer

> **Status:** NOT YET IMPLEMENTED
>
> This skill is planned but not yet functional. References exist in:
> - `.claude/agents/task-planner.md`

---

## Purpose

Convert Prism OS tasks into user story format for teams that use story-based workflows or external project management tools.

---

## Intended Behavior

### When Invoked

The Task Planner invokes this skill when:
- User requests story format output
- Team uses Jira, Linear, or similar story-based tools
- Enterprise track requires formal story documentation

### Expected Capabilities

1. **Story Formatting**
   - Convert task descriptions to "As a... I want... So that..." format
   - Map acceptance criteria to story acceptance criteria
   - Preserve priority and dependency information

2. **Story Sizing**
   - Suggest story point estimates based on task complexity
   - Flag stories that may need splitting
   - Maintain sizing consistency across feature

3. **External Tool Export**
   - Generate CSV/JSON for tool import
   - Map Prism OS fields to tool-specific fields
   - Support common tools (Jira, Linear, Asana)

---

## Planned Input

```markdown
**Task:** T001
**Description:** [Task description from task-decomposer]
**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
**Dependencies:** [T000]
**Priority:** P1
```

---

## Planned Output

```markdown
## User Story: [Story ID]

### Story
As a [user type],
I want to [action],
So that [benefit].

### Acceptance Criteria
- [ ] Given [context], when [action], then [result]
- [ ] Given [context], when [action], then [result]

### Metadata
- **Points:** [Estimate]
- **Priority:** [P1/P2/P3]
- **Epic:** [Feature name]
- **Blocked By:** [Other story IDs]
- **Prism OS Task:** T001

### Technical Notes
[Any implementation guidance from original task]
```

---

## Export Formats

### CSV (for generic import)

```csv
Summary,Description,Story Points,Priority,Epic,Blocked By
"[Story title]","[Full story text]",3,High,"User Auth","STORY-002"
```

### Jira JSON

```json
{
  "fields": {
    "summary": "[Story title]",
    "description": "[Story text]",
    "issuetype": {"name": "Story"},
    "customfield_10016": 3,
    "priority": {"name": "High"}
  }
}
```

---

## Implementation Notes

When implemented, this skill should:
- Maintain traceability back to Prism OS tasks
- Support batch conversion of all tasks in a feature
- Allow customization of story template
- Preserve all technical context for developers

---

## Related Components

- **Invoked by:** Task Planner
- **Works with:** task-decomposer
- **Outputs to:** User stories (inline or exported file)

---

*Stub created: 2026-01-16*
*Implementation pending*
