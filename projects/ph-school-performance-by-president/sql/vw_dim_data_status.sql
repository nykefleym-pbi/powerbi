-- ============================================================================
-- vw_dim_data_status
-- Purpose : Dimension source for Dim_DataStatus (Official / Illustrative-Estimated).
--           First-class dimension so any page can isolate verified data (A-008).
-- Owner   : SQL Engineer (Stage 3 of 13)
-- Grain   : one data-status value
-- Source  : stg_dim_data_status  (curated dim_data_status.csv; text)
-- Keys    : data_status_key (surrogate PK); status_name (natural key, joined by fact)
-- Last chg: 2026-07-13
-- ============================================================================
CREATE VIEW vw_dim_data_status AS
SELECT
    -- Official sorts first (key 1), Illustrative-Estimated second.
    ROW_NUMBER() OVER (
        ORDER BY CASE WHEN LOWER(s.is_official) = 'true' THEN 0 ELSE 1 END) AS data_status_key,
    CAST(s.status_name AS NVARCHAR(40))                                     AS status_name,
    CAST(CASE WHEN LOWER(s.is_official) = 'true' THEN 1 ELSE 0 END AS BIT)  AS is_official,
    CAST(s.description AS NVARCHAR(300))                                    AS description
FROM stg_dim_data_status AS s;
