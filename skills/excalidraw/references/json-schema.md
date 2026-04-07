# Excalidraw JSON Schema Reference

Quick-reference tables for all element properties. Consult when building or debugging diagram JSON.

## Common Properties (All Elements)

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | string | Yes | Unique identifier. Use descriptive strings: `"server_rect"`, `"arrow_syn"` |
| `type` | string | Yes | `"rectangle"`, `"ellipse"`, `"diamond"`, `"arrow"`, `"line"`, `"text"` |
| `x` | number | Yes | X position (top-left corner). Use multiples of 20 for grid alignment |
| `y` | number | Yes | Y position (top-left corner). Use multiples of 20 for grid alignment |
| `width` | number | Yes | Element width in pixels |
| `height` | number | Yes | Element height in pixels |
| `angle` | number | Yes | Rotation in radians. `0` = no rotation |
| `strokeColor` | string | Yes | Border/outline color. Hex string, e.g. `"#1971c2"` |
| `backgroundColor` | string | Yes | Fill color. Hex string or `"transparent"` |
| `fillStyle` | string | Yes | How the fill is rendered. See fillStyle options below |
| `strokeWidth` | number | Yes | Border thickness. `1` = thin, `2` = normal, `4` = thick |
| `strokeStyle` | string | Yes | `"solid"`, `"dashed"`, `"dotted"` |
| `roughness` | number | Yes | `0` = clean, `1` = slightly rough, `2` = hand-drawn. **Always use `0`** |
| `opacity` | number | Yes | `0`-`100`. `100` = fully opaque |
| `groupIds` | string[] | Yes | Array of group IDs. Elements with same group ID move together |
| `boundElements` | array/null | Yes | Elements bound to this one. `[{ "id": "...", "type": "text" or "arrow" }]` or `null` |
| `seed` | number | Yes | Random seed for rendering. Use unique values; namespace by section |
| `version` | number | Yes | Version counter. Start at `1` |
| `versionNonce` | number | Yes | Unique per version. Use same value as `seed` for simplicity |
| `isDeleted` | boolean | Yes | `false` for visible elements |
| `updated` | number | Yes | Timestamp. Use `1` for generated diagrams |

## Shape-Specific: Rectangle, Ellipse, Diamond

| Property | Type | Description |
|----------|------|-------------|
| `roundness` | object/null | Corner rounding. Rectangle: `{ "type": 3 }`. Ellipse/Diamond: `{ "type": 2 }`. `null` = sharp corners |

## Text-Specific Properties

| Property | Type | Description |
|----------|------|-------------|
| `text` | string | The displayed text. Use `\n` for line breaks |
| `originalText` | string | Must match `text` exactly (used for undo tracking) |
| `fontSize` | number | Font size in pixels. See text sizing in color-palette.md |
| `fontFamily` | number | `1` = Virgil (hand-drawn sans), `2` = Helvetica (serif), `3` = Cascadia (monospace). **Always use `3`** |
| `textAlign` | string | `"left"`, `"center"`, `"right"` |
| `verticalAlign` | string | `"top"`, `"middle"`. Use `"middle"` when inside a container |
| `containerId` | string/null | ID of the container shape this text is bound inside. `null` = free-floating |

## Arrow and Line Properties

| Property | Type | Description |
|----------|------|-------------|
| `points` | number[][] | Array of [x, y] offsets from element's (x, y). First point is always `[0, 0]` |
| `startArrowhead` | string/null | `null`, `"arrow"`, `"bar"`, `"dot"`, `"triangle"` |
| `endArrowhead` | string/null | Same options as startArrowhead. Common: `"arrow"` for arrows, `null` for lines |
| `startBinding` | object/null | `{ "elementId": "shape_id", "focus": 0, "gap": 1 }` or `null` |
| `endBinding` | object/null | Same structure as startBinding |
| `roundness` | object/null | Arrow curve smoothing. `{ "type": 2 }` for smooth curves |

### Binding Object Structure

```json
{
  "elementId": "target_shape_id",
  "focus": 0,
  "gap": 1
}
```

- **`elementId`** — ID of the shape this end connects to
- **`focus`** — `-1` to `1`. `0` = center of the shape's edge. Negative = left/top, positive = right/bottom
- **`gap`** — Pixel gap between arrowhead and shape border. `1` is standard

### Points Examples

```
Horizontal right:  [[0, 0], [200, 0]]
Horizontal left:   [[0, 0], [-200, 0]]
Vertical down:     [[0, 0], [0, 150]]
Diagonal:          [[0, 0], [200, 100]]
L-shaped (2 bend): [[0, 0], [100, 0], [100, 150]]
```

## fillStyle Options

| Value | Appearance | When to Use |
|-------|-----------|-------------|
| `"solid"` | Flat color fill | **Default.** Clean, professional look |
| `"hachure"` | Diagonal line hatching | Hand-drawn feel (avoid with `roughness: 0`) |
| `"cross-hatch"` | Cross-hatched lines | Emphasis on hand-drawn style |
| `"dots"` | Dotted pattern fill | Rarely used. Background/texture |

**Always use `"solid"`** for clean educational diagrams.

## strokeStyle Options

| Value | Appearance | When to Use |
|-------|-----------|-------------|
| `"solid"` | Continuous line | Default for shapes and arrows |
| `"dashed"` | Dashed line | Boundaries, optional paths, lifelines, grouping borders |
| `"dotted"` | Dotted line | Weak relationships, tentative connections |

## fontFamily Options

| Value | Font | When to Use |
|-------|------|-------------|
| `1` | Virgil (hand-drawn sans) | Casual/sketch diagrams |
| `2` | Helvetica (clean sans) | Formal/presentation diagrams |
| `3` | Cascadia (monospace) | **Default.** Technical diagrams, code-adjacent |

**Always use `3`** (monospace) for educational diagrams.

## textAlign Options

| Value | When to Use |
|-------|-------------|
| `"left"` | Free-floating text, annotations, evidence artifacts |
| `"center"` | Text inside containers (rectangles, ellipses, diamonds) |
| `"right"` | Right-aligned labels (rare) |

## verticalAlign Options

| Value | When to Use |
|-------|-------------|
| `"top"` | Free-floating text |
| `"middle"` | Text inside containers (must be `"middle"` for centering) |

## Binding Consistency Checklist

When connecting elements, these relationships MUST all be present:

```
Arrow.startBinding.elementId  = SourceShape.id
Arrow.endBinding.elementId    = TargetShape.id
SourceShape.boundElements     includes { id: Arrow.id, type: "arrow" }
TargetShape.boundElements     includes { id: Arrow.id, type: "arrow" }

Text.containerId              = ContainerShape.id
ContainerShape.boundElements  includes { id: Text.id, type: "text" }
```

Missing any one of these will cause broken bindings in Excalidraw.
