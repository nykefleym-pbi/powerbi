# Data Dictionary — <Project Name>

> Produced by: **Data Architect** (structure) + **Power Query Engineer** (transformations)
> Published by **Documentation**. Format defined in `shared/data_dictionary.md`.

## Tables
| Table | Type | Grain | Source | Refresh | Rows (approx) | Key(s) |
|---|---|---|---|---|---|---|
| FactSales | Fact | order line | vw_sales | daily | ~1.2M | OrderLineKey |
| DimProduct | Dimension | product | vw_dim_product | daily | ~5k | ProductKey |

## Columns

### FactSales
| Column | Display | Type | Description | Key? | Hidden? | Source | Transform | Example |
|---|---|---|---|---|---|---|---|---|
| OrderLineKey | — | Whole | Surrogate line key | Surrogate | Yes | vw_sales.order_line_id | — | 100482 |
| OrderDateKey | — | Whole | FK to DimDate | — | Yes | vw_sales.order_date | Date→Key | 20240115 |
| Quantity | Quantity | Whole | Units sold | — | No | vw_sales.qty | — | 3 |
| NetUnitPrice | Net Unit Price | Currency | Price net of discount | — | No | vw_sales.net_price | rounded 2dp | 19.99 |

### DimProduct
| Column | Display | Type | Description | Key? | Hidden? | Source | Transform | Example |
|---|---|---|---|---|---|---|---|---|
| ProductKey | — | Whole | Surrogate | Surrogate | Yes | vw_dim_product.product_key | — | 42 |
| ProductName | Product | Text | Product display name | — | No | vw_dim_product.name | trim/proper | "Trail Bottle" |
| Category | Category | Text | Product category | — | No | vw_dim_product.category | — | "Accessories" |

_(repeat per table)_

## Audit / lineage columns
| Column | Purpose |
|---|---|
| _LoadDate | Row load timestamp (hidden) |
| _SourceSystem | Origin system (hidden) |
