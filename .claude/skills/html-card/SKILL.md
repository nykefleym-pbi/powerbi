---
name: html-card
description: >-
  Build a dynamic KPI card / progress bar / bespoke layout with the HTML Content visual, driven
  by a DAX measure that returns HTML+CSS. Use when native + Deneb can't achieve the card and the
  tech-selection picked HTML Content. Invoke as /html-card.
---

# Build an HTML Content Card

Reference depth: `knowledge/html-visuals.md` (+ `knowledge/svg.md` for embedded SVG). Tokens:
`shared/design_system.md`. Only proceed if `tech_decision.md` selected HTML Content (or told to).

## Procedure

1. **Define the card** — value(s), label, comparison (target/PY), and the semantic state
   (positive/negative) it must show. Pre-aggregate inputs in DAX.
2. **Author the measure** with `VAR` structure + concatenated markup:
   - Self-contained inline styles or a single `<style>` block; no external fetches.
   - Design-system tokens only (Segoe UI, token colors, 8px spacing, ≥9pt); dynamic color/arrow
     from the variance measure.
3. **Make it responsive** — `flex`/`grid`, `%`/`clamp()`, `min-width`; avoid fixed pixel widths
   that clip. Test at card size and full width.
4. **Add richness as needed** — progress/bullet bar (a track `div` + value `div` with
   `width = FORMAT([%],"0%")`), embedded `<svg>` sparkline/icon, `title=` or `:hover` tooltip,
   badges/mini-tables.
5. **Sanitize** data-derived text so source values can't inject unintended markup.
6. **Accessibility** — text alternatives, contrast per `knowledge/accessibility.md`, no
   meaning-by-color/emoji alone; document glyph-rendering assumptions.
7. **Validate** — reacts to slicers; no layout break at tested sizes; not relied on for
   cross-filtering (it's a display surface).

## Output / handoff

- The measure(s) + required fields, sizes tested, theme binding, and known limits.
- Confirm the choice is logged in `tech_decision.md`.
