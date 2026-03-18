#!/bin/bash
# PostToolUse hook for Edit/Write: remind Claude to review code pedagogically
# Only triggers for files the student is likely working on (not docs, not JSON DB files)

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Skip non-code files and DB/config files
case "$FILE" in
  *.md|*.json|*.jsonl|*.txt|*.yml|*.yaml|*.toml) exit 0 ;;
  */.claude/*|*/.local/share/claude-education/*) exit 0 ;;
  */node_modules/*|*/.git/*) exit 0 ;;
esac

# Skip if file is empty (probably a new scaffold)
[ -z "$FILE" ] && exit 0

echo "Code was just written to $FILE. If this was the student's code, consider asking a pedagogical question: 'What happens if...?', 'Why did you choose...?', 'What edge cases might break this?'. Don't just fix — teach."
