# DAX Best Practices — Time Intelligence, Calc Groups, VertiPaq, Naming

> Companion to [`shared/dax_guidelines.md`](../shared/dax_guidelines.md) (binding) and
> [sqlbi-patterns.md](sqlbi-patterns.md) (context theory). SQLBI-aligned depth.

## Time intelligence

- Requires a **marked Date table** that is contiguous (no gaps) and covers every fact date, with
  a `Date` column at day grain. Mark it as a date table so `DATEADD`/`TOTALYTD` work.
- Prefer built-ins over hand-rolled math: `DATEADD`, `SAMEPERIODLASTYEAR`, `TOTALYTD`,
  `DATESYTD`, `PARALLELPERIOD`, `DATESINPERIOD`.
- For non-standard calendars (445, ISO week, custom fiscal), built-ins break — use an explicit
  **period table** with sequential integer keys and offset arithmetic instead.
- Fiscal year end: pass the year-end date to `TOTALYTD`/`DATESYTD` (`"06-30"`).

## Calculation groups (collapse measure sprawl)

- Use for a **user-selectable** filter/transform across all measures (period selection, scaling) —
  not as a code-reuse mechanism (that's a UDF, below). Justified once you have **3+ time variants
  across 3+ base measures** (Current/PY/YoY/YTD × Sales/Cost/Margin).
- Anatomy: a calc-group table (`CG Time Intelligence`), calculation items each wrapping
  `SELECTEDMEASURE()`, and a **precedence** number when multiple groups combine.
- **Dynamic format strings** per item (e.g., YoY % item forces `0.0%`).
- Watch: sideways recursion, format-string precedence, and that a badly written item taxes
  *every* measure it touches. Add a `"Current"`/blank-selection item so a naked field still works.
- Author with **Tabular Editor**; Power BI Desktop's native calc-group editor is limited.

```dax
-- Calculation item: YoY %
VAR Cur = SELECTEDMEASURE ()
VAR Py  = CALCULATE ( SELECTEDMEASURE (), SAMEPERIODLASTYEAR ( DimDate[Date] ) )
RETURN DIVIDE ( Cur - Py, Py )
```

## User-defined functions (UDFs) — the code-reuse tool

DAX **UDFs** are reusable, **parameterized** logic that behaves like a native function — callable
from measures, calculated columns, security roles, and calc items. They are **developer
infrastructure, invisible to report users**. SQLBI's 2026 guidance resets the old habit of using
calc groups for code reuse:

- **Three tools, three jobs:** *Measures* expose calculations to users · *calculation groups*
  apply a common filter/transform (period, scaling) that a user **selects** across all measures ·
  **UDFs** share business logic between developers.
- **Don't use calc groups for reuse** — they have no parameters, so they must pass information
  through filter context (overhead + indirection). Prefer a UDF with explicit parameters.
- **When to wrap in a UDF:** logic is complex, appears in several places, or takes varying
  parameters (e.g. define "new customer" once). **Don't** wrap a trivial `SUM`/subtraction — it
  only hides the calc and hurts readability.
- **Combine:** keep core computations in UDFs; let calc items apply high-level patterns on top.
  Name/document functions clearly and test performance.

## Visual calculation functions

For visual-layer running/relative math, prefer **visual calculations** (evaluated in the visual's
result grid): `RUNNINGSUM`, `MOVINGAVERAGE`, `PREVIOUS`/`NEXT`, `FIRST`/`LAST`, and
`EXPAND`/`COLLAPSE` (navigate hierarchy detail). They avoid extra model measures for
row-relative calculations that only matter inside one visual.

## VertiPaq-aware modeling

- **Cardinality drives size** far more than row count. The optimizer's biggest wins: reduce
  distinct values (split datetime, round decimals, drop GUIDs/free text), integer keys, remove
  unused columns. See [`shared/performance_guidelines.md`](../shared/performance_guidelines.md)
  and [performance.md](performance.md).
- Prefer **star schema**; avoid bi-directional filters (they enlarge query plans and can create
  ambiguity). Use `CROSSFILTER`/`TREATAS` on demand instead of a permanent bi-di relationship.
- Measures > calculated columns > calculated tables (compute at query time when cheap; a
  calc column costs RAM in every refresh).

## Naming (measures & model)

Follow [`shared/naming_conventions.md`](../shared/naming_conventions.md). SQLBI-consistent habits:
- Measures are business-friendly, no table prefix, stored in `_Measures`.
- Base vs. variant: `Total Sales` → `Sales PY`, `Sales YTD`, `Sales YoY %`.
- Hidden helpers `_`-prefixed. Display folders group by subject.

## Review checklist (DAX self-review before handoff)

- [ ] Every measure is explicit; no implicit column drags.
- [ ] `DIVIDE` everywhere; blank handling deliberate.
- [ ] Base/variant pattern; no copy-pasted time-intel.
- [ ] Calc group used for user-selectable variants; **UDF** used for shared/parameterized logic.
- [ ] Calc group used when the variant matrix justifies it; format strings set.
- [ ] Variables named for intent; no repeated sub-expressions.
- [ ] No `FILTER` over whole large tables; `TREATAS` for virtual relationships.

---
*Sources: SQLBI — [UDFs vs. calculation groups](https://www.sqlbi.com/articles/dax-user-defined-functions-udf-vs-calculation-groups/),
time intelligence, calculation groups, VertiPaq, DAX patterns (aligned to The Definitive Guide to
DAX, 3rd ed., 2026); Microsoft Learn (calculation groups, visual calculations, mark-as-date-table).
Last reviewed: 2026-07-11.*
