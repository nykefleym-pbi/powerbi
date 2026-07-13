-- ============================================================================
-- vw_dim_date
-- Purpose : Daily calendar for the marked Date table (§5 / §7.2).
--           Range 1965-01-01 -> 2026-12-31 so the Marcos Sr. band (term start
--           1965-12-30) and all later term bands render on the same axis.
-- Owner   : SQL Engineer (Stage 3 of 13)
-- Grain   : one calendar day (~22,645 rows)
-- Source  : generated (no staging table)
-- Keys    : date_key (yyyymmdd, surrogate PK)
-- Last chg: 2026-07-13
-- Notes   : This is the SQL reference shaping. In this Import-mode model the
--           Dim_Date table is GENERATED IN POWER QUERY (§8 lineage: source =
--           generated); this view documents the identical column contract.
--           Uses a portable numbers/tally pattern (stacked CROSS JOINs of a
--           digit list) rather than a recursive CTE, so there is no recursion
--           cap to lift and it runs unchanged on Fabric Warehouse / Azure SQL /
--           Synapse. PH school year runs ~June->March (SchoolYear starts June).
-- ============================================================================
CREATE VIEW vw_dim_date AS
WITH digits AS (
    SELECT n FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS d(n)
),
day_offsets AS (
    -- 10^5 = 100,000 candidate offsets; far more than the ~22,645 days needed.
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS day_offset
    FROM digits AS d1
    CROSS JOIN digits AS d2
    CROSS JOIN digits AS d3
    CROSS JOIN digits AS d4
    CROSS JOIN digits AS d5
),
calendar AS (
    SELECT DATEADD(DAY, o.day_offset, CAST('1965-01-01' AS DATE)) AS d
    FROM day_offsets AS o
    WHERE o.day_offset <= DATEDIFF(DAY, CAST('1965-01-01' AS DATE), CAST('2026-12-31' AS DATE))
)
SELECT
    ( YEAR(c.d) * 10000 + MONTH(c.d) * 100 + DAY(c.d) )      AS date_key,
    c.d                                                      AS [date],
    YEAR(c.d)                                                AS calendar_year,
    'Q' + CAST(DATEPART(QUARTER, c.d) AS NVARCHAR(1))        AS quarter,
    MONTH(c.d)                                               AS [month],
    DATENAME(MONTH, c.d)                                     AS month_name,
    LEFT(DATENAME(MONTH, c.d), 3) + ' ' + CAST(YEAR(c.d) AS NVARCHAR(4)) AS month_year,
    -- School year starts in June: months >= June belong to that year's SY start.
    CASE WHEN MONTH(c.d) >= 6 THEN YEAR(c.d) ELSE YEAR(c.d) - 1 END      AS school_year_start_year,
    CAST(CASE WHEN MONTH(c.d) >= 6 THEN YEAR(c.d) ELSE YEAR(c.d) - 1 END AS NVARCHAR(4))
        + N'–' + CAST(CASE WHEN MONTH(c.d) >= 6 THEN YEAR(c.d) + 1 ELSE YEAR(c.d) END AS NVARCHAR(4))
                                                             AS school_year_label,
    CAST(CASE WHEN MONTH(c.d) = 6 THEN 1 ELSE 0 END AS BIT)  AS is_school_year_start_month,
    CAST((YEAR(c.d) / 10) * 10 AS NVARCHAR(4)) + 's'         AS decade
FROM calendar AS c;
