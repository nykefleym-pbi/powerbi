# SQLBI Patterns — Context, CALCULATE, Variables

> Reference for correct, idiomatic DAX. Binding rules live in
> [`shared/dax_guidelines.md`](../shared/dax_guidelines.md); this file explains the *why* so
> engineers apply the rules with judgment. Aligned with SQLBI's evaluation-context model.

## The two evaluation contexts

- **Filter context** — the set of filters active on the model (from slicers, rows/columns of a
  visual, `CALCULATE`, relationships). It *restricts which rows are visible*.
- **Row context** — the "current row" that exists inside an iterator (`SUMX`, `FILTER`,
  calculated columns). It does **not** filter; it just names a row.
- Row context does **not** automatically become filter context. The bridge between them is
  **context transition**, triggered by `CALCULATE` (and by any measure reference, which is
  wrapped in an implicit `CALCULATE`).

**Practical rule:** if a number is wrong "per row" inside an iterator, you probably need a
context transition (wrap the inner measure/expression in `CALCULATE`) — or you accidentally
triggered one and should remove it.

## CALCULATE — the only function that changes filter context

1. Evaluates its filter arguments.
2. Applies **context transition** first (row context → equivalent filter context).
3. Then applies its explicit filter arguments, which **overwrite** filters on the same columns
   unless wrapped in `KEEPFILTERS`.

- `KEEPFILTERS(<filter>)` → *intersect* with the existing filter instead of replacing it.
- Use a boolean predicate (`FactSales[Qty] > 0`) as sugar for `FILTER(ALL(column), …)` on a
  single column; for multi-column conditions write the explicit `FILTER`.

## Variables (VAR / RETURN)

- A `VAR` is evaluated **once**, in the context where it is *defined*, not where it is used.
  This is the most common source of surprise: a `VAR` captured outside `CALCULATE` keeps the
  outer context.
- Variables are immutable and lazily evaluated → use them to (a) improve readability, (b) avoid
  recomputing sub-expressions, (c) freeze a value before a context change:
  ```dax
  Sales Δ vs Selected Year =
  VAR SelectedYearSales = [Total Sales]              -- current context
  VAR AllYearsSales = CALCULATE ( [Total Sales], ALL ( DimDate[Year] ) )
  RETURN DIVIDE ( SelectedYearSales, AllYearsSales )
  ```
- Prefer variables over nested `CALCULATE`s; name them for the business intent.

## Virtual relationships & data lineage

- `TREATAS ( VALUES(a), Table[col] )` transfers a filter across tables with no physical
  relationship — preferred over `FILTER(ALL(...))` and `INTERSECT` (keeps data lineage, folds
  better).
- Understand **data lineage**: `VALUES`/`ALL` preserve the column's lineage so a later
  `CALCULATE` re-applies it as a filter; `SUMMARIZE`/`SELECTCOLUMNS` can break it.

## Iterators & performance intuition

- `SUMX(Fact, Fact[a] * Fact[b])` runs row by row — fine on a fact column, costly when it forces
  a callback to the formula engine (context transitions, measure calls inside the iterator).
- Prefer the **storage engine** (simple `SUM`, `COUNTROWS`, straightforward filters) over the
  **formula engine** (iterators, complex `CALCULATE` branches). See
  [performance.md](performance.md).

## Common correctness traps

| Trap | Fix |
|---|---|
| `IF(HASONEVALUE(x), VALUES(x))` | `SELECTEDVALUE(x, <default>)` |
| `SUM(a)/SUM(b)` | `DIVIDE(SUM(a), SUM(b))` |
| Measure inside iterator giving grand-total per row | intended context transition — or remove the measure call |
| `FILTER(ALL(BigTable), …)` | filter a single column, or `TREATAS` |
| `ALLSELECTED` vs `ALL` confusion | `ALLSELECTED` = visible total; `ALL` = grand total |

---
*Sources: SQLBI (definitive guide to DAX — evaluation contexts, CALCULATE, variables, TREATAS).
Last reviewed: 2026-07-10.*
