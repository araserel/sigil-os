# Implementation Plan: [FEATURE NAME]

> **Spec:** [/.sigil/specs/###-feature/spec.md]
> **Created:** [DATE]
> **Status:** [Draft | In Review | Approved]
> **Complexity:** [Simple | Standard | Complex]

---

## Technical Context

### Technology Stack
<!-- From constitution, confirmed for this feature -->

| Component | Technology | Version | Notes |
|-----------|------------|---------|-------|
| Language | [From constitution] | [Version] | |
| Framework | [From constitution] | [Version] | |
| Database | [From constitution] | [Version] | |
| Additional | [Feature-specific] | [Version] | [Why needed] |

### Existing Codebase Context
<!-- Relevant existing code this feature touches -->

| Area | Files/Modules | Relevance |
|------|---------------|-----------|
| [Area name] | [File paths] | [How it relates] |

---

## Constitution Gate Checks

### Simplicity Gate
- [ ] Solution uses ≤3 new packages/dependencies
- [ ] No new infrastructure components required
- [ ] Complexity is proportional to problem size
- **Violations:** [None / List any violations with justification]

### Anti-Abstraction Gate
- [ ] Uses framework capabilities directly (no wrapper libraries)
- [ ] No premature abstractions for single-use cases
- [ ] Follows existing codebase patterns
- **Violations:** [None / List any violations with justification]

### Integration-First Gate
- [ ] API contracts defined before implementation
- [ ] Data models documented
- [ ] Integration points with existing code identified
- **Violations:** [None / List any violations with justification]

### Accessibility Gate
- [ ] WCAG 2.1 AA requirements identified
- [ ] Keyboard navigation path defined
- [ ] Screen reader behavior specified
- **Violations:** [None / List any violations with justification]

---

## Project Structure Changes

### New Files
<!-- Files that will be created -->

```
src/
├── [path/to/new/file.ts]        # [Purpose]
├── [path/to/new/file.ts]        # [Purpose]
└── [path/to/new/file.test.ts]   # [Test file]
```

### Modified Files
<!-- Existing files that will be changed -->

| File | Change Type | Description |
|------|-------------|-------------|
| [path/to/file.ts] | [Add/Modify/Refactor] | [What changes] |

### Deleted Files
<!-- Files to be removed, if any -->

| File | Reason |
|------|--------|
| [path/to/file.ts] | [Why removing] |

---

## API Contracts

<!-- Define API endpoints if this feature includes API work -->

### New Endpoints

#### [METHOD] /api/[path]
```
Request:
{
  "field": "type — description"
}

Response (200):
{
  "field": "type — description"
}

Errors:
- 400: [Condition]
- 401: [Condition]
- 404: [Condition]
```

### Modified Endpoints

| Endpoint | Change | Breaking? | Migration |
|----------|--------|-----------|-----------|
| [Endpoint] | [Change] | [Yes/No] | [Migration plan if breaking] |

---

## Data Model Changes

<!-- Database schema changes if applicable -->

### New Tables/Collections

#### [table_name]
```sql
CREATE TABLE table_name (
  id UUID PRIMARY KEY,
  field_name TYPE CONSTRAINTS,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Modified Tables

| Table | Change | Migration Required |
|-------|--------|-------------------|
| [table] | [Change] | [Yes/No — migration details] |

### Indexes

| Table | Index | Columns | Reason |
|-------|-------|---------|--------|
| [table] | [index_name] | [columns] | [Performance reason] |

---

## Dependencies

### New Dependencies

| Package | Version | Purpose | Security Review |
|---------|---------|---------|-----------------|
| [package] | [^x.y.z] | [Why needed] | [Pending/Approved] |

### Dependency Updates

| Package | Current | Target | Reason |
|---------|---------|--------|--------|
| [package] | [x.y.z] | [a.b.c] | [Why updating] |

---

## Risk Assessment

### Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk description] | [Low/Medium/High] | [Low/Medium/High] | [How to mitigate] |

### Integration Risks

| Risk | Systems Affected | Mitigation |
|------|------------------|------------|
| [Risk description] | [Systems] | [How to mitigate] |

---

## Testing Strategy

### Unit Tests
- [ ] [Component/function] — [What to test]
- [ ] [Component/function] — [What to test]

### Integration Tests
- [ ] [Endpoint/flow] — [What to test]
- [ ] [Endpoint/flow] — [What to test]

### Accessibility Tests
- [ ] Keyboard navigation verification
- [ ] Screen reader testing
- [ ] Color contrast validation

### Manual Testing
- [ ] [Scenario] — [Steps to verify]

---

## Implementation Phases

### Phase 1: Foundation
<!-- Setup and infrastructure -->
- [Task description]
- [Task description]

### Phase 2: Core Implementation
<!-- Main feature work -->
- [Task description]
- [Task description]

### Phase 3: Integration
<!-- Connecting pieces -->
- [Task description]
- [Task description]

### Phase 4: Testing & Polish
<!-- Quality assurance -->
- [Task description]
- [Task description]

---

## Architecture Decisions

<!-- Significant decisions that should be documented as ADRs -->

| Decision | Options Considered | Choice | Rationale |
|----------|-------------------|--------|-----------|
| [Decision topic] | [Option A, Option B] | [Chosen option] | [Why] |

**ADRs to Create:**
- [ ] ADR-###: [Decision topic]

---

## Research Findings

<!-- If research was conducted, summarize findings -->

### [Research Topic]
- **Question:** [What we needed to learn]
- **Finding:** [What we discovered]
- **Recommendation:** [How this affects implementation]
- **Sources:** [Where information came from]

---

## Open Issues

| Issue | Impact | Resolution Path | Status |
|-------|--------|-----------------|--------|
| [Issue description] | [How it affects plan] | [How to resolve] | [Open/Resolved] |

---

## Approvals

| Role | Name | Date | Status |
|------|------|------|--------|
| Architect | | | Pending |
| Tech Lead | | | Pending |
| Security (if applicable) | | | Pending |
