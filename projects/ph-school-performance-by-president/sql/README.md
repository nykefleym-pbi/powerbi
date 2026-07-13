# SQL warehouse layer — PH School Performance by President

> Stage 3 of 13 (SQL Engineer). SQL only — no M, no DAX, no visuals.
> Builds to `data_model.md` §6 (derivations), §7 (table contracts), §8 (lineage).

## Staging assumption
Each curated CSV in `../data/` is treated as a **staging table**, loaded verbatim with
all columns as text:

| CSV | Staging table |
|---|---|
| `fact_metric_raw.csv` | `stg_fact_metric_raw` |
| `dim_president.csv` | `stg_dim_president` |
| `dim_metric.csv` | `stg_dim_metric` |
| `dim_education_level.csv` | `stg_dim_education_level` |
| `dim_data_status.csv` | `stg_dim_data_status` |
| `dim_source.csv` | `stg_dim_source` |
| `dim_measurement_break.csv` | `stg_dim_measurement_break` |

Because staging is text, every view casts types explicitly per the §7 contracts
(keys/counts → INT, ratios/scores/percents → DECIMAL, flags → BIT, dates → DATE).

## Views → data_model §8 lineage
Each view is the "curated CSV → SQL view" warehouse layer that Power Query (Stage 4) imports.

| View | Model table | Grain | Surrogate PK (+ sentinel) |
|---|---|---|---|
| `vw_fact_metric` | FactMetric | metric × AnchorDate × level × source | `metric_fact_key` |
| `vw_dim_date` | Dim_Date | day | `date_key` (yyyymmdd) |
| `vw_dim_president` | Dim_President | administration | `president_key` (-1 = Unknown) |
| `vw_dim_metric` | Dim_Metric | metric member | `metric_key` |
| `vw_dim_education_level` | Dim_EducationLevel | level | `education_level_key` (0 = National) |
| `vw_dim_data_status` | Dim_DataStatus | status | `data_status_key` |
| `vw_dim_source` | Dim_Source | publisher × indicator | `source_key` |
| `vw_dim_measurement_break` | Dim_MeasurementBreak | break event | `break_key` (0 = No break) |

## Import-mode note
This is an Import-mode portfolio project; there is no live warehouse. These views
**document and reference-implement** the semantic shaping. Stage 4 mirrors the same
logic in Power Query over the CSVs for the actual load — keep the two in sync. In
particular `Dim_Date` is generated in Power Query (§8), so `vw_dim_date` is the
reference calendar, not the load path.

## AnchorDate + president as-of (the two non-obvious derivations)
- **AnchorDate (§6.1):** each period collapses to one date — `July 1 of year` for K7/K8
  (LFS/WB annual), `Oct 1 of year` for K6_* (PISA cycle), `Oct 1 of school_year_start_year`
  for every school/academic-year series (K1, K1b, K2, K3, K4, K5_*). NAT (K5_*) rows already
  carry `school_year_start_year = year − 1`, so they need no special-casing. `DateKey` is that
  date as `yyyymmdd`.
- **PresidentKey (D-003):** an as-of join stamps the administration in office on the AnchorDate
  (`term_start_date ≤ AnchorDate < term_end_date`). Term bands are contiguous half-open
  intervals, so exactly one president matches; this is a computed FK **on the fact**, never a
  `Dim_Date → Dim_President` relationship.

## How to validate
Row counts after building the views:

| Object | Expected rows |
|---|---|
| `vw_fact_metric` | **273** |
| `vw_dim_date` | ~22,645 (1965-01-01 → 2026-12-31) |
| `vw_dim_president` | 9 (8 administrations + Unknown) |
| `vw_dim_metric` | 13 |
| `vw_dim_education_level` | 6 |
| `vw_dim_data_status` | 2 |
| `vw_dim_source` | 10 |
| `vw_dim_measurement_break` | 5 (incl. No break) |

Key integrity checks:
- No `vw_fact_metric` row should have `president_key = -1` (all anchors fall 1971→2024, inside a
  known term). A `-1` means a fact row anchored before Marcos Sr.'s 1965 term start — investigate.
- Every `metric_key / education_level_key / data_status_key / source_key` on the fact must resolve
  (the four dim joins are INNER; a dropped row signals a token mismatch).
- `break_key` is `0` for all rows with a blank `break_flag`; non-zero only for the four seeded breaks.

## Contract notes / handled mismatches (flag for Orchestrator + Data Architect)
1. **K4 AnchorDate not in the §6.1 table.** `data_model.md` §6.1 lists AnchorDate rules for
   K1/K2/K3/K5, K6, K7/K8 but **omits K4** (frequency "Annual academic-year"). K4 has 8 fact
   rows with `school_year_start_year` populated, so this view anchors K4 with the school/academic-year
   rule (Oct 1 of `school_year_start_year`), consistent with its frequency. **Not silently changing
   the model — please confirm** this is the intended rule for K4.
2. **Dim_Source grouped codes.** `dim_source.csv` has one row for PISA (`PISA-MATH/READ/SCI`) and one
   for NAT (`NAT-MPS-G6/G10`), but the fact carries per-subject/per-grade codes (`PISA-MATH`, …,
   `NAT-MPS-G10`). `vw_fact_metric` normalises those onto the grouped codes before joining
   (`source_join_code`) so every fact row resolves a `source_key`. Publisher-text join was **not**
   usable (the fact merges WB publishers into one label; the dim splits WB by indicator).
3. **Dim_Metric row count.** Contract §3 estimates ~14 metric members; the seed CSV has **13**
   (K1, K1b, K2, K3, K4, K5_G6/G10/G12, K6_MATH/READ/SCI, K7, K8). No action — noted for QA.
4. **Portability.** Views use `DATEFROMPARTS`, `DATENAME`, and (for `vw_dim_date`) a numbers/tally
   pattern built from stacked `CROSS JOIN`s — all valid on Fabric Warehouse / Azure SQL / SQL Server /
   Synapse, with no recursion cap to lift. Power Query generates the calendar for the actual Import
   load regardless.
