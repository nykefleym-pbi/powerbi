# Figma for Power BI Design

> For the **SVG & Figma designer** and Visualization. Figma is used to design the report's look
> and system *before* build, and to export clean SVG assets. It feeds
> [`shared/design_system.md`](../shared/design_system.md) and the project `theme.json`.

## Why Figma in a BI workflow

- Design the **wireframe → hi-fi mockup** fast, iterate with stakeholders before touching Power BI.
- Maintain a **design system** (tokens, components) that maps 1:1 to the Power BI theme.
- Produce **optimized SVG icons/illustrations** for [svg.md](svg.md) measures and backgrounds.

## Components & variants

- Build reusable **components** for KPI cards, headers, legends, buttons; use **variants** for
  states (positive/negative, selected/default) matching design-system semantic roles.
- Component properties (boolean/text/instance-swap) keep one source of truth for repeated UI.

## Variables & tokens (→ Power BI theme)

- Define **variables** for color, number, and string tokens; group into collections
  (Color / Type / Spacing) and modes for **light/dark** — mirror the tokens in
  `design_system.md` so the exported palette drops straight into `theme.json`.
- Name tokens by role (`primary`, `positive`, `surface`), not by hex — same discipline as the
  design system. This makes the handoff to `theme.json` mechanical.

## Auto Layout

- Use **Auto Layout** for anything that stacks/repeats (KPI rows, lists, legends) so spacing
  follows the 8px base unit and the 12-column grid in `design_system.md`.
- Set consistent padding/gap tokens; align to grid — no free-floating elements (mirrors the
  Power BI "snap to grid" rule).

## SVG export optimization

- Flatten unnecessary groups; outline strokes only when needed; remove hidden layers.
- Export at the intended `viewBox`; run through an SVG optimizer (SVGO-style) to strip metadata,
  round coordinates, and shrink paths → smaller strings for SVG measures.
- Prefer simple, single-path icons for measure-driven recoloring (one `fill` to parametrize).

## Handoff to the build

- Deliver: token export (→ `theme.json` values), component inventory (→ visual/page layout),
  and optimized SVG assets (→ SVG measures / backgrounds).
- Keep the Figma file the **design source of truth**; the Power BI theme and wireframe are its
  downstream artifacts. Log any deviation in `decision_log.md`.

---
*Sources: Figma docs (components, variables, auto layout), design-system practice, SVGO.
Last reviewed: 2026-07-10.*
