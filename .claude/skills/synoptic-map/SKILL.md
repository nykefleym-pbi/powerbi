---
name: synoptic-map
description: >-
  Build a Synoptic Panel visual — map data onto custom areas over an image (floor plan, process,
  org, non-standard geography). Use when the story is spatial but not a standard map and the
  tech-selection picked Synoptic Panel. Invoke as /synoptic-map.
---

# Build a Synoptic Panel Map

Reference depth: `knowledge/synoptic-panel.md` (+ `knowledge/svg.md` for area SVG). Palette:
`shared/design_system.md`. Only proceed if `tech_decision.md` selected Synoptic Panel (or told to).
Note the third-party (OKViz) dependency and check org visual allow-listing.

## Procedure

1. **Confirm the fit** — is the story genuinely spatial-but-not-standard-map? (Standard geo →
   native filled map; plain category comparison → sorted bar. If so, stop.)
2. **Prepare the image** — a clean PNG/JPG or, preferably, an optimized **SVG** whose shapes carry
   `id`/`title` values that will match the category field.
3. **Author the areas map** — draw regions in Synoptic Designer or import the SVG; ensure each
   **area name matches the data category value exactly** (`id="North"` ↔ `Region = "North"`).
4. **Bind data** — Category = the matching field; Measures drive fill color/saturation.
5. **Define encoding** — states (thresholds → color) or a continuous gradient using
   design-system semantic colors; add a legend and tooltips. Never color-only.
6. **Accessibility** — provide a companion data table; add labels; document reader limits with
   the Accessibility specialist.
7. **Validate** — all areas map to a value (no unmatched names); cross-filtering works; scales
   crisply.

## Output / handoff

- The base image, the areas map (SVG/JSON) in `report/assets/`, the category→area mapping, the
  state/gradient rules, and required measures.
- Log the technology choice and the third-party dependency in `tech_decision.md`.
