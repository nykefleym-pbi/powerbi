# Agent Interaction

How the agents relate, communicate, and stay isolated from each other's context.

## Hub-and-spoke, not a free-for-all

The Orchestrator is a hub. Specialists are spokes. **Specialists do not talk to each other
directly** — they hand deliverables and short summaries back to the Orchestrator, which routes
what the next agent needs. This keeps each agent's context minimal and prevents cross-contamination.

```
                          ┌─────────────────────────┐
                          │      ORCHESTRATOR        │
                          │  owns project_state.md   │
                          │  decomposes · reviews ·  │
                          │  routes · resolves       │
                          └───────────┬─────────────┘
        assigns a stage + short brief │  ▲  returns deliverable + 3–5 line summary
                                      ▼  │
   ┌───────────┬───────────┬──────────┴──────────┬───────────┬───────────┐
   ▼           ▼           ▼                     ▼           ▼           ▼
Business    Data        SQL /                  DAX      Visualization  Performance
Analyst     Architect   Power Query            Engineer  & UX          Optimizer
   │           │           │                     │           │           │
   └─────── each reads shared/ + only the artifacts it needs ──────────────┘
                                      │
                          reviewers (read-only to artifacts)
                          ┌───────────┼───────────┐
                          ▼           ▼           ▼
                         QA      Portfolio     Dashboard
                       Validator  Reviewer      Critic
```

**Visual sub-specialists** hang off Visualization at build time (Stage 7), assigned by the
Orchestrator's `tech_decision.md` — they never choose *what* to build, only implement their slice:

```
        Visualization (owns wireframe/layout/theme/story)
                 │  the Orchestrator routes each element per tech_decision.md
   ┌─────────────┼───────────────┬────────────────┬──────────────────┐
   ▼             ▼               ▼                ▼                  ▼
deneb-        svg-figma-      html-visual-     synoptic-panel-   (native + theme
specialist    designer        specialist       specialist        stay with Visualization)
```

**On-demand advisors & the curator** (not linear stages):

```
  fabric-engineer ── advises ─► Data Architect / DAX / Power Query / Documentation (via Orchestrator)
  accessibility-specialist ── audits report ─► feeds QA (QA owns the pass/fail gate)
  knowledge-curator ── maintains knowledge/ + recommends updates ─► OUTSIDE all project builds
```

## What flows along each spoke

| Producer → Orchestrator → Consumer | What's handed over |
|---|---|
| Business Analyst → Data Architect | requirements, KPIs, grain hints |
| Data Architect → SQL + Power Query | table contracts (name, grain, columns, keys) |
| SQL → Power Query | view names, keys, fold notes |
| Power Query → DAX | final table/column names + types |
| DAX → Visualization | available measures + folders |
| Visualization → (Critic, then build) | wireframe for challenge/approval |
| Orchestrator → visual sub-specialists | `tech_decision.md` element + `custom_visual_brief.md` |
| visual sub-specialists → Visualization | built custom visual + inputs used + limits |
| fabric-engineer → Architect/DAX/PQ/Docs | storage-mode / deployment / Fabric guidance |
| accessibility-specialist → QA | `accessibility_audit.md` (findings + owners) |
| Everyone → QA | the built solution to validate |
| Everyone → Documentation | artifacts + dictionaries to publish |
| Performance / QA / Critic → owners | routed fixes, defects, challenges |

## Communication contract

Every delegation is a short brief (see the Orchestrator charter):
`ROLE · STAGE · GOAL · READ (files) · DO · OUTPUT TO · CONSTRAINTS · RETURN summary`.

Every return is a **3–5 line handoff summary** the Orchestrator prepends to `project_state.md`.

**Nobody pastes transcripts.** Context travels as files + summaries, never as replayed conversation.

## Ownership map (who writes what)

| File / area | Sole writer |
|---|---|
| `project_state.md`, `release_notes.md` | Orchestrator |
| `decision_log.md` | Orchestrator (any agent proposes) |
| `assumptions.md` | Business Analyst (Orchestrator closes) |
| `requirements.md`, `business_rules.md` (proposals) | Business Analyst |
| `data_model.md`, structural naming, lineage | Data Architect |
| `sql/*` | SQL Engineer |
| `powerquery/*`, transformation notes | Power Query Engineer |
| `measures/*`, `measure_dictionary.md` | DAX Engineer |
| `wireframe.md`, `report/*`, `theme.json` | Visualization |
| `tech_decision.md` | Orchestrator (via `select-visual-tech`) |
| Deneb specs, SVG/HTML/Synoptic assets in `report/*` | the assigned visual sub-specialist |
| `performance_report.md`, Fabric/deployment note in `architecture.md` | Performance / Fabric engineer |
| `accessibility_audit.md` | Accessibility specialist (feeds QA) |
| `knowledge/*` | Knowledge Curator (recommends `shared/`+agent changes; never edits them directly) |
| `qa_report.md` | QA Validator |
| README + guides (published docs) | Documentation |
| `portfolio_review.md` | Portfolio Reviewer |
| `critique.md` | Dashboard Critic |

If an agent needs a change in a file it doesn't own, it **requests** it via the Orchestrator.
This single rule is what keeps responsibilities clean and the system modular.

## Conflict resolution

When two agents disagree (e.g., DAX wants a calculated column, Performance wants it gone), the
Orchestrator decides using: business need → shared standards → performance budget → portfolio
impact — and records the decision in `decision_log.md`. The decision is final for that project.
