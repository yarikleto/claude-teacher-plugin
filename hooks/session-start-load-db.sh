#!/bin/bash
# SessionStart: load the student profile and report what spaced repetition says
# is due, so reviews happen before any new material.

INPUT=$(cat)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/teach-guard.sh
. "$SCRIPT_DIR/lib/teach-guard.sh"

teach_is_learning_project "$INPUT" || exit 0

DB_DIR=$(teach_db_dir)
TODAY=$(date +%Y-%m-%d)
TODAY_SEC=$(date -j -f "%Y-%m-%d" "$TODAY" "+%s" 2>/dev/null || date -d "$TODAY" "+%s" 2>/dev/null)

if [ ! -f "$DB_DIR/student.json" ]; then
  teach_emit_context "SessionStart" "This project is set up for learning but there is no student profile yet. Ask the student to run /init-edu to get started."
  exit 0
fi

NAME=$(jq -r '.name // "student"' "$DB_DIR/student.json" 2>/dev/null)

if [ ! -f "$DB_DIR/dashboard.json" ]; then
  teach_emit_context "SessionStart" "Student $NAME is onboarded but has no dashboard yet. Greet them by name and ask what they want to study."
  exit 0
fi

LAST=$(jq -r '.last_session // "never"' "$DB_DIR/dashboard.json" 2>/dev/null)
TOPIC=$(jq -r '.current_topic // "none"' "$DB_DIR/dashboard.json" 2>/dev/null)
WEAK=$(jq -r '.stats.weak // 0' "$DB_DIR/dashboard.json" 2>/dev/null)
LEARNED=$(jq -r '.stats.learned // 0' "$DB_DIR/dashboard.json" 2>/dev/null)
SOLID=$(jq -r '.stats.solid // 0' "$DB_DIR/dashboard.json" 2>/dev/null)

# Per-topic files carry the real review schedule; the dashboard only summarizes.
OVERDUE=""
DUE_TODAY=""
WEAK_TOPICS=""

if [ -d "$DB_DIR/topics" ]; then
  for topic_file in "$DB_DIR/topics"/*.json; do
    [ -f "$topic_file" ] || continue

    STATUS=$(jq -r '.status // ""' "$topic_file" 2>/dev/null)
    DEPTH=$(jq -r '.depth // "surface"' "$topic_file" 2>/dev/null)
    NEXT_REVIEW=$(jq -r '.next_review // ""' "$topic_file" 2>/dev/null)
    TOPIC_NAME=$(jq -r '.name // .slug // ""' "$topic_file" 2>/dev/null)
    INTERVAL=$(jq -r '.review_interval_days // 1' "$topic_file" 2>/dev/null)

    # Weak topics need attention whatever their review date says.
    if [ "$STATUS" = "weak" ]; then
      WEAK_TOPICS="$WEAK_TOPICS
  - $TOPIC_NAME (weak, depth: $DEPTH)"
    fi

    if [ -n "$NEXT_REVIEW" ] && [ "$NEXT_REVIEW" != "null" ] && [ -n "$TODAY_SEC" ]; then
      REVIEW_SEC=$(date -j -f "%Y-%m-%d" "$NEXT_REVIEW" "+%s" 2>/dev/null || date -d "$NEXT_REVIEW" "+%s" 2>/dev/null)
      [ -n "$REVIEW_SEC" ] || continue

      DAYS_OVERDUE=$(( (TODAY_SEC - REVIEW_SEC) / 86400 ))

      if [ "$DAYS_OVERDUE" -gt 0 ]; then
        OVERDUE="$OVERDUE
  - $TOPIC_NAME (${DAYS_OVERDUE}d overdue, status: $STATUS, depth: $DEPTH, interval: ${INTERVAL}d)"
      elif [ "$DAYS_OVERDUE" -eq 0 ]; then
        DUE_TODAY="$DUE_TODAY
  - $TOPIC_NAME (due today, status: $STATUS, depth: $DEPTH)"
      fi
    fi
  done
fi

MSG="=== SESSION START ===
Student: $NAME | Today: $TODAY | Last session: $LAST
Stats: $SOLID solid, $LEARNED learned, $WEAK weak | Current topic: $TOPIC"

[ -n "$OVERDUE" ] && MSG="$MSG

OVERDUE FOR REVIEW (quiz these first — most urgent):$OVERDUE"

[ -n "$DUE_TODAY" ] && MSG="$MSG

DUE FOR REVIEW TODAY:$DUE_TODAY"

[ -n "$WEAK_TOPICS" ] && MSG="$MSG

WEAK TOPICS (re-explain before new material):$WEAK_TOPICS"

MSG="$MSG

INSTRUCTIONS:
1. Greet $NAME by name
2. If there are overdue/due topics — quiz them BEFORE any new material
3. If there are weak topics — re-explain them with fresh analogies, target recorded misconceptions
4. Give a brief recap of last session and suggest what to do today
5. Only start new material after reviews are done"

teach_emit_context "SessionStart" "$MSG"

exit 0
