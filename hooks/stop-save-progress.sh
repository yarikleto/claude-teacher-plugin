#!/bin/bash
# Stop hook: remind Claude to save progress before ending the session
# If stop_hook_active is true, we already ran — allow stop to avoid loops

INPUT=$(cat)
ACTIVE=$(printf '%s' "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null)

if [ "$ACTIVE" = "true" ]; then
  exit 0
fi

# Check if progress DB exists (student has been onboarded)
if [ ! -f "$HOME/.local/share/claude-education/dashboard.json" ]; then
  exit 0
fi

# Check last assistant message for signs that /summary or /save-progress already ran
LAST_MSG=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // ""' 2>/dev/null)
if printf '%s' "$LAST_MSG" | grep -qi "SESSION SUMMARY\|Progress Saved\|session_end"; then
  exit 0
fi

# Block stop and ask Claude to save progress first
jq -n '{
  decision: "block",
  reason: "BEFORE ENDING: Save the student'\''s progress. Update ~/.local/share/claude-education/dashboard.json and relevant topics/*.json with anything learned this session. Append a session_end entry to sessions/<today>.jsonl. Keep it quick — just save the data, no need for a full /summary unless the student asked for one."
}'
