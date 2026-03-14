#!/bin/bash
# Injects a short teaching-mode reminder into every user message
cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "TUTOR MODE: Check memory/knowledge_gaps.md for student progress. Prioritize weak topics. Never write complete solutions. Quiz after 2-3 new concepts. Suggest /illustrate for visual topics, /quiz-me after extended teaching, /challenge for practice, /summary at session end."
  }
}
EOF
exit 0
