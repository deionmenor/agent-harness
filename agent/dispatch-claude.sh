#!/usr/bin/env bash
# Dispatch one Claude Code task headless into an existing worktree.
# Usage: agent/dispatch-claude.sh <worktree-dir> <task-file> [log-file]
# Run from WSL: bash agent/dispatch-claude.sh /home/you/T-018a-fix /path/to/repo/agent/tasks/T-018a.md
#
# Why an absolute binary path: a non-interactive shell (wsl.exe bash script, cron, CI)
# does not source the profile, so ~/.local/bin is not on PATH and `claude` resolves to
# nothing. That silently kills a dispatch and leaves an empty log. Set CLAUDE_BIN if yours
# lives elsewhere.
#
# Why the prompt goes in on stdin: with --allowedTools present, at least one claude build
# drops a positional prompt and exits 1 with "Input must be provided either through stdin
# or as a prompt argument when using --print". Same command with the prompt on stdin works.
# If your dispatch produces an empty log and no process, suspect this before the task.
#
# Why it runs in the foreground and the caller backgrounds it: a nohup/setsid child dies
# with the shell that spawned it the moment the wrapper returns — the other half of the
# same silent failure. Run the whole thing as a background job from a process that stays
# alive, then read the log.
#
# A 60-second smoke test first: `claude -p "Reply with exactly: OK"`. If that fails, the
# problem is your launch, not your task.
set -euo pipefail

CLAUDE_BIN="${CLAUDE_BIN:-$HOME/.local/bin/claude}"
WT="${1:?worktree dir}"
TASK="${2:?task file path}"
LOG="${3:-$HOME/claude-dispatch-$(basename "$TASK" .md).log}"

[ -x "$CLAUDE_BIN" ] || { echo "no claude binary at $CLAUDE_BIN" >&2; exit 1; }
case "$(cd "$WT" && git branch --show-current)" in
  "") echo "$WT is not on a branch" >&2; exit 1 ;;
esac

cd "$WT"
echo "started $(date -Is) in $WT; task $TASK; log $LOG"
printf 'Read %s and do exactly what it says. When you finish, append one entry to agent/CLAUDE-NOTES.md in the format that file gives.\n' "$TASK" \
  | "$CLAUDE_BIN" -p --permission-mode acceptEdits \
    --allowedTools 'Bash(git *),Bash(npm *),Bash(npx *),Bash(gh *),Edit,Write,Read' \
    2>&1 | tee "$LOG"
echo "finished $(date -Is) with ${PIPESTATUS[1]}"
