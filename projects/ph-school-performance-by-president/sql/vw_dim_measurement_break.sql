-- ============================================================================
-- vw_dim_measurement_break
-- Purpose : Dimension source for Dim_MeasurementBreak. Makes measurement breaks
--           queryable, not hard-coded in visuals (A-009/A-010). Doubles as a
--           disconnected annotation source (EventDate plotted on the timeline).
-- Owner   : SQL Engineer (Stage 3 of 13)
-- Grain   : one break event (row 0 = "No break")
-- Source  : stg_dim_measurement_break  (curated dim_measurement_break.csv; text)
-- Keys    : break_key (surrogate PK). Sentinel 0 = No break.
-- Last chg: 2026-07-13
-- Notes   : break_name is the natural key the fact joins on (break_flag text).
-- ============================================================================
CREATE VIEW vw_dim_measurement_break AS
SELECT
    -- "No break" sorts first -> row 1 -> key 0 (the model's sentinel); real
    -- breaks then ordered by EventDate.
    ROW_NUMBER() OVER (
        ORDER BY CASE WHEN b.break_name = 'No break' THEN 0 ELSE 1 END,
                 CAST(b.event_date AS DATE)) - 1                 AS break_key,
    CAST(b.break_name AS NVARCHAR(60))                           AS break_name,
    CAST(b.break_type AS NVARCHAR(30))                           AS break_type,
    CAST(NULLIF(b.event_date, '') AS DATE)                       AS event_date,
    CASE WHEN NULLIF(b.event_date, '') IS NULL THEN NULL
         ELSE ( YEAR(CAST(b.event_date AS DATE)) * 10000
              + MONTH(CAST(b.event_date AS DATE)) * 100
              + DAY(CAST(b.event_date AS DATE)) )
    END                                                          AS event_date_key,
    CAST(b.affected_scope AS NVARCHAR(120))                      AS affected_scope,
    CAST(b.severity AS NVARCHAR(20))                             AS severity,
    CAST(b.description AS NVARCHAR(400))                         AS description
FROM stg_dim_measurement_break AS b;
