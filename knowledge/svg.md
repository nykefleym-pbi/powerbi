# Dynamic SVG in Power BI

> For the **SVG & Figma designer**. Two delivery paths: (1) **measure-driven SVG** rendered by a
> native visual set to *Image URL*, and (2) SVG embedded inside the
> [HTML Content visual](html-visuals.md) or [Deneb](deneb.md).

## Measure-driven SVG (the core technique)

Return an SVG document from a DAX measure as a **data URI**, then set the column's data category
to **Image URL** and drop it into a Table/Matrix (or a card-style visual that accepts image URLs).

```dax
KPI Spark SVG =
VAR Fill = IF ( [Revenue YoY %] >= 0, "#1F9E6E", "#E5484D" )
VAR Header = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' "
VAR Body =
    "width='120' height='40' viewBox='0 0 120 40'>" &
    "<rect width='120' height='40' rx='6' fill='" & Fill & "' opacity='0.12'/>" &
    "<text x='8' y='26' font-family='Segoe UI' font-size='16' fill='" & Fill & "'>" &
    FORMAT ( [Revenue YoY %], "0.0%" ) & "</text></svg>"
RETURN Header & Body
```

- Colors, widths, and paths are **driven by measures** → the SVG reacts to slicers/filters.
- Build bars/sparklines by computing `x`/`width`/`points` in DAX (normalize to a fixed viewBox).

## Optimization for Power BI

- **Keep it small.** Image-URL measures have length limits and re-render per row — minimize
  markup, drop whitespace, avoid huge `path` strings.
- Use a fixed `viewBox` and relative coordinates so the same measure scales cleanly.
- Escape characters that break the data URI (`#` in colors is fine inside `utf8`; avoid raw `%`,
  `<`, `>` in text content — encode them).
- Prefer `utf8` data URIs over base64 (shorter, readable, diffable).
- Reuse a **DAX SVG helper pattern** (header/body/footer variables) so specs stay maintainable.

## Icons & KPI illustrations

- Ship a small **icon set** as parametric SVG (status dots, arrows, flags) whose color/rotation
  is measure-driven (up/down arrow via a `transform='rotate(...)'`).
- Trend indicators, progress rings, bullet bars, rating stars — all expressible as SVG measures.
- Keep an internal library of tested SVG snippets; reference the design-system palette.

## Animated SVG

- SMIL (`<animate>`, `<animateTransform>`) works in some render contexts but is **unreliable**
  in the native Image-URL path and in exports/print. Prefer animation only inside the HTML
  Content visual (CSS keyframes) and document the limitation. Never depend on animation to
  convey meaning (accessibility).

## Synoptic maps

Custom clickable regions over an image are their own discipline — see
[synoptic-panel.md](synoptic-panel.md). SVG authoring/optimization here feeds that.

## Accessibility & handoff

- SVG images need **alt text**; color must not be the only signal (add labels/shapes).
- Handoff: the measure(s), required inputs, the data-category setting (Image URL), viewBox
  conventions, and any render limitation. Coordinate a11y with the Accessibility specialist.

---
*Sources: Power BI SVG-measure community patterns, Data Goblins (SVG in Power BI), MDN SVG.
Last reviewed: 2026-07-10.*
