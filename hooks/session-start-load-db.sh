#!/bin/bash
# SessionStart hook: load student profile, check spaced repetition schedule

DB_DIR="$HOME/.local/share/claude-education"
TODAY=$(date +%Y-%m-%d)
TODAY_SEC=$(date -j -f "%Y-%m-%d" "$TODAY" "+%s" 2>/dev/null || date -d "$TODAY" "+%s" 2>/dev/null)

# If no DB yet, remind to onboard
if [ ! -f "$DB_DIR/student.json" ]; then
  echo "No student profile found. Ask the student to run /init-edu to get started."
  exit 0
fi

NAME=$(jq -r '.name // "student"' "$DB_DIR/student.json" 2>/dev/null)

if [ ! -f "$DB_DIR/dashboard.json" ]; then
  echo "Student $NAME is onboarded but has no dashboard yet. Greet them by name and ask what they want to study."
  exit 0
fi

LAST=$(jq -r '.last_session // "never"' "$DB_DIR/dashboard.json" 2>/dev/null)
TOPIC=$(jq -r '.current_topic // "none"' "$DB_DIR/dashboard.json" 2>/dev/null)
WEAK=$(jq -r '.stats.weak // 0' "$DB_DIR/dashboard.json" 2>/dev/null)
LEARNED=$(jq -r '.stats.learned // 0' "$DB_DIR/dashboard.json" 2>/dev/null)
SOLID=$(jq -r '.stats.solid // 0' "$DB_DIR/dashboard.json" 2>/dev/null)

# Scan individual topic files for due reviews — more accurate than dashboard
OVERDUE=""
DUE_TODAY=""
WEAK_TOPICS=""

if [ -d "$DB_DIR/topics" ]; then
  for topic_file in "$DB_DIR/topics"/*.json; do
    [ -f "$topic_file" ] || continue

    SLUG=$(jq -r '.slug // ""' "$topic_file" 2>/dev/null)
    STATUS=$(jq -r '.status // ""' "$topic_file" 2>/dev/null)
    DEPTH=$(jq -r '.depth // "surface"' "$topic_file" 2>/dev/null)
    NEXT_REVIEW=$(jq -r '.next_review // ""' "$topic_file" 2>/dev/null)
    TOPIC_NAME=$(jq -r '.name // .slug // ""' "$topic_file" 2>/dev/null)
    INTERVAL=$(jq -r '.review_interval_days // 1' "$topic_file" 2>/dev/null)

    # Collect weak topics regardless of review date
    if [ "$STATUS" = "weak" ]; then
      WEAK_TOPICS="$WEAK_TOPICS\n  - $TOPIC_NAME (weak, depth: $DEPTH)"
    fi

    # Check review schedule
    if [ -n "$NEXT_REVIEW" ] && [ "$NEXT_REVIEW" != "null" ]; then
      REVIEW_SEC=$(date -j -f "%Y-%m-%d" "$NEXT_REVIEW" "+%s" 2>/dev/null || date -d "$NEXT_REVIEW" "+%s" 2>/dev/null)
      DAYS_OVERDUE=$(( (TODAY_SEC - REVIEW_SEC) / 86400 ))

      if [ "$DAYS_OVERDUE" -gt 0 ]; then
        OVERDUE="$OVERDUE\n  - $TOPIC_NAME (${DAYS_OVERDUE}d overdue, status: $STATUS, depth: $DEPTH, interval: ${INTERVAL}d)"
      elif [ "$DAYS_OVERDUE" -eq 0 ]; then
        DUE_TODAY="$DUE_TODAY\n  - $TOPIC_NAME (due today, status: $STATUS, depth: $DEPTH)"
      fi
    fi
  done
fi

# Build the context message for Claude
MSG="=== SESSION START ===
Student: $NAME | Today: $TODAY | Last session: $LAST
Stats: $SOLID solid, $LEARNED learned, $WEAK weak | Current topic: $TOPIC"

if [ -n "$OVERDUE" ]; then
  MSG="$MSG

OVERDUE FOR REVIEW (quiz these first — most urgent):$(printf '%b' "$OVERDUE")"
fi

if [ -n "$DUE_TODAY" ]; then
  MSG="$MSG

DUE FOR REVIEW TODAY:$(printf '%b' "$DUE_TODAY")"
fi

if [ -n "$WEAK_TOPICS" ]; then
  MSG="$MSG

WEAK TOPICS (re-explain before new material):$(printf '%b' "$WEAK_TOPICS")"
fi

MSG="$MSG

INSTRUCTIONS:
1. Greet $NAME by name
2. If there are overdue/due topics — quiz them BEFORE any new material
3. If there are weak topics — re-explain them with fresh analogies, target recorded misconceptions
4. Give a brief recap of last session and suggest what to do today
5. Only start new material after reviews are done"

echo "$MSG"
