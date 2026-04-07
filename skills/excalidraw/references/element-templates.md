# Excalidraw Element Templates

Copy-paste JSON templates for every element type. All templates use:
- `roughness: 0` (clean lines, not hand-drawn)
- `fontFamily: 3` (monospace for technical feel)
- Descriptive string IDs
- Comments showing which values to customize

## Wrapper Structure

Every `.excalidraw` file wraps elements in this:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "claude-teacher",
  "elements": [
    /* all elements go here */
  ],
  "appState": {
    "gridSize": 20,
    "viewBackgroundColor": "#ffffff"
  },
  "files": {}
}
```

---

## Free-Floating Text (no container)

Use for titles, annotations, labels near arrows, footnotes.

```json
{
  "id": "title_text",
  "type": "text",
  "x": 40,
  "y": 40,
  "width": 400,
  "height": 35,
  "text": "TCP Three-Way Handshake",
  "fontSize": 28,
  "fontFamily": 3,
  "textAlign": "left",
  "verticalAlign": "top",
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "groupIds": [],
  "boundElements": null,
  "containerId": null,
  "originalText": "TCP Three-Way Handshake",
  "seed": 100001,
  "version": 1,
  "versionNonce": 100001,
  "isDeleted": false,
  "updated": 1
}
```

**Customize:** `id`, `x`/`y`, `text`, `originalText`, `fontSize`, `strokeColor`, `seed`/`versionNonce`

---

## Rectangle with Bound Text

Two elements required: the rectangle AND a text element bound inside it.

### The Rectangle

```json
{
  "id": "server_rect",
  "type": "rectangle",
  "x": 100,
  "y": 200,
  "width": 200,
  "height": 80,
  "strokeColor": "#1971c2",
  "backgroundColor": "#a5d8ff",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "roundness": { "type": 3 },
  "groupIds": [],
  "boundElements": [
    { "id": "server_label", "type": "text" }
  ],
  "seed": 100010,
  "version": 1,
  "versionNonce": 100010,
  "isDeleted": false,
  "updated": 1
}
```

### The Bound Text Inside It

```json
{
  "id": "server_label",
  "type": "text",
  "x": 150,
  "y": 218,
  "width": 100,
  "height": 25,
  "text": "Server",
  "fontSize": 20,
  "fontFamily": 3,
  "textAlign": "center",
  "verticalAlign": "middle",
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "groupIds": [],
  "boundElements": null,
  "containerId": "server_rect",
  "originalText": "Server",
  "seed": 100011,
  "version": 1,
  "versionNonce": 100011,
  "isDeleted": false,
  "updated": 1
}
```

**Binding rules:**
- Rectangle's `boundElements` includes `{ "id": "server_label", "type": "text" }`
- Text's `containerId` is set to `"server_rect"`
- Text `textAlign: "center"` and `verticalAlign: "middle"` to center inside container

**Customize:** IDs, positions, `text`/`originalText`, colors (from palette), `seed`/`versionNonce`

---

## Ellipse with Bound Text

For start/end states, actors, circular concepts.

### The Ellipse

```json
{
  "id": "start_node",
  "type": "ellipse",
  "x": 100,
  "y": 100,
  "width": 160,
  "height": 80,
  "strokeColor": "#2f9e44",
  "backgroundColor": "#b2f2bb",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "roundness": { "type": 2 },
  "groupIds": [],
  "boundElements": [
    { "id": "start_label", "type": "text" }
  ],
  "seed": 100020,
  "version": 1,
  "versionNonce": 100020,
  "isDeleted": false,
  "updated": 1
}
```

### The Bound Text

```json
{
  "id": "start_label",
  "type": "text",
  "x": 140,
  "y": 128,
  "width": 80,
  "height": 25,
  "text": "Start",
  "fontSize": 20,
  "fontFamily": 3,
  "textAlign": "center",
  "verticalAlign": "middle",
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "groupIds": [],
  "boundElements": null,
  "containerId": "start_node",
  "originalText": "Start",
  "seed": 100021,
  "version": 1,
  "versionNonce": 100021,
  "isDeleted": false,
  "updated": 1
}
```

---

## Diamond with Bound Text

For decision nodes, conditionals, branching points.

### The Diamond

```json
{
  "id": "decision_check",
  "type": "diamond",
  "x": 300,
  "y": 300,
  "width": 180,
  "height": 120,
  "strokeColor": "#e67700",
  "backgroundColor": "#ffec99",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "roundness": { "type": 2 },
  "groupIds": [],
  "boundElements": [
    { "id": "decision_label", "type": "text" }
  ],
  "seed": 100030,
  "version": 1,
  "versionNonce": 100030,
  "isDeleted": false,
  "updated": 1
}
```

### The Bound Text

```json
{
  "id": "decision_label",
  "type": "text",
  "x": 340,
  "y": 348,
  "width": 100,
  "height": 25,
  "text": "ACK?",
  "fontSize": 20,
  "fontFamily": 3,
  "textAlign": "center",
  "verticalAlign": "middle",
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "groupIds": [],
  "boundElements": null,
  "containerId": "decision_check",
  "originalText": "ACK?",
  "seed": 100031,
  "version": 1,
  "versionNonce": 100031,
  "isDeleted": false,
  "updated": 1
}
```

---

## Arrow with Start/End Bindings

Connects two shapes. Three things must be consistent: the arrow's bindings AND both shapes' `boundElements`.

### Source Shape (already defined above as `server_rect`)

Add the arrow to its `boundElements`:

```json
"boundElements": [
  { "id": "server_label", "type": "text" },
  { "id": "arrow_request", "type": "arrow" }
]
```

### Target Shape

```json
{
  "id": "client_rect",
  "type": "rectangle",
  "x": 500,
  "y": 200,
  "width": 200,
  "height": 80,
  "strokeColor": "#1971c2",
  "backgroundColor": "#a5d8ff",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "roundness": { "type": 3 },
  "groupIds": [],
  "boundElements": [
    { "id": "client_label", "type": "text" },
    { "id": "arrow_request", "type": "arrow" }
  ],
  "seed": 100040,
  "version": 1,
  "versionNonce": 100040,
  "isDeleted": false,
  "updated": 1
}
```

### The Arrow

```json
{
  "id": "arrow_request",
  "type": "arrow",
  "x": 300,
  "y": 240,
  "width": 200,
  "height": 0,
  "points": [[0, 0], [200, 0]],
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "roundness": { "type": 2 },
  "startArrowhead": null,
  "endArrowhead": "arrow",
  "startBinding": {
    "elementId": "server_rect",
    "focus": 0,
    "gap": 1
  },
  "endBinding": {
    "elementId": "client_rect",
    "focus": 0,
    "gap": 1
  },
  "groupIds": [],
  "boundElements": null,
  "seed": 100050,
  "version": 1,
  "versionNonce": 100050,
  "isDeleted": false,
  "updated": 1
}
```

**Binding checklist (must be consistent):**
1. Arrow `startBinding.elementId` = source shape's `id`
2. Arrow `endBinding.elementId` = target shape's `id`
3. Source shape's `boundElements` includes `{ "id": "arrow_request", "type": "arrow" }`
4. Target shape's `boundElements` includes `{ "id": "arrow_request", "type": "arrow" }`

**`focus`:** `-1` to `1`. `0` = center. Negative = toward start, positive = toward end.
**`gap`:** Pixel gap between arrowhead and shape border. `1` is standard.

---

## Line (Structural, No Arrowhead)

For timelines, separators, boundaries, lifelines. No bindings needed.

```json
{
  "id": "separator_line",
  "type": "line",
  "x": 40,
  "y": 180,
  "width": 800,
  "height": 0,
  "points": [[0, 0], [800, 0]],
  "strokeColor": "#868e96",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "dashed",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "roundness": { "type": 2 },
  "groupIds": [],
  "boundElements": null,
  "seed": 100060,
  "version": 1,
  "versionNonce": 100060,
  "isDeleted": false,
  "updated": 1
}
```

**For vertical lines:** set `width: 0`, `height: 400`, `points: [[0, 0], [0, 400]]`
**`strokeStyle`:** `"solid"`, `"dashed"`, or `"dotted"`

---

## Small Marker Dot

Tiny ellipse for marking points on timelines, indicating positions, or status indicators.

```json
{
  "id": "marker_step1",
  "type": "ellipse",
  "x": 200,
  "y": 176,
  "width": 12,
  "height": 12,
  "strokeColor": "#7048e8",
  "backgroundColor": "#7048e8",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "roundness": { "type": 2 },
  "groupIds": [],
  "boundElements": null,
  "seed": 100070,
  "version": 1,
  "versionNonce": 100070,
  "isDeleted": false,
  "updated": 1
}
```

---

## Evidence Artifact (Dark Code Block)

Shows real code, JSON, event names, or terminal output. Dark background with green text makes it visually distinct from abstract concepts.

### The Dark Rectangle

```json
{
  "id": "evidence_syn_packet",
  "type": "rectangle",
  "x": 100,
  "y": 400,
  "width": 300,
  "height": 100,
  "strokeColor": "#334155",
  "backgroundColor": "#1e293b",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "roundness": { "type": 3 },
  "groupIds": [],
  "boundElements": [
    { "id": "evidence_syn_text", "type": "text" }
  ],
  "seed": 100080,
  "version": 1,
  "versionNonce": 100080,
  "isDeleted": false,
  "updated": 1
}
```

### The Green Code Text

```json
{
  "id": "evidence_syn_text",
  "type": "text",
  "x": 110,
  "y": 415,
  "width": 280,
  "height": 70,
  "text": "SYN seq=1000\nflags: 0x02\nwindow: 65535",
  "fontSize": 14,
  "fontFamily": 3,
  "textAlign": "left",
  "verticalAlign": "middle",
  "strokeColor": "#22c55e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "angle": 0,
  "groupIds": [],
  "boundElements": null,
  "containerId": "evidence_syn_packet",
  "originalText": "SYN seq=1000\nflags: 0x02\nwindow: 65535",
  "seed": 100081,
  "version": 1,
  "versionNonce": 100081,
  "isDeleted": false,
  "updated": 1
}
```

**Key:** Green text (`#22c55e`) on dark slate (`#1e293b`) = "this is real, concrete data." Use evidence artifacts whenever the diagram teaches something that has actual code, packets, events, or data behind it.
