# Assumptions Register — TEMPLATE

> **Owner:** Business Analyst maintains; Orchestrator confirms/closes. **Readers:** all agents.
> Copied to `projects/<name>/assumptions.md` at kickoff.

Tracks everything the team is **taking as true without confirmation**. Because portfolio projects
often use synthetic or public data with no live stakeholder, most business questions resolve into
documented assumptions rather than answered requirements. Making them explicit keeps the work
honest and interview-defensible.

## Entry format

```
### A-<nnn>: <assumption in one sentence>
- **Date raised:** <YYYY-MM-DD>  · **Raised by:** <agent>
- **Category:** business rule / data / scope / performance / design
- **Why we need it:** <what's blocked without a decision>
- **Assumed value:** <what we're proceeding with>
- **Confidence:** high / medium / low
- **Impact if wrong:** <what breaks / must change>
- **Status:** open / confirmed / rejected → graduated to `business_rules.md` as <rule>
```

## Rules
- No agent silently guesses a business definition — it becomes an assumption here first.
- When an assumption is confirmed, it graduates to `business_rules.md` (or the data model) and is
  marked confirmed here with a link.
- Low-confidence, high-impact assumptions are surfaced by the Orchestrator to the user before the
  dependent stage proceeds.
- The Portfolio Reviewer and Critic scan this register — undocumented guesses are a finding.

---

_(entries below)_
