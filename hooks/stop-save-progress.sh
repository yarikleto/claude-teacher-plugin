#!/bin/bash
# Stop hook: remind Claude to save progress before ending the session

INPUT=$(cat)

# If no DB yet, nothing to save
if [ ! -f "$HOME/.local/share/claude-education/dashboard.json" ]; then
  exit 0
fi

# Only fire in learning projects (must have memory/knowledge_gaps.md)
if [ ! -f "memory/knowledge_gaps.md" ]; then
  exit 0
fi

# If /summary or /save-progress already ran this session, skip
LAST_MSG=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // ""' 2>/dev/null)
if printf '%s' "$LAST_MSG" | grep -qi "SESSION SUMMARY\|Progress Saved\|session_end"; then
  exit 0
fi

# Block stop and inject save reminder into Claude's context
jq -n '{
  decision: "block",
  reason: "BEFORE ENDING: Save the student'\''s progress. Update ~/.local/share/claude-education/dashboard.json and relevant topics/*.json with anything learned this session. Append a session_end entry to sessions/<today>.jsonl. Keep it quick — just save the data, no need for a full /summary unless the student asked for one."
}'
