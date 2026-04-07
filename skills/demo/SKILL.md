---
name: demo
description: "Use when the concept needs ANIMATION or INTERACTIVITY to be understood — step-by-step protocol flows, sorting algorithm traces, state machine transitions, network packet journeys, or anything where static images fall short. Generates a self-contained .html file with Canvas/SVG + JavaScript. Opens in any browser, zero dependencies. For static diagrams use /ascii (simple) or /excalidraw (complex)."
---

# Demo — Interactive Animated Diagrams

Generate `.html` files with animated, interactive visualizations. Uses a **template** with built-in engine, drawing library, and Preact UI — you only write the steps and draw functions.

## Invocation

`/demo <concept description>`

## When to Use This

| `/demo` | `/excalidraw` | `/ascii` |
|-----------|---------------|----------|
| Needs animation (packets moving, sort steps) | Complex but static (architecture, data structures) | Quick inline terminal visual |
| Step-by-step walkthrough with play/pause | Student wants to edit/rearrange the diagram | Simple sequence or flowchart |
| Timing matters (race conditions, event loops) | Diagram will be exported as image | Just needs a quick look |

## Template Architecture

The template at `skills/demo/template.html` ships with:

| Layer | Technology | What it provides |
|-------|-----------|-----------------|
| **UI** | Preact + HTM (CDN) | Reactive controls, step navigation, keyboard shortcuts |
| **Styling** | Bootstrap 5 + Icons (CDN) + custom dark theme | Pretty buttons, icons, responsive layout, utilities |
| **Canvas** | Native Canvas 2D + drawing library | Drawing helpers, animation math, color theming |
| **Engine** | Built into template | Animation loop, step progression, speed control |

**You only fill in the content section** between `__CONTENT_START__` and `__CONTENT_END__`.

## Process

1. **Research the concept** using WebSearch — verify accuracy
2. **Read the template** at `skills/demo/template.html`
3. **Copy the template** to `docs/<concept-name>.html`
4. **Replace placeholders:**
   - `__TITLE__` → concept name (appears in 3 places: `<title>`, `<h1>`, and Preact `html`)
   - `__SUBTITLE__` → one-line description (appears in 2 places)
   - `__SOURCE_HTML__` → source link, e.g. `Source: <a href="https://...">RFC 793</a>`
   - `__CUSTOM_CSS__` → any concept-specific CSS (usually empty — use Bootstrap utilities first)
5. **Replace the content section** (`__CONTENT_START__` to `__CONTENT_END__`) with your STEPS array and optional drawBackground/drawOverlay functions
6. **Save** and tell the student how to open it

## What You Write: The STEPS Array

```javascript
const STEPS = [
  {
    title: "Short step name",       // shown in step title bar
    explain: "What's happening.",    // shown in explanation panel

    // REQUIRED: animation during this step (progress: 0→1)
    draw(ctx, progress, W, H, stepIndex) {
      // Draw both persistent elements (arrow) AND transient ones (moving packet)
      drawArrow(ctx, x1, y1, x2, y2, opts);
      drawMovingPacket(ctx, x1, y1, x2, y2, progress, 'SYN');
    },

    // OPTIONAL: what stays on screen AFTER this step completes
    // If omitted, draw(ctx, 1, ...) is used as fallback.
    // Use this to prevent transient elements (packets, popups, detail boxes)
    // from piling up on screen across steps.
    drawResult(ctx, W, H, stepIndex) {
      // Only the persistent elements — the arrow stays, the packet is gone
      drawArrow(ctx, x1, y1, x2, y2, opts);
    }
  },
  // ... 5-15 steps
];
```

**IMPORTANT — `draw` vs `drawResult`:**
- `draw()` renders the full animation including transient elements (moving packets, popups, detail panels)
- `drawResult()` renders ONLY what should stay visible after the step is done
- Without `drawResult`, ALL elements from `draw()` persist — this causes overlap bugs in protocol flows where moving packets and header boxes pile up
- **Always define `drawResult`** for steps that have transient animated elements

### Optional: drawBackground(ctx, W, H)

Static elements drawn every frame behind everything. Attach to `window`:
```javascript
window.drawBackground = function(ctx, W, H) {
  // lifelines, grid, labels, static infrastructure
};
```

### Optional: drawOverlay(ctx, W, H, currentStep, progress)

Drawn on top every frame. Attach to `window`:
```javascript
window.drawOverlay = function(ctx, W, H, step, progress) {
  // HUD, state labels, persistent indicators
};
```

## Drawing Library Reference

All functions are globally available. Every shape function takes `ctx` as first argument.

### Shapes

```javascript
drawBox(ctx, x, y, w, h, { fill, stroke, lineWidth, radius, opacity })
drawCircle(ctx, x, y, r, { fill, stroke, lineWidth, opacity })
drawDiamond(ctx, cx, cy, w, h, { fill, stroke, lineWidth, opacity })
```

### Text

```javascript
drawText(ctx, text, x, y, { size, weight, fillColor, align, baseline, maxWidth, opacity })
drawPill(ctx, text, x, y, { fill, textColor, size, px, py })  // text in a pill badge
```

### Lines & Arrows

```javascript
drawArrow(ctx, x1, y1, x2, y2, { strokeColor, lineWidth, headSize, dash, opacity })
drawDashedLine(ctx, x1, y1, x2, y2, { strokeColor, lineWidth, dash, opacity })
drawLine(ctx, x1, y1, x2, y2, { strokeColor, lineWidth, opacity })
drawCurvedArrow(ctx, x1, y1, cpx, cpy, x2, y2, { strokeColor, lineWidth, headSize, opacity })
```

### Animation

```javascript
drawMovingPacket(ctx, x1, y1, x2, y2, progress, label, { fill, textColor, size, width, height })
withGlow(ctx, drawFn, glowColor, blur)   // wrap draw call with glow effect
pulse(time, speed)                        // oscillating 0-1 for pulsing effects
```

### Math

```javascript
lerp(a, b, t)           // linear interpolation
easeInOut(t)             // smooth S-curve
easeOut(t)               // decelerate
easeIn(t)                // accelerate
clamp(val, min, max)     // clamp value
subProgress(progress, start, end)  // map sub-range of 0-1 to its own 0-1
```

### Colors (CSS variables)

```javascript
color('--node-a')    // #4ea8de — client/source
color('--node-b')    // #4ecca3 — server/destination
color('--node-c')    // #f0c040 — intermediary
color('--data')      // #c084fc — packets/data
color('--accent')    // #e94560 — highlights
color('--success')   // #4ecca3
color('--warning')   // #f0c040
color('--error')     // #e94560
color('--info')      // #4ea8de
color('--text')      // #f0f0f5
color('--text-muted')// #8b8fa3
color('--surface')   // #1a1f36
color('--primary')   // #0f3460
```

### Sequencing Animations Within a Step

Use `subProgress()` to split one step's 0→1 progress into phases:

```javascript
draw(ctx, progress, W, H) {
  // Phase 1: arrow appears (0% to 40%)
  const arrowP = subProgress(progress, 0, 0.4);
  if (arrowP > 0) {
    drawArrow(ctx, x1, y1, x1 + (x2 - x1) * easeOut(arrowP), y1, ...);
  }

  // Phase 2: packet moves (30% to 90%, overlaps phase 1)
  const packetP = subProgress(progress, 0.3, 0.9);
  if (packetP > 0) {
    drawMovingPacket(ctx, x1, y1, x2, y2, packetP, 'SYN', ...);
  }

  // Phase 3: label fades in (80% to 100%)
  const labelP = subProgress(progress, 0.8, 1);
  if (labelP > 0) {
    drawPill(ctx, 'SYN_SENT', x1, y3, { ...opts, opacity: labelP });
  }
}
```

## Available CDN Libraries

The template loads these from CDN — you can use them for custom UI if needed:

- **Bootstrap 5 CSS** — full utility classes (`d-flex`, `gap-2`, `rounded`, `text-muted`, etc.)
- **Bootstrap Icons** — `<i class="bi bi-*"></i>` icon font
- **Preact + HTM** — reactive components (the engine uses these, you can too for custom overlays)

For extra HTML sections (tables, accordions, tabbed views alongside the canvas), you can add Bootstrap-styled elements in the `__CUSTOM_CSS__` area or extend the Preact App component.

## Layout Guidelines

- **Use relative positions:** `W * 0.25` not `200`. Responsive by default.
- **Actor positions:** 2 actors → `W * 0.25`, `W * 0.75`. 3 actors → `W * 0.2`, `W * 0.5`, `W * 0.8`.
- **Vertical flow:** Start at `H * 0.1`, gaps of `H * 0.08` between rows.
- **Font scaling:** `Math.max(12, W * 0.015)` for labels.
- **5-15 steps** is the sweet spot.

## Style Recipes

### Protocol Flow

```javascript
window.drawBackground = function(ctx, W, H) {
  drawBox(ctx, W*0.15, H*0.05, W*0.2, H*0.08, { fill: color('--node-a'), radius: 6 });
  drawText(ctx, 'Client', W*0.25, H*0.09, { size: 16, weight: '600' });
  drawBox(ctx, W*0.65, H*0.05, W*0.2, H*0.08, { fill: color('--node-b'), radius: 6 });
  drawText(ctx, 'Server', W*0.75, H*0.09, { size: 16, weight: '600' });
  drawDashedLine(ctx, W*0.25, H*0.14, W*0.25, H*0.95);
  drawDashedLine(ctx, W*0.75, H*0.14, W*0.75, H*0.95);
};

// Example step with draw + drawResult:
const step1 = {
  title: "Client sends SYN",
  explain: "Client initiates with SYN packet.",
  draw(ctx, progress, W, H) {
    // Arrow line (persistent)
    drawArrow(ctx, W*0.25, H*0.25, W*0.75, H*0.25, { strokeColor: color('--accent') });
    // Moving packet (transient — disappears after step)
    drawMovingPacket(ctx, W*0.25, H*0.25, W*0.75, H*0.25, progress, 'SYN');
    // State label fades in
    const lp = subProgress(progress, 0.8, 1);
    if (lp > 0) drawPill(ctx, 'SYN_SENT', W*0.25, H*0.32, { fill: color('--warning') });
  },
  drawResult(ctx, W, H) {
    // Only the arrow + state label stay — no packet
    drawArrow(ctx, W*0.25, H*0.25, W*0.75, H*0.25, { strokeColor: color('--accent') });
    drawPill(ctx, 'SYN_SENT', W*0.25, H*0.32, { fill: color('--warning') });
  }
};
```

### Algorithm Trace
- `drawBackground`: array cells as boxes in a row
- Steps: highlight comparing cells, animate swaps, mark sorted
- `drawResult`: show cells in their new positions after swap, sorted cells in green

### State Machine
- `drawBackground`: all state circles + transition arrows (dimmed)
- Steps: `withGlow` to highlight current state, animate pulse along transition
- `drawResult`: highlight the new current state (no pulse animation)

## Quality Checklist

- [ ] All `__PLACEHOLDER__` values replaced
- [ ] STEPS array has 5-15 entries
- [ ] Every step has title + explain + draw
- [ ] Positions use `W * ...` / `H * ...` (no hardcoded pixels)
- [ ] `subProgress()` used for multi-phase animations within steps
- [ ] Concept researched — technical details verified
- [ ] File opens in browser without console errors

## DB Integration

After creating the visualization:

1. **Save `.html` file** to `docs/<concept-name>.html`
2. **Save/update explanation** in `docs/<concept-name>.md` — mention the interactive visualization
3. **Save to global docs** at `~/.local/share/claude-education/docs/<concept-name>.html` (for general concepts)
4. **Append to session log** `~/.local/share/claude-education/sessions/[date].jsonl`:
   ```jsonl
   {"time": "[now]", "event": "demo", "topic": "[concept-slug]", "file": "docs/[concept-name].html", "saved_to": "global|project|both"}
   ```
5. If the concept corresponds to a tracked topic, update `last_reviewed` in its topic file

## Integration with Other Skills

- **`/ascii`** — quick terminal diagrams (simplest tier)
- **`/excalidraw`** — static but editable diagrams (middle tier)
- **`/demo`** — animated interactive visualizations (richest tier)
- **`/quiz-me`** — after watching a demo animation, quiz the student on the steps
- **`/challenge`** — "predict what happens at step 5" before revealing it
