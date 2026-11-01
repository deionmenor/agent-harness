# agent-harness

A delivery loop for AI coding agents, built on one idea: **the agent that judges cannot be the agent that writes, and neither of them decides what the product is.**

Three agents, a product spec, and a paper trail. It runs in [opencode](https://opencode.ai) but the pattern is portable — the files are plain markdown and the permissions are the design.

Built while shipping a real app in the gaps between client calls, mostly from a phone.

---

## Why it works

Four things do the heavy lifting, and none of them is the model:

1. **A PRD is the scope.** Every task cites a feature in `agent/PRD.md`. A request that is not in the PRD gets marked `blocked: out of scope?` instead of being built. This is the single rule that stops an agent from confidently shipping the wrong product.
2. **Permissions are asymmetric.** The agent that plans cannot write code; the agent that writes cannot touch the queue, secrets or CI; the agent that judges cannot write at all. Reviewing is only meaningful when the reviewer *can't* quietly fix what it found.
3. **The human answers lists, not paragraphs.** Every check-in is a five-line status and one multiple-choice checklist. Decisions get ticked, not discussed — which is what makes the whole thing workable from a phone.
4. **Work escalates by size, never by retry.** An agent that runs out of steps commits what it has and says what is left. That tail goes to a stronger agent with a written brief, in its own worktree, under the same review gate.

## What is in here

```
AGENTS.md                  the constitution: stack, commands, conventions, never-touch list
CLAUDE.md                  pointer for Claude Code sessions (@AGENTS.md)
opencode.json              session default model
.opencode/agents/
  orchestrator.md          primary agent; the only one you talk to; never writes app code
  builder.md               subagent; one task, one branch, one PR, 50 steps
  reviewer.md              subagent; read-only, 16 steps, posts a verdict early
agent/
  PRD.md                   product scope with feature IDs and [confirm] items
  QUEUE.md                 the task list, with states and per-task history
  STATUS.md                the live snapshot, written before every handback
  LOG.md                   one line per finished or blocked task
  CLAUDE-NOTES.md          append-only mailbox from Claude Code back to the orchestrator
  HANDOFF-claude.md        the brief format for work that outgrows one run
  dispatch-claude.sh       headless Claude Code dispatch into a worktree
```

## Adopt it in 15 minutes

1. Copy `AGENTS.md`, `CLAUDE.md`, `opencode.json`, `.opencode/` and `agent/` into your repo.
2. **Fill in `AGENTS.md`.** Stack, commands, base branch, never-touch list. This file is read first every session, so every minute spent on it is repaid.
3. **Point the model pins at your provider.** `.opencode/agents/*.md` each have a `model:` line, and `opencode.json` sets the session default. Keep them consistent — a pinned agent silently running on a different provider is a defect, not a saving.
4. **Write the first PRD section.** Not all of it. One feature, with the behaviour a reviewer could check, is enough to start.
5. **Queue one small task** in `agent/QUEUE.md` using the example entry: 2–5 acceptance criteria, a branch name, a note on which files matter.
6. Start an opencode session in the repo and say what you want next. The orchestrator reads `AGENTS.md`, `STATUS.md` and `QUEUE.md`, replies in five lines, and asks you one checklist.

From then on the loop is:

> you describe → orchestrator queues it → builder opens a PR → reviewer posts a verdict → CI green → you tick "Merge" → the orchestrator records it in `LOG.md` and `STATUS.md`.

### Placeholders

Everything in angle brackets is meant to be replaced. They are the whole configuration surface:

| Token | Lives in | Replace with |
| --- | --- | --- |
| `<PROJECT>`, `<OWNER>`, `<STACK>` | `AGENTS.md`, `CLAUDE.md`, `PRD.md`, agent definitions | your name, the product, the stack |
| `<BASE_BRANCH>` | `AGENTS.md`, orchestrator, builder | `main` (or `staging`) |
| `<INSTALL>` `<DEV>` `<LINT>` `<TYPECHECK>` `<BUILD>` `<TEST>` | `AGENTS.md`, plus the `bash` allow rules in `builder.md` and `reviewer.md` | your real commands |
| `<provider>/<model>` | `opencode.json`, all three agent definitions | e.g. `opencode-go/deepseek-v4.1-flash` |
| `<date>`, `<sha>`, `<url>` | `QUEUE.md`, `LOG.md`, `STATUS.md`, `CLAUDE-NOTES.md` | filled in as you go — they are examples |

A bare `<` in a shell permission rule is harmless: unmatched rules simply never fire, so an unfilled `<LINT>*` allow is a no-op rather than an error.

## The three agents

| | Orchestrator | Builder | Reviewer |
| --- | --- | --- | --- |
| Talks to you | yes | no | no |
| May edit | `agent/`, `AGENTS.md`, `.env.example` | source, but not `.env*`, CI, `agent/` | nothing |
| May merge | only on your explicit yes | never | never |
| Budget | no step cap; context is the limit | 50 steps, ~300 lines | 16 steps |
| Output | queued tasks, status, merges | one PR | a verdict on the PR |

**Why the orchestrator cannot code:** it owns the queue, so it must not be able to satisfy a request by writing the code itself. Its edit permission is a deny-all with three exceptions, and its instructions tell it to delegate the moment it catches itself reaching for a source file.

**Why the builder has a ceiling:** a builder that can touch anything becomes an architect with commit rights. Denying `agent/`, `.env*`, CI and the schema keeps scope where it belongs.

**Why the reviewer is read-only:** it posts a provisional verdict with `gh pr review --comment` *before* reading deeply, then amends if the deep read changes its mind. Runs get cut off; a verdict that lives only in a chat message that never arrived is worth nothing.

## The rules worth keeping

**Ask with a checklist.** Every check-in: status in five lines or fewer, then exactly one `question` call with `multiple: true`, 2–5 options, the recommended one first. If nothing needs a decision, send no checklist at all. The side effect is a decision log — "ticked *Dispatch T-087*, left the rest" is a complete record of a session.

**Nothing merges alone.** The merge command is `ask` for exactly one agent, and only after a yes in that session. Reviewer approves, CI is green, you tick "Merge #67".

**`Needs handoff:` is mandatory.** Every builder run ends with that line, including `none`. A task with real work left is marked blocked and written into `HANDOFF-claude.md` with the branch, what is done, what is left and the next command — then dispatched headless to Claude Code. Never re-run the same work and hope.

**State is written before you let go.** `STATUS.md` says what landed, what is blocked, what is owed and what nobody has verified. Any device can pick it up an hour later.

## Failure modes

This harness fails in ways that look like progress. From real use:

- **Reviewers go quiet after the provisional verdict.** The PR shows an approval nobody finished checking. Read the verdict, not the label.
- **Cap-outs leave work uncommitted.** Hence "commit at the cap, open a draft PR, report" in `builder.md`.
- **Agents cannot see a device.** UI lands verified by a diff only. Say so in `STATUS.md`; a green build is not evidence.
- **A confident answer is not a probe.** Test the deployed thing, and keep the one command that reports true status in `STATUS.md`.

## Customising

- **Small repo / solo:** drop `HANDOFF-claude.md` and `dispatch-claude.sh` until a task actually outgrows one run. Keep the reviewer anyway — a read-only second pass is the cheapest bug you will ever catch.
- **No CI yet:** the reviewer's verdict becomes the gate. Add CI before the repo has two contributors.
- **Other stacks:** only the commands and the never-touch list in `AGENTS.md` are stack-specific. The role split is not.
- **Other providers:** change the `model:` lines. Keep all three agents on the same model if you can — the differences here are permissions, not intelligence.

## Licence

MIT. See `LICENSE`.
