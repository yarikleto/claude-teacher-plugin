#!/bin/bash
# SessionStart hook: load student profile and progress, remind Claude to greet by name

DB_DIR="$HOME/.local/share/claude-education"

# If no DB yet, remind to onboard
if [ ! -f "$DB_DIR/student.json" ]; then
  echo "No student profile found at $DB_DIR/student.json. If the student hasn't been onboarded yet, ask them to run /init-edu."
  exit 0
fi

# Read student name
NAME=$(jq -r '.name // "student"' "$DB_DIR/student.json" 2>/dev/null)

# Read dashboard stats
if [ -f "$DB_DIR/dashboard.json" ]; then
  WEAK=$(jq -r '.stats.weak // 0' "$DB_DIR/dashboard.json" 2>/dev/null)
  LEARNED=$(jq -r '.stats.learned // 0' "$DB_DIR/dashboard.json" 2>/dev/null)
  SOLID=$(jq -r '.stats.solid // 0' "$DB_DIR/dashboard.json" 2>/dev/null)
  LAST=$(jq -r '.last_session // "never"' "$DB_DIR/dashboard.json" 2>/dev/null)
  TOPIC=$(jq -r '.current_topic // "none"' "$DB_DIR/dashboard.json" 2>/dev/null)

  # Check for topics due for review
  TODAY=$(date +%Y-%m-%d)
  DUE=$(jq -r --arg today "$TODAY" '
    [.topics | to_entries[] | select(.value.next_review != null and .value.next_review <= $today) | .key] | join(", ")
  ' "$DB_DIR/dashboard.json" 2>/dev/null)

  MSG="Student profile loaded: $NAME. Last session: $LAST. Current topic: $TOPIC. Stats: $SOLID solid, $LEARNED learned, $WEAK weak."

  if [ -n "$DUE" ] && [ "$DUE" != "" ]; then
    MSG="$MSG Topics DUE FOR REVIEW today: $DUE — quiz these first!"
  fi

  echo "$MSG Greet $NAME by name and give a brief recap."
else
  echo "Student $NAME is onboarded but has no dashboard yet. Greet them by name."
fi
