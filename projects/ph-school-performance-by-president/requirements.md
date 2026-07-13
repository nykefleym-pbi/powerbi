# Dashboard Requirements — PH School Performance by President

> Produced by: **Business Analyst** · Approved by: **Orchestrator** (pending)
> Stage 1 of 13. Every section filled; unknowns live in `assumptions.md` (A-001…A-012), not blank fields.
> All data claims trace to a named public source. Where a figure is unverifiable or must be estimated, it is labelled **illustrative/estimated** here and must be labelled the same way in the report.

---

## 1. Overview

- **Business context:** A portfolio piece that demonstrates end-to-end Power BI craft on a real, emotionally resonant Philippine question: *do education outcomes appear to improve or decay across presidential administrations?* The subject is deliberately chosen to show honest handling of a politically charged, correlation-only question — the analytical maturity is as much the portfolio point as the visuals.
- **Primary goal (one sentence):** Let a viewer explore Philippine basic- and higher-education trends over the longest reliable time span, with presidential terms marked as context bands, and judge for themselves whether outcomes trend up or down across administrations — without the dashboard claiming any president *caused* an outcome.
- **Audience & personas:**
  - **P1 — Hiring manager / BI reviewer (primary):** evaluates data modelling, DAX, storytelling, and intellectual honesty. Views once, deeply, for ~5–10 minutes. Decides: "is this person's analytical judgement trustworthy?"
  - **P2 — Technical peer / interviewer (primary):** interrogates KPI definitions, sourcing, and the correlation-vs-causation framing. Decides: "can they defend every number and caveat?"
  - **P3 — General reader / education-curious citizen (secondary):** wants the headline story and to filter to an administration or education level. Decides nothing operational; must not be misled.
- **Decisions enabled:** (1) For reviewers — a hire/interview-advance judgement on BI + analytical-honesty skill. (2) For readers — an *informed personal interpretation* of long-run education trends, correctly understood as correlation. This dashboard supports **interpretation**, not policy or attribution decisions.

### 1.1 Framing recommendation (→ to be logged as a decision by Orchestrator)

- **Recommended framing:** **"Trends in context, not a scoreboard."** Present every metric as a continuous time series (the primary mark) with **presidential terms drawn as labelled background bands / reference regions**, never as a bar chart that ranks presidents against each other. The president is a *temporal annotation on the timeline*, not the axis of comparison.
- **Why this framing:**
  - Attribution is **correlation, not causation.** Education outcomes move on decade-long lags (a 2018 Grade-6 cohort entered school ~2012); global shocks (COVID-19, 2020), structural reforms (K-12, phased 2012–2016), and measurement changes confound any president-to-outcome link. A ranked "best/worst president" framing would be indefensible in interview and intellectually dishonest.
  - A trend-with-bands framing is genuinely more useful: it lets the viewer *see* lags, shocks, and reform breaks rather than collapsing them into a single misleading rank.
  - It protects the portfolio: reviewers reward the candidate who *refuses* the tempting-but-wrong chart and explains why.
- **Required caveat language the dashboard must carry** (on the landing page and on any president-segmented view):
  - > "Presidential terms are shown as **time context only**. Trends across a term reflect many factors — prior-administration policy, demographics, the economy, global events, and changes in how data is measured. **Correlation is not causation; this dashboard does not attribute outcomes to any president.**"
  - Each metric that spans a measurement break (K-12 rollout, NAT scale changes, COVID, PISA's 2018 debut) must carry a visible break annotation.
- **Explicitly rejected framing:** any "rank the presidents," "grade per administration," league table, or single "score" per president. If a president-level summary is shown at all, it must be a *descriptive average with confidence caveats and a break flag*, never a ranking.

---

## 2. Business questions

Most important first. Each drives at least one page and one or more KPIs.

1. **How has the pupil-to-teacher ratio moved over the longest reliable period, and how does its trajectory sit against presidential terms?** — *why it matters:* it is the single best-covered, longest-running, least-ambiguous resource metric (UNESCO/UIS from ~1971), so it anchors the whole "improve or decay" question with the strongest evidence.
2. **Are Filipino students learning more or less over time, and can we even measure that consistently?** — *why it matters:* learning is the outcome people care about most, yet it is the *weakest* series (NAT comparability breaks; PISA only 2018 & 2022). Handling this honestly is the analytical centrepiece.
3. **Is the education system producing more graduates (basic completion and higher-ed graduates), and are those graduates finding work?** — *why it matters:* connects the pipeline (completion → higher-ed graduates → labour-market outcome) and surfaces the "educated but jobless" tension via a clearly-labelled proxy.
4. **Where does each administration sit relative to long-run structural breaks (K-12, COVID, measurement changes)?** — *why it matters:* prevents naive president-to-outcome reads by making confounders visible.
5. **How complete and trustworthy is the underlying data across the time span?** — *why it matters:* a data-coverage view is portfolio gold and keeps the piece honest about pre-2000s gaps.

---

## 3. KPIs / metrics

Prioritised by decision value. Each earns its place by changing what a viewer concludes. Precise definitions to graduate into `business_rules.md` on Orchestrator sign-off; open definitional points carry an A-xxx link.

| # | KPI | Definition (→ business_rules) | Grain | Source (publisher) | Earliest reliable year | Proxy / illustrative note | Owner page |
|---|---|---|---|---|---|---|---|
| K1 | **Pupil–Teacher Ratio (Basic Ed)** | Enrolment ÷ teaching positions, split primary vs. secondary (A-006) | Per school year, national, by level | UNESCO Institute for Statistics via World Bank (`SE.PRM.ENRL.TC.ZS`, `SE.SEC.ENRL.TC.ZS`); DepEd BEIS for recent years | ~1971 (UIS/WB) | Real. Long, continuous. **Anchor KPI.** DepEd standard 25:1 basic / 45:1 secondary (DO 77 s.2010) as reference lines | Overview; Resourcing |
| K2 | **Basic Education Enrolment** | Total learners enrolled, by level | Per school year, national, by level | DepEd BEIS / factsheets; World Bank `SE.PRM.ENRL`, `SE.SEC.ENRL` | ~1971 (WB) | Real. Segmented; senior-high only exists post-K-12 (2016) — a structural break, not growth | Resourcing |
| K3 | **Cohort Survival / Completion Rate (Basic Ed)** | Share of a starting cohort that reaches/finishes the final grade of a level | Per school year, national, by level | DepEd BEIS / official education statistics | ~1990s (DepEd series); earlier illustrative | Real where published; pre-1990s **illustrative/estimated** (A-005) | Pipeline |
| K4 | **Higher-Education Graduates** | Count of graduates from HEIs, by broad discipline where available | Per academic year, national | CHED HEMIS / CHED Statistical Bulletins | ~mid/late-1990s (CHED est. 1994) | Real from CHED era; pre-CHED **illustrative/estimated** (A-002) | Pipeline |
| K5 | **Student Achievement — NAT Mean Percentage Score** | DepEd National Achievement Test MPS, by grade tested (6/10/12) | Per school year, national, by grade | DepEd (NAT results releases / FOI) | ~2000s | Real but **NOT comparable across years** — scale/method changed (2015 MPS 70.88 → 2018 37.44 is largely measurement, not learning). Must show break flags; treat cross-year trend as **indicative only** (A-004) | Learning |
| K6 | **Student Achievement — PISA Score** | OECD PISA mean score, math/reading/science | Per PISA cycle, national | OECD PISA 2018, 2022 | 2018 (PH's first cycle) | Real, internationally comparable, but only **two data points** — cannot form a long trend; shown as benchmark anchors, not a line implying continuity (A-003) | Learning |
| K7 | **Youth Unemployment Rate (15–24)** | PSA Labour Force Survey unemployment rate for ages 15–24 | Per LFS round (monthly/quarterly/annual avg) | PSA Labour Force Survey | ~2005 (current LFS definition era) | **PROXY** for post-graduation joblessness — there is no clean cohort "unemployment after graduation" series (A-001). Label as proxy | Outcomes |
| K8 | **College-Educated Share of the Unemployed** | Share of total unemployed whose highest attainment is college (undergrad/graduate) | Per LFS round, national | PSA Labour Force Survey; World Bank `unemployment with advanced education (% of total)` (2003–2023) as corroboration | ~2003 (WB series) | **PROXY** for "educated but jobless"; a share, not a rate — must be labelled so it isn't read as a graduate unemployment rate (A-001) | Outcomes |

**KPI count: 8** (K1–K8). K1–K2 are the strong evidentiary spine; K3–K4 the pipeline; K5–K6 the deliberately-caveated learning story; K7–K8 the clearly-labelled labour-market proxy.

---

## 4. Dimensions & filters

- **Slicing dimensions:**
  - **President / Administration (first-class dimension).** Each with exact term start/end for band placement:
    | President | Term start | Term end |
    |---|---|---|
    | Ferdinand E. Marcos (Sr.) | 1965-12-30 | 1986-02-25 |
    | Corazon C. Aquino | 1986-02-25 | 1992-06-30 |
    | Fidel V. Ramos | 1992-06-30 | 1998-06-30 |
    | Joseph E. Estrada | 1998-06-30 | 2001-01-20 |
    | Gloria Macapagal-Arroyo | 2001-01-20 | 2010-06-30 |
    | Benigno S. Aquino III | 2010-06-30 | 2016-06-30 |
    | Rodrigo R. Duterte | 2016-06-30 | 2022-06-30 |
    | Ferdinand R. Marcos Jr. | 2022-06-30 | present |
    *(Source: Wikipedia "List of presidents of the Philippines," corroborated by official records; term-to-school-year mapping rule is A-007.)*
  - **Date / Year** — with a School-Year vs Calendar-Year vs Academic-Year reconciliation rule (A-007).
  - **Education level** — Primary / Elementary, Junior High, Senior High, Higher Education.
  - **Metric family** — Resourcing / Learning / Pipeline / Outcomes (for the overview navigator).
  - **Data status** — Official / Illustrative-estimated (so viewers can isolate verified data) (A-008).
- **Default filters / date range:** default to the **full available span per metric** (do not force a common window that hides long series); highlight the most-covered window (~1971–present for K1–K2). President bands always on by default.
- **Required drill paths:** Metric family → Metric → Education level → Year (→ optional President-segmented descriptive view, with caveat).

---

## 5. Pages & storytelling

| Page | Question it answers | Key visuals (intent — not design) | Audience |
|---|---|---|---|
| **Overview / Landing** | What's the whole story, and how should I read it? | KPI headline row (K1, K5/K6, K4, K7); one master timeline with president bands; **prominent framing caveat**; navigator to families | P1, P2, P3 |
| **Resourcing** | Is the system better- or worse-staffed over time? (Q1) | K1 pupil-teacher ratio trend with 25:1/45:1 reference lines + president bands; K2 enrolment trend; senior-high break annotation | All |
| **Learning** | Are students learning more or less — and can we even tell? (Q2) | K5 NAT MPS with explicit **measurement-break flags**; K6 PISA 2018/2022 as anchor points (not a continuous line); honesty callout | P1, P2 (analytical) |
| **Pipeline** | Are more people completing and graduating? (Q3, part 1) | K3 completion/cohort-survival trend; K4 higher-ed graduates trend; illustrative-data shading pre-CHED/pre-1990s | All |
| **Outcomes** | Do graduates find work? (Q3, part 2) | K7 youth unemployment trend; K8 college-share-of-unemployed; **proxy label** banner | All |
| **Data & Method** | How trustworthy is this? (Q5) | Coverage matrix (metric × year × official/illustrative); source list with links; full caveat + framing statement | P1, P2 |

**Narrative arc:** Landing states the answer *and* the honesty rule → Resourcing gives the strongest, longest evidence → Learning confronts the hardest, weakest evidence openly → Pipeline & Outcomes follow the human pipeline from completion to the labour market → Data & Method earns trust by exposing every gap and source. Overview → insight → *epistemic humility as the "action."* The viewer leaves with an informed interpretation and full sight of the caveats.

---

## 6. User stories

- As a **hiring manager (P1)**, I want a one-screen overview with the headline trend and a visible correlation caveat, so that I can judge both BI skill and analytical honesty in under a minute.
- As a **technical interviewer (P2)**, I want every KPI to expose its source, grain, earliest year, and any proxy/illustrative flag, so that I can probe definitions and the candidate can defend them.
- As a **technical interviewer (P2)**, I want measurement breaks (K-12, NAT scale change, COVID, PISA debut) annotated on the timeline, so that I can confirm the candidate understands what confounds a president-to-outcome read.
- As a **general reader (P3)**, I want to filter to one administration or one education level and still see the caveat, so that I explore freely without being misled into a causal conclusion.
- As a **general reader (P3)**, I want illustrative/estimated figures clearly distinguished from official ones, so that I know which numbers to trust.
- As **any viewer**, I want a Data & Method page listing sources with links, so that I can verify any figure myself.

---

## 7. Acceptance criteria

Objectively testable statements for QA.

- [ ] Every KPI (K1–K8) renders with a visible source attribution and, where applicable, a proxy/illustrative label matching this document.
- [ ] The **correlation-not-causation caveat** (Section 1.1 language) appears on the Landing page and on every president-segmented view; QA confirms it cannot be filtered away.
- [ ] No visual in the report ranks presidents against each other on any outcome (no league table, no "best/worst president" chart). QA inspects every page.
- [ ] President term bands on the master timeline match the exact dates in Section 4 (start/end within ±0 days of the table).
- [ ] Each measurement break — K-12 senior-high start (2016), NAT scale change, COVID (2020), PISA first cycle (2018) — has a visible annotation on the relevant page.
- [ ] Illustrative/estimated data points are visually distinct from official data (not by colour alone — per visual guidelines) and are reconciled to a source or explicitly flagged as estimated on the Data & Method page.
- [ ] Every source cited in the report resolves to a real, reachable publisher URL (DepEd, CHED, PSA, UNESCO/UIS, World Bank, OECD) listed on the Data & Method page.
- [ ] K1 pupil-teacher ratio series covers at least ~1971→latest for at least one level; the covered range is stated on the page.
- [ ] K5 (NAT) is never drawn as a single continuous comparable line across a known scale break without a break marker; QA verifies the break flag is present.
- [ ] K6 (PISA) is shown only at 2018 and 2022 (discrete anchors), not interpolated as a continuous trend.
- [ ] K7/K8 carry a "proxy for post-graduation joblessness" label wherever shown.
- [ ] The Data & Method coverage matrix marks, per KPI per era, whether data is Official or Illustrative — with no blank cells.

---

## 8. Scope

- **In scope:** Long-run national trends for K1–K8; president terms as time-context bands; basic + higher education; a data-coverage/method page; honest handling of gaps via illustrative labelling; correlation-with-caveats framing.
- **Out of scope (explicitly):**
  - Any causal attribution of an outcome to a president, or any president ranking/scorecard.
  - Regional / provincial / school-level granularity (national only for v1).
  - Private-vs-public disaggregation beyond what a source directly publishes.
  - Budget/spending-per-student analysis (candidate for v2; not in the four locked metric themes).
  - Real-time or frequent refresh — this is a historical, static-vintage dataset.
  - Forecasting/projection of future outcomes.
- **Data sources (named):** DepEd (BEIS, factsheets, NAT releases, FOI portal); CHED (HEMIS, Statistical Bulletins); PSA (Labour Force Survey, OpenSTAT); UNESCO Institute for Statistics; World Bank Open Data (education & labour indicators); OECD PISA (2018, 2022). Exact URLs compiled by the Data Architect; starting links in Section 9.
- **Refresh expectation:** One-time curated historical load; manual re-cut only when a source publishes a new year. No live gateway.

---

## 9. Assumptions & open questions

Logged in `assumptions.md`: **A-001** (post-graduation unemployment proxy), **A-002** (pre-CHED higher-ed graduate data gap), **A-003** (PISA two-points-only, not a trend), **A-004** (NAT cross-year comparability break), **A-005** (pre-1990s basic-ed completion illustrative), **A-006** (pupil-teacher ratio definition: enrolment÷positions vs÷teachers), **A-007** (school-year / academic-year / calendar-year ↔ presidential-term mapping rule), **A-008** (official vs illustrative labelling standard), **A-009** (K-12 structural break handling), **A-010** (COVID-2020 break handling), **A-011** (data vintage / as-of date to freeze), **A-012** (Marcos Jr. term ongoing / right-censoring).

**Awaiting Orchestrator confirmation:** the framing recommendation in Section 1.1 (to be logged as a decision); the KPI set (Critic may cut); the earliest-year floor per KPI once the Data Architect verifies actual source coverage.

**Source starting points (for Data Architect to verify & cite exactly):**
- DepEd statistics / BEIS: deped.gov.ph ; NAT & teacher data via FOI: foi.gov.ph/agencies/deped
- CHED statistics: ched.gov.ph/statistics ; legacy.ched.gov.ph/statistics
- PSA Labour Force Survey: psa.gov.ph/statistics/labor-force-survey ; OpenSTAT: openstat.psa.gov.ph
- UNESCO/World Bank pupil-teacher ratio: data.worldbank.org/indicator/SE.PRM.ENRL.TC.ZS (and SE.SEC…), SE.PRM.ENRL / SE.SEC.ENRL
- OECD PISA Philippines: oecd.org PISA 2022 country note (and 2018)
- Presidential terms: en.wikipedia.org/wiki/List_of_presidents_of_the_Philippines
