---
name: svg-measure
description: >-
  Build a dynamic, measure-driven SVG for Power BI (KPI illustration, sparkline, progress ring,
  status icon) rendered via an Image-URL column or embedded in an HTML/Deneb visual. Use when
  the tech-selection picked SVG. Invoke as /svg-measure.
---

# Build a Dynamic SVG Measure

Reference depth: `knowledge/svg.md` (+ `knowledge/figma.md` for asset prep). Palette/tokens:
`shared/design_system.md`. Only proceed if `tech_decision.md` selected SVG (or you're told to).

## Procedure

1. **Define the visual intent** — what does it show (trend, status, progress, rating) and which
   measure(s) drive color/size/shape?
2. **Set a fixed `viewBox`** and design in relative coordinates so it scales cleanly.
3. **Author the measure** with a header/body/footer `VAR` pattern:
   - `Header` = `"data:image/svg+xml;utf8,<svg xmlns='...' viewBox='...'>"`
   - `Body` = shapes/paths/text whose attributes are built from measures (fill, width, points,
     `transform='rotate(...)'` for up/down).
   - Colors from the design-system semantic roles; use `utf8` data URIs (not base64).
4. **Keep it tiny** — minimal markup, no whitespace, short paths; respect the Image-URL length
   limit; encode characters that break the URI.
5. **Wire it up** — set the column/measure **Data category = Image URL**; place in a
   Table/Matrix/card that renders image URLs. (Or embed the `<svg>` string inside an HTML card.)
6. **Accessibility** — provide alt text; never rely on color alone (add label/shape). Avoid
   depending on SMIL animation in the Image-URL path; animate only inside HTML/CSS if needed.
7. **Validate** — reacts correctly to slicers; renders across the row range; no clipping.

## Output / handoff

- The measure(s) + the data-category setting, viewBox convention, inputs, and render limits.
- Reusable snippets added to an internal library note if broadly useful.
- Confirm the choice is logged in `tech_decision.md`; coordinate a11y with the specialist.
