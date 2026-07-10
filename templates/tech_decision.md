# Technology Decision — <Project Name>

> Owner: **Orchestrator** (via the `select-visual-tech` skill). Completed **after wireframe
> approval, before Report Development (Stage 7)**. Framework: `shared/tech_selection.md`.
> Material choices are also logged in `decision_log.md`. QA verifies the build matches this record.

## Summary

- Wireframe version approved: `<link / date>`
- Default posture: **native-first**; non-native choices justified below.
- Third-party/custom visuals used: `<list, or "none">` — allow-listing checked: `<yes/no>`

## Per-element decisions

| # | Element (page · visual/KPI) | Question it answers | Technology | Rationale (why native won't do) | Cost / risk accepted | Owner |
|---|---|---|---|---|---|---|
| 1 | Executive · Revenue KPI card | Current revenue vs target | Native / Custom theme | Native card + theme suffices | none | Visualization |
| 2 | Executive · YoY trend spark | Direction at a glance | Dynamic SVG measure | No native inline spark in card | length limit, a11y alt text | SVG & Figma |
| 3 | Drivers · Contribution bullet | Actual vs target vs range | Deneb (Vega-Lite) | No native bullet chart | JSON maintenance, no cross-highlight | Deneb specialist |
| … | | | | | | |

## Model-layer decisions

| Decision | Choice | Rationale | Owner |
|---|---|---|---|
| Calculation groups? | Yes / No | 3+ time variants × 3+ base measures? | DAX Engineer |
| Storage mode / Fabric | Import / Direct Lake / DirectQuery / Composite | see `knowledge/fabric.md` | Fabric engineer |

## Dependencies, accessibility & performance notes

- **Third-party visuals:** `<name, certification/allow-listing status, fallback if blocked>`
- **Accessibility:** custom visuals bypass native a11y — remediation per element:
  `<alt text / companion table / palette>` (routed to Accessibility specialist).
- **Performance:** pre-aggregation / render cost notes for custom visuals.

## Sign-off

- [ ] Every non-native element justified.
- [ ] Dependencies and a11y implications recorded.
- [ ] Owners assigned; specialists build only what this record assigns.
- Orchestrator: `<name / date>`
