---
name: challenge
description: Use when the student wants a mini-task or practice exercise on the current topic — generates short focused challenges adapted to learning type (code, conceptual, or scenario-based). Results saved to global education DB.
---

# Challenge — Mini-Tasks

Generates a short, focused exercise on the current topic. Adapts to the learning type. Results update the global education DB.

## Invocation

`/challenge` — picks topic from current context, weak areas, or topics at `surface` depth that need to reach `working`
`/challenge [topic]` — specific topic

## Process

1. Read `~/.local/share/claude-education/dashboard.json` — check topic statuses
2. Read `~/.local/share/claude-education/student.json` — adapt to learning style and level
3. If a topic was given, read `~/.local/share/claude-education/topics/<topic>.json` — check depth, misconceptions
4. If no topic given, pick using priority: topics at `surface` depth (need hands-on to reach `working`) → `weak` topics → `learned` topics
5. **NEVER generate challenges on topics not in the DB** — the student hasn't learned them yet. If no covered topics exist: "Nothing to challenge on yet — let's learn something first!"
6. Check CLAUDE.md for learning type (project / technology / theory)
7. If topic has unresolved misconceptions, design the challenge to expose/address them
8. Generate ONE challenge appropriate to the type
9. Wait for the student's answer
10. Evaluate, explain, update DB

## Challenge Types by Learning Type

### Project (code challenges)
```
CHALLENGE: Write a function that...

  Difficulty: [easy / medium / hard]
  Time: ~5-10 minutes
  Targeting: [depth promotion / misconception / reinforcement]
  Hint available: yes (ask if stuck)

  [Clear problem statement]
  [Expected input/output if applicable]
```

### Technology (scenario challenges)
```
CHALLENGE: You are designing...

  Difficulty: [easy / medium / hard]
  Time: ~5 minutes
  Targeting: [depth promotion / misconception / reinforcement]

  [Real-world scenario description]
  [Question: what would you do / choose / configure?]
```

### Theory (conceptual challenges)
```
CHALLENGE: Explain / prove / trace...

  Difficulty: [easy / medium / hard]
  Time: ~5 minutes
  Targeting: [depth promotion / misconception / reinforcement]

  [Problem statement]
```

## Rules

- ONE challenge per invocation. Keep it focused.
- Always state difficulty and estimated time.
- Show what the challenge is targeting (depth promotion, misconception, reinforcement).
- Never give the answer immediately. Wait for their attempt.
- Offer hints on request, not proactively.
- After completing a challenge, suggest: "Want another? Or continue learning?"

## Evaluation & DB Update

After the student submits their answer:

**1. Evaluate and explain (use WebSearch to verify your evaluation — never hallucinate):**
- If correct: acknowledge, explain why it works, highlight good thinking
- If partially correct: credit what's right, explain what's missing
- If wrong: record misconception, explain with source links, offer a simpler version

**2. Update topic file** `~/.local/share/claude-education/topics/<slug>.json`:
- If correct and topic was `surface` depth → promote to `working`
- If correct with good explanation and topic was `working` → promote to `deep`
- If wrong → add misconception, consider demoting status
- Update `last_reviewed` and recalculate `next_review`

**3. Update dashboard** `~/.local/share/claude-education/dashboard.json`:
- Update topic entry with new status/depth

**4. Append to session log** `~/.local/share/claude-education/sessions/[date].jsonl`:
```jsonl
{"time": "[now]", "event": "challenge", "topic": "[slug]", "passed": true, "depth_before": "surface", "depth_after": "working"}
```

**5. Update project-local** `memory/knowledge_gaps.md` if it exists.

## Integration with Other Skills

- **`/quiz-me`** — challenges are more hands-on than quizzes. Use challenges to promote depth, quizzes to test breadth.
- **`/illustrate`** — if the challenge involves a visual concept, offer to illustrate after evaluation.
- **`/progress`** — student can check how challenges affected their dashboard.
