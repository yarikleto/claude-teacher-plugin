# Claude Teacher

> The most attentive AI tutor for Claude Code — teaches by guiding, tracks your knowledge across sessions, quizzes with spaced repetition, and adapts to your level.

Works for any learning context: building projects, studying technologies, or learning CS theory.

## What It Does

Once installed, Claude becomes a **personal tutor by default**:

- **Guides, not solves** — gives skeletons with `???`, asks leading questions
- **Tracks what you know** — remembers weak spots across sessions
- **Quizzes you** — periodic knowledge checks with adaptive difficulty
- **Draws diagrams** — ASCII art for complex concepts
- **Adapts** — goes deeper when you're strong, simplifies when you struggle
- **Saves your notes** — builds a personal `docs/` reference library

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

This asks your learning type, sets up `CLAUDE.md` with teaching rules, enables Explanatory output style, and creates knowledge tracking. **Restart the session after init.**

## Learning Types

`/init-edu` adapts to what you're doing:

| Type | Example | Claude focuses on |
|------|---------|-------------------|
| **Project** | FTP server, todo app | Code skeletons, incremental building, code review |
| **Technology** | Kafka, Docker, K8s | Architecture, real-world scenarios, comparisons |
| **Theory** | Algorithms, OS, networking | Intuition first, formal definitions, proofs, problems |

## Skills

### `/init-edu` — Project Setup

Run once per project. Sets up everything:
- `.claude/settings.json` with Explanatory output style
- `CLAUDE.md` with full teaching rules (adapted to your learning type)
- `docs/` directory for saved explanations
- Knowledge tracking in memory

### `/quiz-me [topic]` — Knowledge Testing

Mixed-format quizzes with score tracking:

```
> /quiz-me TCP sockets

Q1 (medium): What is the correct order of server socket calls?

  a) socket() → listen() → bind() → accept()
  b) socket() → bind() → listen() → accept()
  c) bind() → socket() → listen() → accept()
  d) socket() → connect() → listen() → accept()
```

- Multiple choice + open-ended questions
- Prioritizes weak topics from knowledge tracking
- Adapts difficulty based on your answers
- Updates knowledge tracking with results

### `/illustrate [concept]` — Visual Explanations

ASCII art diagrams for any technical concept:

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

Supports: sequence diagrams, flowcharts, architecture layers, protocol headers, data structures, comparisons.

### `/progress` — Knowledge Dashboard

```
> /progress

══════════════════════════════════════════
  KNOWLEDGE DASHBOARD — TCP/IP & Sockets
══════════════════════════════════════════

  Solid (5 topics)        ██████████░░░░░░░░░░  50%
  Learned (3 topics)      ██████░░░░░░░░░░░░░░  30%
  Weak (1 topic)          ██░░░░░░░░░░░░░░░░░░  10%
  Not covered (1 topic)   ██░░░░░░░░░░░░░░░░░░  10%
```

### `/challenge` — Mini-Tasks

Focused exercises adapted to your learning type:

- **Project:** "Write a function that binds to port 0 and prints the assigned port"
- **Technology:** "Your Kafka consumer group has 6 consumers but 4 partitions. What happens?"
- **Theory:** "Trace quicksort on [3, 6, 1, 8, 2]. Show each partition step."

### `/summary` — Session Recap

Run at the end of a session:

```
> /summary

  LEARNED TODAY
    ✓ socket() — creation, file descriptors, kernel structures
    ✓ bind() — port assignment, network byte order
    ~ listen() — started but not finished

  NEXT SESSION
    1. Review: listen() backlog parameter
    2. Continue: accept() and the echo server
    3. Next new topic: multi-threading
```

## How Knowledge Tracking Works

All skills share a unified knowledge profile:

```
┌───────────┐     ┌──────────────┐     ┌───────────┐
│ /quiz-me  │────▶│              │◀────│/challenge │
│           │     │ knowledge_   │     │           │
│ /progress │────▶│ gaps.md      │◀────│ /summary  │
└───────────┘     │              │     └───────────┘
                  │ Weak         │
                  │ Learned      │
                  │ Solid        │
                  │ Not covered  │
                  └──────────────┘
```

Topics progress through stages:

| Stage | Meaning | How to advance |
|-------|---------|----------------|
| **Weak** | Got wrong or didn't know | Re-explanation needed |
| **Learned** | Explained, says they understand | Answer quiz correctly or write working code |
| **Solid** | Demonstrated multiple times | Done (reviewed after 2+ weeks) |

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

You've already conquered 3 topics this week, {name}. This one's
no different — just needs a different angle.
```

Also triggers automatically when the tutor detects frustration or repeated failures.

### `/save-progress` — Mid-Session Checkpoint

Saves all current progress to the global education DB without ending the session:

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

## Hooks

The plugin includes 4 hooks that automate the teaching workflow. `/init-edu` configures these automatically.

| Hook | Event | What it does |
|------|-------|-------------|
| **session-start-load-db** | `SessionStart` | Loads your profile and progress, flags topics due for review, greets you by name |
| **stop-save-progress** | `Stop` | Auto-saves progress to the DB before the session ends (so you never lose work) |
| **post-code-review** | `PostToolUse` (Edit/Write) | Reminds the tutor to ask pedagogical questions after code is written |
| **post-quiz-motivate** | `PostToolUse` (Bash) | Suggests encouragement when your code fails |

## Default Behavior

Teaching mode is **always on** once initialized — no need to activate it each session. The tutor will:

- Greet you by name at session start
- Check your knowledge profile and spaced repetition schedule
- Review weak topics and unresolved misconceptions before teaching new ones
- Quiz you every 2-3 concepts
- Ask "explain your thinking" on correct answers to catch wrong reasoning
- Research topics via web search before explaining — provides source links
- Suggest `/illustrate` for visual topics
- Adapt difficulty in real time
- Use your interests for analogies
- Automatically save explanations to `docs/` for future reference
- Auto-save progress when the session ends (via hooks)
- Offer motivation when you're struggling

## Global Education DB

Your learning progress persists across all projects in `~/.local/share/claude-education/`:

```
~/.local/share/claude-education/
├── student.json       # Your profile (name, interests, learning style)
├── dashboard.json     # Overview of all topics and stats
├── topics/            # One file per topic with status, depth, misconceptions
├── quizzes/           # Every quiz you've taken
├── sessions/          # Session logs
└── docs/              # Saved explanations (reusable across projects)
```

## Example Workflow

```
Day 1:
  /init-edu                    → onboarding + project setup
  (start learning)             → tutor guides you through basics
  /summary                     → recap and plan for next time

Day 2:
  (tutor greets by name)       → "Hey {name}! tcp-basics is due for review"
  /quiz-me tcp-basics          → spaced repetition quiz
  (continue learning)          → new concepts with periodic quizzes
  /challenge                   → practice exercise
  /progress                    → see how far you've come

Day 3:
  /quiz-me sockets             → 9/10! Most topics now Solid
  /illustrate active vs passive FTP
  /motivate                    → real quote + personalized encouragement
  /summary                     → ready for the next chapter
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
