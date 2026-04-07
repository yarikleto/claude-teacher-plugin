# Excalidraw Color Palette — Educational Diagrams

Consistent semantic colors for teaching diagrams. Every color choice should carry meaning.

## Shape Colors (Fill + Stroke)

| Role | Fill | Stroke | When to Use |
|------|------|--------|-------------|
| **Primary / Neutral** | `#a5d8ff` | `#1971c2` | Main concepts, default boxes, core components |
| **Secondary** | `#d0ebff` | `#1c7ed6` | Supporting concepts, secondary flows, helpers |
| **Tertiary** | `#e7f5ff` | `#339af0` | Background grouping, subtle containers, context |
| **Start / Trigger** | `#ffd8a8` | `#e8590c` | Entry points, triggers, initial events, requests |
| **End / Success** | `#b2f2bb` | `#2f9e44` | Completion, success states, final outputs, responses |
| **Warning / Reset** | `#ffc9c9` | `#e03131` | Errors, failures, resets, danger zones, wrong paths |
| **Decision** | `#ffec99` | `#e67700` | Decision nodes, conditionals, branching points |
| **Highlight / Active** | `#d0bfff` | `#7048e8` | Current step, focus area, "you are here", emphasis |
| **Error** | `#ffe3e3` | `#c92a2a` | Bugs, exceptions, invalid states (distinct from Warning) |
| **Evidence Artifact** | `#1e293b` | `#334155` | Code blocks, JSON payloads, real data, terminal output |

## Evidence Artifact Details

Evidence artifacts show real code, JSON, event names, or terminal output inside the diagram. They use a dark background to visually separate "concrete evidence" from "abstract concepts."

- **Background:** `#1e293b` (dark slate)
- **Stroke:** `#334155` (slightly lighter slate)
- **Text color:** `#22c55e` (terminal green)
- **Font:** monospace (`fontFamily: 3`), fontSize 14-16
- **Use for:** code snippets, JSON payloads, CLI commands, event names, packet contents

## Text Colors

| Role | Hex | When to Use |
|------|-----|-------------|
| **Title** | `#1e1e1e` | Diagram title, top-level heading |
| **Subtitle** | `#343a40` | Section headers, group labels |
| **Body** | `#495057` | Regular labels, descriptions, annotations |
| **On-light backgrounds** | `#1e1e1e` | Text inside light-colored shapes |
| **On-dark backgrounds** | `#22c55e` | Text inside evidence artifacts (green on dark) |
| **Muted / annotation** | `#868e96` | Source attribution, footnotes, secondary info |
| **Link / reference** | `#1971c2` | Cross-references, "see also" labels |

## Text Sizing

| Level | fontSize | Use |
|-------|----------|-----|
| Title | 28 | One per diagram, top-left or centered |
| Subtitle | 24 | Section or group headings |
| Label | 20 | Shape labels, main text inside boxes |
| Body | 16 | Annotations, descriptions, arrow labels |
| Small | 14 | Source attribution, footnotes, evidence artifact text |

## Usage Rules

1. **Never use random colors** — every color must map to a semantic role above
2. **Contrast matters** — dark text on light fills, green text on dark fills
3. **Limit palette per diagram** — use 3-4 roles max per diagram, not all 10
4. **Evidence artifacts stand out** — their dark background should be visually distinct from all other elements
5. **Consistent across diagrams** — "green always means success" across all diagrams the student sees
