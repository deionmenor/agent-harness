# Log

One line per finished or blocked task, appended oldest first. Maintained by the orchestrator.

The point of this file is that it is written **when the merge happens, not when someone remembers**. A queue that still says `review` for a merged PR costs a future session an hour of re-checking.

| Date | Task | PR | Outcome |
| --- | --- | --- | --- |
| <date> | T-001 | #12 | **Merged as `<sha>` on <OWNER>'s go-ahead.** <n> files, +<n>/−<n>, APPROVE <n>/<n>, CI green. What changed, in one sentence a stranger could follow. What the review caught that CI could not. What was deliberately left out and why. **Unverified:** <what nobody has seen run.> |
| <date> | T-002 | — | **Blocked, handed to Claude Code.** The builder hit its step cap with <state of the work>. <Why one run was never enough — a task-size fault, not a budget one.> Handoff block written in `agent/HANDOFF-claude.md`. |
