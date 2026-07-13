# Vega-Lite — Grammar for Deneb Specs

> Companion to [deneb.md](deneb.md). Vega-Lite is a high-level grammar of interactive graphics;
> Deneb renders it inside Power BI.

## Mental model

A spec = **data** → **transform** → **mark** + **encoding** (+ optional `layer`/`facet`/`params`).
You describe *what* to draw (a grammar), not *how* to draw it (imperative code).

- **mark:** `bar`, `line`, `point`, `area`, `arc`, `rule`, `text`, `tick`, `rect`.
- **encoding channels:** `x`, `y`, `color`, `size`, `opacity`, `shape`, `theta`, `text`,
  `tooltip`, `order`, `detail`, `column`/`row` (faceting).
- **field types:** `quantitative` (Q), `nominal` (N), `ordinal` (O), `temporal` (T) — set them
  explicitly; wrong types cause wrong axes/sorts.

## Layered & composed charts

```json
{
  "layer": [
    {"mark": "bar", "encoding": {"x": {"field": "Month", "type": "temporal"},
                                  "y": {"field": "Sales", "type": "quantitative"}}},
    {"mark": {"type": "rule", "color": "#E0A400"},
     "encoding": {"y": {"field": "Target", "type": "quantitative"}}}
  ]
}
```

- `layer` — overlay marks sharing a scale (bars + target rule, line + points + labels).
- `facet` / `concat` (`hconcat`/`vconcat`) — small multiples and dashboards-in-a-visual.
- `resolve` — control whether layers share or independent scales/axes/legends.

## Transforms (shape data in-spec)

`filter`, `calculate`, `aggregate`, `bin`, `timeUnit`, `window` (running totals, ranks),
`joinaggregate`, `fold` (wide→long), `lookup`, `stack`. Prefer these over adding one-off DAX.

## Tooltips & interaction

- Tooltip: `"tooltip": [{"field": "...", "type": "..."}]` or `"mark": {"tooltip": true}`.
- Selections via `params` with `"select": {"type": "point"|"interval"}`; bind to Power BI
  cross-filtering in Deneb settings. Use `condition` in encoding to style selected vs. unselected.

## Responsive & theming

- `"width": "container", "height": "container"`, `"autosize": {"type": "fit", "contains": "padding"}`.
- Centralize a palette/config at the top; pull Power BI theme colors via Deneb config so the
  spec honors [`shared/design_system.md`](../shared/design_system.md).
- Set `axis`, `legend`, `title` font/size to match the design system (Segoe UI, ≥9pt).

## Number & date formatting

- Use `format` with d3 format strings (`",.0f"`, `"$,.2f"`, `".1%"`) and `formatType`.
- `timeUnit` (`yearmonth`, `week`) to bucket temporal fields without extra columns.

## Gotchas

- Aggregation happens per encoding `aggregate` **or** via transform — don't double-aggregate.
- Sort with `"sort": "-y"` (by value) not alphabetical unless natural order.
- Large datasets: pre-aggregate in DAX; Vega-Lite is not a data warehouse.
- **Validation (5.21+):** Vega-Lite tightened schema validation — a spec that only emitted
  *warnings* before can now **fail to render** in current Deneb (1.9.x / Vega-Lite 5.x). Validate
  against the bundled schema and clear warnings before shipping; see [deneb.md](deneb.md).

---
*Sources: Vega-Lite documentation, Deneb docs. Last reviewed: 2026-07-11.*
