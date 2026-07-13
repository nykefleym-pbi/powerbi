-- ============================================================================
-- vw_fact_metric
-- Purpose : Core long/tidy fact source for FactMetric (D-002). Stamps each
--           observation with an AnchorDate (§6.1), derives PresidentKey via an
--           as-of term join (D-003), and resolves every FK to the dim views.
-- Owner   : SQL Engineer (Stage 3 of 13)
-- Grain   : one metric value  x  AnchorDate  x  education level  x  source
--           (surrogate PK metric_fact_key). Expect 273 rows.
-- Source  : stg_fact_metric_raw  (curated fact_metric_raw.csv; columns as text)
-- Last chg: 2026-07-13
-- ----------------------------------------------------------------------------
-- AnchorDate (§6.1) collapses each period to a single date, then DateKey = that
-- date as yyyymmdd:
--   * K7, K8 (LFS/WB annual) ......... July 1 of `year`   (neutral mid-year anchor)
--   * K6_* (PISA cycle) .............. Oct 1 of `year`     (PH sat PISA ~Q3-Q4)
--   * all school/academic-year series  Oct 1 of school_year_start_year
--     (K1, K1b, K2, K3, K4, K5_*) ...  (mid first semester, after the June-30 inaugural)
--   NAT (K5_*) rows already carry school_year_start_year = year - 1 (SOURCES.md),
--   so no special-casing is needed here.
--
-- PresidentKey (D-003): as-of join — the administration in office on AnchorDate,
--   i.e. term_start_date <= AnchorDate < term_end_date. Term bands are contiguous
--   half-open intervals (each term_end = next term_start), so exactly one matches;
--   the Unknown row (null dates) never matches and unmatched rows fall back to -1.
--   This is a computed FK ON THE FACT, NOT a Dim_Date -> Dim_President relationship.
-- ============================================================================
CREATE VIEW vw_fact_metric AS
WITH fact_anchored AS (
    SELECT
        f.metric_code,
        f.period_label,
        f.education_level,
        f.data_status,
        CAST(f.value AS DECIMAL(18, 5))                              AS metric_value,
        CAST(NULLIF(f.school_year_start_year, '') AS INT)           AS school_year_start_year,
        CAST(f.year AS INT)                                         AS obs_year,
        -- Normalise per-subject / per-grade codes onto Dim_Source's grouped codes.
        CASE
            WHEN f.indicator_code IN ('PISA-MATH', 'PISA-READ', 'PISA-SCI')     THEN 'PISA-MATH/READ/SCI'
            WHEN f.indicator_code IN ('NAT-MPS-G6', 'NAT-MPS-G10', 'NAT-MPS-G12') THEN 'NAT-MPS-G6/G10'
            ELSE f.indicator_code
        END                                                         AS source_join_code,
        -- Blank break_flag -> NULL so the left join misses and BreakKey resolves to 0.
        NULLIF(f.break_flag, '')                                    AS break_flag,
        -- AnchorDate per §6.1 (see header).
        CASE
            WHEN f.metric_code IN ('K7', 'K8')
                THEN DATEFROMPARTS(CAST(f.year AS INT), 7, 1)
            WHEN f.metric_code IN ('K6_MATH', 'K6_READ', 'K6_SCI')
                THEN DATEFROMPARTS(CAST(f.year AS INT), 10, 1)
            ELSE DATEFROMPARTS(CAST(f.school_year_start_year AS INT), 10, 1)
        END                                                         AS anchor_date
    FROM stg_fact_metric_raw AS f
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY fa.metric_code, fa.source_join_code, fa.education_level, fa.obs_year) AS metric_fact_key,
    m.metric_key,
    ( YEAR(fa.anchor_date) * 10000
    + MONTH(fa.anchor_date) * 100
    + DAY(fa.anchor_date) )                                         AS date_key,   -- = AnchorDate yyyymmdd
    el.education_level_key,
    COALESCE(pres.president_key, -1)                                AS president_key,
    ds.data_status_key,
    src.source_key,
    COALESCE(brk.break_key, 0)                                      AS break_key,
    fa.metric_value,
    fa.school_year_start_year,                                                       -- degenerate, nullable
    CAST(fa.period_label AS NVARCHAR(60))                          AS period_label
FROM fact_anchored AS fa
INNER JOIN vw_dim_metric          AS m   ON m.metric_code     = fa.metric_code
INNER JOIN vw_dim_education_level AS el  ON el.level_name     = fa.education_level
INNER JOIN vw_dim_data_status     AS ds  ON ds.status_name    = fa.data_status
INNER JOIN vw_dim_source          AS src ON src.indicator_code = fa.source_join_code
-- As-of president join (D-003): administration in office on the AnchorDate.
LEFT  JOIN vw_dim_president        AS pres ON fa.anchor_date >= pres.term_start_date
                                         AND fa.anchor_date <  pres.term_end_date
-- Break tag; misses (blank flag) resolve to BreakKey 0 via COALESCE above.
LEFT  JOIN vw_dim_measurement_break AS brk ON brk.break_name = fa.break_flag;
