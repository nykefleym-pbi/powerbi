# Onboarding

Welcome. This system is a multi-agent BI team that builds portfolio-quality Power BI dashboards
inside Claude Code. Read this once; you'll be productive in ten minutes.

## Mental model

- **The Orchestrator is the project manager.** You talk to it; it talks to the specialists.
- **Specialists are narrow experts.** Each owns one slice (SQL, DAX, visuals, …) and a small set
  of files. They don't reach into each other's work.
- **`shared/` is the team's shared brain.** Standards and durable knowledge live there so agents
  don't re-derive them and don't carry them in every prompt.
- **`project_state.md` is the single source of truth** for status and handoffs.

## The two-file pattern (important)

Each agent exists twice:
- `.claude/agents/<role>.md` — the **runnable** sub-agent Claude Code loads. Deliberately short.
- `agents/<role>.md` — the **full charter** (purpose, scope, decision rules, examples). The
  sub-agent reads it on demand.

Why: keeping the runnable agent lean is how we fight context rot. Deep knowledge is *retrieved*,
not *carried*.

## Your first project (5 steps)

1. Open this repo as your Claude Code workspace.
2. Invoke the Orchestrator:
   > *Use the orchestrator agent. New project: "A retail chain wants a sales-performance dashboard
   > for regional managers to spot margin erosion."*
3. The Orchestrator creates `projects/<name>/`, copies the state/log/assumptions files, scaffolds
   templates, and starts **Stage 1 (Business Analyst)**.
4. It runs the pipeline stage by stage, delegating to one specialist at a time and reviewing each
   output. Watch progress in `projects/<name>/project_state.md`.
5. At the end you get a documented, QA'd, critiqued dashboard project plus `release_notes.md`.

## Invoking a single specialist

You don't always need the whole pipeline:
> *Use the dax-engineer agent to add a rolling-12-month revenue measure to the retail project.*

The specialist reads its charter + the relevant `shared/` files, does the work, and returns a
short handoff summary.

## Working with a live Power BI model (optional)

If the **`powerbi-modeling` MCP server** is connected to a tabular model, the modeling agents
(Data Architect, DAX Engineer, Power Query, Performance, QA) can create/inspect objects and run
DAX directly. Without it, they produce the definitions as files for you to apply in Power BI
Desktop / Tabular Editor. Either way, the written specs in `projects/<name>/` are the source of truth.

## Ground rules that keep quality high

- The **wireframe is approved before any visuals** are built.
- **QA is independent** — it finds defects; owners fix them.
- The **Critic is adversarial by design** — it exists to cut weak KPIs and simplify, not to approve.
- Every non-obvious decision lands in `decision_log.md`; every guess lands in `assumptions.md`.

## Where to go next
- Full flow: [project-lifecycle.md](project-lifecycle.md)
- Who talks to whom: [agent-interaction.md](agent-interaction.md)
- Add/adjust an agent: [../CONTRIBUTING.md](../CONTRIBUTING.md)
- Standards: everything in [../shared/](../shared/)
