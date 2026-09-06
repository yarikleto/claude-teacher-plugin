#!/bin/bash
# Shared helpers for claude-teacher hooks.
#
# The plugin registers hooks for SessionStart, UserPromptSubmit, Stop,
# PostToolUse and PostToolUseFailure. Those events fire in every project where
# the plugin is enabled, and the default install scope is `user`, so each hook
# checks teach_is_learning_project before emitting anything.

# Hooks parse their stdin payload with jq. Without it, exit quietly rather than
# emitting malformed JSON.
command -v jq >/dev/null 2>&1 || exit 0

# Project root for this invocation. CLAUDE_PROJECT_DIR is exported into every
# hook process; the payload's cwd and $PWD are fallbacks.
teach_project_dir() {
  local input="$1" dir="${CLAUDE_PROJECT_DIR:-}"

  if [ -z "$dir" ] && [ -n "$input" ]; then
    dir=$(printf '%s' "$input" | jq -r '.cwd | select(type == "string")' 2>/dev/null)
  fi

  printf '%s' "${dir:-$PWD}"
}

# True when /init-edu has set this project up for learning. The marker file is
# authoritative; memory/knowledge_gaps.md keeps projects initialized by earlier
# versions working.
teach_is_learning_project() {
  local dir marker
  # Ignore malformed input and subagent activity. Teaching prompts belong in
  # the main conversation, not in a background research or utility task.
  printf '%s' "$1" | jq -se 'length == 1 and (.[0] | type == "object" and (.agent_id == null))' >/dev/null 2>&1 || return 1
  dir=$(teach_project_dir "$1")
  marker="$dir/.claude/claude-teacher.json"
  if [ -e "$marker" ]; then
    # An explicit opt-out wins over the legacy marker. Invalid markers do not
    # activate teaching and are never repaired by a read-only hook.
    jq -se 'length == 1 and (.[0] | type == "object" and ((has("enabled") | not) or .enabled == true))' "$marker" >/dev/null 2>&1
  else
    [ -f "$dir/memory/knowledge_gaps.md" ]
  fi
}

# Path to the global education DB.
teach_db_dir() {
  local dir="${CLAUDE_TEACHER_DB:-$HOME/.local/share/claude-education}"
  # Relative overrides would refer to different databases after a cd.
  [ -n "${dir//\//}" ] || return 1
  case "$dir" in /*) printf '%s' "${dir%/}" ;; *) return 1 ;; esac
}

# Read exactly one JSON object. Broken files are left intact for recovery.
teach_read_object() {
  jq -ecs 'if length == 1 and (.[0] | type == "object") then .[0] else empty end' "$1" 2>/dev/null
}

# Emit context for Claude. Plain stdout is only surfaced for UserPromptSubmit
# and SessionStart, so every hook uses this structured form instead.
teach_emit_context() {
  jq -n --arg event "$1" --arg ctx "$2" \
    '{hookSpecificOutput: {hookEventName: $event, additionalContext: $ctx}}'
}
