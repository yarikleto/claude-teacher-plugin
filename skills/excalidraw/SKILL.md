---
name: excalidraw
description: "Middle tier — complex STATIC diagrams. Use when user invokes /excalidraw, OR when concept has 5+ components, multi-layer architecture, or detailed data structures that benefit from editable layout. Generates .excalidraw JSON files opened in excalidraw.com or VS Code. For simple visuals use /ascii. For animated/dynamic concepts (protocol handshakes, algorithm traces) use /demo instead."
---

# Excalidraw Diagram

Generate `.excalidraw` JSON files with detailed educational explanations. Produces interactive, editable diagrams the student can open in [excalidraw.com](https://excalidraw.com) or the VS Code Excalidraw extension.

## Invocation

`/excalidraw <concept description>`

---

## Philosophy

### Diagrams Should ARGUE, Not DISPLAY

A diagram is not a picture — it is a visual argument. Every shape, arrow, and color must advance the student's understanding. If an element does not teach something, remove it.

### Isomorphism Test

If you removed ALL text from the diagram, would the spatial structure alone communicate the concept? The layout, grouping, arrow directions, and color coding should carry meaning independently of labels.

### Education Test

Could someone who knows nothing about this topic learn something concrete from this diagram? Not just "see a pretty picture" but actually understand a relationship, flow, or structure they did not understand before.

---

## Reference Files (Read Before Generating)

Before generating any diagram, read these reference files:

1. **`references/color-palette.md`** — semantic color system, text colors, sizing
2. **`references/element-templates.md`** — copy-paste JSON for every element type
3. **`references/json-schema.md`** — property tables, binding rules, options

These files contain the exact hex codes, JSON templates, and schema details needed to produce valid diagrams. Do not rely on memory — read them.

---

## Depth Assessment

Before building, assess the complexity the student needs:

### Simple / Conceptual

- Abstract shapes, overview flows, high-level architecture
- 5-15 elements total
- No evidence artifacts needed
- One zoom level

### Comprehensive / Technical

- MUST include evidence artifacts (real code, real JSON, real event names, real packet contents)
- 15-50+ elements
- Multiple zoom levels
- Shows what actually happens, not just the abstract idea

Choose depth based on the student's level and the concept's complexity. When in doubt, go comprehensive — concrete evidence teaches better than abstract boxes.

---

## Multi-Zoom Architecture

Large diagrams should work at three levels of detail:

### Level 1 — Summary Flow

The bird's-eye view. 5-8 major shapes connected by arrows. A student glancing at this level gets the overall flow or structure. Use large labels (fontSize 24-28) and primary colors.

### Level 2 — Section Boundaries

Logical grouping within the flow. Dashed boundary rectangles or spatial clustering. Section headers (fontSize 20-24) label each group. This is where the diagram's "chapters" become visible.

### Level 3 — Evidence Artifacts

The concrete details. Real code, JSON payloads, event names, packet contents inside dark evidence artifact boxes. fontSize 14-16. This level answers "but what does it actually look like?"

---

## Container Discipline

Boxes around text are expensive — they add visual noise and make diagrams feel like PowerPoint slides.

### Rules

1. **Default to free-floating text.** Most labels, annotations, and descriptions should be plain text positioned near the relevant element.
2. **Add containers only when they serve a purpose:**
   - The shape IS the concept (a server, a database, a component)
   - The shape needs arrows connecting to/from it
   - The shape represents a boundary or grouping
3. **Target: <30% of text elements inside containers.** If more than 30% of your text elements have a `containerId`, you are over-boxing.
4. **Use font size, weight, and color for hierarchy** instead of wrapping everything in rectangles. A 28px dark title vs a 14px gray annotation needs no box to show importance.

---

## Visual Pattern Library

Choose the pattern that best matches the concept's structure. Combine patterns for complex diagrams.

### Fan-Out (one source, many outputs)

```
         +--> B
    A ---+--> C
         +--> D
```

Use for: event emission, broadcast, one-to-many relationships, API responses consumed by multiple services.

### Convergence (many inputs, one result)

```
    A --+
    B --+--> D
    C --+
```

Use for: aggregation, reduce operations, load balancers, merging streams.

### Tree (hierarchical parent-child)

```
         A
        / \
       B   C
      / \
     D   E
```

Use for: DOM trees, file systems, inheritance, organizational charts, ASTs.

### Timeline / Sequence (ordered flow)

```
    A --> B --> C --> D
```

Use for: request lifecycle, protocol handshakes, pipeline stages, state machines. Can be horizontal (left-to-right) or vertical (top-to-bottom).

### Spiral / Cycle (recurring process)

```
    A --> B
    ^     |
    |     v
    D <-- C
```

Use for: event loops, retry logic, feedback systems, iterative processes.

### Assembly Line (pipeline with transformations)

```
    [raw] --> |Stage 1| --> |Stage 2| --> |Stage 3| --> [done]
```

Use for: compilation pipeline, CI/CD, data processing, middleware chains. Show what transforms at each stage.

### Side-by-Side (comparison)

```
    | Concept A  |  | Concept B  |
    |  - point   |  |  - point   |
    |  - point   |  |  - point   |
```

Use for: TCP vs UDP, SQL vs NoSQL, sync vs async, before/after.

### Gap / Break (problem to solution)

```
    [Problem state]  ~~gap~~  [Solution state]
```

Use for: debugging visualization, refactoring before/after, migration steps.

---

## Section-by-Section Build Strategy

Large diagrams must be built incrementally, not all at once.

### 1. Plan Sections

Divide the diagram into 2-5 logical sections. Each section is a coherent visual unit.

### 2. Namespace IDs and Seeds

Use descriptive string IDs and namespace seeds by section:

- Section 1 elements: seeds `100xxx` (e.g., `100001`, `100010`, `100020`)
- Section 2 elements: seeds `200xxx`
- Section 3 elements: seeds `300xxx`
- Cross-section arrows: seeds `900xxx`

ID examples: `"client_rect"`, `"server_rect"`, `"arrow_syn"`, `"evidence_packet"`, `"title_text"`

### 3. Build One Section at a Time

Generate the JSON for section 1 completely, then section 2, etc. This avoids mistakes from trying to hold 50+ elements in working memory at once.

### 4. Connect Sections Last

Cross-section arrows and references come after all sections are built. Update `boundElements` arrays on previously defined shapes when adding arrows to them.

### 5. Final Assembly

Combine all sections into a single `elements` array. Verify all cross-references are consistent.

---

## Process

1. **Research the concept** using WebSearch — verify accuracy against official docs, RFCs, or standards. Never diagram something you have not verified.

2. **Assess depth** — simple/conceptual or comprehensive/technical? Based on student level and concept complexity.

3. **Map concepts to visual patterns** — which pattern(s) from the library match this concept's structure? Sketch the layout mentally.

4. **Plan layout with multi-zoom levels** — where does the Level 1 summary flow go? Where do Level 3 evidence artifacts attach? Plan spatial regions.

5. **Read reference files:**
   - `references/color-palette.md` for colors
   - `references/element-templates.md` for JSON templates
   - `references/json-schema.md` for property reference

6. **Build JSON section-by-section** — follow the section-by-section strategy above. Use templates from element-templates.md as starting points.

7. **Save the file** to `docs/<concept-name>.excalidraw`

8. **Write educational explanation** alongside the diagram:
   - **What the diagram shows** — walk through each section
   - **Why it works this way** — reasoning behind the design
   - **Key concepts** — define terms that might be new
   - **Evidence highlights** — point out what the evidence artifacts reveal
   - **Common pitfalls** — what people often misunderstand
   - **Sources** — links to official docs, RFCs, or standards

9. **Save the explanation** to `docs/<concept-name>.md` (or append if it already exists) — note that an Excalidraw diagram is available.

---

## Layout Rules

- **Grid alignment:** Use coordinates that are multiples of 20
- **Minimum spacing:** 40px between unrelated elements, 20px padding inside containers
- **Text sizing:** Title 28px, section headers 24px, labels 20px, annotations 16px, evidence 14px
- **Max diagram size:** ~1400px wide, ~1000px tall. If larger, split into multiple diagrams
- **Arrow routing:** Prefer straight horizontal/vertical arrows. Use waypoints (multiple points) for complex routing
- **Grouping:** Use `groupIds` to group related elements so they move together
- **Evidence placement:** Evidence artifacts sit near the element they describe, slightly offset and smaller

---

## Quality Checklist

Before saving any diagram, verify:

- [ ] **Isomorphism Test** — structure communicates without text
- [ ] **Education Test** — someone can learn something concrete from this
- [ ] **Container ratio** — <30% of text elements have `containerId`
- [ ] **Binding consistency** — every `boundElements` entry has a matching `containerId` or `startBinding`/`endBinding`; every `containerId` has a matching `boundElements` entry; every arrow binding has matching `boundElements` on both connected shapes
- [ ] **Descriptive string IDs** — no generic `"id1"`, `"id2"`. Use `"server_rect"`, `"arrow_request"`, `"evidence_payload"`
- [ ] **Colors from palette** — all colors come from `references/color-palette.md`
- [ ] **fontFamily: 3** — monospace for all text elements
- [ ] **roughness: 0** — clean lines for all elements
- [ ] **fillStyle: "solid"** — unless there is a specific reason for hatching
- [ ] **Valid JSON** — parseable, no trailing commas, no comments in output
- [ ] **Title present** — every diagram has a title text element
- [ ] **Source attribution** — small text at bottom with reference link

---

## DB Integration

After creating the diagram and explanation:

1. **Save `.excalidraw` file** to `docs/<concept-name>.excalidraw`
2. **Save/update explanation** in `docs/<concept-name>.md` — mention the diagram file
3. **Save to global docs** at `~/.local/share/claude-education/docs/<concept-name>.excalidraw` (for general concepts)
4. **Append to session log** `~/.local/share/claude-education/sessions/[date].jsonl`:
   ```jsonl
   {"time": "[now]", "event": "excalidraw", "topic": "[concept-slug]", "file": "docs/[concept-name].excalidraw", "saved_to": "global|project|both"}
   ```
5. If the concept corresponds to a tracked topic, update `last_reviewed` in its topic file

---

## How to Open the Diagram

Tell the student:

1. **VS Code:** Install the "Excalidraw" extension, then open the `.excalidraw` file directly
2. **Browser:** Go to [excalidraw.com](https://excalidraw.com), click the menu (hamburger icon) -> "Open" -> select the file
3. **Edit freely:** The diagram is fully editable — move elements, add notes, change colors

---

## Integration with Other Skills

- **`/ascii`** — for quick ASCII terminal diagrams (simpler, inline). Use `/excalidraw` when the concept needs more detail or editability
- **`/demo`** — for animated/dynamic concepts. Use `/excalidraw` for static structure diagrams
- **`/quiz-me`** — if a visual concept is wrong, suggest `/excalidraw` for interactive exploration
- **`/challenge`** — challenges may ask the student to modify or extend an Excalidraw diagram
- **`/progress`** — diagrams count toward topic engagement
- Saved `.excalidraw` files become part of the student's visual reference library
