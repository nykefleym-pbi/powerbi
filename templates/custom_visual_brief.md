# Custom Visual Brief — <Element Name>

> The Orchestrator/Visualization hands this to a visual specialist (Deneb / SVG / HTML / Synoptic)
> when `tech_decision.md` assigns a non-native build. One brief per custom element. The specialist
> follows the matching skill (`/deneb-visual`, `/svg-measure`, `/html-card`, `/synoptic-map`).

## What & why

- **Element:** `<page · name>`
- **Question it answers / decision it supports:** `<one sentence>`
- **Technology (from tech_decision.md):** `Deneb | SVG | HTML Content | Synoptic Panel`
- **Why not native:** `<one line>`

## Inputs

- **Measures/columns available:** `<exact names — must already exist in the model>`
- **Missing inputs to request (via Orchestrator):** `<name → owner, or "none">`
- **Grain / expected row count after pre-aggregation:** `<...>`

## Design spec

- **Encoding / layout:** `<mark & channels | card layout | SVG shapes | area map>`
- **Design-system tokens:** colors `<roles>`, type `<sizes>`, spacing — per `shared/design_system.md`.
- **States / thresholds:** `<positive/negative, targets, gradient breaks>`
- **Responsive behavior:** `<container sizing; sizes to test>`
- **Interaction:** `<cross-filter? tooltip content? drillthrough?>`

## Constraints

- Accessibility: `<alt text, non-color encoding, companion table>` (coord. Accessibility specialist).
- Performance: `<pre-aggregate in DAX; render budget>`.
- Dependency/governance: `<third-party allow-listing, fallback>`.

## Definition of done

- [ ] Answers the stated question; matches design-system tokens.
- [ ] Responsive at tested sizes; interaction as specified.
- [ ] Accessibility handled or limitation documented.
- [ ] Deliverable saved to `projects/<name>/report/` (+ assets); choice reflected in `tech_decision.md`.
- [ ] Handoff summary returned: what was built, inputs used, limits.
