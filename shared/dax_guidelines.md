# DAX Guidelines

> **Owner:** DAX Engineer · **Readers:** DAX Engineer, Performance Optimizer, QA
> Enforced by QA. Performance rules cross-reference `performance_guidelines.md`.

## Structure & readability

- Use `VAR` / `RETURN` for any measure with more than one operation. Name variables for intent.
- One expression per line; indent nested functions; align `VAR` assignments.
- No single-letter variable names except trivial iterators. `VAR CurrentRevenue = ...`.
- Keep measures short. If a measure exceeds ~25 lines, decompose into helper measures (`_`-prefixed, hidden).

```dax
Gross Margin % =
VAR Revenue = [Total Revenue]
VAR Cost    = [Total Cost]
VAR Margin  = Revenue - Cost
RETURN
    DIVIDE ( Margin, Revenue )
```

## Correctness rules

- **Always `DIVIDE(n, d)`** instead of `/` to handle divide-by-zero. Add the 3rd arg only when a non-blank fallback is required.
- Use **`SELECTEDVALUE`** (not `VALUES` + `IF(HASONEVALUE)`) to read a single selected value with a default.
- Prefer **`TREATAS`** over `FILTER(ALL(...))` for virtual relationships.
- Wrap context transitions consciously; know when `CALCULATE` introduces a filter vs. context transition.
- Never rely on implicit measures dragged from columns — every number on a report is an explicit measure.

## Base measures pattern

Build a small set of **base measures**, then layer variants on top:

```
_Revenue Base   = SUMX ( FactSales, FactSales[Quantity] * FactSales[UnitPrice] )  // hidden helper
Total Revenue   = [_Revenue Base]
Revenue PY      = CALCULATE ( [Total Revenue], DATEADD ( DimDate[Date], -1, YEAR ) )
Revenue YoY     = [Total Revenue] - [Revenue PY]
Revenue YoY %   = DIVIDE ( [Revenue YoY], [Revenue PY] )
```

Variants (PY, YTD, ranks) reference the base — never re-implement the calculation.

## Time intelligence

- Requires a contiguous, marked **Date table** (`DimDate`) covering every fact date.
- Use built-in functions (`DATEADD`, `TOTALYTD`, `SAMEPERIODLASTYEAR`) over hand-rolled date math.
- Prefer a **Calculation Group** (`CG Time Intelligence`) for Current / YTD / PY / YoY % once there are 3+ time variants across 3+ base measures — it collapses combinatorial measure sprawl.

## Filtering & context

- Use `KEEPFILTERS` when you intend to intersect, not overwrite, existing filters.
- Use `ALLSELECTED` for "% of visible total"; `ALL` for "% of grand total". Choose deliberately.
- Avoid `FILTER` over an entire large table; filter columns, not tables, and let the engine fold.

## Formatting & UX

- Set the **format string on the measure** (currency, %, thousands). Percentages usually `0.0%`.
- Use **dynamic format strings** (via calculation group or measure) for multi-currency or unit-adaptive KPIs.
- Blank handling: return `BLANK()` for "no data" so visuals hide it; only coalesce to `0` when zero is meaningful.

## Performance (see performance_guidelines.md)

- Prefer measures over calculated columns; prefer calculated columns over calculated tables.
- Avoid `SUMX`/iterators over large tables when a straight `SUM` on a column works.
- Minimize context transitions inside row-heavy iterators.
- Variables are evaluated once — reuse them instead of repeating sub-expressions.

## Anti-patterns (QA rejects)

- `IFERROR` used to hide real logic errors.
- `/` division without `DIVIDE`.
- Nested `CALCULATE` where a variable would be clearer.
- Measures referencing physical columns that should be hidden.
- Copy-pasted time-intelligence logic instead of a base-measure/calc-group pattern.

## Handoff

Every new/changed measure is logged to the project `measure_dictionary.md` with: name,
folder, description, format string, dependencies, and the business question it answers.
