# Performance — Engine Internals & Tuning

> For Performance, DAX, and Data Architect. Companion to
> [`shared/performance_guidelines.md`](../shared/performance_guidelines.md) (budgets + rules).
> This file explains the *engine* so tuning is diagnosis-led, not guesswork. SQLBI/Microsoft-aligned.

## The two engines

- **Storage Engine (VertiPaq/SE):** columnar, compressed, multi-threaded, fast. Does scans,
  simple aggregations, and filters. Cacheable.
- **Formula Engine (FE):** single-threaded, evaluates DAX logic the SE can't. Iterators,
  context transitions, and complex `CALCULATE` push work to the FE.
- **Goal:** maximize SE, minimize FE. A slow measure is usually FE-bound or making too many SE
  queries (high "SE queries" count, big "FE %").

## VertiPaq compression (why cardinality rules)

- Columns are compressed per-column; **fewer distinct values = better compression = smaller,
  faster**. This is why splitting datetime, rounding decimals, and dropping GUIDs/free text win.
- Encoding: value vs. hash; sort order affects run-length compression. Integer keys beat text.
- Use **VertiPaq Analyzer** to rank columns by size and see cardinality/encoding.

## Diagnosis workflow

1. **Performance Analyzer** (Desktop) → find the slow visual; read DAX vs. render time.
2. Copy its DAX into **DAX Studio** → **Server Timings** (SE vs FE ms, SE query count) and
   **Query Plan**.
3. **VertiPaq Analyzer** → biggest columns/tables, relationship cardinality.
4. **Best Practice Analyzer** (Tabular Editor) → model-wide rule violations.
5. Fix the biggest offender, re-measure. One change at a time.

## Common fixes (highest leverage first)

| Symptom | Likely cause | Fix |
|---|---|---|
| Huge model | High-cardinality columns | Split datetime, round, drop unused, integer keys |
| Slow measure | FE-bound iterator / context transition | Rework to SE-friendly `SUM`/filters; reduce transitions |
| Slow page | Too many visuals / high-card tables | ≤8 visuals, drillthrough for detail, turn off needless interactions |
| Slow refresh | Broken folding, no incremental | Preserve folding, incremental refresh, source-side filter |
| Bi-di blowups | Bi-directional relationships | Single direction + `CROSSFILTER`/`TREATAS` on demand |

## Model & DAX levers

- Star schema; narrow facts; integer surrogate keys; disable Auto Date/Time.
- Aggregation tables (`Agg*`) mapped to detail facts for very large data.
- Base measures so the engine reuses cached sub-results; avoid `FILTER` over whole tables.
- Calc groups are powerful but a bad item taxes every measure — profile them.
- Direct Lake / storage-mode choices: see [fabric.md](fabric.md).

---
*Sources: SQLBI (VertiPaq, optimizing DAX, server timings), Microsoft Learn (Performance
Analyzer, aggregations, incremental refresh), DAX Studio & Tabular Editor docs.
Last reviewed: 2026-07-10.*
