#!/bin/bash
# PostToolUse (Edit|Write): prompt Claude to review the student's code by asking
# questions rather than correcting it.

INPUT=$(cat)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/teach-guard.sh
. "$SCRIPT_DIR/lib/teach-guard.sh"

teach_is_learning_project "$INPUT" || exit 0

FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
[ -z "$FILE" ] && exit 0

# Prose, config, diagrams and education-DB writes are not the student's code.
case "$FILE" in
  *.md|*.json|*.jsonl|*.txt|*.yml|*.yaml|*.toml|*.excalidraw) exit 0 ;;
  */.claude/*|*/.local/share/claude-education/*) exit 0 ;;
  */node_modules/*|*/.git/*|*/docs/*) exit 0 ;;
esac

teach_emit_context "PostToolUse" "The student just wrote code to $FILE. Ask a pedagogical question before moving on: 'What happens if...?', 'Why did you choose...?', 'What edge cases might break this?'. Don't just fix — teach."

exit 0
