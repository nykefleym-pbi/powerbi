# Assumptions Register — TEMPLATE

> **Owner:** Business Analyst maintains; Orchestrator confirms/closes. **Readers:** all agents.
> Copied to `projects/<name>/assumptions.md` at kickoff.

Tracks everything the team is **taking as true without confirmation**. Because portfolio projects
often use synthetic or public data with no live stakeholder, most business questions resolve into
documented assumptions rather than answered requirements. Making them explicit keeps the work
honest and interview-defensible.

## Entry format

```
### A-<nnn>: <assumption in one sentence>
- **Date raised:** <YYYY-MM-DD>  · **Raised by:** <agent>
- **Category:** business rule / data / scope / performance / design
- **Why we need it:** <what's blocked without a decision>
- **Assumed value:** <what we're proceeding with>
- **Confidence:** high / medium / low
- **Impact if wrong:** <what breaks / must change>
- **Status:** open / confirmed / rejected → graduated to `business_rules.md` as <rule>
```

## Rules
- No agent silently guesses a business definition — it becomes an assumption here first.
- When an assumption is confirmed, it graduates to `business_rules.md` (or the data model) and is
  marked confirmed here with a link.
- Low-confidence, high-impact assumptions are surfaced by the Orchestrator to the user before the
  dependent stage proceeds.
- The Portfolio Reviewer and Critic scan this register — undocumented guesses are a finding.

---

_(entries below)_

### A-001: Post-graduation unemployment has no clean cohort series; we use PSA LFS youth unemployment + college-share-of-unemployed as the proxy.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** data
- **Why we need it:** One of the four locked metric themes is "post-graduation unemployment," but PSA publishes no "unemployment specifically after graduation, by cohort/year." A defensible proxy is required or the theme is unmeasurable.
- **Assumed value:** Use (a) PSA LFS **youth unemployment rate, 15–24** (K7) and (b) **college-educated share of the unemployed** (K8), both labelled as proxies; corroborate with World Bank "unemployment with advanced education (% of total)" and PIDS Graduate Tracer Study. Do NOT present either as a true graduate-unemployment rate.
- **Confidence:** medium
- **Impact if wrong:** If reviewers reject the proxy, the Outcomes page loses its metric; mitigated by explicit proxy labelling and the Data & Method page.
- **Status:** open

### A-002: Higher-education graduate counts are only reliable from the CHED era (~mid/late-1990s); earlier figures are illustrative.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** data
- **Why we need it:** CHED was established in 1994; consistent HEMIS graduate series predate that thinly if at all. K4's earliest-year floor depends on this.
- **Assumed value:** Treat CHED-era data as official; any pre-CHED higher-ed graduate figure shown is labelled **illustrative/estimated** and sourced if possible.
- **Confidence:** medium
- **Impact if wrong:** Earliest-year floor for K4 shifts; affects how far the Pipeline page timeline extends.
- **Status:** open

### A-003: PISA provides only two Philippine data points (2018, 2022) and must be shown as discrete anchors, not a continuous trend.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** data
- **Why we need it:** The Philippines first joined PISA in 2018; two cycles cannot form a trend line without misleading.
- **Assumed value:** Render PISA as two labelled benchmark points per subject; never interpolate. Use as international comparability anchor for the Learning page.
- **Confidence:** high
- **Impact if wrong:** Minimal; conservative choice. If a third cycle is released within scope, add it.
- **Status:** open

### A-004: NAT Mean Percentage Score is not comparable across years due to scale/methodology changes; cross-year trend is indicative only.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** data
- **Why we need it:** Published NAT MPS shows a break (e.g., Grade-6 ~70.88 in 2015 → 37.44 in 2018) that is largely a measurement change, not a real learning collapse. Drawing a naive trend would be misleading.
- **Assumed value:** Show NAT with explicit **measurement-break flags**; label the cross-year series indicative, not comparable; never draw it as a single continuous comparable line across a known break.
- **Confidence:** medium
- **Impact if wrong:** If DepEd confirms a consistent re-based series exists, breaks can be removed; until verified, breaks stay.
- **Status:** open

### A-005: Basic-education completion / cohort-survival data is reliable from ~1990s; pre-1990s points are illustrative.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** data
- **Why we need it:** DepEd cohort-survival/completion series coverage thins before the 1990s; K3's floor depends on it.
- **Assumed value:** Official from ~1990s onward; earlier values labelled illustrative/estimated.
- **Confidence:** medium
- **Impact if wrong:** K3 timeline start shifts.
- **Status:** open

### A-006: Pupil–Teacher Ratio is defined as enrolment ÷ teaching positions (per DepEd), which may differ from UNESCO's enrolment ÷ teachers.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** business rule
- **Why we need it:** DepEd's "Teacher–Pupil Ratio" uses *authorized nationally paid teaching positions*; UNESCO/World Bank uses *teaching staff headcount*. Splicing the two series without noting the definitional difference would be inconsistent.
- **Assumed value:** Use the UNESCO/WB definition for the long historical series (K1 anchor) and note where DepEd's position-based figure differs; do not silently splice.
- **Confidence:** medium
- **Impact if wrong:** Level shifts at the splice point; mitigated by keeping series clearly attributed and annotated.
- **Status:** open → **resolved at model level by Data Architect** (data_model.md §6.2, proposed **D-004**): canonical PTR = UNESCO/WB (enrolment ÷ teaching staff, verified 1971–2017); DepEd positions-basis kept as a distinct metric `K1b`, never spliced. Pending Orchestrator confirm → `business_rules.md`.

### A-007: A mapping rule is needed between school year / academic year / calendar year and presidential terms (terms start mid-year, June 30).
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** business rule
- **Why we need it:** Most presidential terms begin June 30; school years and PISA/LFS rounds use different period conventions. Band placement and any president-segmented view need one consistent rule.
- **Assumed value:** Anchor each data point to the calendar year in which the school/academic year *ends* (or the LFS round occurs); place president bands on the continuous date axis by exact term dates; note that a data year can straddle two administrations.
- **Confidence:** medium
- **Impact if wrong:** Points near term boundaries could be mis-associated; the trend-with-bands framing (not per-president aggregation) limits the damage.
- **Status:** open → **resolved at model level by Data Architect** (data_model.md §6.1, proposed **D-003**): AnchorDate rule = Oct 1 of school-year start (K1–K5), Oct 1 of PISA cycle (K6), Jul 1 of LFS/WB year (K7–K8); stamp president in office on AnchorDate; bands drawn from exact term dates. Pending Orchestrator confirm → `business_rules.md`.

### A-008: A single "Official vs Illustrative/Estimated" labelling standard applies to every figure.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** design / business rule
- **Why we need it:** The portfolio integrity depends on viewers always knowing which numbers are verified. A consistent, non-colour-alone visual convention is required.
- **Assumed value:** Every data point carries a status of Official or Illustrative/Estimated; illustrative points are visually distinct (pattern/label, not colour alone) and enumerated on the Data & Method page.
- **Confidence:** high
- **Impact if wrong:** Low; conservative and required by the locked kickoff decision.
- **Status:** open → **implemented in model** as `Dim_DataStatus` (data_model.md §6.3). Pending Orchestrator confirm → `business_rules.md`.

### A-009: The K-12 reform (senior high phased 2012–2016) is a structural break, not organic growth, and must be annotated.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** data
- **Why we need it:** Senior-high enrolment (Grades 11–12) did not exist before K-12, so K2/K3 show discontinuities that are reform-driven, not administration performance.
- **Assumed value:** Annotate the K-12 rollout on affected pages; do not read the enrolment/completion step-change as a president effect.
- **Confidence:** high
- **Impact if wrong:** Low; conservative.
- **Status:** open

### A-010: COVID-19 (2020 onward) is a global shock break affecting learning and labour metrics and must be annotated.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** data
- **Why we need it:** Pandemic school closures and labour disruption distort K5/K7/K8 around 2020–2022 independent of any administration.
- **Assumed value:** Annotate 2020 as a shock on affected pages; caveat any interpretation spanning it.
- **Confidence:** high
- **Impact if wrong:** Low; conservative.
- **Status:** open

### A-011: A single data-vintage / as-of date will be frozen for the build.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** scope
- **Why we need it:** PSA LFS updates monthly and figures are revised; the dashboard must state the vintage it was cut from for reproducibility.
- **Assumed value:** Freeze an as-of date (e.g., latest complete year available at build) and state it on the Data & Method page; do not mix vintages within a series.
- **Confidence:** high
- **Impact if wrong:** Low; a stated vintage is standard practice.
- **Status:** open

### A-012: The current administration (Marcos Jr., 2022–present) is right-censored; its band is open-ended and partial.
- **Date raised:** 2026-07-13  · **Raised by:** business-analyst
- **Category:** data / design
- **Why we need it:** The latest term is incomplete, so any within-term read is partial and must not be compared as if complete.
- **Assumed value:** Draw the current term band as open-ended/"to date"; caveat that its data is partial.
- **Confidence:** high
- **Impact if wrong:** Low; conservative.
- **Status:** open

### A-013: World Bank/UIS school-year indicators are re-labelled to our `SchoolYearStartYear` before the AnchorDate rule is applied.
- **Date raised:** 2026-07-13  · **Raised by:** data-architect
- **Category:** data
- **Why we need it:** WB/UIS `SE.*` indicators carry a single calendar-year label whose convention (year the school year *begins* vs *ends*) is not uniform; the AnchorDate rule (A-007 / D-003) depends on knowing the school-year *start* year.
- **Assumed value:** Treat each WB annual value as the school year **beginning** in that labelled year and map it to `SchoolYearStartYear = labelled year`; the SQL Engineer verifies this against UIS metadata per indicator and documents any per-indicator exception in `vw_fact_metric`.
- **Confidence:** medium
- **Impact if wrong:** A one-year shift in the series and possible mis-attribution of boundary years to the adjacent president; mitigated because bands are drawn from exact term dates, not from attribution.
- **Status:** open

### A-014: Higher-education graduates (K4) are modelled at national grain only for v1; discipline breakdown is deferred.
- **Date raised:** 2026-07-13  · **Raised by:** data-architect
- **Category:** scope
- **Why we need it:** CHED publishes graduates by discipline, but coverage/consistency of the discipline cut across the full span is uneven and out of scope for v1's national-trend story.
- **Assumed value:** K4 rows use `EducationLevelKey = Higher Education` with no discipline split; discipline is a v2 candidate (add a `Dim_Discipline` if pursued).
- **Confidence:** high
- **Impact if wrong:** Low; adding a dimension later is non-breaking to the tidy fact.
- **Status:** open

### A-015: `FactMetric.MetricValue` is a single mixed-unit column; cross-metric aggregation is intentionally meaningless and disabled.
- **Date raised:** 2026-07-13  · **Raised by:** data-architect
- **Category:** data
- **Why we need it:** The tidy/long grain (D-002) stores ratios, counts, scores, and percents in one column; summing across metrics would be nonsense.
- **Assumed value:** Measures always resolve a single metric via `SELECTEDVALUE(Dim_Metric[...])`; `Dim_Metric.DefaultAggregation` never permits `Sum` across metrics; Viz always pins a metric before showing a value. This is a deliberate guard-rail, not a limitation to fix.
- **Confidence:** high
- **Impact if wrong:** If a genuine additive cross-metric need appears, split that metric into its own purpose-built fact; low likelihood for this portfolio.
- **Status:** open
