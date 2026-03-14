---
name: init-edu
description: Use when starting a new educational project — sets up CLAUDE.md with teaching guidelines, creates memory structure for knowledge tracking, and configures the project for learning mode
---

# Initialize Educational Project

Sets up any project for learning mode. Creates the local CLAUDE.md with teaching instructions and initializes knowledge tracking.

## What It Does

1. Configures `.claude/settings.json` with educational output style
2. Creates or updates `CLAUDE.md` with educational guidelines
3. Creates `docs/` directory for saving explanations
4. Initializes knowledge tracking in Claude's project memory

## Process

When invoked, perform these steps:

### Step 1: Configure Claude Settings

Create or update `.claude/settings.json` to enable educational output style:

```json
{
  "outputStyle": "Explanatory"
}
```

If `.claude/settings.json` already exists, merge the `outputStyle` field — do NOT overwrite other settings. Read the file first, add/update only the `outputStyle` key.

Create `.claude/` directory if it doesn't exist:
```bash
mkdir -p .claude
```

**Note:** The output style takes effect on the next session. Inform the student:
```
Output style set to "Explanatory" — restart the session to activate it.
```

### Step 2: Ask About the Project

Ask the student ONE question:
```
What are you learning in this project? (e.g., "FTP server with C++ sockets", "React todo app", "sorting algorithms in Python")
```

### Step 3: Create CLAUDE.md

Write a `CLAUDE.md` in the project root with this template (adapt the topic):

```markdown
# [Project Name] - Educational Project

## Purpose
This is an educational project for learning [topic]. The student is building [what] to understand [concepts].

## Claude's Role
- **Teach, don't solve.** Explain concepts, trade-offs, and reasoning behind decisions.
- **Guide the student** through implementation rather than writing complete solutions.
- When asked to implement something, explain the "why" alongside the "how."
- Point out relevant standards, docs, or RFCs when applicable.
- Highlight common pitfalls and security considerations as learning opportunities.

## Guidelines
- Prefer simple, readable code over clever optimizations — clarity aids learning.
- Add comments explaining non-obvious logic.
- When introducing a new concept, briefly explain it.
- Suggest incremental steps rather than large, monolithic implementations.
- Encourage writing tests as a way to verify understanding.
- Use the Socratic method — ask leading questions before giving answers.
- After every 2-3 new concepts, do a quick knowledge check.
- Track what the student knows and doesn't know across sessions.

## Available Skills
- `/teach-mode` — activate full tutoring mode with knowledge tracking
- `/quiz-me [topic]` — test understanding with mixed question formats
- `/illustrate [concept]` — create ASCII diagrams to explain concepts visually
```

### Step 4: Create docs/ Directory

```bash
mkdir -p docs
```

### Step 5: Initialize Knowledge Tracking

Create the knowledge tracking file in Claude's project memory (`memory/knowledge_gaps.md`):

```markdown
---
name: knowledge_gaps
description: Topics the student struggled with or didn't know — revisit in future quizzes
type: user
---

## Weak (review next session)

(none yet)

## Learned (needs practice)

(none yet)

## Solid (demonstrated understanding)

(none yet)

## Not Yet Covered

- (to be filled based on project scope)
```

Also create `memory/MEMORY.md` index if it doesn't exist.

### Step 6: Confirm Setup

Print a summary:
```
Educational project initialized!

  .claude/settings.json .. outputStyle set to "Explanatory"
  CLAUDE.md .............. created (teaching mode active)
  docs/ .................. ready for saving explanations
  Knowledge tracking ..... initialized

  Available commands:
    /teach-mode      Start a guided learning session
    /quiz-me [topic] Test your knowledge
    /illustrate      Visualize a concept

  Note: Restart the session for output style to take effect.
  Ready to learn. What would you like to start with?
```

## If CLAUDE.md Already Exists

Read it first. If it already has educational guidelines, ask:
```
CLAUDE.md already exists with educational config. Want me to:
  a) Leave it as is
  b) Update it with the latest template
  c) Show me what's different
```
