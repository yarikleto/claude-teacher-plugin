#!/bin/bash
# Stop fires after each response, not when the session exits.

INPUT=$(cat)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/teach-guard.sh
. "$SCRIPT_DIR/lib/teach-guard.sh"

teach_is_learning_project "$INPUT" || exit 0

DB_DIR=$(teach_db_dir) || exit 0
teach_read_object "$DB_DIR/dashboard.json" >/dev/null || exit 0

# stop_hook_active is true when Claude Code is already continuing because of a
# stop hook. Without this check the hook re-fires on the continuation it caused.
ACTIVE=$(printf '%s' "$INPUT" | jq -r '.stop_hook_active // false')
[ "$ACTIVE" = "true" ] && exit 0

# A phrase in the final message is not proof that any files were saved.
printf '%s' "$INPUT" | jq -e '.last_assistant_message | type == "string" and length > 0' >/dev/null 2>&1 || exit 0

# additionalContext continues the conversation the same way decision:"block"
# does, but the transcript labels it Stop hook feedback instead of a hook error.
teach_emit_context "Stop" "Checkpoint only unsaved learning evidence using /claude-teacher:save-progress. If everything is already persisted or nothing was learned, do nothing. Re-read existing records before merging; preserve quiz IDs, history, and review dates unless a new assessment occurred. This is the end of a response, not the session: do not append session_end unless the student actually ended the lesson. Do not start a new quiz or topic. If saving is denied or fails, report that briefly without retrying indefinitely."

exit 0
