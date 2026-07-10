# Deneb — Declarative Custom Visuals in Power BI

> For the **Deneb specialist** and Visualization. Deneb hosts Vega / Vega-Lite specs as a
> certified Power BI custom visual. Use it only when native visuals can't express the design
> (see [`shared/tech_selection.md`](../shared/tech_selection.md)). Grammar depth:
> [vega-lite.md](vega-lite.md).

## When Deneb is the right tool

- Native visual can't do it: small multiples with custom layout, dumbbell/lollipop, bullet, bump,
  radial/arc, custom-encoded KPI, dot plots, layered annotation, precise design-system control.
- You need **pixel/design control** or a repeatable **template** across reports.
- Not for: anything a native visual + theme already does well (cost: no native cross-highlight
  parity, more maintenance, JSON literacy required).

## How Deneb binds to the model

- Data comes from the **visual's data roles** (fields you drop in), exposed to the spec as the
  `dataset` — reference values by **field name**. Measures/columns must exist first (DAX/model).
- **Interactivity:** enable cross-filtering via Deneb's selection options; declare Vega-Lite
  `params` with `select` and map to Power BI selection IDs. Report tooltips via the tooltip
  channel or Power BI's tooltip service.
- **Themes:** read Power BI theme colors through Deneb config so the visual matches
  [`shared/design_system.md`](../shared/design_system.md) instead of hard-coding hex.

## JSON authoring best practices

- Prefer **Vega-Lite** over raw Vega unless you need fine control (custom signals, complex layout).
- Keep specs **declarative and layered**: `layer`, `facet`, `concat`, `resolve` over imperative
  hacks. Parameterize colors, fonts, sizes at the top so a template is reusable.
- **Responsive:** set `"width": "container"` / `"height": "container"` and use
  `autosize: {type: fit, contains: padding}`; avoid fixed pixel sizes that clip on resize.
- Move data shaping into Vega-Lite `transform` (`calculate`, `filter`, `aggregate`, `window`,
  `fold`) rather than pre-building extra DAX measures where reasonable.
- Externalize a **template**: expose config (palette, number format, fonts) at the top of the
  spec and document the required data roles.

## Deliverable & handoff

- Output a `.json` spec + a short note: required fields/measures, interactivity enabled,
  responsive behavior, theme binding, and known limitations (e.g., no native cross-highlight).
- Store under the project `report/` folder; log the technology choice in `tech_decision.md`.

## Pitfalls

- Overusing Deneb where native works → maintenance debt. Justify every Deneb visual in the
  tech-selection record.
- Hard-coded colors/fonts drifting from the theme. Bind to theme.
- Performance: Deneb re-renders on data change; keep the dataset small (aggregate in DAX first).
- Accessibility: custom visuals bypass native a11y — add titles, high-contrast palettes, and
  document keyboard/reader limitations for the Accessibility specialist.

---
*Sources: Deneb documentation (deneb-viz), Data Goblins (Deneb tutorials), Vega-Lite docs.
Last reviewed: 2026-07-10.*
