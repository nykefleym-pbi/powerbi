# Project State

> **Owner:** Orchestrator (exclusively). No other agent writes to this file.
> **Readers:** all agents read the relevant slice at the start of their task.
> Single source of truth for status. Keep it short — a dashboard, not a transcript.

---

## Project: `ph-school-performance-by-president`
- **Goal (one sentence):** A portfolio-quality Power BI dashboard exploring Philippine school-performance trends over time with presidential terms marked, to see whether outcomes appear to decay or improve across administrations — covering student-to-teacher ratio, student performance trends, graduate counts, and post-graduation unemployment — using cited data from official sources (DepEd, CHED, PSA, etc.).
- **Stakeholders / audience:** Primary — portfolio reviewers / hiring managers evaluating BI skill. Secondary — general readers interested in PH education trends. (Confirm exact persona in Stage 1.)
- **Current stage:** `3`→`4` (Stages 1–3 ✅ + data acquired; next: Power Query)
- **Overall status:** 🟢 on track — pacing: drive through engineering, **PAUSE at Stage 6 wireframe** for user approval
- **Last updated:** 2026-07-13

## Project decisions locked at kickoff (from user)
- **Purpose:** Portfolio showcase — use real official data; where official data has gaps, label figures as illustrative/estimated clearly.
- **Data:** Orchestrator team gathers and **cites** from official sources (DepEd, CHED, PSA/PSA LFS, UNESCO/World Bank as corroboration). No fabricated authority.
- **Time span:** As far back as reliable official data allows; accept that early administrations will have gaps.
- **Framing:** Business Analyst to **recommend** the most credible framing (correlation-with-caveats vs. ranking) and bring it back — presidential attribution is correlational, not causal, and must be presented as such.

## Pipeline status

| # | Stage | Agent | Status | Output artifact | Notes |
|---|-------|-------|--------|-----------------|-------|
| 1 | Business Analysis | business-analyst | ✅ | requirements.md | 8 KPIs, 5 questions, testable AC, A-001…A-012 logged; framing recommended |
| 2 | Data Architecture | data-architect | ✅ | data_model.md + architecture.md | Tidy star: 1 fact + 7 dims; D-002/003/004 logged; source coverage verified |
| 3 | SQL Development | sql-engineer | ✅ | sql/ | 8 views + README; AnchorDate + president as-of join (D-003); 3 minor mismatches accepted |
| 4 | Power Query | power-query | ☐ | powerquery/ | |
| 5 | Semantic Model (DAX) | dax-engineer | ☐ | measures/ | |
| 6 | Wireframe Approval + Tech Selection | visualization → orchestrator | ☐ | wireframe.md + tech_decision.md | Hard gate |
| 7 | Report Development | visualization | ☐ | report/ | |
| 8 | Performance Review | performance | ☐ | performance_report.md | |
| 9 | QA Validation | qa | ☐ | qa_report.md | Hard gate |
| 10 | Documentation | documentation | ☐ | README + guides | |
| 11 | Portfolio Review | portfolio-reviewer | ☐ | portfolio_review.md | |
| 12 | Dashboard Critique | dashboard-critic | ☐ | critique.md | Hard gate |
| 13 | Final Review | orchestrator | ☐ | release_notes.md | |

Legend: ☐ not started · ⏳ in progress · ✅ done · 🔁 rework requested · ⛔ blocked

## Handoff summaries (rolling, newest first)

> One short paragraph per completed stage — the summary the next agent needs.

- **Stage 3 SQL Development — 2026-07-13:** Wrote 8 views + README to `sql\`. Each SELECTs from a `stg_*` staging table (CSV-as-source), casts to §7 contract types, adds integer surrogate keys with sentinel rows (President -1, EducationLevel 0, Break 0). `vw_fact_metric` implements **AnchorDate** (Jul 1 of year for K7/K8; Oct 1 of year for K6; Oct 1 of school_year_start_year for school/academic series incl. K4) → `DateKey`, and **PresidentKey via as-of LEFT JOIN** (term_start ≤ AnchorDate < term_end; unmatched → -1) = D-003 realized. Normalized PISA/NAT subject/grade codes onto grouped Dim_Source codes via `source_join_code` so every fact row resolves a SourceKey. Orchestrator accepted 3 minor mismatches (K4 anchor rule, source-code normalization, 13 vs ~14 metric rows). **Expected row counts:** fact 273, president 9, metric 13, education 6, status 2, source 10, break 5, date ~22,645. **Next (Power Query, Stage 4):** mirror this shaping over the CSVs for the Import load (generate Dim_Date, replicate AnchorDate CASE + president as-of stamp + code normalization + BreakKey-0 default; PascalCase names, §7 types, hide *Key columns).
- **Data Acquisition (Stage 3 input) — 2026-07-13:** Gathered REAL cited data into `data\` (9 files). `fact_metric_raw.csv` = **273 rows: 265 Official + 8 Illustrative**. Fully-real: K1 PTR (WB/UIS 1971–2017), K2 enrolment (WB 1971–2024), K3 primary-completion proxy (WB 1981–2024), K5 NAT MPS G6/G10 (DepEd, 2016 break-flagged), K6 PISA (OECD, 2018 M353/R340/S357, 2022 M355/R347/S356), K7 youth unemployment (WB 1991–2024), K8 unemployment-w/-advanced-ed (WB 2003–2023). **Only illustrative:** K4 higher-ed graduates (all 8 rows — CHED site 403-blocks automated fetch; smooth ~180k→830k estimate, replace w/ CHED Facts & Figures later). K1b + K5_G12 catalogued, no rows yet. Every source cited in `data\SOURCES.md`. **SQL note:** NAT rows use `school_year_start_year = year−1`; education_level uses bare tokens (join keys) — add parenthetical display names downstream.
- **Stage 2 Data Architecture — 2026-07-13:** Produced `data_model.md` + `architecture.md`. **Tidy/long star:** one `FactMetric` (grain = Metric × AnchorDate × Education Level × Source, single `MetricValue`) + 7 dimensions (Date [daily 1965–2026, marked], President, Metric, EducationLevel, DataStatus, Source, MeasurementBreak) + 1 disconnected `_Benchmarks`. 7 single-direction relationships, pure star. Adopted **D-002** (grain), **D-003** (president = computed FK on fact via AnchorDate as-of rule; no Date→President snowflake), **D-004** (canonical PTR = UNESCO/WB, DepEd positions-basis kept as separate `K1b`, never spliced). Resolved A-006/007/008/009/010; added A-013/014/015. **Verified earliest→latest per KPI** (§9): K1 1971→2017, K2 1971→2024, K3 ~SY2002/03, K4 thin pre-2000, K5 ~2003 (break 2015→16), K6 2018 & 2022 only, K7 ~2005, K8 2003→2023. Import mode, one-time curated load. **Next:** curated CSVs must be *gathered* from the named sources, then SQL Stage 3 builds `vw_fact_metric` + `vw_dim_*` to the §7 contracts.
- **Stage 1 Business Analysis — 2026-07-13:** Produced `requirements.md` (8 KPIs, 5 business questions, 6 pages, testable acceptance criteria) + logged A-001…A-012 in `assumptions.md`. Grounded in an 8-lookup data-availability scan. Strongest evidence = pupil-teacher ratio (UNESCO/WB from ~1971, the anchor KPI); weakest = cross-year learning measurement (NAT not comparable across years; PISA only 2018 & 2022) — handled openly as the analytical centrepiece. Post-graduation unemployment has no clean series → proxied by PSA youth-unemployment + college-share-of-unemployed, clearly labelled. **Framing recommended: "Trends in context, not a scoreboard"** — time series with presidential terms as labelled background bands + a permanent correlation-not-causation caveat; explicitly reject any president ranking. **Next (Data Architect):** verify actual source coverage/earliest years, resolve the pupil-teacher-ratio definition mismatch (A-006) and the school-year↔term mapping rule (A-007), design the star schema with President/Administration and a Date dimension + a Data-Status (official/illustrative) flag.

## Open items / blockers
- **Data availability is the top project risk.** Ratios and enrolment/graduate counts are well-published by DepEd/CHED/PSA; "unemployment specifically after graduation, by year" is much harder and may need a proxy (e.g., PSA Labour Force Survey youth/new-graduate unemployment). BA to assess and flag → data-architect.
- Attribution methodology (president ↔ outcome) must be framed as correlation with explicit caveats. → BA to recommend, Orchestrator to log as a decision.

## Decisions & assumptions
- See `decision_log.md` and `assumptions.md`. Kickoff choices captured above.
