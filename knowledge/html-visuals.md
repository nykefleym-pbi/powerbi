# HTML Content Visual

> For the **HTML Visual specialist**. The *HTML Content* custom visual renders HTML/CSS driven by
> a DAX measure that returns markup. Use when native + Deneb can't achieve a bespoke card/layout
> (see [`shared/tech_selection.md`](../shared/tech_selection.md)).

## How it works

- A measure returns an **HTML string**; the visual renders it. Content is recomputed with the
  filter context, so cards react to slicers.
- Build the markup in DAX with `VAR` blocks (structure) and concatenation (dynamic values +
  colors). Keep a header/body/footer helper pattern like [svg.md](svg.md).

```dax
KPI Card HTML =
VAR Val   = FORMAT ( [Total Revenue], "$#,0" )
VAR Delta = [Revenue YoY %]
VAR Color = IF ( Delta >= 0, "#1F9E6E", "#E5484D" )
VAR Arrow = IF ( Delta >= 0, "▲", "▼" )
RETURN
"<div style='font-family:Segoe UI;padding:12px;border:1px solid #E3E6EB;border-radius:8px'>" &
  "<div style='font-size:12px;color:#5B6472'>Revenue</div>" &
  "<div style='font-size:32px;color:#1A1D23'>" & Val & "</div>" &
  "<div style='font-size:13px;color:" & Color & "'>" & Arrow & " " &
     FORMAT ( Delta, "0.0%" ) & " YoY</div>" &
"</div>"
```

## CSS & responsive layout

- Prefer **inline styles** or a single `<style>` block; keep it self-contained (no external
  fetches — many are blocked and it hurts trust/perf).
- Responsive: `display:flex`/`grid`, `%`/`clamp()` sizes, `min-width`; avoid fixed pixel widths
  that clip. Test at card and full-width sizes.
- Honor [`shared/design_system.md`](../shared/design_system.md): Segoe UI, token colors, 8px
  spacing, ≥9pt text. Don't invent a second palette.

## Patterns

- **Dynamic KPI cards** — value + label + variance with semantic color and arrow/icon.
- **Progress bars / bullet** — a track `div` + a value `div` whose `width` is `FORMAT([%],"0%")`.
- **Embedded SVG** — drop an `<svg>` (from [svg.md](svg.md)) inside the HTML for sparklines/icons.
- **Tooltips** — `title="..."` for native hover text, or a CSS `:hover` reveal for richer content.
- **Mini tables / badges / callouts** the native card can't style.

## Limits & accessibility

- No cross-highlight into other visuals; it's a display surface, not an interactive filter.
- Measure string length is bounded — keep markup lean; pre-aggregate in DAX.
- Provide text alternatives; never rely on color/emoji alone. Ensure contrast per
  [accessibility.md](accessibility.md). Emoji/glyph rendering varies — document assumptions.
- Sanitize any data-derived text you inject (avoid unintended markup from source values).

## Handoff

Deliver the measure(s), required fields, the sizes tested, theme binding, and known limits.
Log the technology choice in `tech_decision.md`.

---
*Sources: HTML Content visual docs, Power BI HTML-measure community patterns, MDN CSS.
Last reviewed: 2026-07-10.*
