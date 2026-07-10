# Measure Dictionary (System Reference)

> **Owner:** DAX Engineer · **Readers:** DAX Engineer, QA, Documentation, Portfolio Reviewer
> Reference/how-to. Each project maintains its own catalog generated from
> `templates/measure_specification.md`.

The measure dictionary is the authoritative catalog of every **explicit measure** in the model.
It is how QA, Documentation, and reviewers understand the semantic layer without reading the PBIX.

## What every measure entry records

| Field | Meaning |
|---|---|
| Name | Measure name (Title Case, per naming conventions) |
| Folder | Display folder in `_Measures` |
| Business question | The question this measure answers (from `business_rules.md`) |
| Definition (DAX) | The final expression |
| Depends on | Base measures / columns it references |
| Format string | e.g. `\$#,0`, `0.0%` |
| Blank behavior | What it returns when there is no data |
| Notes | Edge cases, calc-group interaction, performance notes |

## Organization

- Measures are grouped by **display folder**: `Sales`, `Profitability`, `Time Intelligence`,
  `Customers`, `Ranking`, `KPIs`, `_Internal`.
- **Base measures** are listed first in each folder; variants reference them.
- Hidden helper measures (`_`-prefixed) are documented in `_Internal` so dependencies are traceable.

## Rules

- Every number that appears on the report maps to exactly one documented measure here.
- No measure ships without: a description, a format string, and a business question.
- When a measure changes, its entry and every dependent entry are reviewed (QA regression).
- The DAX Engineer keeps this in sync as the single source of truth for the semantic layer;
  Documentation publishes the reader-friendly version.
