---
name: flashcards
description: Use when the student wants to generate Anki-style flashcards from studied topics — creates question/answer cards in Markdown and Anki-compatible CSV, prioritized by weak areas and misconceptions. Cards saved to global education DB and project-local docs.
---

# Flashcards — Anki-Style Card Generation

Generates study flashcards from topics the student has already learned. Cards are prioritized by weakness, misconceptions, and spaced repetition schedule. Exports in Markdown and Anki-compatible CSV.

## Invocation

`/flashcards` — generate cards for all studied topics, prioritized by need
`/flashcards [topic]` — generate cards for a specific topic

## Process

### 1. Load Context

1. Read `~/.local/share/claude-education/dashboard.json` — get all topic statuses
2. Read `~/.local/share/claude-education/student.json` — adapt card style to learning preferences
3. If a topic was given, read `~/.local/share/claude-education/topics/<topic>.json` — check depth, misconceptions, quiz history
4. If no topic given, collect all topics from dashboard and read each topic file
5. **NEVER generate flashcards for topics not in the DB** — the student hasn't learned them yet. If no studied topics exist: "Nothing to make flashcards for yet — let's learn something first!"

### 2. Prioritize Topics for Card Generation

Generate cards in this order (highest priority first):

1. **Weak topics** — these need the most reinforcement
2. **Topics with unresolved misconceptions** — targeted cards to correct misunderstandings
3. **Topics with `next_review <= today`** — due for spaced repetition
4. **Topics at `surface` depth** — need more exposure to reach `working`
5. **Learned topics** — general reinforcement
6. **Solid topics** — fewer cards, focused on edge cases and connections

### 3. Generate Cards

For each topic, generate 5-10 flashcards using a mix of card types. **Use WebSearch to verify every fact** before putting it on a card — flashcards with wrong information are worse than no flashcards.

#### Card Types

**Definition** — core concept recall
```
Front: What is [concept]?
Back: [Concise definition]. [Why it matters in one sentence].
```

**Concept Application** — apply knowledge to a scenario
```
Front: You need to [scenario]. Which [concept/tool/approach] would you use and why?
Back: [Answer with reasoning]. [Key tradeoff or consideration].
```

**"What happens if..."** — trace behavior and consequences
```
Front: What happens if [specific situation related to topic]?
Back: [Step-by-step what occurs]. [Common mistake: ...].
```

**Compare/Contrast** — distinguish related concepts
```
Front: What is the difference between [concept A] and [concept B]?
Back: [A]: [key trait]. [B]: [key trait]. Key distinction: [one sentence].
```

**Fill-in-the-Blank** — active recall of specifics
```
Front: In [context], the ___ is responsible for [function].
Back: [answer]. [Brief explanation of why].
```

#### Card Rules

- Every card back should be **concise** — aim for 1-3 sentences, not paragraphs
- If the topic file has **unresolved misconceptions**, create at least one card that directly addresses each misconception
- Use the student's **interests** from `student.json` for analogies in card backs (e.g., if they like gaming, use gaming analogies)
- Avoid the student's **dislikes** — if they dislike dry definitions, make cards more scenario-based
- Include a **source link** on cards that cite specific technical facts
- Tag each card with difficulty: `[easy]`, `[medium]`, `[hard]` based on topic depth and quiz history

### 4. Export in Both Formats

#### Markdown Format

Save as `docs/flashcards-<topic-slug>.md` (project-local) and `~/.local/share/claude-education/docs/flashcards-<topic-slug>.md` (global):

```markdown
# Flashcards: [Topic Name]

Generated: [date]
Cards: [count]
Priority: [weak / review-due / reinforcement]

---

### Card 1 [easy] — Definition
**Q:** What is [concept]?
**A:** [Answer]. [Why it matters].

---

### Card 2 [medium] — What happens if...
**Q:** What happens if [scenario]?
**A:** [Answer]. Common mistake: [misconception].

---

(... more cards ...)

---

*Generated from your study progress. Review with `/quiz-me [topic]` or practice with `/challenge [topic]`.*
```

#### Anki-Compatible CSV

Save as `docs/flashcards-<topic-slug>.csv` (project-local) and `~/.local/share/claude-education/docs/flashcards-<topic-slug>.csv` (global):

```
"Front";"Back";"Tags"
"What is [concept]?";"[Answer]. [Why it matters].";"[topic-slug] [card-type] [difficulty]"
"What happens if [scenario]?";"[Answer]. Common mistake: [misconception].";"[topic-slug] what-happens-if [difficulty]"
```

CSV rules:
- Semicolon-separated (Anki default)
- All fields double-quoted
- First row is a header
- Tags field uses space-separated tags: topic slug, card type, difficulty
- Escape any double quotes inside fields by doubling them (`""`)
- No HTML — plain text only for maximum compatibility

### 5. Show Summary

After generating, display:

```
── Flashcards Generated ──────────────────
  Topic: [topic name]
  Cards: [count] ([easy]/[medium]/[hard])
  Misconception cards: [count]
  Card types: [list of types used]

  Saved to:
    docs/flashcards-[slug].md
    docs/flashcards-[slug].csv
    ~/.local/share/claude-education/docs/flashcards-[slug].md
    ~/.local/share/claude-education/docs/flashcards-[slug].csv

  Import CSV into Anki: File > Import > select the .csv file
──────────────────────────────────────────
```

If generating for multiple topics, show a combined summary at the end with totals.

### 6. Update DB

**Append to session log** `~/.local/share/claude-education/sessions/[date].jsonl`:
```jsonl
{"time": "[now]", "event": "flashcards", "topics": ["[slug1]", "[slug2]"], "total_cards": 15, "formats": ["markdown", "csv"]}
```

**Update dashboard** `~/.local/share/claude-education/dashboard.json`:
- Update `last_session` to today

## Rules

- **Only generate cards for studied topics.** Check `dashboard.json` — only topics with status `weak`, `learned`, or `solid` are valid. Never invent cards for topics the student hasn't seen.
- **Verify facts with WebSearch.** Every factual claim on a card must be checked. Include source links for technical facts.
- **Prioritize weak areas.** The whole point is targeted review — weak topics and misconceptions come first.
- **Keep cards atomic.** One concept per card. If a card needs more than 3 sentences on the back, split it.
- **Respect student preferences.** Use their learning style, interests, and avoid their dislikes when crafting card language.
- **Regeneration is safe.** Running `/flashcards [topic]` again overwrites the previous files for that topic — this is expected, as cards should reflect the latest knowledge state.
- **Create project-local `docs/` directory** if it doesn't exist before saving.

## Integration with Other Skills

- **`/quiz-me [topic]`** — flashcards are for self-study; quizzes are for active testing. Suggest quizzing after reviewing flashcards.
- **`/challenge [topic]`** — for hands-on practice after memorizing concepts via flashcards.
- **`/progress`** — check which topics need flashcards most (weak areas, due reviews).
- **`/save-progress`** — flashcard generation auto-logs to the session, but student can explicitly checkpoint.
