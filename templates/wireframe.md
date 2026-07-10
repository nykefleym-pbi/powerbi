# Wireframe — <Project Name>

> Produced by: **Visualization & UX** · Approved by: **Orchestrator** · Challenged by: **Critic**
> No report visuals are built until this is signed off. Use ASCII/box layouts — fidelity is about
> structure and intent, not pixels.

## Global
- **Theme:** references `design_system.md` (`theme.json`)
- **Grid:** 12-col, 8px base
- **Navigation:** <how users move between pages>
- **Persistent elements:** title bar, filter panel location, page nav

## Page: <Executive Summary>
- **Question answered:** <one question>
- **Reading order:** <top-left → ...>

```
+------------------------------------------------------------------+
| <Title bar: project name>              [ Date slicer ][ Region ] |
+------------------------------------------------------------------+
| [ KPI: Revenue ] [ KPI: Margin % ] [ KPI: Orders ] [ KPI: YoY ] |
+------------------------------------------------------------------+
| Revenue trend (line, 24 mo)          | Top regions (bar, sorted) |
|                                       |                           |
+---------------------------------------+---------------------------+
| Revenue by category (bar)             | Insight callout / notes   |
+------------------------------------------------------------------+
```

- **Per-visual intent:**
  - KPI row: current value + variance vs. PY, semantic color
  - Trend line: 24-month revenue, PY reference line
  - Top regions: horizontal bar, sorted desc, drillthrough to Regional Detail
- **Interactions:** which visuals cross-filter which; slicer scope
- **Drillthrough targets:** <page> carrying <fields>

## Page: <Detail / Drillthrough>
```
(box layout)
```

## Accessibility notes
- Contrast checked (light/dark) · tab order defined · alt text planned · no color-only meaning

## Mobile layout (Executive Summary)
```
[ KPI ]
[ KPI ]
[ Trend ]
[ Top regions ]
```

## Open design questions
- <for the Critic / Orchestrator>
