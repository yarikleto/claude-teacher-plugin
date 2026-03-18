---
name: progress
description: Use when the student wants to see their knowledge dashboard — shows what they know, what's weak, what's due for review, misconceptions, and overall stats across all projects
---

# Progress Dashboard

Shows a visual overview of the student's knowledge state from the global education DB.

## Process

1. Read `~/.local/share/claude-education/dashboard.json`
2. Read `~/.local/share/claude-education/student.json` for goals/deadlines
3. If dashboard doesn't exist, say: "No progress tracked yet. Run `/init-edu` first."
4. For topics with unresolved misconceptions, read individual `topics/<slug>.json` files
5. Render the dashboard

## Dashboard Format

```
══════════════════════════════════════════════════
  KNOWLEDGE DASHBOARD
══════════════════════════════════════════════════

  Overall: N topics tracked · M quizzes taken · avg score: X%

  Solid (N)          ████████████░░░░░░░░  60%   depth: ██ working
  Learned (N)        █████░░░░░░░░░░░░░░░  25%   depth: █░ surface
  Weak (N)           ██░░░░░░░░░░░░░░░░░░  10%

──────────────────────────────────────────────────
  🔴 DUE FOR REVIEW (next_review <= today)
──────────────────────────────────────────────────
  · tcp-basics — was solid, due since 2026-03-18
  · recursion — learned, due since 2026-03-17

──────────────────────────────────────────────────
  WEAK — address these first
──────────────────────────────────────────────────
  ✗ tcp-congestion — last score: 40% (2026-03-15)
    ⚠ Misconception: "confused slow start with congestion avoidance"
  ✗ udp — never quizzed, marked weak in session

──────────────────────────────────────────────────
  LEARNED — needs more practice
──────────────────────────────────────────────────
  ~ docker-networking (working) — next review: 2026-03-22
  ~ osi-model (surface) — next review: 2026-03-20

──────────────────────────────────────────────────
  SOLID — proven understanding
──────────────────────────────────────────────────
  ✓ tcp-basics (deep) — last reviewed: 2026-03-16
  ✓ socket-api (working) — last reviewed: 2026-03-14

──────────────────────────────────────────────────
  UNRESOLVED MISCONCEPTIONS (N total)
──────────────────────────────────────────────────
  · tcp-congestion: "confused slow start with congestion avoidance" (2026-03-15)
  · udp: "thought UDP has flow control" (2026-03-14)

──────────────────────────────────────────────────
  GOALS
──────────────────────────────────────────────────
  · Pass OS exam — deadline: 2026-06-15 (88 days away)
    Progress: 3/10 topics solid

══════════════════════════════════════════════════
  Suggestion: 2 topics are due for review. Start
  with /quiz-me tcp-basics, then address the
  misconception in tcp-congestion.
══════════════════════════════════════════════════
```

## Rules

- Calculate percentages based on total topic count
- Progress bar: 20 characters wide, `█` for filled, `░` for empty
- Show depth level next to status categories
- **Due for review section** appears at the TOP if any topics have `next_review <= today` — this is the most actionable info
- **Misconceptions section** — show all unresolved misconceptions across all topics. Read individual topic files to get these.
- **Goals section** — show goals from `student.json` with days remaining and estimated progress
- Sort weak topics by last score (lowest first — most urgent)
- Sort learned topics by next review date (soonest first)
- End with a concrete, actionable suggestion
- If all topics are Solid with no due reviews: congratulate and suggest exploring advanced subtopics or increasing depth
