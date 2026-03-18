---
name: illustrate
description: Use when user invokes /illustrate to create an ASCII art diagram explaining a concept — protocol flows, data structures, state machines, architecture, or any technical idea that benefits from a visual representation with educational explanation
---

# Illustrate

Create ASCII art diagrams with detailed educational explanations. All output is pure Unicode box-drawing art — renders in any modern terminal, no external tools needed.

## Invocation

`/illustrate <concept description>`

## Style Selection

| Concept Type | Style | Example Use |
|-------------|-------|-------------|
| Time-ordered (protocol flows, request/response) | Sequence diagram | TCP handshake, HTTP request |
| States/decisions (transitions, branching) | Flowchart | Connection lifecycle, error handling |
| Byte-level/structural (memory, packets, formats) | RFC-style grid or table | TCP header, packet layout |
| Relationships/architecture (components, deps) | Box-and-line with layers | System architecture, module deps |
| Comparisons (A vs B) | Side-by-side or before/after | Active vs passive mode |
| Hierarchies (trees, org charts) | Tree with branches | Directory structure, class hierarchy |

## Character Toolkit

**Visual hierarchy through line weight:**

| Weight | Characters | Use For |
|--------|-----------|---------|
| Double | `═ ║ ╔ ╗ ╚ ╝ ╠ ╣ ╦ ╩ ╬` | Outer boundaries, system borders, emphasis |
| Single | `─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼` | Standard boxes, connections |
| Rounded | `╭ ╮ ╰ ╯` | Softer/informal elements |
| Dashed | `┄ ┆` or `- - -` | Optional, conditional, weak relationships |
| Heavy | `━ ┃ ┏ ┓ ┗ ┛` | Bold emphasis |

**Arrows:** `→ ← ↑ ↓ ↔` standard, `▶ ◀ ▲ ▼` filled, `⇒ ⇐` double

**Fill/shading:** `░` light, `▒` medium, `▓` dark, `█` full

**Elision:** `⋮` vertical omission, `⋯` horizontal omission

## Style Recipes

### Sequence Diagram
```text
  Client              Server
    │                    │
    │   SYN (seq=x)      │
    │───────────────────▶│
    │                    │
    │  SYN-ACK (seq=y)   │
    │◀───────────────────│
    │                    │
```
- Vertical lifelines per actor, names at top
- Horizontal arrows with labels above
- Consistent column spacing and arrow lengths

### Flowchart
```text
  ┌─────────┐
  │  Start  │
  └────┬────┘
       │
       ▼
  condition? ──no──▶ Action B
       │                 │
      yes                │
       │                 │
       ▼                 │
  Action A               │
       │                 │
       ◀─────────────────┘
```
- Avoid ASCII diamond shapes — use `condition?` with branching labels instead
- Label branches on the arrows

### RFC-Style Protocol Header
```text
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
- Each `-+-` = one bit, centered field names
- Use pure ASCII for this style — IETF convention

### Architecture / Layer Diagram
```text
╔═══════════════════════════════╗
║      Presentation Layer       ║
║  ┌────────┐    ┌───────────┐  ║
║  │  CLI   │    │  REST API │  ║
║  └───┬────┘    └─────┬─────┘  ║
╠══════╪════════════════╪═══════╣
║      ▼   Service Layer▼       ║
║  ┌────────────────────────┐   ║
║  │      Core Logic        │   ║
║  └───────────┬────────────┘   ║
╚══════════════╪════════════════╝
               ▼
         ┌──────────┐
         │ Database │
         └──────────┘
```
- Double-line for system boundaries
- Single-line for components inside
- Horizontal dividers between layers

## Process

1. **Analyze** the concept — what type of information is it?
2. **Pick style** using the selection table
3. **Create the diagram** in a `text` code block:
   - Max width 78 characters
   - Generous whitespace — padding inside boxes
   - Standardize box widths where possible
   - Center vertical connectors under boxes
   - Break complex concepts into multiple smaller diagrams
4. **Research the concept** using WebSearch before creating the diagram — verify accuracy against official docs, RFCs, or standards. Include source links.
5. **Write educational explanation:**
   - **What it shows** — walk through the diagram
   - **Why it works this way** — reasoning behind the design
   - **Key concepts** — define terms that might be new
   - **Common pitfalls** — what people often misunderstand
   - **Sources** — links to official docs, RFCs, or standards used
6. **Save to docs/** — automatically save the diagram and explanation to `docs/<concept-name>.md` for future reference.

## Quality Rules

- Never mix pure ASCII (`+ - |`) with Unicode box-drawing in the same diagram
- Align everything carefully — misaligned ASCII art is worse than no diagram
- Use 2+ space gaps between unrelated elements
- Keep consistent arrow lengths in sequence diagrams
- If a diagram exceeds ~40 lines or ~10 nodes, split it up

## DB Integration

After creating the diagram and explanation:

1. **Save to project-local** `docs/<concept-name>.md` (for project-specific concepts)
2. **Save to global** `~/.local/share/claude-education/docs/<concept-name>.md` (for general concepts)
3. **Append to session log** `~/.local/share/claude-education/sessions/[date].jsonl`:
   ```jsonl
   {"time": "[now]", "event": "illustrate", "topic": "[concept-slug]", "saved_to": "global|project|both"}
   ```
4. If the concept corresponds to a tracked topic, update `last_reviewed` in its topic file

## Integration with Other Skills

This skill is part of the **claude-teacher** plugin:

- **`/quiz-me`** — if a student gets a visual concept wrong during a quiz, suggest illustrating it.
- **`/challenge`** — challenges may need diagrams as part of the answer.
- **`/progress`** — diagrams count toward topic engagement.
- Diagrams saved to `docs/` become the student's personal reference library.
- The tutor (via CLAUDE.md) will suggest `/illustrate` when visual explanation helps.
