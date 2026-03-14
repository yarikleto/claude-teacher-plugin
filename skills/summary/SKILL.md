---
name: summary
description: Use when the student is ending a learning session — generates a recap of what was covered, updates knowledge tracking, and suggests what to start with next time
---

# Session Summary

Generates an end-of-session recap and updates knowledge tracking.

## Invocation

`/summary` — run at the end of a learning session

## Process

1. Review the current conversation — what topics were discussed?
2. Read `memory/knowledge_gaps.md` for current state
3. Generate the summary
4. Update `memory/knowledge_gaps.md` with session results
5. Save the summary to `memory/` for next session reference

## Summary Format

```
══════════════════════════════════════════
  SESSION SUMMARY — [date]
══════════════════════════════════════════

  Duration: ~[estimate based on conversation length]

  LEARNED TODAY
  ─────────────
  ✓ [topic 1] — [one-line what was covered]
  ✓ [topic 2] — [one-line what was covered]
  ~ [topic 3] — [started but not finished]

  QUIZ RESULTS
  ─────────────
  [If any quizzes happened: score and weak areas]

  COMMON MISTAKES
  ─────────────
  · [pattern noticed, e.g., "confused bind() argument order twice"]

  KNOWLEDGE CHANGES
  ─────────────
  ↑ [topic] moved from Weak → Learned
  ↑ [topic] moved from Learned → Solid
  ↓ [topic] — struggled, stays in Weak

  NEXT SESSION
  ─────────────
  Start with:
    1. Review: [weak topic to revisit]
    2. Continue: [where we left off]
    3. Next new topic: [what comes next on the roadmap]

══════════════════════════════════════════
```

## Rules

- Be honest about what was understood vs what needs more work
- Track mistake patterns, not just topics (e.g., "keeps forgetting to close file descriptors")
- The "Next Session" section is critical — it's the first thing to read next time
- Update knowledge_gaps.md:
  - Topics that were explained → Learned (if new)
  - Topics answered correctly in quiz → promote toward Solid
  - Topics answered incorrectly → Weak
  - Note dates for spaced repetition
- Save a brief version to memory so next session can reference it
