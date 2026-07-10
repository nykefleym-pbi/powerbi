# Projects

One folder per dashboard project lives here, created by the Orchestrator at kickoff:
`projects/<kebab-case-name>/`.

At kickoff the Orchestrator:
1. Copies `shared/project_state.md`, `shared/decision_log.md`, and `shared/assumptions.md` into
   the project folder (these become the project's living documents).
2. Scaffolds artifacts from `templates/` as each stage needs them.

## Typical project layout

```
projects/<name>/
├── project_state.md        # Orchestrator-owned single source of truth
├── decision_log.md
├── assumptions.md
├── requirements.md         # Business Analyst
├── data_model.md           # Data Architect
├── architecture.md
├── sql/                    # SQL Engineer
├── powerquery/             # Power Query Engineer
├── measures/               # DAX Engineer
├── measure_specification.md
├── measure_dictionary.md
├── data_dictionary.md
├── wireframe.md            # Visualization (approved before build)
├── report/                 # Visualization (build notes)
├── theme.json
├── performance_report.md   # Performance Optimizer
├── qa_report.md            # QA Validator
├── portfolio_review.md     # Portfolio Reviewer
├── critique.md             # Dashboard Critic
├── release_notes.md        # Orchestrator (final gate)
├── README.md               # Documentation (portfolio README)
└── assets/                 # screenshots, model diagram, preview.png
```

No example project is committed here yet — start one by invoking the `orchestrator` agent.
