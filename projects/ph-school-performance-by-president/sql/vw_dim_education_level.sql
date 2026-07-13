-- ============================================================================
-- vw_dim_education_level
-- Purpose : Dimension source for Dim_EducationLevel. One row per level.
-- Owner   : SQL Engineer (Stage 3 of 13)
-- Grain   : one education level
-- Source  : stg_dim_education_level  (curated dim_education_level.csv; text)
-- Keys    : education_level_key (surrogate PK). Sentinel 0 = National.
-- Last chg: 2026-07-13
-- Notes   : level_name is kept as the BARE token (the join key the fact carries
--           in education_level). level_name_display adds the parenthetical form
--           for report labels, per the SOURCES.md display-vs-join note.
-- ============================================================================
CREATE VIEW vw_dim_education_level AS
SELECT
    -- National (level_order 0) sorts first -> row 1 -> key 0 (the model's sentinel).
    ROW_NUMBER() OVER (ORDER BY CAST(el.level_order AS INT)) - 1 AS education_level_key,
    CAST(el.level_name AS NVARCHAR(40))                          AS level_name,          -- join key (bare token)
    CAST(
        CASE el.level_name
            WHEN 'National'         THEN 'National (not level-specific)'
            WHEN 'Elementary'       THEN 'Elementary (Primary)'
            WHEN 'Secondary'        THEN 'Secondary (aggregate)'
            ELSE el.level_name
        END AS NVARCHAR(60))                                     AS level_name_display,  -- display label
    CAST(el.level_group AS NVARCHAR(30))                         AS level_group,
    CAST(el.level_order AS INT)                                  AS level_order,
    CAST(CASE WHEN LOWER(el.is_post_k12_only) = 'true' THEN 1 ELSE 0 END AS BIT) AS is_post_k12_only
FROM stg_dim_education_level AS el;
