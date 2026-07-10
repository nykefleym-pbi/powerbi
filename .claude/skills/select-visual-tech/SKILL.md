---
name: select-visual-tech
description: >-
  Decide, per wireframe element, which implementation technology to use — native visual, Deneb,
  dynamic SVG, HTML Content, Synoptic Panel, custom theme, calculation groups — and record the
  reasoning before any build work. Run by the Orchestrator at the wireframe gate. Invoke as
  /select-visual-tech.
---

# Select Visual Technology

The Orchestrator runs this **after wireframe approval and before Report Development (Stage 7)**.
Reference: `shared/tech_selection.md` (decision framework). Output: a completed
`projects/<name>/tech_decision.md` (from `templates/tech_decision.md`). Reasoning is mandatory —
every non-native choice must be justified and logged.

## Procedure

1. **Enumerate elements** — list each visual/KPI/interaction from the approved `wireframe.md`.
2. **Apply the decision ladder per element** (default to the cheapest that works):
   - **Native visual** — first choice; if a native visual + theme answers the question, use it.
   - **Custom theme (`theme.json`)** — for styling/format defaults; always, not a substitute for a visual.
   - **Dynamic SVG measure** — small measure-driven KPI art, sparkline, status icon, progress ring.
   - **HTML Content** — bespoke KPI card/layout/progress bar native can't style; display-only.
   - **Deneb (Vega-Lite)** — a chart native can't express (bullet, dumbbell, small multiples,
     custom-encoded, layered annotation) or needing precise design control.
   - **Synoptic Panel** — spatial story on a custom image (floor/process/org/non-standard geo).
   - **Calculation groups** — when 3+ time variants × 3+ base measures (routes to DAX, not visuals).
3. **Justify each non-native choice** — one line: why native won't do, the cost accepted
   (maintenance, no cross-highlight, a11y, third-party dependency).
4. **Note dependencies & risks** — third-party/custom visuals (allow-listing, certification),
   accessibility implications, performance cost.
5. **Assign the builder** — native/theme → Visualization; SVG → SVG & Figma designer; HTML → HTML
   specialist; Deneb → Deneb specialist; Synoptic → Synoptic specialist; calc groups → DAX Engineer.
6. **Record** the full table in `tech_decision.md` and log material choices in `decision_log.md`.

## Output

`tech_decision.md`: one row per element → chosen technology → rationale → cost/risk → owner.
This gates Stage 7; specialists build only what this record assigns.
