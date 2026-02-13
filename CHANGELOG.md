# Changelog

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
