---
name: deneb-visual
description: >-
  Build a Deneb (Vega-Lite) custom visual for Power BI — choose the mark, bind data roles,
  make it responsive, theme it, and enable cross-filtering. Use when a native visual can't
  express the design and the tech-selection record picked Deneb. Invoke as /deneb-visual.
---

# Build a Deneb / Vega-Lite Visual

Reference depth: `knowledge/deneb.md`, `knowledge/vega-lite.md`. Binding rules:
`shared/visual_guidelines.md`, `shared/design_system.md`. Only proceed if `tech_decision.md`
selected Deneb (or you're told to). Pre-aggregate data in DAX first.

## Procedure

1. **Confirm the job.** What question does this visual answer? Why not a native visual? (If a
   native visual + theme works, stop and use it.)
2. **Pick the mark & encodings.** Map the question to mark (`bar/line/point/arc/rule/text/...`)
   and channels (`x/y/color/size/tooltip/theta/detail`). Set explicit field types (Q/N/O/T).
3. **List the required data roles.** Name the exact measures/columns the spec reads; confirm they
   exist (request from DAX/model via the Orchestrator if not).
4. **Draft the spec** — prefer Vega-Lite; use `layer`/`facet`/`concat` for composition; move
   shaping into `transform` (`calculate/filter/aggregate/window/fold`) not extra DAX.
5. **Parametrize a template** — hoist palette, fonts, and number formats to the top so it's
   reusable; bind colors to the Power BI theme (design-system tokens), never hard-coded hex.
6. **Make it responsive** — `width/height: "container"`, `autosize: {type: fit, contains: padding}`.
7. **Enable interaction** — declare `params` with `select`; turn on Deneb cross-filtering; wire
   tooltips via the tooltip channel.
8. **Accessibility pass** — title, high-contrast palette, non-color encoding; note keyboard/reader
   limits for the Accessibility specialist.
9. **Validate** — renders at card and full-width size; no double-aggregation; sorts by value.

## Output / handoff

- The `.json` spec saved under `projects/<name>/report/` (or a template in `templates/` if reusable).
- A short note: required fields/measures, interactivity, responsive behavior, theme binding,
  known limits (e.g., no native cross-highlight parity).
- Ensure the choice is logged in `tech_decision.md`.
