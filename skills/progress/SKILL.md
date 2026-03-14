---
name: progress
description: Use when the student wants to see their knowledge dashboard — shows what they know, what's weak, and what's ahead. Invoke with /progress
---

# Progress Dashboard

Shows a visual overview of the student's knowledge state.

## Process

1. Read `memory/knowledge_gaps.md` from project memory
2. If it doesn't exist, say: "No knowledge tracking found. Run `/init-edu` first."
3. Render the dashboard

## Dashboard Format

```
══════════════════════════════════════════
  KNOWLEDGE DASHBOARD — [Topic]
══════════════════════════════════════════

  Solid (N topics)        ████████████░░░░░░░░  60%
  Learned (N topics)      █████░░░░░░░░░░░░░░░  25%
  Weak (N topics)         ██░░░░░░░░░░░░░░░░░░  10%
  Not covered (N topics)  █░░░░░░░░░░░░░░░░░░░   5%

──────────────────────────────────────────
  SOLID — you've proven these
──────────────────────────────────────────
  ✓ topic 1
  ✓ topic 2

──────────────────────────────────────────
  LEARNED — explained, needs more practice
──────────────────────────────────────────
  ~ topic 3 (last reviewed: 2026-03-15)
  ~ topic 4 (last reviewed: 2026-03-14)

──────────────────────────────────────────
  WEAK — review these next
──────────────────────────────────────────
  ✗ topic 5 — got wrong on quiz (2026-03-15)
  ✗ topic 6 — didn't know (2026-03-14)

──────────────────────────────────────────
  AHEAD — not yet covered
──────────────────────────────────────────
  · topic 7
  · topic 8
  · topic 9

══════════════════════════════════════════
  Suggestion: Review "topic 5" and "topic 6"
  before moving to new material.
══════════════════════════════════════════
```

## Rules

- Calculate percentages based on total topic count
- Progress bar: 20 characters wide, `█` for filled, `░` for empty
- Sort weak topics by date (oldest first — most urgent to review)
- Sort learned topics by date (oldest first — most likely forgotten)
- End with a concrete suggestion: what to review or what to learn next
- If all topics are Solid: congratulate and suggest exploring advanced subtopics
