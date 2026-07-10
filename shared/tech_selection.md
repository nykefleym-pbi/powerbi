# Visual Technology Selection

> **Owner:** Orchestrator · **Readers:** Orchestrator, Visualization + visual specialists, DAX, QA
> The **binding decision framework** for choosing an implementation technology per report element.
> The Orchestrator runs it at the wireframe gate via the `select-visual-tech` skill and records
> the result in the project `tech_decision.md`. QA checks that builds match the record.

## Principle: cheapest technology that answers the question

Custom technology buys expressiveness at the cost of maintenance, cross-highlight parity,
accessibility, and (for third-party visuals) governance. **Default to native.** Every non-native
choice must be justified in `tech_decision.md`.

## Decision ladder

| Technology | Use when | Cost / risk | Owner | Depth |
|---|---|---|---|---|
| **Native visual** | A native visual + theme answers the question | none | Visualization | `shared/visual_guidelines.md` |
| **Custom theme** (`theme.json`) | Styling, format, and default enforcement (always) | none | Visualization | `shared/design_system.md` |
| **Calculation groups** | 3+ time variants × 3+ base measures (collapses measure sprawl) | bad item taxes all measures | DAX Engineer | `knowledge/dax-best-practices.md` |
| **Dynamic SVG measure** | Small measure-driven KPI art, sparkline, status icon, progress ring | length limit, per-row render, a11y | SVG & Figma designer | `knowledge/svg.md` |
| **HTML Content** | Bespoke KPI card / layout / progress bar native can't style | display-only, no cross-highlight, a11y | HTML Visual specialist | `knowledge/html-visuals.md` |
| **Deneb (Vega-Lite)** | Chart native can't express (bullet, dumbbell, small multiples, layered/annotated, custom-encoded) or needing precise design control | JSON literacy, no native cross-highlight, maintenance | Deneb specialist | `knowledge/deneb.md`, `knowledge/vega-lite.md` |
| **Synoptic Panel** | Spatial story on a custom image (floor/process/org/non-standard geography) | third-party, allow-listing, a11y | Synoptic specialist | `knowledge/synoptic-panel.md` |

## Rules

- **Native first.** If two technologies both work, pick the one with lower cost/risk.
- **Justify every non-native element** in one line: why native won't do + the cost accepted.
- **Record third-party dependencies** (custom visuals) and check org allow-listing / certification.
- **Flag accessibility** for every custom visual — it bypasses native a11y; route to the
  Accessibility specialist and note remediation.
- **Performance:** custom visuals cost load time and re-render on data change — pre-aggregate in DAX.
- The decision is made **after wireframe approval, before Report Development (Stage 7)**. Builds
  that deviate from `tech_decision.md` are a QA defect unless re-logged in `decision_log.md`.

## Output

`projects/<name>/tech_decision.md` (from `templates/tech_decision.md`): one row per element →
technology → rationale → cost/risk → owner. Material choices also go to `decision_log.md`.
