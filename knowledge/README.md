# Knowledge Library

A reusable, internal reference library for **every** agent. It is the deep "textbook" that sits
behind the enforced "law" in [`shared/`](../shared/).

- **`shared/`** = the standards agents must *comply* with (QA rejects violations).
- **`knowledge/`** = the patterns and external best practices agents *learn from* and cite.
  Reading is optional-but-recommended; nothing here is a hard gate on its own.

Agents read the file(s) relevant to their task and link back to `shared/` for the binding rule.
Knowledge files **reference** `shared/` standards — they don't restate or override them.

## Contents

| File | Domain | Primary readers |
|---|---|---|
| [sqlbi-patterns.md](sqlbi-patterns.md) | Evaluation/filter context, variables, `CALCULATE`, virtual relationships | DAX, Performance, QA |
| [dax-best-practices.md](dax-best-practices.md) | Time intelligence, calc groups, VertiPaq, naming (SQLBI-aligned) | DAX, Data Architect, Performance |
| [deneb.md](deneb.md) | Deneb custom visuals, templates, responsive JSON | Deneb specialist, Visualization |
| [vega-lite.md](vega-lite.md) | Vega-Lite grammar, layered charts, tooltips, transforms | Deneb specialist |
| [svg.md](svg.md) | Dynamic SVG measures, optimization, icons, KPI illustrations | SVG & Figma designer |
| [figma.md](figma.md) | Components, variables, auto layout, design systems, SVG export | SVG & Figma designer, Visualization |
| [html-visuals.md](html-visuals.md) | HTML Content visual, CSS, responsive KPI cards, progress bars | HTML specialist |
| [synoptic-panel.md](synoptic-panel.md) | Synoptic maps, areas over image, SVG map authoring | Synoptic specialist |
| [fabric.md](fabric.md) | Fabric, semantic models, Direct Lake, deployment pipelines | Fabric engineer, Data Architect |
| [ux.md](ux.md) | Modern Power BI UX, layout, interaction design | Visualization, Critic |
| [accessibility.md](accessibility.md) | WCAG 2.2 AA, Power BI a11y features, remediation | Accessibility specialist, QA |
| [performance.md](performance.md) | Engine internals, tuning workflow, tools | Performance, DAX, Data Architect |
| [report-storytelling.md](report-storytelling.md) | Executive dashboards, narrative, portfolio presentation (Data Goblins) | Visualization, Portfolio Reviewer |

## Sources tracked

The [knowledge-curator](../agents/knowledge-curator.md) keeps these current against:
**Microsoft Learn** (Power BI, Fabric, semantic models, design, accessibility, deployment
pipelines), **SQLBI** (DAX, context, VertiPaq, calc groups), **Deneb docs** (Vega-Lite),
and **Data Goblins** (storytelling, Deneb, SVG, modern design). Each file's footer records the
last review date and the source anchors it summarizes.

> These files summarize and synthesize public guidance for internal use; they are not
> verbatim copies. When in doubt, follow the primary source and update the file.
