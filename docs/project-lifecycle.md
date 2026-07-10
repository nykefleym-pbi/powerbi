# Project Lifecycle

Every project runs through 13 stages. Each stage has one owning agent, one primary deliverable,
and a gate the Orchestrator checks before advancing.

## The pipeline

| # | Stage | Owner | Deliverable | Gate to pass |
|---|-------|-------|-------------|--------------|
| 1 | Business Analysis | business-analyst | `requirements.md` | Questions, KPIs, testable acceptance criteria; unknowns logged |
| 2 | Data Architecture | data-architect | `data_model.md` | Grain stated; star schema; relationships defined |
| 3 | SQL Development | sql-engineer | `sql/` views | Grain-correct, fold-friendly views with keys |
| 4 | Power Query | power-query | `powerquery/` | Model tables at correct grain; folding preserved |
| 5 | Semantic Model (DAX) | dax-engineer | `measures/` + spec | KPIs implemented; base/variant pattern; dictionary updated |
| 6 | **Wireframe Approval + Technology Selection** | visualization → orchestrator | `wireframe.md` + `tech_decision.md` | Wireframe approved & Critic-challenged; **technology chosen per element** (native/theme/SVG/HTML/Deneb/Synoptic + calc groups) and justified |
| 7 | Report Development | visualization + visual sub-specialists | `report/` + `theme.json` | Matches wireframe & `tech_decision.md`; ≤8 visuals/page; a11y |
| 8 | Performance Review | performance | `performance_report.md` | Within budget or documented exception |
| 9 | **QA Validation** | qa | `qa_report.md` | PASS; no blocking defects |
| 10 | Documentation | documentation | README + guides | Impact-first, complete, consistent |
| 11 | Portfolio Review | portfolio-reviewer | `portfolio_review.md` | Score at/above portfolio bar |
| 12 | **Dashboard Critique** | dashboard-critic | `critique.md` | Material challenges resolved or consciously accepted |
| 13 | Final Review | orchestrator | `release_notes.md` | Sign-off: SHIP / REWORK |

Bold stages are hard gates that are never skipped. The 13-stage backbone is unchanged; Stage 6
now also produces the **technology decision** (see below) before any build.

## Technology selection (inside Stage 6, before build)

After the wireframe is approved, the **Orchestrator** runs the `select-visual-tech` skill and
records `tech_decision.md` (from `templates/tech_decision.md`), choosing the cheapest technology
that answers each element — **native visual → custom theme → dynamic SVG → HTML Content → Deneb →
Synoptic Panel**, plus **calculation groups** at the model layer — per `shared/tech_selection.md`.
Stage 7 then routes each element to its builder:

| Technology | Builder (sub-specialist) |
|---|---|
| Native visual / custom theme | visualization |
| Dynamic SVG measure | svg-figma-designer |
| HTML Content | html-visual-specialist |
| Deneb (Vega-Lite) | deneb-specialist |
| Synoptic Panel | synoptic-panel-specialist |
| Calculation groups | dax-engineer |

## On-demand roles (outside the linear pipeline)

- **fabric-engineer** — invoked when storage mode (Import / Direct Lake / DirectQuery / Composite),
  refresh strategy, deployment pipelines, or Fabric/semantic-model governance are in scope
  (typically consulted around Stages 2, 8, and 10).
- **accessibility-specialist** — audits the built report (around Stage 7–9) and hands an
  `accessibility_audit.md` to **QA (Stage 9)**, which still owns the pass/fail gate.
- **knowledge-curator** — works entirely **outside** project execution, maintaining `knowledge/`
  and recommending updates. Never joins a project build.

## Flow diagram

```
        (1) Business Analysis
                 │  requirements.md
                 ▼
        (2) Data Architecture ──► table contracts
                 │  data_model.md
        ┌────────┴─────────┐   (SQL and the Date-table build can overlap)
        ▼                  ▼
   (3) SQL            (Date table)
        │  vw_*             │
        ▼                   │
   (4) Power Query ◄────────┘
        │  Dim*/Fact*
        ▼
   (5) Semantic Model (DAX)
        │  measures / calc groups
        ▼
   (6) Wireframe ──approve? ──► Critic challenges ──► Orchestrator sign-off
        │  (no visuals before this)
        ▼
   (7) Report Development ───────────────► (10) Documentation can start drafting here
        │  report / theme.json                     using stable artifacts
        ▼
   (8) Performance Review ──routes fixes──► DAX / Power Query / Architect
        ▼
   (9) QA Validation ──defects──► owners ──► retest
        ▼
   (10) Documentation
        ▼
   (11) Portfolio Review ──recommendations──► owners (targeted rework if below bar)
        ▼
   (12) Dashboard Critique ──challenges──► Orchestrator decides + logs
        ▼
   (13) Final Orchestrator Review ──► release_notes.md ──► SHIP / REWORK
```

## When can stages run in parallel?

The Orchestrator may overlap stages only when one is **not** an input to the other:

- ✅ SQL (3) and building the **Date table** portion of the model can overlap.
- ✅ Documentation (10) can begin drafting from stable artifacts during Performance (8)/QA (9).
- ✅ Performance (8) profiling of the model can begin while late report polish continues.
- ❌ DAX (5) cannot start before Power Query (4) lands the tables.
- ❌ Report build (7) cannot start before wireframe approval **and the `tech_decision.md`** (6).
- ❌ QA (9) needs a complete, built solution.

When in doubt, sequence. A parallel decision is logged in `decision_log.md`.

## Rework loops

- **QA defects** → routed to the owning agent → fix → QA retests. Only QA closes a defect.
- **Critic challenges** → Orchestrator decides: adopt, adapt, or consciously reject (logged).
- **Portfolio recommendations** below the bar → targeted rework of the specific dimension, not a
  full restart.

## State & handoffs

After every stage, the owning agent returns a 3–5 line handoff summary. The Orchestrator prepends
it to `project_state.md` and updates the pipeline table. **No agent re-reads prior transcripts** —
they read the summary and the named artifacts. This is the core anti-context-rot loop.
