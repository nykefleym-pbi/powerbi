# Decision Log — TEMPLATE

> **Owner:** Orchestrator records; any agent may propose an entry. **Readers:** all agents.
> Copied to `projects/<name>/decision_log.md` at kickoff. Append-only — never rewrite history;
> supersede with a new entry.

Records **non-obvious decisions** and their rationale so future work (and interview questions)
can trace *why* the dashboard is built the way it is. If a choice would make someone ask "why did
you do it that way?", it belongs here.

## Entry format

```
### D-<nnn>: <short title>
- **Date:** <YYYY-MM-DD>
- **Stage / agent:** <who raised it>
- **Context:** <the situation / problem>
- **Options considered:** <A, B, C — briefly>
- **Decision:** <what we chose>
- **Rationale:** <why — the trade-off>
- **Consequences:** <what this constrains or enables later>
- **Supersedes:** <D-xxx or none>
```

## What to log (examples)
- Grain choices and why (e.g., order-line vs. order-header fact).
- Star vs. snowflake exceptions.
- Bi-directional relationships or `USERELATIONSHIP` roles.
- Calculation group vs. explicit measure sprawl.
- Choice of visual for a contested KPI (often driven by the Critic).
- Performance trade-offs (aggregations, incremental refresh, dropped columns).
- Any business-rule interpretation that resolved an assumption.

## What NOT to log
- Routine, convention-following work already covered by `shared/` standards.
- Trivial naming choices.

---

_(entries below)_

### D-001: Framing — "Trends in context, not a scoreboard" (no president ranking)
- **Date:** 2026-07-13
- **Stage / agent:** Stage 1 Business Analyst (recommended) → user-approved via Orchestrator.
- **Context:** The project links Philippine education outcomes to presidential terms. A ranking/"best-or-worst-president" framing is tempting but attribution is correlational only (decade-long education lags, K-12 reform, COVID, measurement changes all confound).
- **Options considered:** (A) Rank/grade presidents by outcome; (B) Trends with presidents shown only as labelled time-context bands + permanent correlation-not-causation caveat, no ranking; (C) B plus a cautious per-president descriptive average.
- **Decision:** **Option B.** Presidential terms are drawn as labelled background bands on continuous time series; a correlation-not-causation caveat is permanent on the Landing page and every president-segmented view; no visual ranks or scores presidents against each other.
- **Rationale:** Honest, defensible in interview, and more insightful (lets viewers see lags/shocks/breaks). Protects portfolio credibility.
- **Consequences:** Constrains Visualization (no league tables/scorecards) and QA (acceptance criteria AC in requirements.md §7 enforce the caveat + no-ranking rule). Any president-level summary, if shown, must be descriptive with break-flags — never a rank.
- **Supersedes:** none.

### D-002: Grain — one tidy `FactMetric` (measures-as-rows), not eight facts
- **Date:** 2026-07-13
- **Stage / agent:** Stage 2 Data Architect (proposed) → Orchestrator adopted.
- **Context:** The 8 KPIs span annual school-year series (K1–K5), two discrete PISA cycles (K6), and annual LFS/WB rounds (K7–K8), with different disaggregations (level/grade/subject).
- **Options considered:** (A) one wide fact with a column per metric — mostly nulls; (B) eight purpose-built facts — relationship/measure sprawl; (C) one long/tidy indicator fact at metric × AnchorDate × education level × source with a single `MetricValue`.
- **Decision:** **Option C.** Grain = one value per Metric × AnchorDate × EducationLevel × Source; single `MetricValue` payload whose unit is defined per metric.
- **Rationale:** Smallest, most uniform model; makes the required Data & Method coverage matrix a trivial crosstab; cross-metric `SUM` is meaningless and is intentionally disabled as a guard-rail.
- **Consequences:** DAX uses a single-metric-context pattern (`SELECTEDVALUE(Dim_Metric[…])`); no additive roll-up across metrics; visuals always pin a metric. Constrains Stage 5 DAX + Stage 7 Viz.
- **Supersedes:** none.

### D-003: President attributed via computed FK on the fact + AnchorDate as-of rule (no Date→President snowflake)
- **Date:** 2026-07-13
- **Stage / agent:** Stage 2 Data Architect (proposed) → Orchestrator adopted. Resolves A-007.
- **Context:** Presidents are time-context only (D-001); terms start mid-year (mostly June 30) and straddle school years.
- **Options considered:** (A) relate Dim_Date → Dim_President (snowflake); (B) computed `PresidentKey` stamped on FactMetric via an AnchorDate as-of rule.
- **Decision:** **Option B.** AnchorDate = Oct 1 of school-year start (K1–K5), Oct 1 of PISA cycle (K6), Jul 1 of LFS/WB year (K7–K8); fact stamped with the president in office on that date. Presidential *bands* are drawn from exact term dates directly on the axis, independent of attribution.
- **Rationale:** Keeps a pure star; president is a deterministic function of date computed once at ETL; avoids query-plan inflation. Single-president attribution is used only for descriptive filtering, never ranking (D-001 preserved).
- **Consequences:** No relationship between Dim_Date and Dim_President; straddle periods attributed by AnchorDate only; QA verifies no ranking structure exists.
- **Supersedes:** none.

### D-004: Canonical Pupil–Teacher Ratio = UNESCO/World Bank; DepEd positions-basis kept separate
- **Date:** 2026-07-13
- **Stage / agent:** Stage 2 Data Architect (proposed) → Orchestrator adopted. Resolves A-006.
- **Context:** DepEd (enrolment ÷ authorized teaching positions) and UNESCO/WB (enrolment ÷ teaching-staff headcount) differ; splicing them would fabricate a false level shift.
- **Options considered:** (A) splice both into one continuous line; (B) pick one canonical series and keep the other as a distinct, separately-attributed member.
- **Decision:** **Option B.** WB/UIS `SE.*.ENRL.TC.ZS` is the canonical long anchor (verified 1971→2017); DepEd positions-basis stored as a distinct metric (`K1b`) attributed to `Dim_Source = DepEd`, never merged into the WB line.
- **Rationale:** Preserves comparability and honesty; both definitions remain visible and attributed.
- **Consequences:** Two K1 metric members; Viz shows WB as the primary line and DepEd positions-basis as an optional recent-years comparison; `Dim_Metric.DefinitionBasis` carries the distinction.
- **Supersedes:** none.
