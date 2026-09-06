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

COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command | select(type == "string")' 2>/dev/null)
ERROR=$(printf '%s' "$INPUT" | jq -r '.error | select(type == "string")' 2>/dev/null)
INTERRUPT=$(printf '%s' "$INPUT" | jq -r '.is_interrupt // false')

# A cancelled command is not a failed attempt.
[ "$INTERRUPT" = "true" ] && exit 0
[ -z "$ERROR" ] && exit 0

# Housekeeping commands the tutor runs itself, not the student's work.
# Only skip simple housekeeping. A compound command may run student tests.
case "$COMMAND" in
  *'&&'*|*';'*|*'|'*|*$'\n'*) ;;
  git|git\ *|mkdir\ *|curl\ *|jq\ *|cat\ *|ls|ls\ *|cd\ *|echo\ *|rm\ *|npm\ install*|pip\ install*) exit 0 ;;
esac

# The existing tool result already contains the error. Do not repeat arbitrary
# command output as plugin instructions, or assume Claude's failure is theirs.
teach_emit_context "PostToolUseFailure" "A Bash tool call failed. If it ran the student's exercise or tests, help them reason through the error with one hint at a time. For repeated difficulty, offer specific encouragement via /claude-teacher:motivate. Diagnose setup, network, permission, or tool failures normally; do not count those as student misconceptions."

exit 0
