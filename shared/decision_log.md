# Decision Log — TEMPLATE

> **Owner:** Orchestrator records; any agent may propose an entry. **Readers:** all agents.
> Copied to `projects/<name>/decision_log.md` at kickoff. Append-only — never rewrite history;
> supersede with a new entry.

Records **non-obvious decisions** and their rationale so future work (and interview questions)
can trace *why* the dashboard is built the way it is. If a choice would make someone ask "why did
you do it that way?", it belongs here.

## Entry format

```
### D-<nnn>: <short title>
- **Date:** <YYYY-MM-DD>
- **Stage / agent:** <who raised it>
- **Context:** <the situation / problem>
- **Options considered:** <A, B, C — briefly>
- **Decision:** <what we chose>
- **Rationale:** <why — the trade-off>
- **Consequences:** <what this constrains or enables later>
- **Supersedes:** <D-xxx or none>
```

## What to log (examples)
- Grain choices and why (e.g., order-line vs. order-header fact).
- Star vs. snowflake exceptions.
- Bi-directional relationships or `USERELATIONSHIP` roles.
- Calculation group vs. explicit measure sprawl.
- Choice of visual for a contested KPI (often driven by the Critic).
- Performance trade-offs (aggregations, incremental refresh, dropped columns).
- Any business-rule interpretation that resolved an assumption.

## What NOT to log
- Routine, convention-following work already covered by `shared/` standards.
- Trivial naming choices.

---

_(entries below)_
