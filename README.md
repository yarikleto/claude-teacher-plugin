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

## Default Behavior

Teaching mode is **always on** once initialized — no need to activate it each session. The tutor will:

- Check your knowledge profile at session start
- Review weak topics before teaching new ones
- Quiz you every 2-3 concepts
- Research topics via web search before explaining — provides source links
- Suggest `/illustrate` for visual topics
- Adapt difficulty in real time
- Automatically save explanations to `docs/` for future reference

## Example Workflow

```
Day 1:
  /init-edu                    → set up project
  (start learning)             → tutor guides you through basics
  /summary                     → recap and plan for next time

Day 2:
  (tutor reviews weak topics)  → "Quick check: what does bind() do?"
  (continue learning)          → new concepts with periodic quizzes
  /challenge                   → practice exercise
  /progress                    → see how far you've come

Day 3:
  /quiz-me sockets             → 9/10! Most topics now Solid
  /illustrate active vs passive FTP
  /summary                     → ready for the next chapter
```

## Updating

```bash
claude plugins update claude-teacher
```

If you installed from a specific marketplace, the update pulls the latest version from the same source.

## Uninstall

```bash
claude plugins uninstall claude-teacher
```

## License

MIT
