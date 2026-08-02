#!/bin/bash
# Stop: persist the session's progress to the education DB before the turn ends.

INPUT=$(cat)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/teach-guard.sh
. "$SCRIPT_DIR/lib/teach-guard.sh"

teach_is_learning_project "$INPUT" || exit 0

DB_DIR=$(teach_db_dir)
[ -f "$DB_DIR/dashboard.json" ] || exit 0

# stop_hook_active is true when Claude Code is already continuing because of a
# stop hook. Without this check the hook re-fires on the continuation it caused.
ACTIVE=$(printf '%s' "$INPUT" | jq -r '.stop_hook_active // false')
[ "$ACTIVE" = "true" ] && exit 0

# Skip when /summary or /save-progress already flushed the DB this turn.
LAST_MSG=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // ""')
if printf '%s' "$LAST_MSG" | grep -qi "SESSION SUMMARY\|Progress Saved\|session_end"; then
  exit 0
fi

# additionalContext continues the conversation the same way decision:"block"
# does, but the transcript labels it Stop hook feedback instead of a hook error.
teach_emit_context "Stop" "BEFORE ENDING: save the student's progress. Update $DB_DIR/dashboard.json and the relevant topics/*.json with anything learned this session, then append a session_end entry to sessions/<today>.jsonl. Keep it quick — just persist the data; a full /summary is only needed if the student asked for one."

exit 0
