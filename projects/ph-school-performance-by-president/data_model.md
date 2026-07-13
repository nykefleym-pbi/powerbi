# Data Model — PH School Performance by President

> Produced by: **Data Architect** (Stage 2 of 13) · Readers: SQL, Power Query, DAX, Performance, QA, Docs
> The blueprint every downstream engineer builds against. **Star schema, Import mode.**
> Sources for coverage claims verified 2026-07-13 (World Bank Open Data API, OECD PISA country notes, PSA/DepEd/CHED metadata). See §9.
> Respects **D-001** (presidents are *time-context bands*, never a ranking axis). No structure in this model ranks or scores presidents.

---

## 1. Grain statement

**Primary (and only) fact — `FactMetric` (long / tidy design):**
- **One row = one measured value for one Metric, for one Period (reduced to a single AnchorDate), for one Education Level, from one Source.**
- Grain key = `MetricKey × DateKey(AnchorDate) × EducationLevelKey × SourceKey`. Surrogate PK `MetricFactKey`.
- The single numeric payload is `MetricValue` (Decimal). Its unit is defined by the metric (`Dim_Metric.UnitOfMeasure`: ratio / count / score / percent), so **values are never summed across metrics** — that is meaningless by construction and is the intended guard-rail.

**Why long/tidy over multiple purpose-built facts** (proposed **D-002**, text in §6 / §10): the 8 KPIs have irreconcilable frequencies and shapes — annual school-year series (K1–K5), two discrete PISA cycles (K6), and annual LFS/WB rounds (K7–K8) — and different disaggregations (level, grade tested, subject). A single wide fact would be mostly nulls; eight narrow facts would each need their own seven relationships and eight sets of near-identical measures. A tidy "measures-as-rows" indicator fact keeps the portfolio model small, uniform, and honest, and makes the Data & Method coverage matrix (a required page) a trivial `FactMetric × Dim_Date × Dim_DataStatus` crosstab. Trade-off: DAX must always filter to a single metric (a `SELECTEDVALUE(Dim_Metric[MetricName])`-driven measure pattern), and cross-metric `SUM` is disabled — acceptable and protective. Logged as D-002.

There are **no additional facts** in v1.

## 2. Star schema diagram

```
                         +------------------+
                         |    Dim_Date      |  (marked date table, daily
                         |  DateKey (PK)    |   1965-01-01 → 2026-12-31)
                         +--------+---------+
                                  | 1
                                  | *  (AnchorDate)
   +---------------+   +----------+-----------+   +--------------------+
   | Dim_President |*--|                      |--*| Dim_EducationLevel |
   | PresidentKey  |   |                      |   | EducationLevelKey  |
   +---------------+   |                      |   +--------------------+
                       |     FactMetric       |
   +---------------+   |   MetricFactKey (PK) |   +--------------------+
   |  Dim_Metric   |*--|   MetricValue        |--*|   Dim_DataStatus   |
   |  MetricKey    |   |   (+ 7 FKs)          |   |   DataStatusKey    |
   +---------------+   |                      |   +--------------------+
                       |                      |
   +---------------+   |                      |   +----------------------+
   |  Dim_Source   |*--|                      |--*| Dim_MeasurementBreak |
   |  SourceKey    |   +----------------------+   | BreakKey  (0 = none) |
   +---------------+                              +----------------------+

   Disconnected helper (no relationship):  _Benchmarks
   (DepEd 25:1 / 45:1 reference lines; OECD PISA averages 472/476/485)
```
Pure star: **7 single-direction, many-to-one relationships**, fact → dimension only. No snowflake, no bridge, no bi-directional. President is a computed FK **on the fact** (not derived through Date) — see §6 / D-003 for why.

## 3. Tables

| Table | Type | Grain | Source | Key(s) | Approx rows |
|---|---|---|---|---|---|
| `FactMetric` | Fact | one metric value × period × level × source | `vw_fact_metric` (staged, curated CSVs) | `MetricFactKey` (PK); FKs below | ~1,500–4,000 |
| `Dim_Date` | Dimension | day | generated (Power Query) | `DateKey` | ~22,600 (1965–2026) |
| `Dim_President` | Dimension | one administration | curated (requirements §4) | `PresidentKey` | 8 (+1 Unknown) |
| `Dim_Metric` | Dimension | one metric/sub-variant | curated | `MetricKey` | ~14 |
| `Dim_EducationLevel` | Dimension | one level | curated | `EducationLevelKey` | ~6 |
| `Dim_DataStatus` | Dimension | one status | curated | `DataStatusKey` | 2 |
| `Dim_Source` | Dimension | one publisher/indicator | curated | `SourceKey` | ~8 |
| `Dim_MeasurementBreak` | Dimension / annotation | one break event (row 0 = "No break") | curated | `BreakKey` | ~5 |
| `_Benchmarks` | Disconnected helper (hidden) | one reference line | curated | none (disconnected) | ~5 |

## 4. Relationships

| From (fact) | To (dim) | Column | Cardinality | Direction | Active | Role |
|---|---|---|---|---|---|---|
| FactMetric | Dim_Date | `DateKey` (= AnchorDate) | * → 1 | single | yes | Period anchor |
| FactMetric | Dim_President | `PresidentKey` | * → 1 | single | yes | Administration in office on AnchorDate (time-context) |
| FactMetric | Dim_Metric | `MetricKey` | * → 1 | single | yes | Metric |
| FactMetric | Dim_EducationLevel | `EducationLevelKey` | * → 1 | single | yes | Level |
| FactMetric | Dim_DataStatus | `DataStatusKey` | * → 1 | single | yes | Official / Illustrative |
| FactMetric | Dim_Source | `SourceKey` | * → 1 | single | yes | Provenance |
| FactMetric | Dim_MeasurementBreak | `BreakKey` | * → 1 | single | yes | Break flag (0 = none) |

- **No relationship** exists between `Dim_President` and `Dim_Date` (that would be a snowflake). President bands are drawn by plotting `Dim_President.TermStartDate / TermEndDate` **directly** on the continuous date axis (reference regions), and president filtering flows through `FactMetric.PresidentKey`. See D-003.
- `Dim_MeasurementBreak` doubles as a disconnected **annotation source**: its `EventDate` is plotted as vertical markers on the timeline independently of the relationship. The relationship (via `BreakKey`) exists only to tag the specific fact rows sitting on/after a break (e.g., senior-high enrolment rows, NAT post-2016 rows).
- `_Benchmarks` is disconnected (reference-line values read directly by measures/visuals).

## 5. Date table

- **Range:** `1965-01-01 → 2026-12-31`, contiguous daily. Starts at 1965 so the **Marcos Sr. band (term start 1965-12-30)** and all subsequent term bands render on the same axis even though the earliest fact is 1971. Marked as the model's Date table; Auto Date/Time disabled.
- **Grain note:** the model is annual/periodic, but the Date table is daily so president term boundaries (specific dates, all June-30 inaugurations except 1986/2001) render precisely. Each fact row maps to one **AnchorDate** (see §6, A-007 resolution).
- **Columns:** `DateKey` (int `yyyymmdd`), `Date` (Date), `CalendarYear`, `Quarter`, `Month`, `MonthName`, `MonthYear`, `SchoolYearStartYear` (int), `SchoolYearLabel` (e.g., `"2015–2016"`), `IsSchoolYearStartMonth` (bool, June), `Decade`. No fiscal calendar (education/calendar year only; see A-007).

## 6. Design decisions

### 6.1 President-term mapping rule — resolves A-007 (proposed D-003)
Each metric period is reduced to a single **AnchorDate**, and the fact row is stamped (at ETL) with the `PresidentKey` of the administration in office on that AnchorDate:

| Series type | KPIs | AnchorDate rule | Rationale |
|---|---|---|---|
| Annual school-year | K1, K2, K3, K5 | **October 1 of the school-year *start* calendar year** | PH school year runs ~June→March; Oct 1 sits mid-first-semester, unambiguously after the June-30 inauguration, inside the term that presides over the bulk of that school year. SY2015–16 → 1 Oct 2015 → Aquino III (correct: classes opened June 2015 under Aquino). SY2016–17 → 1 Oct 2016 → Duterte. |
| PISA cycle | K6 | **October 1 of the cycle year** (PH sat PISA ~Q3–Q4) | 2018 → Duterte; 2022 → Marcos Jr. |
| LFS / WB annual | K7, K8 | **July 1 of the reference year** (mid-year, annual average) | Neutral mid-year anchor for a full-year figure. |

- **Straddle rule:** because every period collapses to exactly one AnchorDate, every fact row maps to exactly one president; periods that straddle a June-30 inauguration are attributed to whoever holds the AnchorDate. Single-president attribution is used **only** for optional descriptive filtering (never ranking, per D-001). The **bands themselves are always drawn from exact term dates** regardless of attribution, so the honest continuous-timeline story does not depend on this rule.
- **Why PresidentKey on the fact rather than a `Dim_Date → Dim_President` relationship:** relating two dimensions snowflakes the model and inflates query plans; a computed integer FK keeps a pure star, and president is a deterministic function of AnchorDate computed once at ETL. This is a non-obvious "why" → logged as **D-003**. It does **not** encode any ranking (D-001 preserved): `Dim_President` carries only descriptive/temporal attributes and a chronological `TermOrdinal` for axis sorting.

### 6.2 Pupil–Teacher Ratio canonical definition — resolves A-006 (proposed D-004)
- **Canonical K1 = UNESCO/UIS via World Bank definition: enrolment ÷ teaching-staff headcount** (`SE.PRM.ENRL.TC.ZS`, `SE.SEC.ENRL.TC.ZS`), because it is the longest continuous, internationally comparable series (**verified 1971→2017**, see §9). This is the primary anchor line.
- **DepEd's position-basis figure (enrolment ÷ authorized nationally-paid teaching positions, DO 77 s.2010) is stored as a SEPARATE metric member** (`K1b — Pupil–Teacher Ratio (DepEd, positions basis)`), attributed to `Dim_Source = DepEd BEIS`, covering recent years (BEIS from SY2002/03). **The two are never spliced into one line.** Reconciliation rule: both values coexist as distinct `MetricKey`s, always attributed by `Dim_Source`, with the definitional difference carried in `Dim_Metric.DefinitionBasis`. The report shows WB as the continuous line and DepEd positions-basis as an optional recent-years comparison. Logged as **D-004** (business-rule interpretation resolving A-006).

### 6.3 Data-Status modelling — implements A-008
`Dim_DataStatus` (2 rows: `Official`, `Illustrative-Estimated`) is a first-class dimension so any visual/page can isolate verified data with a single slicer, and the Data & Method coverage matrix reads it directly. `IsOfficial` (bool) supports non-colour-alone encoding downstream.

### 6.4 Measurement breaks — implements A-009/A-010 (and A-003/A-004 context)
`Dim_MeasurementBreak` makes breaks **queryable, not hard-coded in visuals**. It serves two roles: (a) disconnected annotation (its `EventDate` plotted as timeline markers), and (b) a fact tag via `BreakKey` (row 0 = "No break") marking observations affected. Seeded breaks: K-12 senior-high start (2016), NAT scale/realignment change (~2015→2016), COVID-19 shock (2020), PISA debut (2018). DAX/Viz read this table; QA checks the flags exist.

### 6.5 Disaggregation folding
True level splits (primary/secondary/SHS/HE) live in `Dim_EducationLevel`. Finer within-metric breakdowns that are **not** education levels — PISA **subject** (math/reading/science) and NAT **grade tested** (6/10/12) — are folded into `Dim_Metric` as distinct members, keeping `Dim_EducationLevel` semantically clean. K4 higher-ed graduates is **national grain only** for v1 (discipline breakdown deferred — A-014).

### 6.6 SCD / no bi-di / no snowflake
All dimensions are small and static (curated one-time load) → **Type-1** (overwrite) is sufficient; no SCD-2 history needed. No bi-directional relationships. No snowflake or bridge (the one temptation, Date→President, is deliberately avoided per D-003).

## 7. Table contracts (build to these — SQL Stage 3 / Power Query Stage 4)

> Warehouse columns are `snake_case`; Power Query renames to the PascalCase shown. Keys are Whole Number; ratios/scores/percents are Decimal; counts are Whole Number; dates are real Date. Hide every `*Key`.

### 7.1 `FactMetric`  (grain: metric × AnchorDate × level × source)
| Column | Type | Key | Notes |
|---|---|---|---|
| `MetricFactKey` | Whole Number | PK (surrogate) | identity/row number from staging; hidden |
| `MetricKey` | Whole Number | FK → Dim_Metric | |
| `DateKey` | Whole Number | FK → Dim_Date | = AnchorDate as `yyyymmdd` (per §6.1) |
| `EducationLevelKey` | Whole Number | FK → Dim_EducationLevel | `0` = National / not level-specific |
| `PresidentKey` | Whole Number | FK → Dim_President | computed at ETL from AnchorDate |
| `DataStatusKey` | Whole Number | FK → Dim_DataStatus | |
| `SourceKey` | Whole Number | FK → Dim_Source | |
| `BreakKey` | Whole Number | FK → Dim_MeasurementBreak | `0` = No break |
| `MetricValue` | Decimal | — | the single payload; unit per Dim_Metric |
| `SchoolYearStartYear` | Whole Number | — | degenerate; nullable for non-school-year metrics |
| `PeriodLabel` | Text | — | display period, e.g. `"SY2015–2016"`, `"PISA 2022"`, `"2019 (annual)"` |

### 7.2 `Dim_Date`
`DateKey` (WN, PK) · `Date` (Date) · `CalendarYear` (WN) · `Quarter` (Text) · `Month` (WN) · `MonthName` (Text) · `MonthYear` (Text) · `SchoolYearStartYear` (WN) · `SchoolYearLabel` (Text) · `IsSchoolYearStartMonth` (bool) · `Decade` (Text). Source: generated.

### 7.3 `Dim_President`  (source: requirements.md §4, corroborated — see §9)
`PresidentKey` (WN, PK) · `PresidentName` (Text) · `ShortName` (Text) · `TermStartDate` (Date) · `TermEndDate` (Date, null/`2026-12-31` sentinel for current) · `TermStartDateKey` (WN) · `TermEndDateKey` (WN) · `TermOrdinal` (WN — chronological sort only, **not** a performance rank) · `IsCurrentTerm` (bool) · `IsRightCensored` (bool — Marcos Jr., A-012) · `BandColorToken` (Text — visual placeholder, set by Viz). Row `-1` = `Unknown`.

### 7.4 `Dim_Metric`
`MetricKey` (WN, PK) · `MetricCode` (Text — `K1`,`K1b`,`K2`,`K3`,`K4`,`K5_G6`,`K5_G10`,`K5_G12`,`K6_MATH`,`K6_READ`,`K6_SCI`,`K7`,`K8`) · `MetricName` (Text) · `MetricFamily` (Text — Resourcing/Learning/Pipeline/Outcomes) · `UnitOfMeasure` (Text — Ratio/Count/Score/Percent) · `Frequency` (Text — Annual school-year / PISA cycle / LFS-WB annual) · `DefinitionBasis` (Text — e.g. `"Enrolment ÷ teaching staff (UIS)"` vs `"Enrolment ÷ authorized positions (DepEd)"`) · `IsProxy` (bool — K7,K8) · `IsComparableAcrossYears` (bool — **false for K5_***) · `HigherIsBetter` (bool, nullable — display/format hint only) · `DefaultAggregation` (Text — `None`/`Average`; never `Sum`) · `SortOrder` (WN).

### 7.5 `Dim_EducationLevel`
`EducationLevelKey` (WN, PK) · `LevelName` (Text — National / Elementary(Primary) / Junior High / Senior High / Secondary(aggregate) / Higher Education) · `LevelGroup` (Text — Basic Ed / Higher Ed / Labour Market / N/A) · `LevelOrder` (WN) · `IsPostK12Only` (bool — Senior High = true, ties to A-009). Row `0` = `National (not level-specific)`.

### 7.6 `Dim_DataStatus`
`DataStatusKey` (WN, PK) · `StatusName` (Text — Official / Illustrative-Estimated) · `IsOfficial` (bool) · `Description` (Text).

### 7.7 `Dim_Source`
`SourceKey` (WN, PK) · `Publisher` (Text) · `Dataset` (Text) · `IndicatorCode` (Text — e.g. `SE.PRM.ENRL.TC.ZS`) · `SourceURL` (Text — must resolve, AC §7) · `AccessedDate` (Date — vintage, A-011) · `DefinitionNote` (Text) · `CoverageEarliestYear` (WN) · `CoverageLatestYear` (WN).

### 7.8 `Dim_MeasurementBreak`
`BreakKey` (WN, PK; `0` = No break) · `BreakName` (Text) · `BreakType` (Text — Reform / MeasurementChange / GlobalShock / SeriesDebut) · `EventDate` (Date) · `EventDateKey` (WN) · `AffectedScope` (Text — metric/family it flags) · `Severity` (Text) · `Description` (Text).

### 7.9 `_Benchmarks` (hidden, disconnected)
`BenchmarkName` (Text) · `AppliesToMetricCode` (Text) · `AppliesToLevel` (Text) · `Value` (Decimal) · `Note` (Text). Seed: DepEd 25:1 (primary), 45:1 (secondary) reference lines; OECD PISA averages (Math 472, Reading 476, Science 485).

## 8. Lineage

| Model table | Source system | Staging (curated CSV → SQL view) | Power Query |
|---|---|---|---|
| FactMetric | WB API, OECD PISA notes, PSA LFS/OpenSTAT, DepEd BEIS/NAT, CHED HEMIS → curated CSVs | `stg_metric_raw` → `vw_fact_metric` (unpivots to long, stamps AnchorDate + PresidentKey + DataStatus + Break) | `FactMetric` |
| Dim_Date | generated | — | `DimDate` |
| Dim_President | requirements.md §4 CSV | `vw_dim_president` | `DimPresident` |
| Dim_Metric / EducationLevel / DataStatus / Source / MeasurementBreak | curated seed CSVs | `vw_dim_*` | `Dim*` |

Full source → staging → model narrative in `architecture.md`.

## 9. Verified source coverage (tightens the "earliest-year floor" the BA left open)

> Verified 2026-07-13. Every claim traces to a named indicator/publisher. Thin coverage is stated and deferred to the assumption, not invented.

| KPI | Concrete source/indicator | **Verified earliest → latest** | Note for the floor |
|---|---|---|---|
| K1 PTR primary | WB/UIS `SE.PRM.ENRL.TC.ZS` | **1971 → 2017** (gap after 2017) | Anchor. Post-2017 fill from DepEd BEIS positions-basis (K1b), *not spliced* (D-004). |
| K1 PTR secondary | WB/UIS `SE.SEC.ENRL.TC.ZS` | **1971 → 2017** (sparse 2000s) | Same handling. |
| K2 enrolment primary | WB `SE.PRM.ENRL` | **1971 → 2024** (gap 2010–2013) | Strong. Secondary via `SE.SEC.ENRL`. Senior High only 2016+ (A-009 break). |
| K3 cohort survival | DepEd BEIS/EBEIS | Official **~SY2002/03 → present** (BEIS est. 2002/03; documented 2009–2018) | Pre-2002 illustrative (A-005). |
| K4 HE graduates | CHED HEMIS / Statistical Bulletins | CHED est. **1994**; consistent bulletins ~AY1999/2000 onward; exact earliest not pinnable online | Thin pre-2000 → **defer to A-002**; pre-CHED illustrative. |
| K5 NAT MPS | DepEd NAT releases | ~2003 → present, **break ~2015→2016** | Not comparable across break (A-004); indicative only, break-flagged. |
| K6 PISA | OECD PISA country notes | **2018 & 2022 only** — Math 353→355, Reading 340→347, Science 357→356 | Two discrete anchors, never interpolated (A-003). Values seeded verified. |
| K7 youth unemployment 15–24 | PSA LFS / OpenSTAT | LFS data back to **1988**; current definition era **~2005** | Official per-round floor ~2005 (2005 LFS redefinition); WB modeled `SL.UEM.1524.ZS` longer if needed. |
| K8 college-share of unemployed | PSA LFS + WB `SL.UEM.ADVN.ZS` (corroboration) | WB **2003 → 2023** (gaps 2004–2008, 2013, 2018–2020) | Floor 2003 (WB corroboration); PSA LFS custom tab for exactness. |

## 10. Open items & proposed decision-log entries

- **Assumptions this stage resolves:** A-006 → §6.2 (D-004); A-007 → §6.1 (D-003); A-008 → §6.3; A-009/A-010 → §6.4. Marked in `assumptions.md`.
- **New assumptions added** this stage: **A-013** (WB/UIS year-label convention reconciliation), **A-014** (K4 national-grain-only, discipline deferred), **A-015** (single mixed-unit `MetricValue`; cross-metric SUM intentionally meaningless).
- **Proposed decision-log entries** (Orchestrator assigns final numbers — full text below):
  - **D-002** — Grain: single long/tidy `FactMetric` over multiple purpose-built facts.
  - **D-003** — President attributed via computed FK on the fact + AnchorDate as-of rule; Date→President snowflake explicitly rejected (D-001 preserved).
  - **D-004** — Canonical PTR = UNESCO/WB (enrolment ÷ teaching staff); DepEd positions-basis kept as a distinct, never-spliced series (resolves A-006).

### Proposed decision-log text

**D-002 — Grain: one tidy `FactMetric` (measures-as-rows), not eight facts**
- *Context:* 8 KPIs span annual school-year series, two discrete PISA cycles, and annual LFS/WB rounds, with different disaggregations (level/grade/subject).
- *Options:* (A) one wide fact (metric columns) — mostly nulls; (B) eight purpose-built facts — relationship/measure sprawl; (C) one long/tidy indicator fact at metric × period × level × source.
- *Decision:* **C.** Grain = one value per metric × AnchorDate × education level × source; single `MetricValue`.
- *Rationale:* smallest, most uniform model; makes the required coverage matrix a trivial crosstab; cross-metric SUM is meaningless and intentionally disabled.
- *Consequences:* DAX uses a single-metric-context measure pattern (`SELECTEDVALUE`); no additive roll-up across metrics; Viz slices always pin a metric.

**D-003 — President as computed FK on the fact + AnchorDate as-of rule (no Date→President snowflake)**
- *Context:* Presidents are time-context (D-001); terms start mid-year (mostly June 30) and straddle school years (A-007).
- *Options:* (A) relate Dim_Date→Dim_President (snowflake); (B) computed `PresidentKey` on FactMetric via an AnchorDate as-of rule.
- *Decision:* **B.** AnchorDate = Oct 1 of school-year start (K1–K5), Oct 1 of PISA cycle (K6), July 1 of LFS/WB year (K7–K8); stamp the president in office on that date. Bands drawn from exact term dates directly on the axis.
- *Rationale:* keeps a pure star; president is a deterministic function of date; avoids query-plan inflation; single-president attribution used only for descriptive filtering, never ranking.
- *Consequences:* no relationship between the two dimensions; QA verifies no ranking structure exists; straddle points are attributed by AnchorDate only.

**D-004 — Canonical Pupil–Teacher Ratio = UNESCO/WB; DepEd positions-basis kept separate (resolves A-006)**
- *Context:* DepEd (enrolment ÷ authorized teaching positions) and UNESCO/WB (enrolment ÷ teaching-staff headcount) differ; splicing would create a false level shift.
- *Decision:* WB/UIS `SE.*.ENRL.TC.ZS` is the canonical long anchor (verified 1971–2017); DepEd positions-basis stored as a distinct metric (`K1b`) attributed to `Dim_Source=DepEd`, never merged into the WB line.
- *Rationale:* preserves comparability and honesty; both definitions visible and attributed.
- *Consequences:* two K1 metric members; Viz shows WB as primary line, DepEd as optional recent comparison; `Dim_Metric.DefinitionBasis` carries the distinction.
