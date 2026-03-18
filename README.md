<p align="center">
  <img src="assets/banner.svg" alt="Claude Teacher — The AI tutor plugin for Claude Code" width="100%"/>
</p>

<p align="center">
  <strong>The most attentive AI tutor for Claude Code</strong><br/>
  Teaches by guiding, not giving answers. Tracks your knowledge across sessions.<br/>
  Quizzes with spaced repetition. Catches wrong reasoning. Adapts to you.
</p>

<p align="center">
  <a href="#installation"><img src="https://img.shields.io/badge/Claude_Code-plugin-blue?style=flat-square" alt="Claude Code Plugin"/></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="MIT License"/></a>
  <a href="#skills"><img src="https://img.shields.io/badge/skills-8-orange?style=flat-square" alt="8 Skills"/></a>
  <a href="#hooks"><img src="https://img.shields.io/badge/hooks-4-purple?style=flat-square" alt="4 Hooks"/></a>
</p>

---

## Why Claude Teacher?

Most AI tools give you the answer and move on. **Claude Teacher makes you earn it** — through the Socratic method, targeted quizzes, and challenges designed around your specific misunderstandings. It's the difference between copying from Stack Overflow and actually understanding the code you write.

**It remembers everything.** Your progress, misconceptions, and learning style persist across sessions and projects. Come back next week — the tutor picks up exactly where you left off.

---

## Quick Start

```bash
# 1. Add the marketplace (one time)
claude plugins marketplace add https://github.com/yarikleto/claude-teacher-plugin

# 2. Install in your project
cd your-project
claude plugins install claude-teacher --scope project
```

**That's it.** Start a new Claude Code session — the plugin detects you're a new student and automatically runs onboarding. It will ask your name, how you learn best, and what you're studying. After that, just start learning.

> You can also run `/init-edu` manually at any time to set up a new project or re-do onboarding.

---

## What Happens After Setup

Teaching mode is **always on**. No commands needed. Just talk to Claude:

> *"Teach me about TCP sockets"*

The tutor will:

1. Research the topic via web search (never hallucinates — always provides sources)
2. Explain using analogies from **your** interests
3. Give you code skeletons with `???` to fill in
4. Quiz you after 2-3 concepts
5. Ask "explain your thinking" to catch wrong reasoning
6. Track everything in your personal knowledge DB
7. Auto-save progress when you leave

---

## Skills

### `/init-edu` — Onboarding & Project Setup

<details>
<summary>Full onboarding in one command</summary>

**Student profile (first time only):**
- Name, age, native language
- Background, level, known technologies
- Learning style, frustrations, motivations
- Goals with deadlines, time commitment
- Interests and dislikes (used for analogies and tone)

**Project setup:**
- `CLAUDE.md` — teaching rules adapted to your learning type, with your Student Profile at the top
- `.claude/settings.json` — Explanatory output style + hooks
- `docs/` — directory for saved explanations
- Global education DB at `~/.local/share/claude-education/`
- Project-local knowledge tracking

</details>

### `/quiz-me [topic]` — Adaptive Quizzes

```
> /quiz-me TCP sockets

Q1 (medium): What is the correct order of server socket calls?

  a) socket() → listen() → bind() → accept()
  b) socket() → bind() → listen() → accept()
  c) bind() → socket() → listen() → accept()
  d) socket() → connect() → listen() → accept()
```

| Feature | How it works |
|---------|-------------|
| **Misconception-first** | Reads your unresolved misconceptions, crafts questions to test them |
| **Spaced repetition** | Picks topics due for review based on scheduling algorithm |
| **Adaptive difficulty** | Increases after 2+ correct, decreases after 2+ wrong |
| **"Explain your thinking"** | ~30% of correct answers get a "Why?" follow-up |
| **Full recording** | Every question, answer, and score saved to the grade book |
| **Auto-promotion** | Score >=80% → promotes toward Solid. <50% → demotes to Weak |

### `/illustrate [concept]` — ASCII Diagrams

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

6 styles: sequence diagrams, flowcharts, RFC-style protocol headers, architecture layers, comparisons, tree hierarchies. Researches official docs before drawing. Auto-saves to your reference library.

### `/progress` — Knowledge Dashboard

```
══════════════════════════════════════════════════
  KNOWLEDGE DASHBOARD
══════════════════════════════════════════════════

  Overall: 10 topics · 5 quizzes · avg 74%

  Solid (3)     ██████████████░░░░░░  30%
  Learned (5)   ██████████░░░░░░░░░░  50%
  Weak (2)      ████░░░░░░░░░░░░░░░░  20%

  DUE FOR REVIEW
  · tcp-basics — due since Mar 18
  · recursion — due since Mar 17

  UNRESOLVED MISCONCEPTIONS
  · tcp-congestion: "confused slow start with congestion avoidance"

  GOALS
  · Pass OS exam — 88 days away — 3/10 topics solid
══════════════════════════════════════════════════
```

Shows depth tracking (`surface` → `working` → `deep`), spaced repetition schedule, misconceptions, goal progress with deadline countdowns.

### `/challenge` — Mini-Tasks

Hands-on exercises designed around your weak spots:

| Learning type | Example |
|--------------|---------|
| **Project** | *"Write a function that creates a TCP socket, binds to port 0, and prints the assigned port"* |
| **Technology** | *"Your Kafka consumer group has 6 consumers but 4 partitions. What happens?"* |
| **Theory** | *"Trace quicksort on [3, 6, 1, 8, 2]. Show each partition step."* |

Targets `surface` → `working` depth promotion. Designs challenges around your unresolved misconceptions.

### `/motivate` — Motivation Boost

```
╔══════════════════════════════════════════════════╗
║                                                  ║
║  "If you can't solve a problem, then there is    ║
║   an easier problem you can solve: find it."     ║
║                                                  ║
║                          — George Polya           ║
║                                                  ║
╚══════════════════════════════════════════════════╝

You've conquered 3 topics this week. This one's no different
— just needs a different angle.
```

Real quotes fetched live from APIs (ZenQuotes, Forismatic). 18 verified fallback quotes from Feynman, Curie, Dijkstra, Turing, Knuth, Polya. **Auto-triggers** when the tutor detects frustration or repeated failures.

### `/summary` — Session Recap

```
══════════════════════════════════════════════════
  SESSION SUMMARY — 2026-03-19
══════════════════════════════════════════════════

  LEARNED TODAY
    ✓ socket() — creation, file descriptors
    ✓ bind() — port assignment, byte order
    ~ listen() — started, not finished

  QUIZ RESULTS
    · tcp-basics: 8/10 (80%) — promoted to solid!

  SPACED REPETITION SCHEDULE
    Tomorrow: listen()
    In 4 days: tcp-basics

  NEXT SESSION
    1. Review: listen() backlog parameter
    2. Continue: accept() and the echo server
    3. Next new topic: multi-threading
══════════════════════════════════════════════════
```

Full DB flush: updates topics, dashboard, session log. Shows depth transitions, resolved misconceptions, goal progress, and a prioritized plan for next time.

### `/save-progress` — Mid-Session Checkpoint

Quick save without ending the session. Use anytime you want a safety checkpoint.

### `/reset-edu` — Delete All Data

Wipes everything: profile, quiz history, topic progress, session logs, saved docs. Asks for confirmation before deleting.

```
> /reset-edu

This will permanently delete:
  · Your student profile (name, goals, learning style)
  · All quiz history and scores
  · All topic progress and misconceptions
  · All session logs
  · All saved explanations

Are you sure? Type YES to confirm.
```

Run `/init-edu` afterward to start fresh.

---

## Hooks

The plugin includes 4 hooks that automate the teaching workflow. Configured automatically by `/init-edu`.

| Hook | Trigger | What it does |
|------|---------|-------------|
| **session-start-load-db** | Session start | Loads your profile, flags topics due for review, greets you by name |
| **stop-save-progress** | Session end | Auto-saves progress to the DB so you never lose work |
| **post-code-review** | After code edit | Reminds tutor to ask pedagogical questions instead of just moving on |
| **post-quiz-motivate** | After code fails | Suggests encouragement when your code throws errors |

---

## Learning Types

`/init-edu` adapts to what you're studying:

| Type | Example | Claude focuses on |
|------|---------|-------------------|
| **Project** | FTP server, budget tracker, game | Skeletons, incremental building, hands-on review |
| **Subject / field** | Finance, psychology, math, CS | Concepts, real-world scenarios, comparisons, "why it matters" |
| **Exam prep** | OS exam, job interview, certification | Key concepts, practice questions, weak spots, timed drills |

---

## How It Tracks Your Knowledge

### Global Education DB

Your progress persists across all projects in `~/.local/share/claude-education/`:

```
~/.local/share/claude-education/
├── student.json       Your profile — name, interests, learning style, goals
├── dashboard.json     All topic statuses and stats at a glance
├── topics/            One file per topic — status, depth, misconceptions, review schedule
├── quizzes/           Every quiz ever taken — the grade book
├── sessions/          Session logs — what happened each day
└── docs/              Saved explanations — reusable across projects
```

### Topic Progression

```
  Weak ──────────► Learned ──────────► Solid
  (got it wrong)   (explained, understood)   (proven multiple times)
```

Each topic also tracks **depth**:

| Depth | Meaning | How to advance |
|-------|---------|----------------|
| `surface` | Heard the explanation | Use it correctly in a quiz or challenge |
| `working` | Used it correctly | Explain your reasoning, handle edge cases |
| `deep` | Can teach it to others | Connect to other topics, no misconceptions |

### Spaced Repetition

```
Day 1 ──► Day 2 ──► Day 4 ──► Day 8 ──► Day 16 ──► ...
         (pass)    (pass)    (pass)    (pass)

Day 1 ──► Day 2 ──► FAIL ──► Day 1 (reset)
```

Review intervals double on success, reset to 1 day on failure.

### Misconception Tracking

When you get something wrong, the tutor records **what you said** and **why it's wrong** — not just "incorrect." Future quizzes and challenges specifically target your unresolved misconceptions until you demonstrate correct understanding.

---

## Example Workflow

```
Day 1:
  /init-edu                      Onboarding + project setup
  "teach me about sockets"       Tutor researches, explains with your analogies
  /illustrate TCP handshake      ASCII diagram + sources
  /challenge                     "write a function that binds to port 0..."
  /summary                       Recap + spaced repetition schedule

Day 2:
  (hook greets you)              "Hey! tcp-basics is due for review"
  /quiz-me tcp-basics            Targets your misconceptions first
  (continue learning)            New concepts with periodic quizzes
  /save-progress                 Mid-session checkpoint
  /progress                      Dashboard with depth levels

Day 3:
  (hook: 2 topics due)           Quick review quiz before new material
  /quiz-me sockets               9/10! Promoted to Solid
  /illustrate FTP modes          Active vs passive side-by-side
  (stuck on something)           Auto-triggers /motivate
  /summary                       7 topics solid, next chapter ready
```

---

## Re-initialization

Made a mistake during setup? Run `/init-edu` again:

```
Welcome back! What would you like to do?

  a) Set up this project for learning (keep my profile)
  b) Update my profile (change name, interests, goals, etc.)
  c) Full reset — start fresh (wipes profile, keeps learning progress)
  d) Complete reset — wipe everything (profile + all progress)
```

---

## Updating

```bash
claude plugins update claude-teacher@claude-teacher-marketplace --scope project
```

Use the same `--scope` you used during install. Restart the session after updating.

## Uninstall

```bash
claude plugins uninstall claude-teacher
```

---

<p align="center">
  <strong>Stop copying code. Start understanding it.</strong><br/>
  <sub>MIT License</sub>
</p>
