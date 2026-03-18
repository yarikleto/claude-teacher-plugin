---
name: summary
description: Use when the student is ending a learning session — generates a recap of what was covered, updates knowledge tracking in the global DB, and suggests what to start with next time
---

# Session Summary

Generates an end-of-session recap and persists all progress to the global education DB.

## Invocation

`/summary` — run at the end of a learning session

## Process

1. Review the current conversation — what topics were discussed, quizzed, challenged?
2. Read `~/.local/share/claude-education/dashboard.json` for current state
3. Read relevant `~/.local/share/claude-education/topics/*.json` for topics covered this session
4. Read `~/.local/share/claude-education/student.json` for goals
5. Generate the summary
6. Update ALL DB files with session results
7. Update project-local `memory/knowledge_gaps.md` if it exists

## Summary Format

```
══════════════════════════════════════════════════
  SESSION SUMMARY — [date]
══════════════════════════════════════════════════

  Duration: ~[estimate based on conversation length]
  Project: [current directory]

  LEARNED TODAY
  ─────────────
  ✓ [topic 1] — [one-line what was covered]
  ✓ [topic 2] — [one-line what was covered]
  ~ [topic 3] — [started but not finished]

  QUIZ RESULTS
  ─────────────
  · [topic]: 8/10 (80%) — promoted to solid!
  · [topic]: 5/10 (50%) — stays at learned, review scheduled

  DEPTH CHANGES
  ─────────────
  ↑ [topic]: surface → working (used correctly in challenge)
  ↑ [topic]: working → deep (explained reasoning correctly)

  MISCONCEPTIONS
  ─────────────
  ⚠ [topic]: "[what they said wrong]" — [addressed/still open]
  ✓ [topic]: "[old misconception]" — resolved this session!

  KNOWLEDGE CHANGES
  ─────────────
  ↑ [topic] moved from Weak → Learned
  ↑ [topic] moved from Learned → Solid
  ↓ [topic] — struggled, stays in Weak

  GOAL PROGRESS
  ─────────────
  · Pass OS exam (2026-06-15): 5/10 topics solid (+2 today)

  SPACED REPETITION SCHEDULE
  ─────────────
  Tomorrow: [topic] (review due)
  In 2 days: [topic]
  In 4 days: [topic]

  NEXT SESSION
  ─────────────
  Start with:
    1. Review: [topics due for spaced repetition]
    2. Resolve: [unresolved misconception to address]
    3. Continue: [where we left off]
    4. Next new topic: [what comes next]

══════════════════════════════════════════════════
```

## DB Updates

### 1. Update/create topic files (`~/.local/share/claude-education/topics/<slug>.json`)

For each topic covered this session:
- Create the file if it doesn't exist
- Update `status` based on session performance
- Update `depth` if student demonstrated deeper understanding
- Update `last_reviewed` to today
- Calculate `next_review` using spaced repetition intervals
- Add any new misconceptions discovered
- Mark any resolved misconceptions as `resolved: true`
- Add session notes

### 2. Update dashboard (`~/.local/share/claude-education/dashboard.json`)

- Update `last_session` to today
- Update `current_topic`
- Recalculate `stats` (weak/learned/solid counts)
- Update all topic entries with current status/depth/next_review

### 3. Finalize session log (`~/.local/share/claude-education/sessions/[date].jsonl`)

Append closing entry:
```jsonl
{"time": "[now]", "event": "session_end", "project": "[cwd]", "topics_covered": ["..."], "quizzes_taken": N, "misconceptions_found": N, "misconceptions_resolved": N, "summary": "one-line summary"}
```

### 4. Update project-local tracking

Update `memory/knowledge_gaps.md`:
- Topics explained → Learned (if new)
- Topics answered correctly in quiz → promote toward Solid
- Topics answered incorrectly → Weak
- Note dates for spaced repetition

### 5. Update student profile if needed

If you learned new things about the student during this session (e.g., they mentioned a new goal, showed a preference for a different explanation style), update `~/.local/share/claude-education/student.json`.

## Rules

- Be honest about what was understood vs what needs more work
- Track mistake patterns, not just topics (e.g., "keeps forgetting to close file descriptors")
- The "Next Session" section is critical — it's the first thing to check next time
- Include spaced repetition schedule so the student knows what's coming
- Show goal progress to maintain motivation
- Save everything to DB — this is the primary save point for the session
