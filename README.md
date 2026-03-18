# Claude Teacher

> The most attentive AI tutor for Claude Code — teaches by guiding, tracks your knowledge across sessions and projects, quizzes with spaced repetition, catches wrong reasoning, and adapts to your level and interests.

Works for any learning context: building projects, studying technologies, or learning CS theory.

## What It Does

Once installed, Claude becomes a **personal tutor by default**:

- **Knows you** — asks your name, interests, learning style, and goals on first run; uses them for analogies and pacing
- **Guides, not solves** — gives skeletons with `???`, asks leading questions (Socratic method)
- **Tracks what you know** — persistent DB across sessions and projects with per-topic status, depth, and misconceptions
- **Quizzes you** — spaced repetition scheduling, adaptive difficulty, targets your specific misconceptions
- **Catches wrong reasoning** — asks "explain your thinking" on correct answers to find hidden gaps
- **Draws diagrams** — ASCII art for complex concepts (sequence diagrams, flowcharts, architecture, protocol headers)
- **Motivates you** — fetches real quotes from APIs, delivers personalized encouragement when you're struggling
- **Adapts** — goes deeper when you're strong, simplifies when you struggle, uses your hobbies for analogies
- **Saves your notes** — builds a personal `docs/` reference library, both project-local and global
- **Never loses progress** — hooks auto-save your progress when the session ends

## Installation

### 1. Add the marketplace (one time)

```bash
claude plugins marketplace add https://github.com/yarikleto/claude-teacher-plugin
```

### 2. Install in your project

```bash
cd your-project
claude plugins install claude-teacher --scope project
```

### 3. Initialize (inside Claude Code)

```
/init-edu
```

This runs a full onboarding: asks your name, background, learning style, interests, goals, and learning type. Sets up `CLAUDE.md` with teaching rules, configures hooks, enables Explanatory output style, and initializes the global education DB. **Restart the session after init.**

## Learning Types

`/init-edu` adapts to what you're doing:

| Type | Example | Claude focuses on |
|------|---------|-------------------|
| **Project** | FTP server, todo app | Code skeletons, incremental building, pedagogical code review |
| **Technology** | Kafka, Docker, K8s | Architecture, real-world scenarios, comparisons, "when to use / not use" |
| **Theory** | Algorithms, OS, networking | Intuition first, formal definitions, thought experiments, practice problems |

## Skills

### `/init-edu` — Onboarding & Project Setup

Run once per project. Full setup in one command:

**Student onboarding (first time only):**
- Name, age, native language
- Background, level, known technologies
- Learning style, frustrations, motivations
- Goals with deadlines, time commitment
- Interests and dislikes (used for analogies and tone)

**Project setup:**
- `.claude/settings.json` — Explanatory output style + hooks
- `CLAUDE.md` — teaching rules adapted to your learning type, with your Student Profile at the top
- `docs/` — directory for saved explanations
- Global education DB at `~/.local/share/claude-education/`
- Project-local knowledge tracking in `memory/knowledge_gaps.md`

### `/quiz-me [topic]` — Knowledge Testing

Mixed-format quizzes with full DB integration:

```
> /quiz-me TCP sockets

Q1 (medium): What is the correct order of server socket calls?

  a) socket() → listen() → bind() → accept()
  b) socket() → bind() → listen() → accept()
  c) bind() → socket() → listen() → accept()
  d) socket() → connect() → listen() → accept()
```

- **Multiple choice + open-ended** questions in the same quiz
- **Targets misconceptions first** — reads your unresolved misconceptions and crafts questions to test them
- **Spaced repetition** — picks topics that are due for review based on scheduling algorithm
- **Adaptive difficulty** — increases after 2+ correct, decreases after 2+ wrong
- **"Explain your thinking"** — ~30% of correct answers get a follow-up "Why?" to catch right-answer-wrong-reasoning
- **Explains every answer** — whether right or wrong, explains WHY
- **Records everything** — saves quiz to `quizzes/`, updates topic status/depth/misconceptions, recalculates spaced repetition schedule
- **Promotes/demotes** — score >=80% promotes toward Solid (doubles review interval), <50% demotes to Weak (resets to 1 day)
- Only quizzes on material already covered — never on untaught topics

### `/illustrate [concept]` — Visual Explanations

ASCII art diagrams with educational context:

```
> /illustrate TCP three-way handshake

  Client              Server
    │                    │
    │   SYN (seq=100)    │
    │───────────────────▶│
    │                    │
    │  SYN-ACK (seq=300) │
    │◀───────────────────│
    │                    │
    │   ACK (seq=101)    │
    │───────────────────▶│
    │                    │
```

- **6 diagram styles:** sequence diagrams, flowcharts, RFC-style protocol headers, architecture layers, side-by-side comparisons, tree hierarchies
- **Researches first** — uses WebSearch to verify accuracy against official docs, RFCs, and standards
- **Educational explanation** with each diagram: what it shows, why it works this way, key concepts, common pitfalls, source links
- **Auto-saves** to both project-local `docs/` and global `~/.local/share/claude-education/docs/`
- Max 78 characters wide, Unicode box-drawing characters

### `/progress` — Knowledge Dashboard

```
> /progress

══════════════════════════════════════════════════
  KNOWLEDGE DASHBOARD
══════════════════════════════════════════════════

  Overall: 10 topics tracked · 5 quizzes taken · avg score: 74%

  Solid (3)          ██████████████░░░░░░  30%   depth: ██ working
  Learned (5)        ██████████░░░░░░░░░░  50%   depth: █░ surface
  Weak (2)           ████░░░░░░░░░░░░░░░░  20%

──────────────────────────────────────────────────
  DUE FOR REVIEW (next_review <= today)
──────────────────────────────────────────────────
  · tcp-basics — was solid, due since 2026-03-18
  · recursion — learned, due since 2026-03-17

──────────────────────────────────────────────────
  UNRESOLVED MISCONCEPTIONS (2 total)
──────────────────────────────────────────────────
  · tcp-congestion: "confused slow start with congestion avoidance"
  · udp: "thought UDP has flow control"

──────────────────────────────────────────────────
  GOALS
──────────────────────────────────────────────────
  · Pass OS exam — deadline: 2026-06-15 (88 days away)
    Progress: 3/10 topics solid

══════════════════════════════════════════════════
  Suggestion: 2 topics are due for review. Start
  with /quiz-me tcp-basics.
══════════════════════════════════════════════════
```

- **Due for review** at the top — the most actionable info, based on spaced repetition schedule
- **Depth tracking** per topic — `surface` (heard it), `working` (used it correctly), `deep` (can explain to others)
- **Unresolved misconceptions** — all open misconceptions across all topics
- **Goal progress** — tracks goals from your profile with deadline countdowns
- **Actionable suggestions** — concrete next step based on current state

### `/challenge` — Mini-Tasks

Focused exercises adapted to your learning type and current needs:

- **Project:** "Write a function that creates a TCP socket, binds to port 0, and prints the assigned port"
- **Technology:** "Your Kafka consumer group has 6 consumers but 4 partitions. What happens?"
- **Theory:** "Trace quicksort on [3, 6, 1, 8, 2]. Show each partition step."

Key features:
- **Targets depth promotion** — picks topics at `surface` depth to push toward `working` via hands-on practice
- **Designs around misconceptions** — if you have an unresolved misconception, the challenge is built to expose and address it
- Shows difficulty, estimated time, and what the challenge targets
- Updates topic depth and status based on your answer
- Only challenges on material already covered

### `/motivate` — Motivation Boost

Fetches a real quote from an API and delivers personalized encouragement:

```
> /motivate

╔══════════════════════════════════════════════════╗
║                                                  ║
║  "If you can't solve a problem, then there is    ║
║   an easier problem you can solve: find it."     ║
║                                                  ║
║                        — George Polya            ║
║                                                  ║
╚══════════════════════════════════════════════════╝

You've already conquered 3 topics this week. This one's
no different — just needs a different angle.
```

- **Real quotes** fetched live from ZenQuotes and Forismatic APIs
- **Verified fallback** — 18 hardcoded quotes from Feynman, Curie, Dijkstra, Turing, Knuth, Polya, etc.
- **Personalized** — uses your name, interests, and actual progress from the DB
- **Auto-triggers** on frustration, 3+ wrong quiz answers, or failed challenges — no need to ask

### `/summary` — Session Recap

Run at the end of a session. Full progress save:

```
> /summary

══════════════════════════════════════════════════
  SESSION SUMMARY — 2026-03-19
══════════════════════════════════════════════════

  LEARNED TODAY
    ✓ socket() — creation, file descriptors, kernel structures
    ✓ bind() — port assignment, network byte order
    ~ listen() — started but not finished

  QUIZ RESULTS
    · tcp-basics: 8/10 (80%) — promoted to solid!

  MISCONCEPTIONS
    ✓ tcp-basics: "SYN+ACK vs ACK" — resolved this session!

  SPACED REPETITION SCHEDULE
    Tomorrow: listen()
    In 4 days: tcp-basics
    In 8 days: bind()

  NEXT SESSION
    1. Review: listen() backlog parameter
    2. Continue: accept() and the echo server
    3. Next new topic: multi-threading

══════════════════════════════════════════════════
```

- **Full DB flush** — updates all topic files, dashboard, session log, project-local tracking
- **Depth changes** — shows surface→working→deep transitions
- **Misconception status** — resolved and still-open
- **Spaced repetition schedule** — what's coming up in the next days
- **Goal progress** — how today's session moved you toward your goals
- **Next session plan** — prioritized list of what to do next

### `/save-progress` — Mid-Session Checkpoint

Saves all progress to the DB without ending the session:

```
> /save-progress

── Progress Saved ────────────────────────
  Topics updated: tcp-basics, udp
  Quizzes saved: 1
  Misconceptions recorded: 1
  Dashboard synced: ✓

  Keep going! Your progress is safe.
──────────────────────────────────────────
```

- Non-destructive — only adds/updates, never deletes
- Quick confirmation to keep momentum
- Use anytime you want a safety checkpoint

## Hooks

The plugin includes 4 hooks that automate the teaching workflow. `/init-edu` configures these in `.claude/settings.json` automatically.

| Hook | Event | What it does |
|------|-------|-------------|
| **session-start-load-db** | `SessionStart` | Reads your profile and dashboard, flags topics due for spaced repetition review, injects your name and stats into context so the tutor greets you personally |
| **stop-save-progress** | `Stop` | Blocks session end until progress is saved to the DB. Skips if `/summary` already ran. Prevents infinite loops automatically. |
| **post-code-review** | `PostToolUse` (Edit/Write) | After code files are written, reminds the tutor to ask pedagogical questions ("What happens if...?", "Why did you choose...?") instead of moving on. Skips config/docs/DB files. |
| **post-quiz-motivate** | `PostToolUse` (Bash) | When student's code fails (non-zero exit), suggests encouragement or `/motivate`. Skips internal commands (git, npm, etc.) |

## How Knowledge Tracking Works

All skills share a unified, persistent education DB:

```
┌───────────┐     ┌──────────────────────────┐     ┌────────────┐
│ /quiz-me  │────▶│                          │◀────│ /challenge │
│           │     │  ~/.local/share/          │     │            │
│ /progress │────▶│    claude-education/      │◀────│ /summary   │
│           │     │                          │     │            │
│ /motivate │────▶│  student.json            │◀────│ /save-     │
│           │     │  dashboard.json          │     │  progress  │
│/illustrate│────▶│  topics/*.json           │◀────│            │
│           │     │  quizzes/*.json          │     │ /init-edu  │
│  hooks    │────▶│  sessions/*.jsonl        │     │            │
│           │     │  docs/*.md              │     │            │
└───────────┘     └──────────────────────────┘     └────────────┘
```

### DB Structure

```
~/.local/share/claude-education/
├── student.json       # Your profile (name, interests, learning style, goals)
├── dashboard.json     # Overview: all topic statuses, stats, current focus
├── topics/            # One file per topic — status, depth, misconceptions, review schedule
├── quizzes/           # Every quiz ever taken — the grade book
├── sessions/          # Session logs (JSONL) — what happened each day
└── docs/              # Saved explanations (markdown) — reusable across projects
```

### Topic Status

| Status | Meaning | How to advance |
|--------|---------|----------------|
| **Weak** | Got wrong or didn't know | Re-explanation targeting specific misconception |
| **Learned** | Explained, says they understand | Score >=80% on quiz or complete a challenge |
| **Solid** | Demonstrated multiple times | Maintained via spaced repetition reviews |

### Topic Depth

| Depth | Meaning | How to advance |
|-------|---------|----------------|
| **Surface** | Heard the explanation | Use it correctly in a quiz or challenge |
| **Working** | Used the concept correctly | Explain reasoning, handle edge cases |
| **Deep** | Can explain to others | Connects to other topics, teaches it back |

### Spaced Repetition

- Topic moves to `learned` → review in 1 day
- Successful review → interval doubles (1d → 2d → 4d → 8d → 16d...)
- Failed review → interval resets to 1 day, status demotes to `weak`
- Topics solid for 30+ days → brief spot check

### Misconception Tracking

When you get something wrong, the tutor doesn't just mark it `weak` — it records:
- **What you said** (your exact wrong answer/reasoning)
- **Why it's wrong** (the specific misunderstanding)
- **Resolved status** (tracked until you demonstrate correct understanding)

Future quizzes and challenges specifically target your unresolved misconceptions.

## Default Behavior

Teaching mode is **always on** once initialized — no need to activate it each session:

- Greets you by name at session start (via hook)
- Loads your profile, progress, and spaced repetition schedule
- Reviews weak topics and unresolved misconceptions before teaching new ones
- Uses your interests for analogies (gaming? music? cooking?)
- Avoids things you listed as dislikes or frustrations
- Quizzes you every 2-3 concepts
- Asks "explain your thinking" on ~30% of correct answers
- Researches topics via web search before explaining — provides source links
- Suggests `/illustrate` for visual topics
- Adapts difficulty in real time
- Saves explanations to `docs/` automatically
- Auto-saves progress when the session ends (via hook)
- Offers motivation when you're struggling (via hook)
- Reviews code pedagogically — asks questions before fixing (via hook)

## Example Workflow

```
Day 1:
  /init-edu                    → full onboarding + project setup
  "teach me about sockets"     → tutor researches, explains with analogies from your interests
  /illustrate TCP handshake    → ASCII diagram + explanation with sources
  /challenge                   → "write a function that binds to port 0..."
  /summary                     → recap, spaced repetition schedule set

Day 2:
  (hook loads your profile)    → "Hey {name}! tcp-basics is due for review"
  /quiz-me tcp-basics          → targets your misconceptions first
  (continue learning)          → new concepts with periodic quizzes
  /save-progress               → mid-session checkpoint
  /progress                    → see dashboard with depth levels
  /summary                     → next session plan ready

Day 3:
  (hook: 2 topics due)         → quick review quiz before new material
  /quiz-me sockets             → 9/10! Promoted to Solid
  /illustrate active vs passive FTP
  (stuck on something)         → hook auto-triggers /motivate
  /summary                     → 7 topics solid, ready for next chapter
```

## Updating

From the project where the plugin is installed:

```bash
claude plugins update claude-teacher@claude-teacher-marketplace --scope project
```

Use the same `--scope` you used during install (`project`, `user`, or `local`). Restart the session after updating.

## Uninstall

```bash
claude plugins uninstall claude-teacher
```

## License

MIT
