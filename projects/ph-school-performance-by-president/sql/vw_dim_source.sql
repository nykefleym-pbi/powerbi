-- ============================================================================
-- vw_dim_source
-- Purpose : Dimension source for Dim_Source (provenance: publisher/indicator).
-- Owner   : SQL Engineer (Stage 3 of 13)
-- Grain   : one publisher x indicator (dataset) row
-- Source  : stg_dim_source  (curated dim_source.csv; text)
-- Keys    : source_key (surrogate PK); indicator_code (natural key, joined by fact)
-- Last chg: 2026-07-13
-- Notes   : indicator_code is the join key. Two rows use GROUPED codes that cover
--           several fact indicator_codes: 'PISA-MATH/READ/SCI' and 'NAT-MPS-G6/G10'.
--           vw_fact_metric normalises the fact's per-subject/per-grade codes onto
--           these grouped codes before joining (see that view's source_join_code).
-- ============================================================================
CREATE VIEW vw_dim_source AS
SELECT
    ROW_NUMBER() OVER (ORDER BY s.publisher, s.dataset, s.indicator_code) AS source_key,
    CAST(s.publisher AS NVARCHAR(80))                                     AS publisher,
    CAST(s.dataset AS NVARCHAR(120))                                      AS dataset,
    CAST(s.indicator_code AS NVARCHAR(40))                                AS indicator_code,
    CAST(s.source_url AS NVARCHAR(400))                                   AS source_url,
    CAST(s.accessed_date AS DATE)                                         AS accessed_date,
    CAST(s.definition_note AS NVARCHAR(400))                              AS definition_note,
    CAST(s.coverage_earliest_year AS INT)                                 AS coverage_earliest_year,
    CAST(s.coverage_latest_year AS INT)                                   AS coverage_latest_year
FROM stg_dim_source AS s;
