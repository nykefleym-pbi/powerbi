# Power BI Dashboard Development Team

A **multi-agent system** for Claude Code that emulates a real Business Intelligence
consulting team. An **Orchestrator** decomposes work and coordinates 11 specialist
agents to build **portfolio-quality Power BI dashboards** from scratch — following
enterprise BI best practices end to end.

> Built for a personal portfolio. Every project produced with this system is designed
> to be interview-ready: strong business framing, a clean star schema, disciplined DAX,
> a polished report, and complete documentation.

---

## The Team

```
Project Orchestrator
│
├── Business Analyst          business questions, KPIs, requirements
├── Data Architect           star schema, grain, relationships, lineage
├── SQL Engineer             views, procs, warehouse queries
├── Power Query Engineer     M transformations, refresh-friendly ETL
├── DAX Engineer             measures, calc groups, time intelligence
├── Visualization & UX       wireframes, layout, interactions, accessibility
├── Performance Optimizer    VertiPaq, model size, DAX/refresh performance
├── QA Validator             correctness, formatting, RLS, regressions
├── Documentation Writer     README, data dictionary, guides
├── Portfolio Reviewer       scores the work like a hiring manager
└── Dashboard Critic         adversarial reviewer — challenges every decision
```

**The Orchestrator never does specialist work itself.** It understands goals,
decomposes work, assigns tasks, reviews outputs, resolves conflicts, maintains
project state, and decides when work is complete.

---

## Repository Layout

```
/
├── README.md                 you are here
├── CONTRIBUTING.md           how to extend the system
├── .claude/
│   └── agents/               Claude Code sub-agent definitions (the runnable team)
├── agents/                   full agent charters (the source of truth for each role)
├── shared/                   project-wide knowledge every agent reads before working
├── templates/                reusable document templates
├── projects/                 one folder per dashboard project (created per engagement)
└── docs/                     onboarding, lifecycle, interaction diagram
```

### Two files per agent — on purpose

| Location | Contains | Why |
|---|---|---|
| `.claude/agents/<role>.md` | Frontmatter + a **short** operating brief | What Claude Code actually loads as a sub-agent. Kept small to minimize context rot. |
| `agents/<role>.md` | The **full charter** (purpose, scope, decision rules, examples) | The source of truth. The sub-agent reads it on demand instead of carrying it in every prompt. |

This split is the core context-management strategy: **the runnable agent stays lean;
deep knowledge lives in files it reads only when relevant.**

---

## How to Use It in Claude Code

1. Open this repository as your Claude Code workspace.
2. Start a project by talking to the Orchestrator:

   ```
   Use the orchestrator agent. Kick off a new project:
   "A retail company wants a sales performance dashboard for regional managers."
   ```
3. The Orchestrator scaffolds `projects/<name>/` from the templates, then runs the
   pipeline stage by stage — delegating to one specialist at a time and reviewing each
   output before moving on.
4. Follow along in `projects/<name>/project_state.md`, which the Orchestrator keeps as
   the single source of truth for status.

You can also invoke any specialist directly (e.g. *"Use the dax-engineer agent to add a
YoY measure"*), but for full projects let the Orchestrator drive.

---

## The Pipeline

```
1  Business Analysis      →  2  Data Architecture   →  3  SQL Development
4  Power Query            →  5  Semantic Model (DAX) →  6  Wireframe Approval
7  Report Development     →  8  Performance Review   →  9  QA Validation
10 Documentation         → 11  Portfolio Review     → 12  Dashboard Critique
                         → 13  Final Orchestrator Review
```

Each stage finishes and is reviewed before the next begins, unless the Orchestrator
determines two stages are safe to run in parallel (see
[docs/project-lifecycle.md](docs/project-lifecycle.md)).

---

## Design Principles

- **Minimal context rot** — lean sub-agents, knowledge in shared files, summaries over transcripts.
- **Clear separation of responsibilities** — each agent owns a narrow slice and a small set of files.
- **Reusable & modular** — add a new specialist by dropping in two files; nothing else changes.
- **Single source of truth** — `shared/` holds durable knowledge; the Orchestrator owns `project_state.md`.
- **Adversarial quality gate** — the Critic exists to make the work better, not to approve it.
- **Enterprise BI best practices** — star schemas, explicit measures, calculation groups, VertiPaq discipline, accessibility.

---

## Start Here

- New to the system? Read [docs/onboarding.md](docs/onboarding.md).
- Want the full flow? Read [docs/project-lifecycle.md](docs/project-lifecycle.md).
- Want to see how agents talk to each other? Read [docs/agent-interaction.md](docs/agent-interaction.md).
- Want to extend the team? Read [CONTRIBUTING.md](CONTRIBUTING.md).
