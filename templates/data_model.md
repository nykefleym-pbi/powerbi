# Data Model — <Project Name>

> Produced by: **Data Architect** · Readers: SQL, Power Query, DAX, Performance, QA, Docs
> The blueprint every downstream engineer builds against. Star schema.

## 1. Grain statement
- **Fact grain:** one row = <e.g., one order line>
- Additional facts (if any) and their grain: <FactInventory = one product per store per day>

## 2. Star schema diagram
```
                 +-----------+
                 |  DimDate  |
                 +-----+-----+
                       |
        +-----------+  |  +--------------+
        | DimProduct|--+--|  DimCustomer |
        +-----------+  |  +--------------+
                       |
                 +-----+------+
                 |  FactSales |
                 +-----+------+
                       |
                 +-----+------+
                 | DimStore   |
                 +------------+
```
(Replace with the actual model; keep it a star — note any exceptions.)

## 3. Tables
| Table | Type | Grain | Source | Key(s) | Approx rows |
|---|---|---|---|---|---|
| FactSales | Fact | order line | vw_sales | OrderLineKey | |
| DimDate | Dimension | day | generated | DateKey | |
| DimProduct | Dimension | product | vw_dim_product | ProductKey | |
| DimCustomer | Dimension | customer | vw_dim_customer | CustomerKey | |

## 4. Relationships
| From (fact) | To (dim) | Column | Cardinality | Direction | Active | Role |
|---|---|---|---|---|---|---|
| FactSales | DimDate | OrderDateKey | * → 1 | single | yes | Order date |
| FactSales | DimDate | ShipDateKey | * → 1 | single | no | Ship date (USERELATIONSHIP) |

## 5. Date table
- Range: <min fact date> → <max fact date>, contiguous, marked as date table.
- Columns: Date, Year, Quarter, Month, MonthName, MonthYear, Fiscal*, IsWeekend, etc.
- Fiscal calendar: <start month> (per `business_rules.md`).

## 6. Design decisions
- Snowflake exceptions & justification (link `decision_log.md`).
- Role-playing dimensions and how they're handled.
- SCD approach for changing dimensions (Type 1/2) if relevant.

## 7. Lineage
Source system → SQL view → Power Query → Model table. One row per model table.

## 8. Open items
- Assumptions affecting the model (link `assumptions.md`).
