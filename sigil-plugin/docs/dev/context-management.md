# Context Management Protocol

> Guidelines for maintaining accurate project state in `/.sigil/project-context.md` across sessions.

---

## Purpose

The project context file serves as the source of truth for workflow state. It enables:

1. **Session Continuity** — Resume work without losing progress
2. **State Visibility** — Users see where things stand at a glance
3. **Agent Coordination** — All agents reference the same state
4. **Decision History** — Track what was decided and why

---

## Update Triggers

Agents must update the project context file when these events occur:

| Trigger | What to Update | Owner Agent |
|---------|----------------|-------------|
| **Phase Transition** | Current Phase, Progress Summary | Orchestrator |
| **Task Started** | Current Task, Recent Activity | Developer |
| **Task Completed** | Progress Summary, Recent Activity | Developer, QA Engineer |
| **Blocker Detected** | Blockers section, Status | Any agent |
| **Blocker Resolved** | Move to Resolved Blockers | Any agent |
| **Decision Needed** | Open Decisions section | Any agent |
| **Decision Made** | Session Notes, remove from Open Decisions | Any agent |
| **Session Ending** | Session Notes | Orchestrator |

---

## Update Ownership

Each agent has specific update responsibilities:

### Orchestrator
- Current Phase and Status
- Active Agent (when delegating)
- Progress Summary checkmarks
- Next Human Touchpoint
- Session startup announcement

### Business Analyst
- Feature name and spec path (when created)
- Open Decisions (scope, requirements)
- Clarification outcomes

### Architect
- Plan path (when created)
- Open Decisions (technical choices)
- Key Decisions Made (architecture)

### Task Planner
- Tasks path and counts
- Task breakdown status

### Developer
- Current Task details
- Task completion updates
- Implementation blockers

### QA Engineer
- Validation status
- Quality blockers
- Fix iteration tracking

### Security
- Security review blockers
- Security decisions requiring approval

### DevOps
- Deployment blockers
- Release decisions

---

## Update Format

### Recent Activity Entry

Add new entries at the TOP of the table (newest first). Keep only the last 5 entries.

```markdown
| [TIMESTAMP] | [Verb phrase describing action] | [Agent name] | [Complete/Blocked/Pending] |
```

**Good examples:**
- `| 2025-01-15 10:30 | Created feature spec | Business Analyst | Complete |`
- `| 2025-01-15 11:45 | QA validation failed (3 lint errors) | QA Engineer | Blocked |`
- `| 2025-01-15 14:00 | Awaiting architecture decision | Architect | Pending |`

**Bad examples:**
- `| Today | Did stuff | BA | Done |` (vague, abbreviated)
- `| 2025-01-15 | spec.md | Business Analyst | Complete |` (missing action verb)

### Open Decision Entry

```markdown
### Decision [N]: [Topic in 2-5 words]
- **Context:** [1-2 sentences explaining why this needs human input]
- **Options:**
  - A) [Option with brief description]
  - B) [Option with brief description]
- **Recommended:** [Option letter] — [Why this is suggested]
- **Status:** Awaiting input
```

When decision is made:
1. Remove from Open Decisions
2. Add to Session Notes → Key Decisions Made

### Blocker Entry

**Active:**
```markdown
- [ ] [Brief description] — Required: [What needs to happen]
```

**Resolved:**
```markdown
- [x] [Brief description] — Resolved: [How it was fixed]
```

---

## Session Startup Protocol

**Every session**, the Orchestrator must:

1. **Read** `/.sigil/project-context.md`

2. **Announce** current state to user:
   ```
   ## Resuming: [Feature Name]

   **Phase:** [Current Phase]
   **Track:** [Track]
   **Status:** [Status]

   **Last Activity:** [Most recent entry from Recent Activity]

   **Open Items:**
   - [Any open decisions]
   - [Any active blockers]

   **Suggested Next Step:** [Based on current phase]
   ```

3. **Validate** state is consistent:
   - Check spec path exists (if past Specify phase)
   - Check plan path exists (if past Plan phase)
   - Check tasks path exists (if past Tasks phase)

4. **Alert** if inconsistencies found:
   ```
   Note: [Description of inconsistency]. Would you like to:
   A) Continue with current state
   B) Investigate the issue
   ```

---

## State Transfer Consolidation

When receiving a handoff with State Transfer JSON, extract and update:

**From Handoff JSON:**
```json
{
  "chain_id": "abc123",
  "spec_path": "/.sigil/specs/001-feature/",
  "track": "Standard",
  "iteration_counts": {
    "clarifier": 2,
    "qa_fixer": 0
  },
  "approvals": {
    "spec": true,
    "plan": false
  },
  "blocking_issues": []
}
```

**Update in project-context.md:**
- `spec_path` → Current Work → Spec Path
- `track` → Current Work → Track
- `iteration_counts` → Session Notes (if limits approaching)
- `approvals` → Progress Summary checkmarks
- `blocking_issues` → Blockers section

---

## Iteration Limit Tracking

Track approaching limits in Session Notes:

```markdown
### Iteration Counts
- Clarifier: [N]/3 rounds
- QA Fixer: [N]/5 attempts

**Warning:** [If N >= 2 for clarifier or N >= 4 for QA fixer, note approaching limit]
```

---

## Quick Reference Updates

Keep these paths current:

| Field | When to Update |
|-------|----------------|
| Current Spec | When spec-writer creates `/.sigil/specs/###-feature/spec.md` |
| Current Plan | When technical-planner creates `plan.md` |
| Current Tasks | When task-decomposer creates `tasks.md` |
| Next Human Touchpoint | Every phase transition |

---

## Example: Complete Update Cycle

**Scenario:** User asks for a new feature, Business Analyst creates spec.

**Updates made:**

1. **Current Work:**
   ```markdown
   - **Feature:** User Authentication
   - **Spec Path:** /.sigil/specs/001-user-auth/
   - **Track:** Standard
   - **Phase:** Specify
   - **Status:** Complete
   - **Active Agent:** Business Analyst
   ```

2. **Progress Summary:**
   ```markdown
   - [x] Specify — Spec created
   ```

3. **Recent Activity:**
   ```markdown
   | 2025-01-15 10:30 | Created feature specification | Business Analyst | Complete |
   ```

4. **Quick Reference:**
   ```markdown
   - Current Spec: `/.sigil/specs/001-user-auth/spec.md`
   ```

5. **Next Human Touchpoint:**
   ```markdown
   - **Action Needed:** Review specification
   - **Tier:** Review
   - **Context:** Spec ready for approval before planning begins
   ```

---

## Error Handling

### Missing Context File

If `/.sigil/project-context.md` doesn't exist:
1. Copy from `/templates/project-context-template.md`
2. Announce: "Starting fresh context — no previous state found"
3. Proceed with current request

### Corrupted Context File

If context file is unreadable or malformed:
1. Rename to `project-context-backup-[timestamp].md`
2. Create fresh from template
3. Alert user: "Context file was corrupted. Starting fresh. Backup saved."

### Conflicting State

If context doesn't match actual artifacts:
1. Trust artifacts over context (specs, plans, tasks are source of truth)
2. Update context to match reality
3. Note discrepancy in Session Notes

---

## Best Practices

1. **Update immediately** — Don't batch updates; write as events happen
2. **Be specific** — Use clear action verbs and outcomes
3. **Keep it current** — Remove stale entries from Open Decisions
4. **Preserve history** — Move to Resolved, don't delete blockers
5. **Think of next session** — Add context that future-you will need
