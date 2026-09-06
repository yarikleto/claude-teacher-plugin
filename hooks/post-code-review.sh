#!/bin/bash
# PostToolUse (Edit|Write): prompt Claude to review the student's code by asking
# questions rather than correcting it.

INPUT=$(cat)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/teach-guard.sh
. "$SCRIPT_DIR/lib/teach-guard.sh"

teach_is_learning_project "$INPUT" || exit 0

FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path | select(type == "string")' 2>/dev/null)
[ -z "$FILE" ] && exit 0

# Prose, config, diagrams and education-DB writes are not the student's code.
case "/${FILE#/}" in
  */.claude/*|*/.local/share/claude-education/*) exit 0 ;;
  */node_modules/*|*/.git/*|*/docs/*) exit 0 ;;
esac
DB_DIR=$(teach_db_dir) || exit 0
case "$FILE" in "$DB_DIR"/*) exit 0 ;; esac
case "$FILE" in
  *.py|*.js|*.jsx|*.ts|*.tsx|*.c|*.h|*.cc|*.cpp|*.hpp|*.cs|*.java|*.go|*.rs|*.rb|*.php|*.swift|*.kt|*.scala|*.sh|*.sql|*.lua|*.r|*.R) ;;
  *) exit 0 ;;
esac

teach_emit_context "PostToolUse" "Claude just edited a source file. This event does not observe the student's editor. If this change belongs to a learning exercise, explain the change and ask one relevant reasoning or edge-case question. Let the student implement the next exercise step; skip this reminder for setup or teaching artifacts."

exit 0
