# Architecture — PH School Performance by President

> Produced by: **Data Architect** (Stage 2) + **Documentation** (later) · Readers: all
> The end-to-end technical picture: where data comes from, how it flows, how it's modeled and served.
> Storage mode: **Import**. Refresh: **one-time curated historical load** (no live gateway).

## 1. Solution overview

A single-vintage, curated historical Power BI model on long-run Philippine education trends, with presidential terms rendered as **time-context bands** (D-001). Public indicators are hand-collected from official publishers, frozen at one as-of vintage (A-011), staged as CSVs, unpivoted into one tidy long fact (`FactMetric`), and served from a small Import-mode star. No live source connection; a re-cut happens only when a source publishes a new year.

```
[Official publishers: WB/UIS, OECD PISA, PSA LFS/OpenSTAT, DepEd BEIS/NAT, CHED HEMIS]
        │  (manual curated download, one vintage — A-011)
        ▼
[Curated CSVs in /data]  →  [SQL staging: stg_* → vw_fact_metric, vw_dim_*]
        │  (unpivot to long; stamp AnchorDate, PresidentKey, DataStatus, Break)
        ▼
[Power Query ETL: typed, folded where possible]  →  [Semantic model: star, Import]
        │
        ▼
[_Measures (single-metric-context DAX)]  →  [Report pages incl. Data & Method]  →  [Portfolio viewers]
```

## 2. Data sources

| Source | Type | Owner/Publisher | Refresh | Notes (verified 2026-07-13) |
|---|---|---|---|---|
| World Bank Open Data | API/CSV | WB / UNESCO UIS | one-time | `SE.PRM.ENRL.TC.ZS`, `SE.SEC.ENRL.TC.ZS` (PTR, 1971–2017); `SE.PRM.ENRL`/`SE.SEC.ENRL` (enrolment, 1971–2024); `SL.UEM.ADVN.ZS` (2003–2023); optional `SL.UEM.1524.ZS` |
| OECD PISA | PDF/CSV | OECD | one-time | Country notes 2018 & 2022 only (discrete anchors, A-003) |
| PSA Labour Force Survey / OpenSTAT | CSV | PSA | one-time | Youth unemployment 15–24; current definition era ~2005; LFS back to 1988 |
| DepEd BEIS / EBEIS / NAT | CSV/FOI | DepEd | one-time | Cohort survival/completion (BEIS from SY2002/03); NAT MPS (~2003, break ~2015→2016); DepEd positions-basis PTR (K1b) |
| CHED HEMIS / Statistical Bulletins | CSV/PDF | CHED | one-time | HE graduates; CHED est. 1994; consistent bulletins ~AY1999/2000; pre-CHED illustrative (A-002) |

All `SourceURL`s live in `Dim_Source` and must resolve (requirements §7 AC).

## 3. Ingestion & transformation

- **SQL layer:** `stg_metric_raw` holds the union of curated per-source extracts; `vw_fact_metric` unpivots to the long grain, computes `DateKey` (AnchorDate per data_model §6.1), stamps `PresidentKey` (as-of lookup), `DataStatusKey`, `SourceKey`, `BreakKey`, and `PeriodLabel`. `vw_dim_*` emit the curated dimensions. Views document grain in their header (coding_standards). *SQL Engineer owns implementation — build to data_model §7 contracts.*
- **Power Query:** query group per table; staging queries prefixed `stg`, load disabled; explicit data types set on load (no inference); rename `snake_case`→PascalCase. Prefer folding to the SQL views; parameter `pAsOfDate` carries the frozen vintage (A-011). *Power Query Engineer owns implementation.*
- **Refresh strategy:** full one-time load; no incremental refresh (dataset is tiny, ~<4k fact rows); no gateway; manual re-cut on new source vintage, with `Dim_Source.AccessedDate` bumped.

## 4. Semantic model

- **Star** (link `data_model.md`): `FactMetric` + 7 single-direction dimensions; no snowflake/bridge/bi-di. One marked `Dim_Date` (1965–2026). President is a computed FK on the fact (D-003).
- **Measure architecture:** all measures in hidden `_Measures`, grouped by family folder (Resourcing/Learning/Pipeline/Outcomes/KPIs/_Internal). Because the fact is tidy long, base measures follow a **single-metric-context** pattern (value resolved via `SELECTEDVALUE(Dim_Metric[...])`); no additive cross-metric roll-up. *DAX Engineer (Stage 5) owns measures.*
- **RLS:** none required (public data, portfolio).

## 5. Report layer

- Pages (requirements §5): Overview/Landing, Resourcing, Learning, Pipeline, Outcomes, Data & Method. President bands + permanent correlation-not-causation caveat per D-001.
- Interaction: metric-family navigator → metric → level → year; president slicer cross-filters via `FactMetric.PresidentKey`; measurement breaks drawn from `Dim_MeasurementBreak`.
- Theme: `theme.json` (Viz stage). Illustrative vs Official encoded non-colour-alone (A-008).

## 6. Non-functional

- **Performance:** trivially within budget — model < 5 MB expected, ~<4k fact rows; all perf targets (performance_guidelines) met by design. Integer surrogate keys; keys hidden; Auto Date/Time off.
- **Accessibility:** AA; data-status not encoded by colour alone.
- **Security:** no secrets/PII; public data only.

## 7. Deployment

- Single workspace; PBIP/TMDL text format preferred (coding_standards) for diffable model + report. Dataset/report can ship together (small portfolio piece). Promotion path: dev → published portfolio workspace.

## 8. Key decisions

- **D-001** framing (bands, no ranking) — governs the whole model.
- **D-002** tidy `FactMetric` grain · **D-003** president FK + AnchorDate rule · **D-004** canonical PTR definition. (Full text in `decision_log.md` once Orchestrator assigns numbers; proposals in `data_model.md` §10.)

## 9. Diagrams

- Star schema: `data_model.md` §2. · Pipeline: §1 above. · DAX dependency map: Stage 5.
