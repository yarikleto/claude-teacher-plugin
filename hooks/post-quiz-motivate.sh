#!/bin/bash
# PostToolUse hook for Bash: detect quiz/challenge failures and suggest motivation
# Looks at the conversation context for signs of repeated failures

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_response.exitCode // 0')

# Only care about non-zero exit codes (student's code failed)
if [ "$EXIT_CODE" = "0" ] || [ "$EXIT_CODE" = "null" ]; then
  exit 0
fi

# Skip internal commands (git, mkdir, curl, etc.)
case "$COMMAND" in
  git*|mkdir*|curl*|jq*|cat*|ls*|cd*|echo*|npm*install*|pip*install*) exit 0 ;;
esac

echo "The student's code just failed (exit code $EXIT_CODE). If this is a repeated failure, consider offering encouragement or running /motivate. Remember: frustration is the biggest barrier to learning."
