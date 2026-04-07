---
name: compare
description: Use when the student wants a structured side-by-side comparison of two concepts — creates a researched comparison table, usage scenarios, misconceptions, and key takeaway adapted to the student's level
---

# Compare — Side-by-Side Concept Comparisons

Creates a structured, researched comparison of two concepts. Adapts depth and language to the student's level. Results are saved to both project-local and global education docs.

## Invocation

`/compare <concept A> vs <concept B>`

Examples:
- `/compare TCP vs UDP`
- `/compare REST vs GraphQL`
- `/compare mutex vs semaphore`
- `/compare Docker vs VMs`
- `/compare SQL vs NoSQL`

## Process

1. Parse the two concepts from the invocation (split on `vs`, `versus`, or `and`)
2. Read `~/.local/share/claude-education/student.json` — adapt to level, interests, and learning style
3. Read `~/.local/share/claude-education/dashboard.json` — check if either concept is already tracked
4. If tracked, read `~/.local/share/claude-education/topics/<concept>.json` for each — check depth, misconceptions
5. **Use WebSearch to research BOTH concepts** before writing the comparison — never rely solely on training data. Search for official documentation, authoritative articles, and recent best-practice guides for each concept.
6. Generate the structured comparison (see Output Format below)
7. Save comparison to docs and update DB (see DB Update below)

## Output Format

Present the comparison in this exact structure:

```
── Compare: [Concept A] vs [Concept B] ──────────────────

## What they are

**[Concept A]:** [One-line summary]
**[Concept B]:** [One-line summary]

## Side-by-side comparison

| Feature            | [Concept A]       | [Concept B]       |
|--------------------|-------------------|-------------------|
| [Feature 1]        | [Value/behavior]  | [Value/behavior]  |
| [Feature 2]        | [Value/behavior]  | [Value/behavior]  |
| [Feature 3]        | [Value/behavior]  | [Value/behavior]  |
| ...                | ...               | ...               |

Include 5-8 rows covering the most important differentiators.
Adapt column detail to student level (beginner = simpler terms, advanced = precise technical language).

## When to use which

**Choose [Concept A] when:**
- [Concrete scenario 1]
- [Concrete scenario 2]
- [Concrete scenario 3]

**Choose [Concept B] when:**
- [Concrete scenario 1]
- [Concrete scenario 2]
- [Concrete scenario 3]

## Common misconceptions

- **Misconception:** "[common wrong belief]"
  **Reality:** [correction with explanation]

- **Misconception:** "[another common wrong belief]"
  **Reality:** [correction with explanation]

Include 2-4 misconceptions. If the student has recorded misconceptions about either topic, address those FIRST.

## Key takeaway

> [One memorable sentence that captures the essential difference]

**Sources:** [list 2-4 links to official docs, RFCs, or authoritative articles used]

──────────────────────────────────────────────────────────
```

## Rules

1. **Always research first.** Use WebSearch for both concepts before writing. Every factual claim must be backed by a source. List sources at the end.
2. **Adapt to student level.** Read `student.json`:
   - Beginner: use analogies from their interests, simpler terms, fewer rows in the table
   - Intermediate: balance precision with clarity, include practical examples
   - Advanced: use precise technical language, include edge cases and nuances
3. **Use the student's interests for analogies.** If they like gaming, music, sports — weave those into the "when to use which" scenarios or the key takeaway.
4. **Respect dislikes.** If the student dislikes dry textbook comparisons, lead with real-world scenarios. If they dislike oversimplification, include nuanced details.
5. **Address known misconceptions first.** If either concept has unresolved misconceptions in its topic file, the "Common misconceptions" section must address those before generic ones.
6. **Keep the table scannable.** Use short values in table cells. If a cell needs elaboration, add a footnote below the table.
7. **Be honest about overlap.** If the concepts are not strictly either/or (e.g., "you can use both together"), say so clearly.
8. **After the comparison, suggest next steps:**
   ```
   Want to go deeper?
   - /illustrate [concept] — visualize how each works under the hood
   - /quiz-me [concept] — test your understanding of either concept
   - /challenge [concept] — hands-on practice with one of them
   ```

## DB Update

After generating the comparison:

**1. Save comparison doc** to both locations:
- Global: `~/.local/share/claude-education/docs/<concept-a>-vs-<concept-b>.md`
- Project-local: `docs/<concept-a>-vs-<concept-b>.md` (if `docs/` directory exists in the project)

Each saved doc includes:
- The full comparison output
- Sources/links used
- Date saved
- Related topics

**2. Update topic files** — for each concept that exists in `~/.local/share/claude-education/topics/`:
- Update `last_reviewed` to today
- Add the other concept to `related_topics` if not already present
- Recalculate `next_review` based on current `review_interval_days`

**3. Update dashboard** `~/.local/share/claude-education/dashboard.json`:
- Update `last_reviewed` for any tracked concepts
- If either concept is new and has not been covered before, do NOT create a topic entry — comparisons alone are not enough to mark a topic as `learned`. Instead, suggest: "Want me to teach [concept] in depth? Then we can track it."

**4. Append to session log** `~/.local/share/claude-education/sessions/[date].jsonl`:
```jsonl
{"time": "[now]", "event": "compare", "concepts": ["<concept-a>", "<concept-b>"], "level_adapted": "<student-level>"}
```

## Integration with Other Skills

- **`/illustrate [concept]`** — visualize how each concept works under the hood (suggest after comparison)
- **`/quiz-me [concept]`** — test understanding of either concept after comparing
- **`/challenge [concept]`** — hands-on practice with one of the compared concepts
- **`/save-progress`** — comparison results are auto-saved, but student can explicitly checkpoint
