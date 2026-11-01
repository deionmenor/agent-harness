# Hand-off to Claude Code

Written by the orchestrator whenever a builder reports `Needs handoff:` with real work left. One block per task, newest at the bottom.

Why this file exists: a builder that runs out of steps has usually written something, and re-running it from scratch throws that away. Claude Code is given the tail of the work, in a worktree, with a written brief — not a second attempt at the whole thing.

## Rules

- **Never re-dispatch the same work to the same agent.** That is what this file replaces.
- The brief must be self-contained: a session that starts here has read none of the conversation that produced it.
- State what is **done** and what is **left**, in that order. A brief that only lists what is left reads as "start again".
- Give the next command verbatim.
- Claude Code gets the same reviewer and the same merge rule as any other agent. It does not get to skip the gate.

## Format

```
## T-017 · <task title> — <date>

- **Branch:** `feat/T-017-<slug>`, pushed at `<sha>`, cut from `<base>` at `<sha>`.
- **Why it is here:** <one line: too big for one run, or a cap hit with the tail left.>
- **Done:** <what is on the branch and compiles. Files and line counts.>
- **Left, in this order:** 1. <step> 2. <step> 3. <step>
- **Next command:** `git checkout feat/T-017-<slug> && <install> && <typecheck>`
- **Do not touch:** `.env*`, CI config, `<schema dir>`, <files another branch owns>.
- **Size:** <what fits in one pass, and what to split if it does not.>
```
