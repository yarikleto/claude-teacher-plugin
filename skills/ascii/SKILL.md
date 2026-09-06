---
name: ascii
description: "DEFAULT diagram skill — simplest tier. Use when user invokes /claude-teacher:ascii OR when suggesting a quick visual. Creates ASCII art rendered inline in terminal — zero friction. Escalate to /claude-teacher:excalidraw for complex static diagrams (5+ components, multi-layer). Escalate to /claude-teacher:demo for animated/dynamic concepts (protocol handshakes, algorithm traces, state transitions)."
argument-hint: "[concept]"
---

Requested topic/task: $ARGUMENTS

Before accessing education data, read `${CLAUDE_PLUGIN_ROOT}/references/education-data.md`. Resolve every `<education-db>` below using that contract. Current session ID: `${CLAUDE_SESSION_ID}`.

# ASCII

Create ASCII art diagrams with detailed educational explanations. All output is pure Unicode box-drawing art — renders in any modern terminal, no external tools needed.

## Invocation

`/claude-teacher:ascii <concept description>`

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
3. **Research the concept** using WebSearch before creating the diagram — verify accuracy against official docs, RFCs, or standards. Include source links.
4. **Create the diagram** in a `text` code block:
   - Max width 78 characters
   - Generous whitespace — padding inside boxes
   - Standardize box widths where possible
   - Center vertical connectors under boxes
   - Break complex concepts into multiple smaller diagrams
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
2. **Save to global** `<education-db>/docs/<concept-name>.md` (for general concepts)
3. **Append to session log** `<education-db>/sessions/[date].jsonl`:
   ```jsonl
   {"time": "[now]", "event": "ascii", "topic": "[concept-slug]", "saved_to": "global|project|both"}
   ```
4. If the concept corresponds to a tracked topic, update only `last_seen`; preserve its assessment dates and review interval

## Integration with Other Skills

This skill is part of the **claude-teacher** plugin:

- **`/claude-teacher:quiz-me`** — if a student gets a visual concept wrong during a quiz, suggest illustrating it.
- **`/claude-teacher:challenge`** — challenges may need diagrams as part of the answer.
- **`/claude-teacher:progress`** — diagrams count toward topic engagement.
- Diagrams saved to `docs/` become the student's personal reference library.
- The tutor (via CLAUDE.md) will suggest `/claude-teacher:ascii` when visual explanation helps.
