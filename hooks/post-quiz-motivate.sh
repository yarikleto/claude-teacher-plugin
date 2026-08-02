#!/bin/bash
# PostToolUseFailure (Bash): offer encouragement when the student's code fails.
#
# A Bash command that exits non-zero raises PostToolUseFailure, not PostToolUse,
# and the payload carries the failure in a top-level `error` string — there is no
# tool_response object on this event.

INPUT=$(cat)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/teach-guard.sh
. "$SCRIPT_DIR/lib/teach-guard.sh"

teach_is_learning_project "$INPUT" || exit 0

COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
ERROR=$(printf '%s' "$INPUT" | jq -r '.error // ""')
INTERRUPT=$(printf '%s' "$INPUT" | jq -r '.is_interrupt // false')

# A cancelled command is not a failed attempt.
[ "$INTERRUPT" = "true" ] && exit 0
[ -z "$ERROR" ] && exit 0

# Housekeeping commands the tutor runs itself, not the student's work.
case "$COMMAND" in
  git*|mkdir*|curl*|jq*|cat*|ls*|cd*|echo*|rm*|npm*install*|pip*install*) exit 0 ;;
esac

# The error opens with a summary line; the rest is usually a stack trace.
SUMMARY=$(printf '%s' "$ERROR" | head -1)

teach_emit_context "PostToolUseFailure" "The student's code just failed ($SUMMARY). Walk them toward the cause with questions rather than handing over a fix. If this is a repeated failure, offer encouragement or run /motivate — frustration is the biggest barrier to learning."

exit 0
