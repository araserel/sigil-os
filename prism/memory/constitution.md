# Project Constitution: Prism OS

> These principles are immutable. All agents respect these boundaries without being reminded.
>
> **Created:** 2025-01-13
> **Last Modified:** 2025-01-13
> **Status:** Active

---

## Article 1: Technology Stack

### Primary Language
- **Language:** TypeScript
- **Version:** TypeScript 5.x
- **Rationale:** Strong typing, excellent IDE support, industry standard for modern development

### Framework
- **Framework:** None (Pure TypeScript/Markdown)
- **Rationale:** Prism OS is a configuration and documentation system, not an application

### Database
- **Database:** File-based (Markdown, JSON)
- **Rationale:** No external database needed; all state stored in project files

### Additional Technologies
- Claude Code: Primary AI agent runtime
- Git: Version control for all artifacts

---

## Article 2: Code Standards

### Style & Formatting
- [x] Use consistent Markdown formatting
- [x] YAML frontmatter for metadata in skill/agent definitions
- [x] Maximum line length: 100 characters for prose

### Naming Conventions
- [x] Use kebab-case for file names (e.g., `spec-writer.md`)
- [x] Use Title Case for section headings
- [x] Use numbered prefixes for ordered items (e.g., `001-feature`)

### Code Organization
- [x] One agent per file
- [x] One skill per file
- [x] Templates in `/templates/`
- [x] Documentation in `/docs/`

---

## Article 3: Testing Requirements

### Validation
- **Framework:** QA Validator skill
- **Requirements:**
  - [x] All skills must produce defined outputs
  - [x] All chains must complete or escalate appropriately
  - [x] Templates must be fillable by guided prompts

### Manual Testing
- [x] End-to-end workflow testing required before release
- [x] Non-technical user testing required for documentation

---

## Article 4: Security Mandates

### Secrets Management
- [x] No secrets in repository
- [x] API keys managed externally by Claude Code

### Input Validation
- [x] User inputs validated before processing
- [x] File paths validated to prevent traversal

---

## Article 5: Architecture Principles

### Design Principles
- [x] Skills are composable and chainable
- [x] Agents have single responsibilities
- [x] Templates are customizable but provide sensible defaults

### Layering
- [x] Agents invoke Skills
- [x] Skills produce Artifacts
- [x] Chains orchestrate Skills

---

## Article 6: Approval Requirements

### Changes
- [x] Template changes require review
- [x] Agent definitions require review
- [x] CLAUDE.md changes require review

### Documentation
- [x] User guide changes require non-technical review

---

## Article 7: Accessibility Requirements

### Compliance Standards
- **Minimum:** WCAG 2.1 Level AA
- **Target:** WCAG 2.1 Level AAA (where feasible)
- **Validation:** Accessibility checks included in QA phase

### Documentation Accessibility
- [x] Clear heading hierarchy in all documents
- [x] Plain language for non-technical users
- [x] Examples provided for complex concepts

---

## Amendment History

| Date | Article | Change | Approved By |
|------|---------|--------|-------------|
| 2025-01-13 | — | Initial constitution | Prism Team |
