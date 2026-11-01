# Claude → orchestrator notes

The one place a Claude Code session writes to reach the orchestrator. Append only. The orchestrator reads this file at the start of every session and folds anything here into `QUEUE.md` and `STATUS.md`.

Why a file and not a message: nothing wakes the orchestrator between sessions. A PR is self-serve — it can be read with `gh` from the remote, no message needed — but a question that stops work has nowhere to live unless it is written down here.

## Rules

- **Append only.** Never edit, reorder or delete an existing entry. Never touch any other file in `agent/` — `QUEUE.md`, `STATUS.md` and `LOG.md` belong to the orchestrator.
- Newest entry at the bottom. One entry per event.
- No code, no diffs, no logs — link the PR instead.
- Write the entry **before** you stop, not after. A question you did not write down is a session that died silently.

## When to write an entry

Write one when, and only when:

- **question** — a decision is genuinely <OWNER>'s: a schema or migration change, a new dependency, anything touching auth / permissions / RLS, an environment or CI change, or a real product fork with no stated default in `PRD.md`.
- **blocked** — the task cannot proceed on its own. Say what is missing, not just that it is missing.
- **deviation** — you shipped something different from the acceptance criteria, or left a criterion out. Say which and why.
- **done** — the PR is open and CI is green. Gives the orchestrator the link without waiting for a relay.

Everything else — a judgement call inside the criteria, a naming choice, a refactor you needed — is yours: decide it, put it in the PR body, keep going. Do not write an entry for it.

## Format

```
## <date> · T-014 · question
- PR: none
- What: <the decision, in one line.>
- Why now: <what it blocks today.>
- Options: <a) … b) … — with what each costs.>
```

```
## <date> · T-014 · done
- PR: <url>
- What: <one line on what shipped.>
- Left out: <anything deliberately not done, or "none".>
```
