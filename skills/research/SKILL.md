---
name: research
description: "Use when the student has a task, project, or goal and needs a structured learning plan — researches prerequisites, finds authoritative resources (docs, articles, RFCs, tutorials), and saves a checklist-style study plan to a file. The student follows the plan at their own pace."
---

# Research — Study Plan Generator

Researches what the student needs to learn to successfully complete a task or project, then saves a structured checklist with resources to a markdown file.

## Invocation

`/research <task or project description>`

Examples:
- `/research build an FTP server in C`
- `/research prepare for AWS Solutions Architect exam`
- `/research create a REST API with authentication`
- `/research understand how Docker networking works`

## Process

### 1. Understand the Goal

Read `~/.local/share/claude-education/student.json` and `dashboard.json` to understand:
- What the student already knows (skip those topics)
- Their level and background (calibrate depth)
- Their goals and deadlines (prioritize accordingly)
- Their learning style (choose resource types that fit)

Ask clarifying questions if the task is vague:
- What's the end result? (working app, exam pass, understanding)
- Any deadline?
- Any constraints? (language, framework, platform)

### 2. Decompose the Task

Break the task into skills/knowledge areas needed. For each area, determine:
- Is it a **prerequisite** (must know before starting)?
- Is it a **core skill** (directly needed for the task)?
- Is it **nice-to-have** (improves quality but not required)?

Cross-reference with `dashboard.json` — if the student already has a topic at `solid` or `working` depth, mark it as done in the plan.

### 3. Research Resources

Use **WebSearch** to find real, authoritative resources for each topic. For every topic, find **2-4 resources** from different categories:

| Category | Examples | When to use |
|----------|---------|-------------|
| Official docs | MDN, RFC, language docs, framework docs | Always — primary source |
| Tutorial/guide | DigitalOcean, freeCodeCamp, Real Python | For hands-on learners |
| Article/deep-dive | Blog posts, conference talks, papers | For deeper understanding |
| Video | YouTube tutorials, course lectures | If student prefers video |
| Interactive | Exercism, LeetCode, Katacoda | For practice-oriented students |

**Rules:**
- Every link MUST be real and verified via WebSearch — never hallucinate URLs
- Prefer free resources over paid
- Prefer official docs over third-party when quality is equal
- Include estimated reading/watching time when possible
- Note difficulty level (beginner/intermediate/advanced) for each resource

### 4. Build the Study Plan

Structure the plan as a markdown checklist with clear phases:

```markdown
# Study Plan: [Task/Project Name]

> Generated: [date]
> Goal: [one-line goal description]
> Estimated time: [total estimate]
> Student level: [from student.json]

---

## Phase 1: Prerequisites
*Must understand before starting the main task*

### Topic Name
> Why: [one sentence — why this is needed for the task]
> Status: [new | already known (solid) | needs review (learned/weak)]
> Estimated time: ~Xh

- [ ] Read: [Resource title](url) — [type, difficulty, ~time]
- [ ] Read: [Resource title](url) — [type, difficulty, ~time]
- [ ] Practice: [specific exercise or mini-task to verify understanding]
- [ ] Self-check: [question they should be able to answer after studying]

### Another Topic
...

---

## Phase 2: Core Skills
*Directly needed to complete the task*

### Topic Name
> Why: [why this matters for the task]
> Status: [new | already known | needs review]
> Estimated time: ~Xh

- [ ] Read: [Resource](url) — [details]
- [ ] Build: [hands-on mini-task related to the project]
- [ ] Self-check: [verification question]

---

## Phase 3: Nice-to-Have
*Will improve quality but not strictly required*

### Topic Name
> Why: [how this improves the result]
> Estimated time: ~Xh

- [ ] Read: [Resource](url)
- [ ] Optional: [deeper exploration idea]

---

## Suggested Order

1. [Topic A] → [Topic B] → [Topic C] (prerequisites build on each other)
2. Then [Core Topic D] + [Core Topic E] (can be parallel)
3. Finally [Nice-to-have F] if time permits

## Next Steps

After completing this plan, you should be ready to:
- [Concrete outcome 1]
- [Concrete outcome 2]
- Start building: [first concrete step of the actual task]
```

### 5. Save the Plan

Save to **two locations**:
- Project-local: `docs/study-plan-<slug>.md`
- Global: `~/.local/share/claude-education/docs/study-plan-<slug>.md`

Tell the student the file path so they can open it and start checking off items.

### 6. Update the Education DB

For each NEW topic in the plan that isn't already in the DB:
- Create `~/.local/share/claude-education/topics/<slug>.json` with:
  - `status: "new"` (not yet studied)
  - `depth: "surface"` 
  - `prerequisites` filled in based on the plan structure
  - `related_topics` filled in
- Update `dashboard.json` to include the new topics

Append to session log:
```jsonl
{"time": "[now]", "event": "research", "task": "[task description]", "plan_file": "docs/study-plan-<slug>.md", "topics_added": ["topic1", "topic2"], "topics_already_known": ["topic3"]}
```

## Adaptation Rules

**Based on student level (from student.json):**
- **Beginner**: More prerequisites, simpler resources, more self-check questions, smaller steps
- **Intermediate**: Skip basics, focus on core + nice-to-have, include deeper resources
- **Advanced**: Minimal prerequisites, focus on specifics and edge cases, include RFCs/papers

**Based on learning style:**
- **Visual learner**: Prioritize video resources, suggest `/excalidraw` or `/demo` for complex topics
- **Hands-on learner**: More "Build:" and "Practice:" items, fewer "Read:" items
- **Reader**: More articles and docs, fewer videos

**Based on time commitment:**
- If tight deadline: mark nice-to-haves clearly, suggest minimum viable path
- If open-ended: include deeper exploration paths and bonus topics

## Quality Rules

- Every resource link must be real (verified via WebSearch)
- Every topic must have a "Why:" explaining relevance to the task
- Every topic must have at least one self-check question or mini-task
- The plan must have a clear suggested order (not just a flat list)
- Already-known topics should be acknowledged (not re-assigned)
- Total time estimate should be realistic based on student level

## Integration with Other Skills

- After the student studies a topic from the plan → suggest `/quiz-me [topic]` to verify
- After a phase is complete → suggest `/progress` to see updated dashboard
- For visual topics in the plan → suggest `/ascii`, `/excalidraw`, or `/demo`
- For hands-on topics → suggest `/challenge`
- At session end → `/summary` captures what was studied from the plan
- The plan file itself becomes a persistent reference the student returns to across sessions
