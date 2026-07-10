# Report Storytelling & Portfolio Presentation

> For Visualization, Documentation, and the Portfolio Reviewer. Companion to
> [ux.md](ux.md) and [`shared/visual_guidelines.md`](../shared/visual_guidelines.md).
> Data-Goblins-aligned: executive dashboards, narrative, and portfolio polish.

## The narrative arc

A strong report reads like an argument, not a data dump:
1. **Headline** — the single most important answer, stated in the title/KPI row.
2. **Context** — vs. target, prior period, benchmark. "Good or bad?" must be instant.
3. **Drivers** — what's moving the headline (top/bottom contributors, trend breaks).
4. **Detail / action** — drillthrough to the record and the "so what / now what."

Order pages the same way: **Executive Summary → Driver/dimension pages → Drillthrough**.

## Executive dashboards

- 3–5 KPIs max, each with value + label + comparison (target or PY) + trend.
- One primary chart that carries the story; supporting visuals subordinate to it.
- Insight titles: *"Revenue up 12% YoY, led by West; East down 4%"* — not *"Revenue by Region"*.
- Variance-to-target coloring, reference lines, and annotations make judgment automatic.
- Respect the executive's 30 seconds: answer first, let them drill only if they want.

## Making it decision-useful

- Every KPI/page must map to a **decision and an owner** (the Critic enforces this).
- Kill vanity metrics; prefer rates/ratios/variances over raw counts where the decision needs them.
- Annotate anomalies; don't make the reader hunt for the story.

## Portfolio presentation (interview-winning polish)

- **Cover / landing** with a clear title, purpose, and audience.
- A concise **README** (impact-first): problem → approach → result → how it was built
  (model, DAX highlights, tech choices). See [`templates/portfolio_readme.md`](../templates/portfolio_readme.md).
- Show **range**: a native-visual page, a tasteful Deneb/custom-visual page, clean DAX with a
  calc group — evidence of breadth, chosen deliberately (log why in `tech_decision.md`).
- Screenshots/GIF of the key interaction; a one-line "what a hiring manager should notice."
- Defensibility: be ready to justify every visual, measure, and grain decision (Portfolio Reviewer
  checks interview-readiness).

## Anti-patterns

- Pretty but pointless; every-chart-a-different-color; no comparison/context; buried headline;
  a wall of tables; custom visuals for their own sake.

---
*Sources: Data Goblins (dashboard storytelling, executive dashboards, portfolio), Storytelling
with Data, Microsoft Power BI design guidance. Last reviewed: 2026-07-10.*
