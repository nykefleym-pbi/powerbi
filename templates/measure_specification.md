# Measure Specification — <Project Name>

> Produced by: **DAX Engineer** · Feeds: `measure_dictionary.md`, Documentation, QA
> One entry per explicit measure. Base measures first, variants after.

## Conventions
- Stored in `_Measures`, grouped by display folder.
- Every measure has: business question, DAX, format string, blank behavior.

## Measures

### `<Total Revenue>`  ·  folder: `Sales`
- **Business question:** How much did we sell (net)?
- **Business rule:** links to `business_rules.md#revenue`
- **DAX:**
  ```dax
  Total Revenue =
  SUMX ( FactSales, FactSales[Quantity] * FactSales[NetUnitPrice] )
  ```
- **Depends on:** `FactSales[Quantity]`, `FactSales[NetUnitPrice]`
- **Format string:** `\$#,0`
- **Blank behavior:** BLANK() when no rows
- **Notes:** base measure; PY/YTD/YoY variants reference this

### `<Revenue YoY %>`  ·  folder: `Time Intelligence`
- **Business question:** How does revenue compare to the same period last year?
- **DAX:**
  ```dax
  Revenue YoY % =
  VAR Cur = [Total Revenue]
  VAR Prior = CALCULATE ( [Total Revenue], DATEADD ( DimDate[Date], -1, YEAR ) )
  RETURN DIVIDE ( Cur - Prior, Prior )
  ```
- **Depends on:** `[Total Revenue]`, `DimDate[Date]`
- **Format string:** `0.0%`
- **Blank behavior:** BLANK() when no prior-year data

## Calculation groups (if used)
| Group | Items | Applies to | Rationale |
|---|---|---|---|
| CG Time Intelligence | Current, YTD, PY, YoY % | base value measures | avoids measure sprawl |

## Validation notes (for QA)
- Reconciliation: `Total Revenue` ties to source `vw_sales` within <tolerance>.
- Edge cases tested: no-data periods, single selection, currency.
