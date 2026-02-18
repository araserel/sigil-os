# Changelog

## [0.22.0] - 2026-02-18

### Added
- **Post-Completion Handoff Prompt (S25-004):** After code review passes, the orchestrator now presents a next-action prompt with three options: build another feature, hand off to an engineer, or wrap up. Handoff packages can now be generated inline at the natural completion point, without requiring users to independently remember `/sigil-handoff`. The standalone `/sigil-handoff` command remains available.
- **Feature Complete output template:** Added canonical completion summary format to `output-formats.md` for consistent post-review output.

### Changed
- **Command Retirement (S25-001):** Retired 8 slash commands whose functionality is already handled by the `/sigil` orchestrator: `sigil-spec`, `sigil-status`, `sigil-clarify`, `sigil-plan`, `sigil-tasks`, `sigil-validate`, `sigil-review`, `sigil-prime`. Users now use `/sigil "description"` to start features, `/sigil continue` to resume, and `/sigil` for status. Workflow phases (specify, clarify, plan, tasks, validate, review) and context loading run automatically.
- **Orchestrator updated:** Replaced `Skill(skill: "sigil-validate")` and `Skill(skill: "sigil-review")` invocations with direct skill SKILL.md reads, since command files no longer exist. Help output reduced from 18 commands to 10.
- **Preflight-check updated:** SIGIL.md enforcement template no longer lists retired commands. Mandatory skill invocation table replaced with orchestrator-handles-it explanation. ENFORCEMENT_VERSION bumped from 2.1.0 to 2.2.0.
- **Skill triggers updated:** Six skills (spec-writer, status-reporter, clarifier, technical-planner, qa-validator, code-reviewer) updated to reflect auto-invocation instead of standalone command triggers.
- **All documentation updated:** command-reference.md, user-guide.md, troubleshooting.md, shared-context-setup.md, multi-team-workflow.md, workflow-diagrams.md, quick-start.md, glossary.md, and example walkthrough updated to remove retired command references. Retired Commands migration table added to command-reference.md.
- **Cross-references cleaned:** Updated orchestrator.md, discovery-chain.md, output-formats.md, sigil-setup.md, sigil-connect.md, sigil-handoff.md, sigil-learn.md, sigil-profile.md, connect-wizard, profile-generator, shared-context-sync, visual-analyzer, and technical-planner to remove all retired command references.

### Removed
- Deleted 8 command files: `sigil-spec.md`, `sigil-status.md`, `sigil-clarify.md`, `sigil-plan.md`, `sigil-tasks.md`, `sigil-validate.md`, `sigil-review.md`, `sigil-prime.md`

## [2.1.3] - 2026-02-13

### Fixed
- **Broken link in status-reporter:** Fixed `context-management.md` reference missing `dev/` subdirectory (`/docs/context-management.md` → `/docs/dev/context-management.md`)

## [2.1.2] - 2026-02-12

### Fixed
- **ENFORCEMENT_VERSION drift:** Aligned preflight-check.sh and SKILL.md frontmatter to canonical 2.1.0
- **VERSION file drift:** Synced VERSION file (was 2.1.0, plugin.json was 2.1.1)
- **Troubleshooting paths:** Corrected `/memory` references to `.sigil/` throughout troubleshooting.md
- **Broken contributor links:** Fixed dead links to non-existent Development Workflows doc in docs/README.md and docs/dev/README.md
- **Legacy command references:** Updated `/memory/`, `/constitution`, `/status`, `/spec` to current `.sigil/`, `/sigil-constitution`, `/sigil-status`, `/sigil-spec` in test scenario docs
- **Test validator false errors:** Fixed validator to not error on never-run scenarios; corrected scenario output mode registry from FULL to QUICK
- **Broken checklist reference:** Fixed final-review-checklist.md reference to archived future-considerations.md
- **Stale skill versions:** Updated learning-capture, learning-reader, and preflight-check versions in versioning.md
- **Migration doc versions:** Updated enforcement version (2.0.0 → 2.1.0) and plugin version (2.0.0 → 2.1.2) in migration guide

### Fixed (Hooks)
- **session-summary.sh:** Field extraction now matches actual `project-context.md` format (`**Key:**` not `**Key**:`); fixed `Tasks Completed` → `Completed` to match template
- **verify-context-update.sh:** Implementation file detection now handles both absolute and relative paths
- **verify-context-update.sh:** Constitution update detection uses fixed-string match (`grep -qF`) to avoid false positives from wildcard dot

### Added
- `/sigil-handoff` command for engineer handoff package generation (renamed from `/handoff` to match `/sigil-*` namespace)
- `/sigil-handoff` and `/sigil-setup` added to workflow diagrams, command reference, and `/sigil help` output

### Changed
- **Installation instructions:** Updated Claude Code install from deprecated `npm install -g` to native installer (`curl` for Mac/Linux/WSL, desktop installer for Windows); removed Node.js as a prerequisite
- **Removed `installation.md`:** Consolidated install instructions into quick-start.md and the Setup Guide; the separate file was outdated and redundant

### Docs
- Updated README.md, quick-start.md, and Setup Guide (Notion + printable) with cross-platform install instructions
- Updated `/sigil-update` examples to use version-agnostic placeholders
- Fixed command reference to include `/sigil-setup` in overview, quick reference, and full section

## [2.1.0] - 2026-02-10

### Changed
- **Rebrand:** Prism OS → Sigil OS ("Inscribe it. Ship it.")
- Renamed `prism-plugin/` → `sigil-plugin/`
- Renamed all `/prism*` commands → `/sigil*` commands
- Updated all internal references, paths, and documentation
- Plugin install is now `claude plugin install sigil@sigil-os`
- Marketplace is now `claude plugin marketplace add araserel/sigil-os`
- Enforcement file renamed from `PRISM.md` → `SIGIL.md`

### Notes
- This is a name-only change — no logic, workflow, agent, skill, or hook behavior changes
- All existing workflows, specs, and project constitutions continue to work unchanged

## [2.0.0] - 2026-02-05 [now Sigil OS]

### Changed
- **BREAKING:** Migrated from configuration-layer framework to Claude Code plugin architecture
- Installation now uses `claude plugin install` instead of `install-global.sh`
- All agents, skills, commands, and templates bundled under `sigil-plugin/`
- Enforcement model changed from instruction-based to hook-based (programmatic)

### Added
- `plugin.json` manifest as canonical source of truth
- `hooks/` directory with 4 lifecycle hooks:
  - `preflight-check.sh` (SessionStart)
  - `verify-context-update.sh` (PostToolUse)
  - `validate-track-routing.sh` (SubagentStart)
  - `session-summary.sh` (Stop)
- Plugin marketplace distribution support

### Removed
- `install-global.sh` (replaced by plugin install)
- `~/.sigil-os/` update mechanism
- Legacy `sigil/` directory structure

### Migration Notes
- Existing users: Uninstall old global installation, then use `claude plugin install sigil@sigil-os`
- See ADR-D013 for full architectural decision record
