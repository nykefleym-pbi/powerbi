# Performance Guidelines

> **Owner:** Performance Optimizer · **Readers:** all engineering agents, QA
> Targets below are portfolio defaults; the Orchestrator may adjust per project and log it.

## Performance budget (defaults)

| Metric | Target | Hard limit |
|---|---|---|
| Model size (PBIX) | < 100 MB | < 500 MB |
| Page render (interactive) | < 2 s | < 5 s |
| Slicer/cross-filter response | < 1 s | < 2 s |
| Full refresh (dev dataset) | < 5 min | < 15 min |
| Visuals per page | ≤ 8 | ≤ 12 |

## VertiPaq / model size

- **Column cardinality is the #1 driver of size.** Reduce it:
  - Split `DateTime` into `Date` + `Time` columns; drop seconds if unused.
  - Remove high-cardinality columns not needed for analysis (GUIDs, raw notes, free text).
  - Round decimals to the needed precision.
- **Remove unused columns and tables** — if no measure, relationship, or visual uses it, drop it.
- Prefer **integer keys** over text keys for relationships.
- Disable **Auto Date/Time** (Options) — it creates a hidden date table per date column.
- Set **"Is Available in MDX" = false** on high-cardinality attribute columns not needed for Excel/Q&A.
- Use **VertiPaq Analyzer** (DAX Studio) to find the largest columns and encoding types.

## Data model

- Star schema; avoid bi-directional relationships (they inflate query plans).
- Integer surrogate keys on relationships.
- Keep fact tables narrow (keys + measures); push descriptive attributes to dimensions.
- Consider **aggregation tables** (`Agg*`) for very large facts, mapped to the detail fact.

## DAX performance

- Straight `SUM`/`COUNTROWS` over iterators (`SUMX`) when a column already holds the value.
- Minimize context transitions inside large iterators.
- Reuse `VAR`s instead of recomputing sub-expressions.
- Avoid `FILTER(Table, ...)` over whole large tables; filter columns and let folding/engine help.
- Prefer measure branches (base + variants) so the engine caches shared sub-results.
- Watch calculation groups: powerful, but a badly written item taxes every measure.

## Power Query / refresh

- Preserve query folding (see `powerquery_guidelines.md`) — fold filters/joins to the source.
- Filter to the needed date range at the source via parameter.
- Incremental refresh for large, date-partitioned facts.
- Avoid unnecessary `Table.Buffer`; use it only to prevent repeated source evaluation.

## Report / visuals

- ≤ 8 visuals per page target; each visual is a query.
- Avoid high-cardinality visuals (tables with thousands of rows) on landing pages — use drillthrough.
- Turn off unnecessary interactions between visuals (Edit Interactions).
- Limit slicers; prefer a single well-designed filter experience.
- Custom visuals only when a native visual can't do the job (they cost load time and trust).

## Measurement tools

- **Performance Analyzer** (in Power BI Desktop) for per-visual DAX + render timing.
- **DAX Studio + VertiPaq Analyzer** for model size, column cardinality, server timings.
- **Best Practice Analyzer** (Tabular Editor) for model-wide rule checks.

## Optimizer's report format

The Performance Optimizer produces an **optimization report** listing, per finding:
observation → impact (size/time) → recommendation → owner agent → status. It hands
actionable items back to the relevant engineer via the Orchestrator; it does not edit
another agent's artifacts directly.
