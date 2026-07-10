# Naming Conventions

> **Owner:** Data Architect · **Readers:** all agents
> Every object name in a project must comply with this file. QA rejects violations.

## Tables

| Table type | Convention | Example |
|---|---|---|
| Fact table | `Fact<Subject>` (singular subject) | `FactSales`, `FactInventory` |
| Dimension table | `Dim<Entity>` | `DimDate`, `DimProduct`, `DimCustomer` |
| Bridge / factless | `Bridge<A><B>` | `BridgeProductCategory` |
| Hidden helper / disconnected | `_<Purpose>` (leading underscore, hidden) | `_Measures`, `_Parameters` |
| Aggregation table | `Agg<Fact><Grain>` (hidden) | `AggSalesMonth` |

- Table names are **PascalCase**, no spaces, no abbreviations except industry-standard (ID, SKU, YoY).
- The measures-only table is `_Measures` and is hidden. All measures live there so the field list stays clean.

## Columns

- **PascalCase**, no spaces (physical), friendly display name applied via the model.
- Key columns end in `Key` (surrogate) or `ID` (business/natural): `ProductKey`, `OrderID`.
- Boolean columns read as a question or state: `IsReturned`, `IsActive`.
- Date columns end in `Date`: `OrderDate`, `ShipDate`.
- Never expose raw key columns to report users — hide them.

## Measures

- **No table prefix** in the name. Stored in `_Measures`. Referenced as `[Total Revenue]`.
- **Title Case with spaces**, business-friendly: `Total Revenue`, `Gross Margin %`, `Revenue YoY %`.
- Percentages end in `%`. Currency measures may include the unit only when ambiguous.
- Base vs. variant naming:
  - Base: `Total Revenue`
  - Time intelligence: `Revenue PY`, `Revenue YTD`, `Revenue YoY`, `Revenue YoY %`
  - Ranking / filtered: `Revenue Rank`, `Revenue (Top 10)`
- Internal/helper measures used only by other measures are prefixed `_` and hidden: `_Revenue Base`.

## Measure Display Folders

Group measures into folders inside `_Measures`:
`Sales`, `Profitability`, `Time Intelligence`, `Customers`, `Ranking`, `KPIs`, `_Internal`.

## Calculation Groups & Items

- Calculation group table: `CG <Purpose>` → `CG Time Intelligence`, `CG Currency`.
- Calculation items: Title Case → `Current`, `YTD`, `PY`, `YoY %`, `MTD`.

## Relationships

- Single direction (fact → dimension, many-to-one) by default.
- Name inactive relationships by their role via `USERELATIONSHIP` and document in `data_model.md`.

## Power Query (M)

- Queries: PascalCase matching the destination table (`FactSales`, `DimDate`).
- Staging queries (not loaded): prefix `stg` and disable load → `stgSalesRaw`.
- Functions: `fn<Verb><Noun>` → `fnCleanText`, `fnGetExchangeRate`.
- Parameters: `p<Name>` → `pServerName`, `pStartYear`.
- Step names: readable, PascalCase, describe the action → `RemovedDuplicates`, `FilteredActiveRows`.

## SQL

- Views: `vw_<subject>` → `vw_sales`, `vw_dim_product`.
- Stored procedures: `usp_<verb>_<subject>` → `usp_load_sales`.
- Schemas: `dim`, `fact`, `stg`, `rpt` where the platform supports schemas.
- Columns: `snake_case` in the warehouse; Power Query renames to PascalCase on import.

## Report Objects

- Pages: business-friendly, Title Case → `Executive Summary`, `Regional Detail`.
- Bookmarks: `<Page> - <State>` → `Regional Detail - Reset`.
- Visual titles: describe the insight, not the mechanic → "Revenue by Region", not "Bar chart 1".

## Files

- PBIX / PBIP: `<ProjectName>.pbix` in PascalCase or kebab-case consistently within a project.
- Project folder: `projects/<kebab-case-name>/`.

## Golden rule

If a name needs a comment to explain what it is, rename it.
