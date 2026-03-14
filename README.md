# Claude Teacher

> The most attentive AI tutor for Claude Code — teaches by guiding, tracks your knowledge across sessions, quizzes you with spaced repetition, and adapts to your level.

Built for students, self-learners, and anyone using Claude Code to study programming, networking, algorithms, or any technical subject.

## What It Does

Instead of writing code for you, Claude becomes a **personal tutor** that:

- **Guides, not solves** — gives you skeletons with `???` to fill in, asks leading questions
- **Tracks what you know** — remembers your weak spots across sessions
- **Quizzes you** — periodic knowledge checks with adaptive difficulty
- **Draws diagrams** — ASCII art explanations for complex concepts
- **Saves your notes** — builds a personal `docs/` reference library as you learn

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

This sets up `CLAUDE.md`, enables Explanatory output style, and creates knowledge tracking. Restart the session after init.

## Skills

### `/init-edu` — Project Setup

Run once per project. It will:

- Ask what you're learning
- Create `CLAUDE.md` with teaching guidelines
- Set `outputStyle: "Explanatory"` in `.claude/settings.json`
- Initialize knowledge tracking in memory

```
> /init-edu

What are you learning in this project?
> Building an FTP server with C++ sockets

Educational project initialized!
  .claude/settings.json .. outputStyle set to "Explanatory"
  CLAUDE.md .............. created (teaching mode active)
  docs/ .................. ready for saving explanations
  Knowledge tracking ..... initialized
```

### `/teach-mode` — Interactive Tutoring

Activates the full tutoring experience. Claude will:

- Check your knowledge profile from previous sessions
- Review weak topics before teaching new ones
- Explain concepts with the **Socratic method** (questions before answers)
- Give you code skeletons to fill in yourself
- Mini-quiz you every 2-3 concepts
- Offer to save explanations to `docs/`

```
> /teach-mode

Welcome back! Last session you learned about socket() and bind().
Quick check before we continue:

  What does bind(0) do?
```

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

Features:
- Multiple choice + open-ended questions
- Adapts difficulty based on your answers
- Prioritizes weak topics from knowledge tracking
- Score summary at the end

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
    │  Connection Open   │
```

Supports: sequence diagrams, flowcharts, architecture layers, protocol headers, data structures, side-by-side comparisons.

## How Knowledge Tracking Works

All skills share a unified knowledge profile stored in Claude's project memory:

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│ /teach-mode │────▶│              │◀────│  /quiz-me   │
│  teaches    │     │ knowledge_   │     │  tests      │
│  explains   │────▶│ gaps.md      │◀────│  scores     │
└─────────────┘     │              │     └─────────────┘
                    │ Weak         │
                    │ Learned      │
                    │ Solid        │
                    │ Not covered  │
                    └──────────────┘
```

Topics progress through stages:

| Stage | Meaning | How to advance |
|-------|---------|----------------|
| **Weak** | Got it wrong or didn't know | Needs re-explanation |
| **Learned** | Explained, says they understand | Answer a quiz correctly or write working code |
| **Solid** | Demonstrated multiple times | Done (reviewed after 2+ weeks) |

The tutor automatically:
- Starts sessions by reviewing weak topics
- Prioritizes weak areas in quizzes
- Won't build on concepts that aren't solid yet
- Celebrates when you level up a topic

## Example Workflow

```
Day 1:
  /init-edu                    → set up project
  /teach-mode                  → learn sockets basics
                               → mini-quiz after 3 concepts
                               → "save to docs?" → yes

Day 2:
  /teach-mode                  → "Let's review: what does bind() do?"
                               → continue with listen() and accept()
  /quiz-me sockets             → 7/10, struggle with passive mode

Day 3:
  /teach-mode                  → focuses on passive mode (weak area)
  /illustrate active vs passive FTP
  /quiz-me FTP                 → 9/10!
```

## Uninstall

```bash
claude plugins uninstall claude-teacher
```

## License

MIT
