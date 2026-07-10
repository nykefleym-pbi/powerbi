# Coding Standards (Cross-Cutting)

> **Owner:** Data Architect · **Readers:** all engineering agents
> Language-specific rules live in `dax_guidelines.md`, `powerquery_guidelines.md`, and
> the SQL section below. This file covers standards that apply everywhere.

## Universal principles

1. **Explicit over implicit.** No implicit measures, no auto-generated relationships left unreviewed, no magic numbers without a named home.
2. **One responsibility per object.** A measure computes one thing; a query produces one table; a view answers one need.
3. **Readable beats clever.** Optimize for the next person reading it. Comment *why*, never *what*.
4. **Deterministic & idempotent.** Re-running a transform or refresh yields the same result. No dependence on load order or locale defaults.
5. **Fail loud in dev, degrade gracefully in report.** Surface data issues during build; show `"—"` or a blank, never an error, to the end user.

## Comments & documentation

- Every measure has a one-line description set in the model (feeds the data dictionary).
- Every non-trivial M query has a top comment: purpose, source, refresh notes.
- SQL objects carry a header comment: purpose, owner, grain, last change.
- Do not narrate obvious code. `// sum revenue` above `SUM(Sales[Revenue])` is noise.

## Formatting

- **DAX:** one clause per line, leading commas or trailing — pick trailing and be consistent; `VAR`/`RETURN` for anything with 2+ operations. See `dax_guidelines.md`.
- **M:** one step per line, `let ... in` aligned, meaningful step names. See `powerquery_guidelines.md`.
- **SQL:** leading keywords uppercased, one column per line in SELECT, joins explicit and aliased.

## Data types & formatting

- Set data types explicitly in Power Query (never rely on inference at load).
- Currency → Fixed Decimal (Currency) to avoid floating point drift.
- Whole numbers for keys and counts; Decimal for ratios.
- Format strings are set on measures, not on visuals, so they travel with the model.
- Dates are real `Date`/`DateTime` types; never text.

## Model hygiene

- Star schema only. No snowflaking unless justified and logged in `decision_log.md`.
- Hide every key column, every raw staging column, and every internal/helper measure.
- One dedicated, marked **Date table** per model; mark as date table.
- Single-direction relationships by default; bi-directional only with written justification.
- No calculated columns where a measure or a Power Query column will do.

## Version control & change safety

- Prefer PBIP (Power BI Project, TMDL/PBIR) format so model and report are diffable text.
- One logical change per commit; commit messages state the stage and what changed.
- Never rename a shipped measure without updating every dependent (QA verifies).

## Security

- No credentials, connection strings, tokens, or PII in the repo. Use parameters and
  documented placeholders (`pServerName`, `<REPLACE_ME>`).
- RLS roles are defined in the model and documented; QA validates them.

## SQL standards (summary)

- ANSI-standard syntax; avoid `SELECT *` in shipped views.
- Explicit `INNER`/`LEFT` joins with ON clauses; no comma joins.
- Filter early, aggregate late; push work to the warehouse, not Power Query.
- Deterministic ordering only where it matters; never rely on physical order.
- Views feed the model at the correct grain; document grain in the view header.

## Definition of Done (engineering)

- [ ] Complies with `naming_conventions.md`.
- [ ] Data types explicit and correct.
- [ ] Descriptions/comments present where required.
- [ ] No hard-coded secrets or environment-specific values outside parameters.
- [ ] Handed off with a short summary written to the project's `decision_log.md` if a
      non-obvious choice was made.
