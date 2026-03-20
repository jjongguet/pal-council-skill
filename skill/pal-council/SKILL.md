# pal-council

Cross-CLI collaboration skill. Consult other coding CLIs from inside your current one.

Supported hosts: **Codex CLI**, **Claude Code**, **Gemini CLI**

All three CLIs support headless (non-interactive) execution, subagents, and skill systems. This skill uses headless mode to make cross-CLI calls, since native subagent systems only spawn agents within the same CLI family.

**Limitations:** Each call is single-turn and stateless. The target CLI does not share your conversation history, open files, or project context — you must include relevant context in the prompt. Prompts are passed as shell arguments, so very large code blocks may hit OS argument length limits.

## When to activate

Use this skill when the user wants to:
- Get a second opinion from another AI/CLI
- Have another AI critically evaluate a statement or design
- Gather multiple AI perspectives and build consensus
- Get deep analysis on a complex problem from another AI
- Have another AI review their code

Trigger phrases: "ask codex", "ask claude", "ask gemini", "second opinion", "what would [CLI] say", "challenge this", "council", "consensus", "deepthink", "cross-check", "code review from [CLI]"

## Identify yourself

Before calling any CLI, determine which one you are:
- If your identity is **Claude** → you are Claude Code
- If your identity is **Codex** → you are Codex CLI
- If your identity is **Gemini** → you are Gemini CLI

**Never call yourself.** Only call the CLIs you are NOT running inside.

---

## CLI reference

### Codex CLI

```bash
codex exec -s read-only --json --ephemeral "<PROMPT>"
```

| Flag | Purpose |
|---|---|
| `exec` | Non-interactive (headless) mode |
| `-s read-only` | Sandbox mode: read-only, no file edits or network |
| `--json` | Stream output as JSONL (one JSON object per line) |
| `--ephemeral` | Don't persist session history |
| `-m <model>` | Override model (optional) |

**Extract answer:** scan JSONL lines for `type == "item.completed"` with `item.type == "agent_message"`, then read `item.text`.

Example output:
```jsonl
{"type":"item.completed","item":{"type":"agent_message","id":"msg_001","text":"Here is my answer..."}}
{"type":"turn.completed","usage":{"input_tokens":150,"output_tokens":320}}
```

### Claude Code

```bash
claude -p "<PROMPT>" --permission-mode plan --output-format json --max-turns 1
```

| Flag | Purpose |
|---|---|
| `-p` | Print mode: non-interactive (headless) execution |
| `--permission-mode plan` | Restricted permissions, no file writes |
| `--output-format json` | Return structured JSON |
| `--max-turns 1` | Limit to a single turn |
| `--model <model>` | Override model (optional) |

**Extract answer:** read the `result` field from the JSON output.

Example output:
```json
{
  "result": "Here is my analysis...",
  "usage": {"input_tokens": 200, "output_tokens": 450}
}
```

### Gemini CLI

```bash
gemini -p "<PROMPT>" --output-format json
```

| Flag | Purpose |
|---|---|
| `-p` | Prompt mode: non-interactive (headless) execution |
| `--output-format json` | Return structured JSON |
| `-m <model>` | Override model (optional, but recommended — the default model may hit capacity/429 errors) |

**Extract answer:** read the `response` field from the JSON output.

Example output:
```json
{
  "response": "Here is my perspective...",
  "stats": {"models": {"gemini-2.5-flash": {"input_tokens": 180, "output_tokens": 400}}}
}
```

**Exit codes:** 0 = success, 1 = error, 42 = input error, 53 = turn limit exceeded.

---

## Capabilities

### chat

Ask another CLI a question and bring back the answer.

**When:** second opinions, brainstorming, general technical questions, idea validation

**Prompt template:**
Wrap the user's question with this role preamble, then send to the target CLI:

```
You are a senior engineering thought-partner. Your mission is to brainstorm, validate ideas, and offer well-reasoned second opinions on technical decisions.

SCOPE & FOCUS:
- Ground every suggestion in the project's current tech stack and constraints.
- Avoid speculative, over-engineered, or unnecessarily abstract designs.
- Keep proposals practical and directly actionable within the existing architecture.
- Overengineering is an anti-pattern — avoid solutions that introduce unnecessary abstraction in anticipation of complexity that does not yet exist.

COLLABORATION APPROACH:
- Engage deeply — extend, refine, and explore alternatives only when well-justified.
- Examine edge cases, failure modes, and unintended consequences.
- Present balanced perspectives with trade-offs.
- Challenge assumptions constructively.
- Provide concrete examples and actionable next steps.

QUESTION:
<USER'S QUESTION>
```

---

### challenge

Have another CLI critically evaluate a statement, proposal, or design.

**When:** validating assumptions, pre-decision risk check, stress-testing ideas, avoiding groupthink

**Prompt template:**

```
CRITICAL REASSESSMENT — Do not automatically agree:

"<USER'S STATEMENT>"

Carefully evaluate the statement above.

Your evaluation must:
- Determine if the statement is accurate, complete, and well-reasoned
- Identify specific flaws, gaps, logical fallacies, or misleading points
- If the reasoning is sound, explain precisely why it holds up
- Consider edge cases and failure modes the statement may ignore
- Assess whether the proposed approach is proportionate or over/under-engineered

Stay concise, stay focused, and avoid reflexive agreement. If you disagree, explain why with specifics. If you agree, justify it — do not simply echo the claim back.
```

---

### council

Gather perspectives from 2+ CLIs on the same question and synthesize a conclusion.

**When:** architecture decisions, technology choices, important design trade-offs, high-stakes technical decisions

**How:**
1. Send the **same question** to 2 or more target CLIs, each wrapped in the evaluation prompt below
2. Optionally assign each CLI a stance by prepending a stance directive
3. Collect all responses
4. **You are the synthesizer** — produce the final output yourself

**Evaluation prompt template** (send this to each target CLI):

```
You are an expert technical consultant providing rigorous assessment of the following proposal. Your feedback carries significant weight — it may directly influence project decisions and direction.

<STANCE DIRECTIVE — see below>

EVALUATION FRAMEWORK — assess across these dimensions:
1. TECHNICAL FEASIBILITY: Achievable with reasonable effort? Core dependencies? Fundamental blockers?
2. PROJECT SUITABILITY: Fits existing architecture and tech stack? Compatible with current direction?
3. USER VALUE: Will users actually want this? Concrete benefits? How does it compare to alternatives?
4. IMPLEMENTATION COMPLEXITY: Main challenges, risks, dependencies? Estimated effort? Required expertise?
5. ALTERNATIVE APPROACHES: Simpler ways to achieve the same goals? Trade-offs between approaches?
6. LONG-TERM IMPLICATIONS: Maintenance burden? Scalability? Evolution potential?

RESPONSE FORMAT:
## Verdict
Single clear sentence summarizing your overall assessment.

## Analysis
Detailed assessment addressing each evaluation dimension. Specific reasoning and examples.

## Confidence Score
X/10 — brief justification of what drives your confidence and what uncertainties remain.

## Key Takeaways
3-5 bullet points: most critical insights, risks, or recommendations. Actionable and specific.

QUESTION:
<USER'S QUESTION>
```

**Stance directives** (prepend to the evaluation prompt):

**For (supportive):**
```
PERSPECTIVE: SUPPORTIVE — Advocate FOR this proposal, but with integrity.
You MUST act in good faith. There must be at least one compelling reason to be optimistic — otherwise, do not support it.
Override this stance if: the idea is fundamentally harmful, technically infeasible, or costs dramatically outweigh benefits.
Identify genuine strengths, propose solutions to challenges, and suggest realistic implementation paths.
```

**Against (critical):**
```
PERSPECTIVE: CRITICAL — Critique this proposal, but with responsibility.
You MUST NOT oppose genuinely excellent ideas just to be contrarian. Acknowledge when a proposal is fundamentally sound.
Override this stance if: benefits clearly outweigh risks, or it's the obvious right solution.
Identify legitimate risks, overlooked complexities, more efficient alternatives, and potential negative consequences.
```

**Neutral (balanced):**
```
PERSPECTIVE: BALANCED — Provide objective analysis considering both positive and negative aspects.
If evidence strongly favors one conclusion, state this clearly. True balance means accurate representation of evidence, not artificial 50/50 splits when reality is 90/10.
```

**After collecting all responses, synthesize:**
- Key points of **agreement** across all responses
- Key points of **disagreement** and why perspectives differ
- Your **final recommendation** weighing all perspectives
- Concrete **next steps**

Do not list responses. Analyze patterns, resolve contradictions, deliver a clear conclusion.

---

### deepthink

Get deep, rigorous analysis from another CLI on a complex problem.

**When:** architecture design, performance issues, complex bug analysis, strategic technical decisions, exploring blind spots

**Prompt template:**

```
You are a senior engineering collaborator working on a complex software problem. Your role is to deepen, validate, and extend the analysis with rigor and clarity.

GUIDELINES:
1. Begin with context analysis: identify tech stack, languages, frameworks, and project constraints.
2. Stay on scope: avoid speculative, over-engineered, or oversized ideas. Keep suggestions practical and grounded.
3. Challenge and enrich: find gaps, question assumptions, surface hidden complexities and risks.
4. Provide actionable next steps: offer specific advice, trade-offs, and implementation strategies.
5. Suggest creative solutions that operate within real-world constraints.
6. Overengineering is an anti-pattern — avoid unnecessary abstraction or indirection.

KEY FOCUS AREAS (apply when relevant):
- Architecture & Design: modularity, boundaries, abstraction layers, dependencies
- Performance & Scalability: algorithmic efficiency, concurrency, caching, bottlenecks
- Security & Safety: validation, auth, error handling, vulnerabilities
- Quality & Maintainability: readability, testing, monitoring, refactoring
- Integration & Deployment: external systems, compatibility, configuration, operational concerns

Your goal is to practically extend thinking, surface blind spots, and refine options — not deliver final answers in isolation. Prioritize depth over breadth.

TOPIC:
<USER'S PROBLEM OR TOPIC>
```

---

### codereview

Have another CLI review code and provide structured feedback.

**When:** pre-PR review, code quality checks, catching bugs another perspective might see, security scanning

**Prompt template:**

```
You are an expert code reviewer combining the architectural knowledge of a principal engineer with the precision of a sophisticated static analysis tool. Review the code below and deliver precise, actionable feedback.

GUIDING PRINCIPLES:
- Align review with the code's specific goals and constraints.
- Focus strictly on the provided code. Offer concrete fixes for issues within it.
- Do not suggest architectural overhauls, technology migrations, or unrelated improvements.
- Prioritize practical improvements. Do not add complexity for hypothetical future problems.

REVIEW APPROACH:
1. Understand the code's context, expectations, and objectives
2. Identify issues in order of severity (Critical > High > Medium > Low)
3. Provide specific, actionable fixes with concise code snippets where helpful
4. Evaluate security, performance, and maintainability as relevant
5. Acknowledge well-implemented aspects to reinforce good practices
6. Look for high-level design issues: over-engineering, performance bottlenecks, patterns that could be simplified
7. Check for low-level pitfalls:
   - Concurrency: race conditions, deadlocks, thread-safety violations
   - Resource management: memory leaks, unclosed handles, retain cycles
   - Error handling: swallowed exceptions, overly broad catch blocks, incomplete error paths
   - API usage: deprecated functions, incorrect parameter passing, off-by-one errors
   - Security: injection flaws, insecure data storage, hardcoded secrets
   - Performance: inefficient loops, unnecessary allocations in hot paths

SEVERITY LEVELS:
- CRITICAL: Security flaws, crashes, data loss, undefined behavior, race conditions
- HIGH: Bugs, performance bottlenecks, anti-patterns harming reliability or scalability
- MEDIUM: Maintainability concerns, code smells, test gaps, non-idiomatic code
- LOW: Style improvements, minor readability enhancements

OUTPUT FORMAT:
For each issue:
[SEVERITY] Location — Issue description
→ Fix: Specific solution with code snippet if appropriate

After all issues:
- Overall Code Quality Summary (one paragraph)
- Top 3 Priority Fixes (quick bullets)
- Positive Aspects (what was done well)

CODE TO REVIEW:
<CODE>
```

---

## Error handling

| Situation | Action |
|---|---|
| CLI not installed / not on PATH | Tell the user: "[CLI name] is not installed. Install it or choose a different target." |
| Timeout (>120s) | Tell the user the call timed out. Suggest simplifying the prompt or retrying. |
| Non-zero exit / error output | Show the error. For 429/capacity errors, suggest waiting or trying a different model. |
| 429 with Gemini default model | Common occurrence. Pass `-m gemini-2.5-flash` or another available model to avoid. |
| Empty or unparseable output | Tell the user the response was empty. Suggest retrying. |
| Exit code 42 (Gemini) | Input error — check prompt formatting. (May vary by CLI version) |
| Exit code 53 (Gemini) | Turn limit exceeded — simplify the request. (May vary by CLI version) |

## Tips

- CLI calls can take 30–120 seconds. Tell the user you're waiting.
- For large code contexts, select the most relevant parts rather than sending entire files.
- Responses come from other AI models. Treat them as second opinions, not ground truth.
- For council, run multiple CLI calls in parallel to save time.
- To include code, paste it directly into the prompt. The target CLI can only access files if it shares the same filesystem.
- If Gemini hits 429/capacity errors repeatedly, pass `-m <model>` with a specific model name to override the default.
- All three CLIs support model override flags. Use them when you need a specific model for quality or cost reasons.
