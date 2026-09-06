#!/bin/bash
# SessionStart: summarize the profile and a bounded queue of studied topics.
INPUT=$(cat)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/teach-guard.sh
. "$SCRIPT_DIR/lib/teach-guard.sh"
teach_is_learning_project "$INPUT" || exit 0
DB_DIR=$(teach_db_dir) || exit 0
TODAY=$(date +%Y-%m-%d)

if [ ! -f "$DB_DIR/student.json" ]; then
  teach_emit_context "SessionStart" "This is a learning project without a student profile. Suggest /claude-teacher:init-edu to finish onboarding."
  exit 0
fi
PROFILE=$(teach_read_object "$DB_DIR/student.json") || {
  teach_emit_context "SessionStart" "The student profile could not be read as a JSON object. Preserve the file and help recover it; do not overwrite or reset it automatically."
  exit 0
}
DASHBOARD='{}'
if [ -f "$DB_DIR/dashboard.json" ]; then
  DASHBOARD=$(teach_read_object "$DB_DIR/dashboard.json") || {
    teach_emit_context "SessionStart" "The education dashboard could not be read as a JSON object. Preserve it and recover from topic and quiz records before saving."
    exit 0
  }
fi

# One jq process per file, rather than five reads plus platform-specific date
# subprocesses for each topic. Skip corrupt records without losing valid ones.
MSG=$(
  for topic_file in "$DB_DIR/topics"/*.json; do
    [ -f "$topic_file" ] || continue
    teach_read_object "$topic_file" || continue
  done | TZ=UTC jq -sr --arg today "$TODAY" --argjson profile "$PROFILE" \
    --argjson dashboard "$DASHBOARD" -f "$SCRIPT_DIR/lib/review-context.jq"
) || exit 0
teach_emit_context "SessionStart" "$MSG"
