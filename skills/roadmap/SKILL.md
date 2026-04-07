---
name: roadmap
description: "Use when the student wants a visual learning roadmap for a goal or topic area — reads current knowledge state, researches the standard learning path, and generates an interactive .excalidraw diagram with color-coded topic nodes, prerequisite arrows, and milestone markers. Visual companion to /research."
---

# Roadmap — Visual Learning Path Generator

Generates an interactive `.excalidraw` diagram showing the full learning path for a goal or topic area, with nodes color-coded by the student's current knowledge state. Also saves a markdown companion with the same information as text.

## Invocation

`/roadmap <goal or topic area>`

Examples:
- `/roadmap backend development`
- `/roadmap networking fundamentals`
- `/roadmap prepare for AWS exam`
- `/roadmap learn Rust from scratch`

## Process

### 1. Understand Current State

1. Read `~/.local/share/claude-education/student.json` — get goals, level, known technologies, learning style, interests
2. Read `~/.local/share/claude-education/dashboard.json` — get all tracked topics and statuses
3. For topics relevant to the goal, read individual `~/.local/share/claude-education/topics/<slug>.json` files — get depth, prerequisites, misconceptions
4. If the student has no profile yet, say: "Run `/init-edu` first so I can personalize your roadmap."

### 2. Research the Learning Path

Use **WebSearch** to research the standard, industry-accepted learning path for the given goal:

- Search for curricula, official certification paths, university course sequences, and community-recommended learning orders
- Identify 8-20 topics that form the path (scale to goal size)
- Determine prerequisite relationships between topics (which must come before which)
- Identify 2-4 milestones — meaningful checkpoints where the student can build something or demonstrate competence
- Note which topics the student already knows (cross-reference with dashboard)

**Rules:**
- Every topic in the roadmap must be verified as genuinely part of the learning path — no filler
- Prerequisites must reflect real dependencies (e.g., you truly need TCP basics before HTTP internals)
- Milestones should be concrete achievements, not vague labels ("Can build a REST API" not "Understands backend")

### 3. Classify Each Topic

For every topic in the roadmap, assign a status based on the student's current knowledge:

| Status | Color | Meaning |
|--------|-------|---------|
| `solid` | Green (`#BFDBAD`) | Student has proven understanding — no work needed |
| `learned` | Blue (`#BDD0E8`) | Student knows it but needs more practice or review |
| `weak` | Red (`#F5C4C4`) | Student has seen it but struggles — needs reteaching |
| `new` | Gray (`#E8E8E8`) | Not yet covered — upcoming |

Also mark:
- **Current position** — the frontier between known and unknown topics, highlighted with a bold border or star marker
- **Milestones** — diamond shapes or double-bordered rectangles at key achievement points

### 4. Generate the Excalidraw Diagram

Invoke `/excalidraw` internally to generate the `.excalidraw` file. The diagram must follow these structural rules:

#### Layout

- **Top-to-bottom flow** — earliest prerequisites at top, advanced topics at bottom
- **Parallel tracks side by side** — topics that can be learned independently sit in parallel columns
- **Milestones span the full width** — horizontal milestone bars separate phases
- Grid-aligned coordinates (multiples of 20), max ~1400px wide, ~1000px tall per section

#### Node Design

Each topic is a rounded rectangle containing:
- Topic name (fontSize 20, bold)
- Status indicator text (fontSize 14): "solid", "learned", "weak", or "new"
- Background color matching status (see table above)

#### Arrows

- Solid arrows from prerequisite to dependent topic
- Arrow labels are optional — use only when the dependency reason is non-obvious
- Prefer straight vertical/horizontal arrows; use waypoints for complex routing

#### Current Position

- The topic(s) the student should work on next get a thicker border (strokeWidth 3) and a subtle glow effect (use a slightly larger shadow rectangle behind the node)
- Add a free-floating label: "YOU ARE HERE" (fontSize 16, bold) with an arrow pointing to the current position

#### Milestones

- Diamond shapes or wide rectangles with dashed borders
- Label format: "MILESTONE: [achievement]" (fontSize 18)
- Examples: "MILESTONE: Can build a basic HTTP server", "MILESTONE: Ready for networking exam"

#### Title and Legend

- Title at top: "[Goal] — Learning Roadmap" (fontSize 28)
- Legend in top-right corner showing color meanings:
  - Green = Solid (mastered)
  - Blue = Learned (needs practice)
  - Red = Weak (needs reteaching)
  - Gray = New (upcoming)
- Source attribution at bottom (fontSize 12)

### 5. Generate the Markdown Companion

Create a text version of the same roadmap:

```markdown
# Learning Roadmap: [Goal]

> Generated: [date]
> Student level: [from student.json]
> Topics: N total (X solid, Y learned, Z weak, W new)

---

## Phase 1: Foundations
*Prerequisites that everything else builds on*

- [x] **Topic A** (solid) — [one-line description]
- [ ] **Topic B** (new) — [one-line description]
  - Prerequisites: Topic A
  - Why: [why this matters for the goal]

> MILESTONE: [what you can do after this phase]

---

## Phase 2: Core Skills
*The main knowledge area for your goal*

- [~] **Topic C** (learned) — [one-line description]
  - Prerequisites: Topic A, Topic B
  - Why: [relevance]
- [ ] **Topic D** (new) — [one-line description]
  - Prerequisites: Topic C

  --> YOU ARE HERE <--

> MILESTONE: [achievement after this phase]

---

## Phase 3: Advanced / Specialization

- [ ] **Topic E** (new) — [description]
- [ ] **Topic F** (new) — [description]

> MILESTONE: [final achievement — goal reached]

---

## Suggested Path

1. Topic A -> Topic B (sequential — B needs A)
2. Topic C + Topic D (parallel — independent of each other)
3. Topic E -> Topic F (sequential)

## Sources

- [Source 1](url) — used to determine topic sequence
- [Source 2](url) — prerequisite relationships
```

**Checklist symbols:**
- `[x]` = solid (done)
- `[~]` = learned or weak (in progress)
- `[ ]` = new (not started)

### 6. Save Files

Save to **four locations**:

1. **Project-local diagram:** `docs/roadmap-<goal-slug>.excalidraw`
2. **Project-local markdown:** `docs/roadmap-<goal-slug>.md`
3. **Global diagram:** `~/.local/share/claude-education/docs/roadmap-<goal-slug>.excalidraw`
4. **Global markdown:** `~/.local/share/claude-education/docs/roadmap-<goal-slug>.md`

Tell the student the file paths and how to open the `.excalidraw` file (VS Code extension or excalidraw.com).

### 7. Update the Education DB

**For each NEW topic in the roadmap not already in the DB:**
- Create `~/.local/share/claude-education/topics/<slug>.json` with:
  - `status: "new"`
  - `depth: "surface"`
  - `prerequisites` filled from the roadmap structure
  - `related_topics` filled from adjacent nodes
- Update `dashboard.json` to include the new topics

**Append to session log** `~/.local/share/claude-education/sessions/[date].jsonl`:
```jsonl
{"time": "[now]", "event": "roadmap", "goal": "[goal description]", "diagram_file": "docs/roadmap-<goal-slug>.excalidraw", "markdown_file": "docs/roadmap-<goal-slug>.md", "topics_total": N, "topics_known": X, "topics_new": Y, "milestones": ["milestone1", "milestone2"]}
```

## Adaptation Rules

**Based on student level (from student.json):**
- **Beginner**: More granular topics (break big topics into smaller steps), more milestones for encouragement, 12-20 nodes
- **Intermediate**: Standard granularity, skip basics that are clearly beneath their level, 8-15 nodes
- **Advanced**: Coarser topics, focus on specialization branches, include cutting-edge/advanced subtopics, 8-12 nodes

**Based on learning style:**
- **Visual learner**: Emphasize the diagram — make it detailed and well-structured
- **Hands-on learner**: Add "Build:" annotations to milestone nodes (what to build at each checkpoint)
- **Reader**: Make the markdown companion more detailed with resource links per topic

**Based on time commitment:**
- If tight deadline: highlight the critical path (shortest route to the goal), mark optional branches clearly
- If open-ended: show the full breadth including nice-to-have branches

## Quality Rules

- Every topic must genuinely belong in the learning path (verified via WebSearch)
- Prerequisite arrows must reflect real dependencies, not arbitrary ordering
- Color coding must accurately reflect the student's current state from the DB
- "YOU ARE HERE" must point to the correct frontier — the first new/weak topic(s) whose prerequisites are all solid/learned
- Milestones must be concrete and achievable ("Can build X" or "Can explain Y to others")
- The diagram must pass the Excalidraw quality checklist (isomorphism test, education test, container ratio, binding consistency)
- The markdown companion must contain all the same information as the diagram in accessible text form

## Integration with Other Skills

- **`/excalidraw`** — roadmap uses `/excalidraw` to generate the diagram. Follow all excalidraw reference files and quality rules.
- **`/research`** — text-based study plan companion. `/roadmap` is the visual overview, `/research` provides detailed resources per topic. Suggest: "Want detailed resources for any of these topics? Run `/research [topic]`."
- **`/progress`** — after generating a roadmap, suggest `/progress` to see the detailed dashboard. As the student progresses, re-running `/roadmap` shows updated colors.
- **`/quiz-me`** — suggest quizzing on learned/weak topics shown in the roadmap to promote them to solid.
- **`/challenge`** — suggest challenges at milestone points to verify readiness before moving on.
- **`/summary`** — session summary can reference roadmap progress.
- Re-running `/roadmap` with the same goal produces an **updated** diagram reflecting new knowledge state — encourage the student to re-run periodically to see visual progress.
