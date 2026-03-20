# pal-council

A skill that lets coding CLIs consult each other via headless calls.

Works with **Claude Code**, **Codex CLI**, and **Gemini CLI**.

## Important — read before installing

The installable skill lives at `skill/pal-council/SKILL.md` inside this
repository, **not** at the repository root.

You must install the `skill/pal-council` subdirectory only.
Copying the entire repository into a skills directory will not work.

The final installed path must look like:

```
<skills-dir>/pal-council/SKILL.md
```

## What's inside

- Skill root: `skill/pal-council`
- Skill entry file: `skill/pal-council/SKILL.md`
- Capabilities: **chat**, **challenge**, **council**, **deepthink**, **codereview**

No MCP server, no API keys, no daemon. Just a markdown skill file.

## Install

### Gemini CLI

Gemini CLI has a built-in install command that supports Git URLs with `--path`
for subdirectories:

```bash
gemini skills install https://github.com/jjongguet/pal-council-skill.git --path skill/pal-council --scope user --consent
```

| Flag | Purpose |
|---|---|
| `--path skill/pal-council` | Install only this subdirectory, not the repo root |
| `--scope user` | Install to `~/.gemini/skills/` (available in all projects) |
| `--consent` | Skip the interactive security prompt (safe for automation) |

Installed location:

```
~/.gemini/skills/pal-council/SKILL.md
```

Verify:

```bash
gemini skills list | grep -i pal-council
```

If skills are not discovered, ensure the experimental skills flag is enabled:

```json
{ "experimental": { "skills": true } }
```

in your Gemini CLI settings, or toggle via `/settings` > search "Skills" > enable.

### Codex CLI

Codex CLI discovers skills from `.agents/skills/` directories
([agentskills.io](https://agentskills.io) standard). There is no `codex skills install`
CLI command — copy the files manually.

User-level install (available in all projects):

```bash
git clone --depth 1 https://github.com/jjongguet/pal-council-skill.git /tmp/pal-council-skill
mkdir -p ~/.agents/skills
cp -R /tmp/pal-council-skill/skill/pal-council ~/.agents/skills/
rm -rf /tmp/pal-council-skill
```

Installed location:

```
~/.agents/skills/pal-council/SKILL.md
```

Project-level install (committed to repo, shared with team):

```bash
git clone --depth 1 https://github.com/jjongguet/pal-council-skill.git /tmp/pal-council-skill
mkdir -p .agents/skills
cp -R /tmp/pal-council-skill/skill/pal-council .agents/skills/
rm -rf /tmp/pal-council-skill
```

Verify — inside a Codex session, type `$` to see the skill mention menu, or:

```
/skills
```

Invoke the skill with `$pal-council`.

### Claude Code

Claude Code discovers skills from `.claude/skills/` directories.
There is no `claude skills install` CLI command — copy the files manually.

User-level install (available in all projects):

```bash
git clone --depth 1 https://github.com/jjongguet/pal-council-skill.git /tmp/pal-council-skill
mkdir -p ~/.claude/skills
cp -R /tmp/pal-council-skill/skill/pal-council ~/.claude/skills/
rm -rf /tmp/pal-council-skill
```

Installed location:

```
~/.claude/skills/pal-council/SKILL.md
```

Project-level install (committed to repo, shared with team):

```bash
git clone --depth 1 https://github.com/jjongguet/pal-council-skill.git /tmp/pal-council-skill
mkdir -p .claude/skills
cp -R /tmp/pal-council-skill/skill/pal-council .claude/skills/
rm -rf /tmp/pal-council-skill
```

Verify — start a new Claude Code session and check:

```
/pal-council
```

Claude Code also auto-activates the skill when it matches the task context
(based on the `description` field in SKILL.md frontmatter).

## Post-install checklist

1. Confirm `pal-council/SKILL.md` exists at the expected installed path
2. Restart the CLI if it was already running before installation
3. Use the CLI's skill listing to confirm `pal-council` appears:
   - Gemini: `gemini skills list`
   - Codex: type `$` or `/skills` inside a session
   - Claude Code: type `/` and look for `pal-council`
4. Test with a simple invocation (e.g., "ask codex what 2+2 is")

## Common mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| Copied entire repo instead of `skill/pal-council` | Skill not discovered | Delete and re-copy only the `skill/pal-council` subdirectory |
| Codex: installed to `~/.codex/skills/` | Skill not discovered | Move to `~/.agents/skills/pal-council/` (current official path) |
| Nested path like `skills/pal-council-skill/skill/pal-council/` | Skill not discovered | Flatten so `SKILL.md` is at `skills/pal-council/SKILL.md` |
| Gemini: skills feature not enabled | `gemini skills list` returns nothing | Enable in settings: `{ "experimental": { "skills": true } }` |

## Prerequisites

- At least one *other* coding CLI installed and on `PATH`
- Each target CLI already authenticated with its provider
- No extra API keys; the skill reuses each CLI's existing auth

## About

Prompt templates derived from [PAL MCP Server](https://github.com/BeehiveInnovations/pal-mcp-server)'s cross-model collaboration tools.

See `skill/pal-council/SKILL.md` for full usage, CLI reference, and prompt templates.
