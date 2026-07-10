# Project State — MASTER TEMPLATE

> **Owner:** Orchestrator (exclusively). No other agent writes to a project's `project_state.md`.
> **Readers:** all agents read the relevant slice at the start of their task.
>
> This file in `shared/` is the **master template**. At project kickoff the Orchestrator copies
> it to `projects/<name>/project_state.md` and maintains it there as the single source of truth
> for status. Keep it short — it is a dashboard, not a transcript.

---

## Project: `<name>`
- **Goal (one sentence):** <what success looks like>
- **Stakeholders / audience:** <who uses this dashboard>
- **Current stage:** `<1–13>` <stage name>
- **Overall status:** 🟢 on track / 🟡 at risk / 🔴 blocked
- **Last updated:** <YYYY-MM-DD>

## Pipeline status

| # | Stage | Agent | Status | Output artifact | Notes |
|---|-------|-------|--------|-----------------|-------|
| 1 | Business Analysis | business-analyst | ☐/⏳/✅ | requirements.md | |
| 2 | Data Architecture | data-architect | ☐ | data_model.md | |
| 3 | SQL Development | sql-engineer | ☐ | sql/ | |
| 4 | Power Query | power-query | ☐ | powerquery/ | |
| 5 | Semantic Model (DAX) | dax-engineer | ☐ | measures/ | |
| 6 | Wireframe Approval | visualization | ☐ | wireframe.md | |
| 7 | Report Development | visualization | ☐ | report/ | |
| 8 | Performance Review | performance | ☐ | performance_report.md | |
| 9 | QA Validation | qa | ☐ | qa_report.md | |
| 10 | Documentation | documentation | ☐ | README + guides | |
| 11 | Portfolio Review | portfolio-reviewer | ☐ | portfolio_review.md | |
| 12 | Dashboard Critique | dashboard-critic | ☐ | critique.md | |
| 13 | Final Review | orchestrator | ☐ | release_notes.md | |

Legend: ☐ not started · ⏳ in progress · ✅ done · 🔁 rework requested · ⛔ blocked

## Handoff summaries (rolling, newest first)

> One short paragraph per completed stage — the summary the next agent needs, so no one
> re-reads prior transcripts. This is the anti-context-rot mechanism.

- **[stage] — [date]:** <what was produced, key decisions, what the next agent needs to know>

## Open items / blockers
- <blocker> → owner → needed by

## Decisions & assumptions
- See `decision_log.md` and `assumptions.md` for detail. Link key ones here.
