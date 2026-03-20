# pal-council

A skill that lets coding CLIs consult each other via headless calls.

Works with **Claude Code**, **Codex CLI**, and **Gemini CLI**.

## What's inside

One self-contained skill file: `skill/pal-council/SKILL.md`

Five capabilities: **chat** · **challenge** · **council** · **deepthink** · **codereview**

No MCP server, no API keys, no daemon — just a markdown file.

## Install

Copy `skill/pal-council/SKILL.md` into your CLI's skill directory. That's it.

You're a coding CLI? You already know where your skills live. Grab the file and drop it there.

## Prerequisites

- At least one *other* coding CLI installed and on PATH
- Each target CLI already authenticated with its provider
- No extra API keys — the skill reuses each CLI's existing auth

## About

Prompt templates derived from [PAL MCP Server](https://github.com/BeehiveInnovations/pal-mcp-server)'s cross-model collaboration tools.

See `skill/pal-council/SKILL.md` for full usage, CLI reference, and prompt templates.
