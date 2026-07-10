# Modern Power BI UX

> For Visualization, the Critic, and the visual specialists. Companion to
> [`shared/visual_guidelines.md`](../shared/visual_guidelines.md) (binding chart/layout rules)
> and [`shared/design_system.md`](../shared/design_system.md) (tokens). This file is the *design
> thinking* behind them, aligned with modern Power BI / Data Goblins practice.

## Principles

- **Clarity over decoration.** Every pixel earns its place; remove before you add.
- **Answer first.** The user should get the headline in ~5 seconds, detail on demand.
- **Consistency is trust.** Same filter placement, nav, spacing, and color roles on every page.
- **Design for the decision, not the data.** Layout should lead the eye to the action.

## Layout & hierarchy

- **Z / F reading pattern**: brand + title top-left, filters top-right, KPI row across the top,
  primary chart center, supporting detail below.
- Establish hierarchy with **size, weight, position, whitespace** — not color or borders.
- Group related content; use whitespace (the 8px system) as the primary separator, not lines.
- ≤ 8 visuals per page; one primary question per page (split or drillthrough otherwise).

## Interaction design

- Progressive disclosure: **overview → focus → detail** via drillthrough and tooltips, not
  cramming everything onto one page.
- Deliberate cross-filtering (Edit Interactions) — not every visual filters every other.
- One well-designed filter experience (a panel via bookmark) beats scattered slicers.
- Give affordances: buttons look clickable, reset is visible, selected state is obvious.

## Color & type (from the design system)

- Neutral canvas; **one accent** for the primary call-to-attention; semantic positive/negative
  only. Never encode meaning by color alone.
- Segoe UI; weight for hierarchy; right-align numbers, left-align text; ≥ 9pt.

## Micro-craft that reads as "senior"

- Insight titles ("Revenue up 12% YoY, led by West"), reference/target lines, variance coloring,
  data labels only where they help, aligned axes, no chart junk, consistent number formats.
- Custom KPI cards ([html-visuals.md](html-visuals.md) / [svg.md](svg.md)) and tasteful Deneb
  visuals where native falls short — chosen via [`shared/tech_selection.md`](../shared/tech_selection.md).

## Anti-patterns

- Dashboard-as-data-dump; rainbow palettes; 3D/gauges without cause; rotated axis labels;
  inconsistent placement; decorative imagery; five slicers in a row.

---
*Sources: Data Goblins (modern Power BI design, UX), Microsoft Power BI design guidance,
Storytelling with Data. Last reviewed: 2026-07-10.*
