# Business Rules

> **Owner:** Business Analyst (with Orchestrator sign-off) · **Readers:** all agents
> Durable definitions of *what the numbers mean*. Every measure and transformation must
> honor these rules. Project-specific rules are added to the project's own copy of this file.

This file is a **living contract**. When a rule is ambiguous, the Business Analyst proposes a
definition, the Orchestrator approves it, and it is recorded here and in `decision_log.md`.

## How to write a rule

Each rule states: the term, its precise definition, the grain it applies at, edge cases, and
who owns it.

```
### <Term>
- **Definition:** <one precise sentence>
- **Formula (conceptual):** <plain-language or pseudo-DAX, not implementation>
- **Grain:** <e.g., per order line / per day / per customer>
- **Includes / Excludes:** <what counts and what doesn't>
- **Edge cases:** <returns, cancellations, nulls, currency, timezone>
- **Owner:** Business Analyst · **Implemented by:** DAX Engineer as [Measure]
```

## Common rules to define per project (starter checklist)

- **Revenue** — gross vs. net; does it include tax, shipping, discounts? Returns?
- **Cost / COGS** — which cost components; landed vs. standard cost.
- **Profit / Margin** — gross vs. net margin; formula and denominator.
- **Active customer** — window of activity that qualifies (e.g., purchased in last 12 months).
- **New vs. returning customer** — first-purchase logic and the comparison window.
- **Churn** — definition, window, and denominator.
- **Fiscal calendar** — fiscal year start, week definition, reporting periods.
- **Currency** — reporting currency, conversion source and timing (transaction date vs. period rate).
- **Time zone** — which zone timestamps are stored/reported in.
- **Exclusions** — test orders, internal accounts, cancelled transactions.
- **"Latest" / "current"** — as-of logic for snapshots and slowly changing dimensions.

## Governance

- No agent invents a business definition silently. Unknowns become entries in `assumptions.md`
  until confirmed, then graduate to a rule here.
- QA validates that measures match the rules in this file; discrepancies are defects.
- Changing a rule after implementation triggers a re-validation by QA (regression risk).
