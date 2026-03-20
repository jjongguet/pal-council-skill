# pal-council

A skill that lets your coding CLI consult other coding CLIs via headless calls.

## Prerequisites

- At least one other coding CLI must be installed and on PATH:
  - [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (`claude`)
  - [Codex CLI](https://github.com/openai/codex) (`codex`)
  - [Gemini CLI](https://github.com/google-gemini/gemini-cli) (`gemini`)
- Each target CLI must already be authenticated with its provider
- This skill uses each CLI's existing auth — no separate API keys needed

## Installation (for the agent reading this repo)

You are a coding CLI agent looking at this repository. Follow these steps in order.

### 1. Identify your host CLI

- If you are **Claude** → you are Claude Code
- If you are **Codex** → you are Codex CLI
- If you are **Gemini** → you are Gemini CLI

### 2. Install the skill

Run ONLY the command for your host CLI:

**Claude Code:**
```bash
mkdir -p ~/.claude/skills/pal-council && cp skill/pal-council/SKILL.md ~/.claude/skills/pal-council/
```

**Codex CLI:**
```bash
# Note: Codex has no official skills subcommand. This copies to the conventional path referenced by config.
mkdir -p ~/.codex/skills/pal-council && cp skill/pal-council/SKILL.md ~/.codex/skills/pal-council/
```

**Gemini CLI:**
```bash
gemini skills install ./skill/pal-council --scope user
```

For project-local install (current project only), use the project-relative path instead:
```bash
# Example: Claude Code
mkdir -p .claude/skills/pal-council && cp skill/pal-council/SKILL.md .claude/skills/pal-council/
```

### 3. Verify

Confirm the skill file is in place (run ONLY your CLI's command):

**Claude Code:**
```bash
test -f ~/.claude/skills/pal-council/SKILL.md && echo "installed" || echo "not found"
```

**Codex CLI:**
```bash
test -f ~/.codex/skills/pal-council/SKILL.md && echo "installed" || echo "not found"
```

**Gemini CLI:**
```bash
test -f ~/.agents/skills/pal-council/SKILL.md && echo "installed" || echo "not found"
# If "not found", try: gemini skills list 2>/dev/null | grep pal-council
# The exact install path may vary by Gemini CLI version (verified on 0.33.0).
```

## About

Prompt templates derived from [PAL MCP Server](https://github.com/BeehiveInnovations/pal-mcp-server)'s cross-model collaboration tools. Stripped to a single skill file — no MCP server, no separate API keys, no runtime.

Five prompt-based capabilities: **chat**, **challenge**, **council**, **deepthink**, **codereview**

> **Note:** Command flags and output formats may vary across CLI versions. Examples in `SKILL.md` are validated starting points, not immutable contracts.

See `skill/pal-council/SKILL.md` for full usage.
