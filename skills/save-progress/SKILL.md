---
name: save-progress
description: Use when the student wants to checkpoint their progress mid-session — flushes all current session state to the global education DB without ending the session
---


Before accessing education data, read `${CLAUDE_PLUGIN_ROOT}/references/education-data.md`. Resolve every `<education-db>` below using that contract. Current session ID: `${CLAUDE_SESSION_ID}`.

# Save Progress

Mid-session checkpoint that persists everything learned so far to the global education DB. Unlike `/claude-teacher:summary` (which ends the session), this saves state and keeps going.

## Invocation

`/claude-teacher:save-progress` — save everything from the current session so far

## Process

### 1. Analyze Current Session

Review the conversation so far and identify:
- New topics explained (not yet in DB)
- Quiz results (not yet saved)
- Challenge results (not yet saved)
- New misconceptions discovered
- Misconceptions resolved
- Depth changes observed
- Any new info about the student's preferences

### 2. Update Topic Files

Read and merge each topic touched this session using the shared contract. This is an example for a newly taught topic, not a replacement for an existing record. Preserve assessment dates and intervals on repeated saves. Create or update `<education-db>/topics/<slug>.json`:

```json
{
  "name": "Topic Name",
  "slug": "topic-name",
  "status": "weak|learned|solid",
  "depth": "surface|working|deep",
  "first_seen": "[date first encountered]",
  "last_reviewed": null,
  "next_review": "[first review or existing date]",
  "review_interval_days": 1,
  "quiz_scores": [],
  "misconceptions": [],
  "prerequisites": [],
  "related_topics": [],
  "notes": ""
}
```

### 3. Save Any Unsaved Quiz Records

For each quiz taken this session that hasn't been saved yet, write to `<education-db>/quizzes/[date]_[topic-slug]_[quiz-id].json`.

### 4. Update Dashboard

Update `<education-db>/dashboard.json`:
- Refresh all topic statuses
- Recalculate stats
- Update `last_session` and `current_topic`

### 5. Append to Session Log

Add entries to `<education-db>/sessions/[date].jsonl` for any events not yet logged:

```jsonl
{"time": "[now]", "event": "checkpoint", "topics_saved": ["..."], "note": "mid-session save"}
```

### 6. Update Student Profile

If you learned anything new about the student (preferences, background, goals), update `<education-db>/student.json`.

### 7. Update Project-Local Tracking

Sync `memory/knowledge_gaps.md` with the current state if it exists.

### 8. Confirm

```
── Progress Saved ────────────────────────
  Topics updated: [list]
  Quizzes saved: [count]
  Misconceptions recorded: [count]
  Dashboard synced: ✓

  Keep going! Your progress is safe.
──────────────────────────────────────────
```

## Rules

- This is a NON-DESTRUCTIVE operation — it only adds/updates, never deletes
- Don't end the session — just save and continue
- If there's nothing new to save, say so: "Everything is already saved — nothing new since last checkpoint."
- Keep the confirmation brief — the student wants to keep learning, not read a report
