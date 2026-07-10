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
| 6 | **Wireframe Approval** | visualization | `wireframe.md` | Approved by Orchestrator; challenged by Critic |
| 7 | Report Development | visualization | `report/` + `theme.json` | Matches wireframe; ≤8 visuals/page; a11y |
| 8 | Performance Review | performance | `performance_report.md` | Within budget or documented exception |
| 9 | **QA Validation** | qa | `qa_report.md` | PASS; no blocking defects |
| 10 | Documentation | documentation | README + guides | Impact-first, complete, consistent |
| 11 | Portfolio Review | portfolio-reviewer | `portfolio_review.md` | Score at/above portfolio bar |
| 12 | **Dashboard Critique** | dashboard-critic | `critique.md` | Material challenges resolved or consciously accepted |
| 13 | Final Review | orchestrator | `release_notes.md` | Sign-off: SHIP / REWORK |

Bold stages are hard gates that are never skipped.

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
- ❌ Report build (7) cannot start before wireframe approval (6).
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
