---
name: challenge
description: Use when the student wants a mini-task or practice exercise on the current topic — generates short focused challenges adapted to learning type (code, conceptual, or scenario-based). Results saved to global education DB.
argument-hint: "[topic]"
---

Requested topic/task: $ARGUMENTS

Before accessing education data, read `${CLAUDE_PLUGIN_ROOT}/references/education-data.md`. Resolve every `<education-db>` below using that contract. Current session ID: `${CLAUDE_SESSION_ID}`.

# Challenge — Mini-Tasks

Generates a short, focused exercise on the current topic. Adapts to the learning type. Results update the global education DB.

## Invocation

`/claude-teacher:challenge` — picks topic from current context, weak areas, or topics at `surface` depth that need to reach `working`
`/claude-teacher:challenge [topic]` — specific topic

## Process

1. Read `<education-db>/dashboard.json` — check topic statuses
2. Read `<education-db>/student.json` — adapt to learning style and level
3. If a topic was given, read `<education-db>/topics/<topic>.json` — check depth, misconceptions
4. If no topic given, pick using priority: topics at `surface` depth (need hands-on to reach `working`) → `weak` topics → `learned` topics
5. **NEVER generate challenges on topics not in the DB** — the student hasn't learned them yet. If no covered topics exist: "Nothing to challenge on yet — let's learn something first!"
6. Read `.claude/claude-teacher.json` for learning type (`project`, `subject`, `exam-prep`, or `mixed`); use CLAUDE.md only as a legacy fallback
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

### Subject / mixed (scenario challenges)
```
CHALLENGE: You are designing...

  Difficulty: [easy / medium / hard]
  Time: ~5 minutes
  Targeting: [depth promotion / misconception / reinforcement]

  [Real-world scenario description]
  [Question: what would you do / choose / configure?]
```

### Exam prep (conceptual or timed challenges)
```
CHALLENGE: Explain / prove / trace...

  Difficulty: [easy / medium / hard]
  Time: ~5 minutes
  Targeting: [depth promotion / misconception / reinforcement]

  [Problem statement]
```

## Multiple-Choice Challenges — Use `AskUserQuestion`

When a challenge naturally fits a multiple-choice format (scenario-based "what would you do?" or theory-based "which approach is correct?"), use the `AskUserQuestion` tool so the student can select with arrow keys. If the tool is unavailable, use plain-text options and wait for an answer.

```
AskUserQuestion({
  questions: [{
    question: "CHALLENGE (medium): A client reports intermittent timeouts connecting to your service behind a load balancer. Which investigation step would you take FIRST?",
    header: "Scenario",
    multiSelect: false,
    options: [
      { label: "a) Restart the load balancer", description: "Restart the network component" },
      { label: "b) Check load balancer health check logs", description: "Inspect the recorded health checks" },
      { label: "c) Increase the client timeout value", description: "Allow clients to wait longer" },
      { label: "d) Add more backend instances", description: "Increase the number of backends" }
    ]
  }]
})
```

**Rules for AskUserQuestion challenges:**
- Provide exactly 4 options
- Randomize the correct answer position
- Write neutral descriptions that do not reveal which choice is correct; explain after the answer
- Keep `header` at most 12 characters; indicate the challenge type (e.g., "Scenario", "Conceptual")
- If the student selects "Other" (custom input), treat it as an open-ended answer and evaluate accordingly

**When NOT to use AskUserQuestion:**
- Code challenges (project type) — the student writes actual code, so use plain text
- Open-ended conceptual challenges ("Explain in your own words...") — the student types freely
- Challenges where the answer requires writing, drawing, or multi-step work

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

**2. Update topic file** `<education-db>/topics/<slug>.json`:
- If correct and topic was `surface` depth → promote to `working`
- If correct with good explanation and topic was `working` → promote to `deep`
- If wrong → add misconception, consider demoting status
- Update `last_reviewed` and recalculate `next_review`

**3. Update dashboard** `<education-db>/dashboard.json`:
- Update topic entry with new status/depth

**4. Append to session log** `<education-db>/sessions/[date].jsonl`:
```jsonl
{"time": "[now]", "event": "challenge", "topic": "[slug]", "passed": true, "depth_before": "surface", "depth_after": "working"}
```

**5. Update project-local** `memory/knowledge_gaps.md` if it exists.

## Integration with Other Skills

- **`/claude-teacher:quiz-me`** — challenges are more hands-on than quizzes. Use challenges to promote depth, quizzes to test breadth.
- **`/claude-teacher:ascii`** — if the challenge involves a visual concept, offer to illustrate after evaluation.
- **`/claude-teacher:progress`** — student can check how challenges affected their dashboard.
