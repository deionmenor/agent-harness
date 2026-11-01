# Task queue

Maintained by the orchestrator. Top = next. States: `todo`, `doing`, `review`, `done`, `blocked`.

Rules that keep this file honest:

1. **One task, one builder run.** Under ~300 changed lines, 2–5 acceptance criteria. If it does not fit, split it here rather than hoping.
2. **Cut the branch from the base branch once the previous PR has actually merged.** Do not stack on an unmerged branch: a squash merge rewrites history, so the stacked PR stops sharing a base and has to be rebuilt.
3. **One schema-change PR at a time.**

## Feature status

Reconciled against the base branch on <date>.

- **F1 <name> — Done.** <which PRs closed it>
- **F2 <name> — Partial.** <what is missing, and which task covers it>

---

## T-002 · <one-line title, imperative>

- State: `todo`
- PRD: §3 F2
- Design: <frame name or link, or "—">
- Acceptance criteria:
  - [ ] <Something a reviewer can point at in the diff.>
  - [ ] <Something a reviewer can only confirm by running it — say which.>
  - [ ] <The negative case: what must not happen.>
- Flags: <new dependency / migration / auth change, or "none">
- Depends: <task IDs or "none">
- Branch: `feat/T-002-<slug>`
- PR: —
- Notes: <files, patterns to copy, known gaps. This is where the next agent's time is saved or wasted.>

---

## T-001 · <example: a finished task, kept as a record>

- State: **done — merged as #12 on <date>** (squash `<sha>`). APPROVE 4/4, no must-fixes. <files and line counts>, CI green.
- PRD: §3 F1
- Acceptance criteria:
  - [x] <criterion, and how the review established it>
- Flags: none
- Branch: `feat/T-001-<slug>`
- PR: #12 — <url>
- Notes: <what changed under it, what was deliberately left out, what nobody has verified yet. “Unseen on a device” is a real note and belongs here.>
