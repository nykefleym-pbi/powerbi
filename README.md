# Power BI Center of Excellence

A **multi-agent system** for Claude Code that emulates a Business Intelligence
**Center of Excellence**. An **Orchestrator** decomposes work and coordinates **18 specialist
agents** — plus a reusable **knowledge library** and invocable **skills** — to build
**portfolio-quality Power BI dashboards** from scratch, following enterprise BI best practices
aligned with Microsoft, SQLBI, Deneb, and Data Goblins guidance.

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

Extended team (added specialists)
├── Deneb Specialist         custom Vega-Lite visuals (bullet, dumbbell, small multiples)
├── SVG & Figma Designer     dynamic SVG measures + Figma design system → theme.json
├── HTML Visual Specialist   HTML Content cards, progress bars, embedded SVG
├── Synoptic Panel Specialist image maps (floor/process/org/non-standard geo)
├── Microsoft Fabric Engineer storage mode, Direct Lake, deployment pipelines, governance
├── Accessibility Specialist  WCAG 2.2 AA audits (incl. custom visuals) → feeds QA
└── Knowledge Curator         keeps knowledge/ current; recommends (never edits) standards
```

The four visual specialists are **implementation sub-specialists** invoked at build time when the
Orchestrator's technology decision selects their technology; Visualization keeps ownership of
layout, theme, and story. Fabric & Accessibility are **on-demand advisors**; the Curator works
**outside** project builds.

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
│   ├── agents/               Claude Code sub-agent definitions (the runnable team)
│   └── skills/               invocable step-by-step procedures (/deneb-visual, /select-visual-tech, …)
├── agents/                   full agent charters (the source of truth for each role)
├── shared/                   binding standards every agent complies with (the "law")
├── knowledge/                reusable reference library (the "textbook": SQLBI/MS/Deneb/Data Goblins)
├── templates/                reusable document templates
├── projects/                 one folder per dashboard project (created per engagement)
└── docs/                     onboarding, lifecycle, interaction diagram
```

### Three knowledge layers

- **`shared/`** — binding standards (QA-enforced). **`knowledge/`** — deep reference agents cite.
  **`.claude/skills/`** — reusable procedures invocable as `/name`. Knowledge and skills reference
  `shared/`; they never override it. See [docs/onboarding.md](docs/onboarding.md).

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

Stage 6 also produces a **technology decision** (native vs. Deneb vs. SVG vs. HTML vs. Synoptic vs.
calc groups) via the `/select-visual-tech` skill before any build — recorded, native-first, and
justified per element in `tech_decision.md`. Each stage finishes and is reviewed before the next
begins, unless the Orchestrator determines two stages are safe to run in parallel (see
[docs/project-lifecycle.md](docs/project-lifecycle.md)).

---

## Design Principles

- **Minimal context rot** — lean sub-agents, knowledge in shared files, summaries over transcripts.
- **Clear separation of responsibilities** — each agent owns a narrow slice and a small set of files.
- **Reusable & modular** — add a new specialist by dropping in two files; nothing else changes.
- **Three-layer knowledge** — `shared/` (law) · `knowledge/` (textbook) · `.claude/skills/` (how-to);
  each concern lives in exactly one place.
- **Deliberate technology choice** — native-first; every Deneb/SVG/HTML/Synoptic build is justified.
- **Single source of truth** — the Orchestrator owns `project_state.md`; the Curator keeps `knowledge/` fresh.
- **Adversarial quality gate** — the Critic exists to make the work better, not to approve it.
- **Enterprise BI best practices** — star schemas, explicit measures, calculation groups, VertiPaq
  discipline, WCAG 2.2 AA accessibility, and Fabric-ready semantic models.

---

## Start Here

- New to the system? Read [docs/onboarding.md](docs/onboarding.md).
- Want the full flow? Read [docs/project-lifecycle.md](docs/project-lifecycle.md).
- Want to see how agents talk to each other? Read [docs/agent-interaction.md](docs/agent-interaction.md).
- Want to extend the team? Read [CONTRIBUTING.md](CONTRIBUTING.md).
