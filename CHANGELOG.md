# Changelog

## [2.0.0] - 2026-02-05

### Changed
- **BREAKING:** Migrated from configuration-layer framework to Claude Code plugin architecture
- Installation now uses `claude plugin install` instead of `install-global.sh`
- All agents, skills, commands, and templates bundled under `prism-plugin/`
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
- `~/.prism-os/` update mechanism
- Legacy `prism/` directory structure

### Migration Notes
- Existing users: Uninstall old global installation, then use `claude plugin install prism@prism-os`
- See ADR-D013 for full architectural decision record
