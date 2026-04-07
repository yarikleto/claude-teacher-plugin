---
name: quiz-me
description: Use when the user wants to be quizzed, tested, or asked questions on any topic — programming concepts, protocols, algorithms, tools, or any subject they are studying
---

# Quiz Me

Interactive quiz that tests understanding through a mix of multiple-choice and open-ended questions. All results are saved to the global education DB.

## How to Use

Invoke with `/quiz-me [topic]` or just `/quiz-me` and specify the topic when asked.

Examples: `/quiz-me TCP sockets`, `/quiz-me git`, `/quiz-me sorting algorithms`

## Quiz Flow

### Setup

1. Read `~/.local/share/claude-education/dashboard.json` — check topic statuses
2. Read `~/.local/share/claude-education/student.json` — adapt to learning style
3. If a topic was given, read `~/.local/share/claude-education/topics/<topic>.json` if it exists — check for unresolved misconceptions and previous scores
4. If no topic given, pick from: first any topics with `next_review <= today`, then `weak` topics, then `learned` topics
5. Also check project-local `memory/knowledge_gaps.md` for covered topics

### Question Loop

```
Determine topic → Check for unresolved misconceptions → Ask question → Wait for answer → Evaluate → (30% chance: ask "explain your thinking") → Record result → More questions? → Score summary → Save to DB
```

## Rules

1. **One question per message.** Never batch questions.
2. **Mix formats:** Alternate between multiple-choice (4 options) and open-ended. Use multiple-choice for factual recall, open-ended for conceptual understanding.
3. **Grade fairly:** For open-ended answers, accept correct reasoning even if wording is imprecise. If partially correct, say what was right and what was missing.
4. **Explain after every answer:** Whether right or wrong, give a brief explanation of WHY the correct answer is correct. This is the learning moment. **Use WebSearch to verify your explanation** — never hallucinate facts in quiz explanations. Include a source link when citing specific facts.
5. **Adapt difficulty:** Start medium. If the user gets 2+ right in a row, increase difficulty. If they get 2+ wrong, ease up and cover fundamentals.
6. **Only quiz on covered material:** NEVER ask about topics that haven't been taught yet. Check `dashboard.json` — only topics with status `weak`, `learned`, or `solid` are fair game. If a topic has no entry or hasn't been explained, it's off limits. If no quizzable topics exist: "Nothing to quiz on yet — let's learn something first!"
7. **Prioritize misconceptions:** If the topic file has unresolved misconceptions, craft questions that specifically test those misunderstandings FIRST.
8. **"Explain your thinking" check:** ~30% of correct answers, ask the student to explain WHY their answer is right. If their reasoning is wrong despite the correct answer, record it as a misconception.
9. **Track score:** Keep a running tally (e.g., "3/5 correct"). Show final summary when the quiz ends.
10. **Let the user control pace:** The quiz ends when the user says stop, or after 10 questions if no limit was specified. Ask "Continue?" after every 5 questions.
11. **Use context:** If inside a project directory, read relevant files to generate questions about the actual codebase — not just generic textbook questions.
12. **No trick questions.** Every question should teach something useful.

## Question Format

**Multiple choice:**
```
Q3 (medium): What system call creates a new socket in C?

  a) connect()
  b) socket()
  c) bind()
  d) listen()
```

**Open-ended:**
```
Q4 (medium): In your own words, explain why FTP uses two separate TCP connections instead of one.
```

## After Each Answer

```
Correct! [or] Not quite.

[Brief explanation of the correct answer and why it matters]

Score: 3/4
```

If the student got it wrong, record the misconception immediately in the topic file.

## Score Summary & DB Update

At the end of the quiz:

**1. Show summary:**
```
── Quiz Complete ──────────────────
Topic: [topic]
Score: 7/10 (70%)
Depth: [surface → working] (promoted!)

Strong areas: [what they got right]
Review these: [concepts they struggled with]
Misconceptions found: [list any new ones]
Next review: [calculated date]
───────────────────────────────────
```

**2. Save quiz record** to `~/.local/share/claude-education/quizzes/[date]_[topic-slug].json`:
```json
{
  "date": "[today]",
  "topic": "[topic-slug]",
  "questions": [
    {
      "question": "...",
      "type": "multiple_choice|open_ended",
      "student_answer": "...",
      "correct_answer": "...",
      "correct": true,
      "reasoning_check": false,
      "reasoning_was_sound": null
    }
  ],
  "score": 70,
  "status_before": "learned",
  "status_after": "learned",
  "depth_before": "surface",
  "depth_after": "working",
  "notes": "..."
}
```

**3. Update topic file** `~/.local/share/claude-education/topics/[topic-slug].json`:
- Update `quiz_scores` array, `last_reviewed`, `status`, `depth`
- Add any new misconceptions
- Recalculate `next_review` using spaced repetition:
  - Score >=80%: double `review_interval_days`, set `next_review` accordingly
  - Score <50%: reset interval to 1 day, demote to `weak`
  - Score 50-79%: keep current interval

**4. Update dashboard** `~/.local/share/claude-education/dashboard.json`:
- Update topic entry, recalculate `stats`, `total_quizzes`, `average_score`

**5. Update project-local** `memory/knowledge_gaps.md` if it exists.

**6. Append to session log** `~/.local/share/claude-education/sessions/[date].jsonl`:
```jsonl
{"time": "[now]", "event": "quiz", "topic": "[slug]", "score": 70, "passed": true, "misconceptions_found": 1}
```

## Priority Order for Questions

1. **Unresolved misconceptions** on the topic (highest priority — targeted questions)
2. Topics marked **Weak** in dashboard (need remediation)
3. Topics marked **Learned** with `next_review <= today` (due for spaced repetition)
4. Topics marked **Learned** that haven't been verified at `working` depth
5. Topics marked **Solid** — for reinforcement and deeper questions

## Integration with Other Skills

- **`/ascii [concept]`** — if a question involves a visual concept and the student got it wrong, offer to illustrate it.
- **`/challenge [topic]`** — for hands-on practice after quiz identifies weak areas.
- **`/progress`** — student can check their overall dashboard.
- **`/save-progress`** — quiz results are auto-saved, but student can explicitly save mid-session.
