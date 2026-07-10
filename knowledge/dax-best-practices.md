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

- Use once you have **3+ time variants across 3+ base measures** (Current/PY/YoY/YTD × Sales/Cost/Margin).
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
- [ ] Calc group used when the variant matrix justifies it; format strings set.
- [ ] Variables named for intent; no repeated sub-expressions.
- [ ] No `FILTER` over whole large tables; `TREATAS` for virtual relationships.

---
*Sources: SQLBI (time intelligence, calculation groups, VertiPaq, DAX patterns);
Microsoft Learn (calculation groups, mark-as-date-table). Last reviewed: 2026-07-10.*
