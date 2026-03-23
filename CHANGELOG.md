# Changelog

All notable changes to pal-council are documented here.

## [1.1.0] - 2026-03-23

### Added
- Oz CLI (Warp) as 4th supported CLI with full parity documentation
- Oz CLI reference section: NDJSON output, `--skill` flag, PATH notes
- Oz identity disambiguation note for multi-model detection
- Prompt safety section with shell escaping guidance
- Context inclusion tips for each of the 6 capabilities
- `bugcheck` capability for cross-model bug diagnosis
- Pre-call context gathering guide with auto-gather checklist
- Coding-specific trigger phrases (debug, PR review, test ideas)
- Smoke test script (`tests/smoke.sh`) for CLI verification
- Version field in SKILL.md frontmatter

### Changed
- "All three CLIs" → "All four CLIs" throughout
- Prompt templates updated to reference "provided information" instead of assuming project context
- Error handling table expanded with Oz-specific entries
- Tips section expanded with Oz auth and PATH guidance

### Fixed
- Prompt template self-contradiction: templates no longer promise context-aware analysis from a contextless model

## [1.0.0] - 2026-03-19

### Added
- Initial release with Claude Code, Codex CLI, Gemini CLI support
- 5 capabilities: chat, challenge, council, deepthink, codereview
- Per-CLI install instructions for all 3 supported CLIs
- Error handling and tips sections
