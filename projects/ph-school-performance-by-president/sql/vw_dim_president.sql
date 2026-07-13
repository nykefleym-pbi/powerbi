-- ============================================================================
-- vw_dim_president
-- Purpose : Dimension source for Dim_President (D-001: time-context bands only,
--           never a ranking axis). One row per administration + one Unknown sentinel.
-- Owner   : SQL Engineer (Stage 3 of 13)
-- Grain   : one presidential administration (term band)
-- Source  : stg_dim_president  (curated dim_president.csv; columns loaded as text)
-- Keys    : president_key (surrogate PK). Sentinel -1 = Unknown.
-- Last chg: 2026-07-13
-- Notes   : term_start/term_end/*_key are the raw material for the fact's
--           AnchorDate as-of join (see vw_fact_metric). Marcos Jr. carries the
--           open-term sentinel 2026-12-31 and is_right_censored = 1 (A-012).
-- ============================================================================
CREATE VIEW vw_dim_president AS
SELECT
    -- Surrogate key: real presidents keyed 1..8 by chronological term_ordinal;
    -- Unknown pinned to the -1 sentinel required by the model contract (§7.3).
    CASE
        WHEN p.president_name = 'Unknown' THEN -1
        ELSE ROW_NUMBER() OVER (
                 ORDER BY CASE WHEN p.president_name = 'Unknown' THEN 1 ELSE 0 END,
                          CAST(p.term_ordinal AS INT))
    END                                                     AS president_key,
    CAST(p.president_name AS NVARCHAR(100))                 AS president_name,
    CAST(p.short_name AS NVARCHAR(50))                      AS short_name,
    CAST(p.term_start_date AS DATE)                         AS term_start_date,
    CAST(p.term_end_date AS DATE)                           AS term_end_date,
    -- yyyymmdd integer keys back into Dim_Date (null for the Unknown sentinel).
    ( YEAR(CAST(p.term_start_date AS DATE)) * 10000
    + MONTH(CAST(p.term_start_date AS DATE)) * 100
    + DAY(CAST(p.term_start_date AS DATE)) )                AS term_start_date_key,
    ( YEAR(CAST(p.term_end_date AS DATE)) * 10000
    + MONTH(CAST(p.term_end_date AS DATE)) * 100
    + DAY(CAST(p.term_end_date AS DATE)) )                  AS term_end_date_key,
    CAST(p.term_ordinal AS INT)                             AS term_ordinal,
    CAST(CASE WHEN LOWER(p.is_current_term)  = 'true' THEN 1 ELSE 0 END AS BIT) AS is_current_term,
    CAST(CASE WHEN LOWER(p.is_right_censored) = 'true' THEN 1 ELSE 0 END AS BIT) AS is_right_censored,
    CAST(NULLIF(p.band_color_token, '') AS NVARCHAR(50))    AS band_color_token
FROM stg_dim_president AS p;
