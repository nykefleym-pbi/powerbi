# Onboarding

Welcome. This system is a multi-agent BI team that builds portfolio-quality Power BI dashboards
inside Claude Code. Read this once; you'll be productive in ten minutes.

## Mental model

- **The Orchestrator is the project manager.** You talk to it; it talks to the specialists.
- **Specialists are narrow experts.** Each owns one slice (SQL, DAX, visuals, …) and a small set
  of files. They don't reach into each other's work.
- **`project_state.md` is the single source of truth** for status and handoffs.

## Three knowledge layers

The team's "brain" is split into three deliberately separate layers:

| Layer | Folder | What it is | Who maintains it |
|---|---|---|---|
| **Standards (the law)** | `shared/` | Binding conventions agents must comply with; QA rejects violations | the owning specialist |
| **Reference (the textbook)** | `knowledge/` | Deep, external-aligned patterns (SQLBI, Microsoft, Deneb, Data Goblins) agents learn from and cite | Knowledge Curator |
| **Procedures (the how-to)** | `.claude/skills/` | Reusable step-by-step recipes, invocable as `/name` (e.g. `/deneb-visual`, `/select-visual-tech`) | whoever owns the procedure |

Knowledge and skills **reference** `shared/` — they never restate or override a binding rule.
This separation is what lets us add capability without bloating agents or breaking standards.

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

The specialist reads its charter + the relevant `shared/`/`knowledge/` files, does the work, and
returns a short handoff summary.

## The extended team (added specialists)

Beyond the core 12, the team now includes:
- **Visual sub-specialists** built at Stage 7 when the Orchestrator's `tech_decision.md` picks a
  non-native technology: **deneb-specialist** (Deneb/Vega-Lite), **svg-figma-designer** (dynamic
  SVG + Figma design system), **html-visual-specialist** (HTML Content cards), and
  **synoptic-panel-specialist** (image maps). Visualization still owns layout, theme, and story.
- **fabric-engineer** — on-demand advisor for Fabric, semantic-model storage modes (Import /
  Direct Lake / DirectQuery), deployment pipelines, and governance.
- **accessibility-specialist** — on-demand WCAG 2.2 AA auditor; its audit feeds QA.
- **knowledge-curator** — keeps `knowledge/` current against Microsoft/SQLBI/Deneb/Data Goblins;
  works outside project builds and only *recommends* changes to standards/agents.

## Choosing a visual technology

The Orchestrator decides *native vs. Deneb vs. SVG vs. HTML vs. Synoptic vs. calc groups* at the
wireframe gate (Stage 6) via the `/select-visual-tech` skill and records the reasoning in
`tech_decision.md`. Default is **native-first**; every custom choice is justified. See
[../shared/tech_selection.md](../shared/tech_selection.md).

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
- Reference library: [../knowledge/](../knowledge/) — start with [../knowledge/README.md](../knowledge/README.md)
- Procedures (skills): [../.claude/skills/](../.claude/skills/)
