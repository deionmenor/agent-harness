# AGENTS.md

Instructions for every AI agent working in this repo. The orchestrator drafts and maintains this file; <OWNER> approves changes to it.

Replace every `<PLACEHOLDER>` below once, when you adopt this template, then delete this paragraph. Agents read this file first, every session, so the effort pays back immediately.

## Project

<PROJECT> — <one sentence on what it is and who it is for>. Product scope lives in `agent/PRD.md`.

## Stack

- <FRAMEWORK AND VERSION>, <LANGUAGE>, strict mode
- <STYLING / UI approach>
- <DATABASE / BACKEND>
- <DEPLOY TARGET>
- <RUNTIME VERSION>
- Tests: <framework, or "none yet">

## Commands

| What | Command |
| --- | --- |
| Install | `<INSTALL>` |
| Dev server | `<DEV>` |
| Lint | `<LINT>` |
| Typecheck | `<TYPECHECK>` |
| Build | `<BUILD>` |
| Tests | `<TEST>` |

Run every command from the repository root. If your machine needs a wrapper (a container, WSL, a remote shell), write the exact form here once and have agents use it verbatim — a half-remembered wrapper is how a `db:push` ends up reporting the wrong error.

## Environment variables

Real values live in `.env.local` and in the deploy provider's variables, never in git. **`.env.example` is the one `.env*` file an agent may edit**, and only the orchestrator may touch it. Placeholders only: a name, and either no value or something obviously fake. Every other `.env*` file, and any file holding a real value, stays off limits. The names are listed here so no agent has to open a file to learn one.

| Name | Scope |
| --- | --- |
| `<VAR_NAME>` | <browser / server only / both> |

Read them through `process.env`; never hardcode a secret, and never print one.

## Branches

- Base branch: `<BASE_BRANCH>`.
- Feature branches: `feat/<task-id>-<short-slug>`.
- Merging to `<BASE_BRANCH>`: ask <OWNER> first, every time, and merge only after an explicit go-ahead in that session. The orchestrator's merge permission is `ask`, so the prompt is the enforcement; no other agent merges anything.
- If the deploy inlines build-time variables, they must be present **before** the build. A runtime-only change does not repair an existing deploy.

## Step budgets and handoff

Every step re-sends the whole context, so cost grows with steps, not with tasks. Budgets live in `.opencode/agents/`: builder 50 steps, reviewer 16. The orchestrator has no step cap — it keeps working until the task is finished or its context is exhausted, and writes `agent/STATUS.md` before it hands back either way.

At its cap an agent stops and reports; it does not loop. A task that genuinely needs more than one builder run is not retried — it goes to <OWNER> as `blocked: needs handoff to Claude Code`, with a block appended to `agent/HANDOFF-claude.md`.

## Model

- **Which model, exactly:** every agent pins its model in the `model:` line of `.opencode/agents/*.md`, and `opencode.json` sets the session default. Keep them consistent: a pinned agent silently running on another provider is a defect, not a saving.
- **A usage-limit error means the provider will not serve more right now.** Stop, say so in one line, and do not retry.

## Folder map

- `<src dir>/` — <what lives here>
- `agent/` — the harness itself: PRD, queue, status, log, handoff
- `.opencode/agents/` — the three agent definitions
- `<tests dir>/` — <what lives here>, if any

## Conventions

- <How pages/routes are structured>
- <How mutations flow>
- <Naming rules>
- DB columns are `snake_case`; generated types are regenerated, never hand-written.
- No `// @ts-ignore`, `eslint-disable`, or `any` casts.

## Never touch

- `.env`, `.env.local` and any file holding real values or secrets. **`.env.example` is the single exception:** the orchestrator may edit it, placeholders only, and the builder and reviewer may not touch it at all.
- CI configuration and workflow files
- Deploy provider project settings
- `supabase/migrations/` (or whatever your schema dir is) without <OWNER>'s approval

## Agent channels

- `agent/QUEUE.md`, `agent/STATUS.md` and `agent/LOG.md` belong to the orchestrator. Every other agent reports through **`agent/CLAUDE-NOTES.md`**, which is append-only: one entry, in the format given in that file, for a question, a blocker, a deviation or a finished PR. Nothing wakes the orchestrator between sessions, so an unlogged question is a dead end.
- A finished PR needs no message — it is on the remote, so `gh pr list --search "<task id>"` finds it. The PR body is where the spec decisions go.
- Any agent asked to implement a queued task reads its entry in `agent/QUEUE.md` first: it carries the criteria, the approvals already given, and the known gaps of the code it is about to touch.
- **Never ask <OWNER> to paste a handoff into Claude Code.** Trigger it headless from the repository with `agent/dispatch-claude.sh` instead. It inherits the same reviewer gate as any other PR.

## Checking in with <OWNER>

Assume they read on a phone between other things and do not want paragraphs. Every check-in ends with a **clickable checklist**:

- Status first, as short as it can be written, then one `question` call with `multiple: true` so several items can be ticked and submitted in one tap.
- 2–5 options. Each label is a short imperative that fits on one line ("Merge #67", "Dispatch T-017"), each description one sentence on the consequence. Put the recommended option first and mark it.
- That checklist is the turn's single question. Never ask in prose as well, and never ask a question the checklist could have carried.
- If nothing needs a decision, say so in one line and send no checklist — an empty one costs more than it saves.
- Decisions never go inside a rendered page or an artefact: buttons drawn anywhere else are decoration. The `question` tool is the only clickable path that returns an answer.
