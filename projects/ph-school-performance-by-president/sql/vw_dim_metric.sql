-- ============================================================================
-- vw_dim_metric
-- Purpose : Dimension source for Dim_Metric. One row per metric / sub-variant.
--           UnitOfMeasure enforces the "never SUM across metrics" guard-rail (D-002).
-- Owner   : SQL Engineer (Stage 3 of 13)
-- Grain   : one metric member (MetricCode is the natural/business key)
-- Source  : stg_dim_metric  (curated dim_metric.csv; columns loaded as text)
-- Keys    : metric_key (surrogate PK); metric_code (natural key, joined by the fact)
-- Last chg: 2026-07-13
-- ============================================================================
CREATE VIEW vw_dim_metric AS
SELECT
    ROW_NUMBER() OVER (ORDER BY CAST(m.sort_order AS INT)) AS metric_key,
    CAST(m.metric_code AS NVARCHAR(20))                    AS metric_code,
    CAST(m.metric_name AS NVARCHAR(120))                   AS metric_name,
    CAST(m.metric_family AS NVARCHAR(30))                  AS metric_family,
    CAST(m.unit_of_measure AS NVARCHAR(20))                AS unit_of_measure,
    CAST(m.frequency AS NVARCHAR(40))                      AS frequency,
    CAST(m.definition_basis AS NVARCHAR(300))              AS definition_basis,
    CAST(CASE WHEN LOWER(m.is_proxy) = 'true' THEN 1 ELSE 0 END AS BIT) AS is_proxy,
    -- false for the K5_* NAT members (not comparable across the 2016 scale break, A-004)
    CAST(CASE WHEN LOWER(m.is_comparable_across_years) = 'true' THEN 1 ELSE 0 END AS BIT) AS is_comparable_across_years,
    -- nullable display/format hint (blank for K2 count and K8 share)
    CAST(CASE WHEN LOWER(m.higher_is_better) = 'true'  THEN 1
              WHEN LOWER(m.higher_is_better) = 'false' THEN 0
              ELSE NULL END AS BIT)                        AS higher_is_better,
    CAST(m.default_aggregation AS NVARCHAR(20))            AS default_aggregation,
    CAST(m.sort_order AS INT)                              AS sort_order
FROM stg_dim_metric AS m;
