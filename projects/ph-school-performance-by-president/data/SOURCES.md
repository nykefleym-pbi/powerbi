# SOURCES.md - Citations for the curated CSV seed layer

> PH School Performance by President - Data Acquisition (Stage 3 input)
> Compiled 2026-07-13. Every Official value traces to a named publisher + reachable URL.
> Illustrative-Estimated values are flagged and carry a one-line basis. No citation is fabricated.

## Data vintage (A-011)
As-of / accessed date for every source below: **2026-07-13**.

## Citation table (metric_code -> source)

| metric_code | Level | Publisher | Dataset / Indicator | URL | Coverage (yrs) | Status |
|---|---|---|---|---|---|---|
| K1 | Elementary | World Bank Open Data (UNESCO UIS) | Pupil-teacher ratio, primary - `SE.PRM.ENRL.TC.ZS` | https://data.worldbank.org/indicator/SE.PRM.ENRL.TC.ZS?locations=PH | 1971-2017 | Official |
| K1 | Secondary | World Bank Open Data (UNESCO UIS) | Pupil-teacher ratio, secondary - `SE.SEC.ENRL.TC.ZS` | https://data.worldbank.org/indicator/SE.SEC.ENRL.TC.ZS?locations=PH | 1971-2017 | Official |
| K2 | Elementary | World Bank Open Data (UNESCO UIS) | Enrolment, primary (number) - `SE.PRM.ENRL` | https://data.worldbank.org/indicator/SE.PRM.ENRL?locations=PH | 1971-2024 (gap 2010-2013) | Official |
| K2 | Secondary | World Bank Open Data (UNESCO UIS) | Enrolment, secondary (number) - `SE.SEC.ENRL` | https://data.worldbank.org/indicator/SE.SEC.ENRL?locations=PH | 1971-2024 (gap 2000, 2010-2013) | Official |
| K3 | Elementary | World Bank Open Data (UNESCO UIS) | Primary completion rate, % - `SE.PRM.CMPT.ZS` | https://data.worldbank.org/indicator/SE.PRM.CMPT.ZS?locations=PH | 1981-2024 (sparse) | Official (real proxy for cohort survival) |
| K5_G6 | Elementary | DepEd | National Achievement Test MPS, Grade 6 | https://region2.deped.gov.ph/wp-content/uploads/2019/05/2018-NATIONAL-ACHIEVEMENT-TEST-NAT-610-12-RESULTS-AND-ANALYSIS-.pdf | 2015-2018 | Official (break 2016) |
| K5_G10 | Junior High | DepEd | National Achievement Test MPS, Grade 10 | https://region2.deped.gov.ph/wp-content/uploads/2019/05/2018-NATIONAL-ACHIEVEMENT-TEST-NAT-610-12-RESULTS-AND-ANALYSIS-.pdf | 2014-2018 | Official (break 2016) |
| K6_MATH / K6_READ / K6_SCI | National | OECD | PISA 2018 & 2022 Country Note: Philippines | https://www.oecd.org/en/publications/pisa-2022-results-volume-i-and-ii-country-notes_ed6fbcc5-en/philippines_a0882a2d-en.html | 2018 & 2022 | Official |
| K7 | National | World Bank Open Data (ILO modelled) | Unemployment, youth 15-24 - `SL.UEM.1524.ZS` | https://data.worldbank.org/indicator/SL.UEM.1524.ZS?locations=PH | 1991-2024 | Official (PROXY metric) |
| K8 | National | World Bank Open Data (ILO) | Unemployment w/ advanced education, % of total - `SL.UEM.ADVN.ZS` | https://data.worldbank.org/indicator/SL.UEM.ADVN.ZS?locations=PH | 2003-2023 (gaps) | Official (PROXY metric) |
| K4 | Higher Education | CHED | Higher Education Facts & Figures / HEMIS | https://ched.gov.ph/statistics | 1975-2019 (est. points) | **Illustrative-Estimated** |

All World Bank series were pulled live from the WB API on 2026-07-13, e.g.
`https://api.worldbank.org/v2/country/PHL/indicator/SE.PRM.ENRL.TC.ZS?format=json&per_page=100&date=1970:2024`
(swap the indicator code for the others). Values in `fact_metric_raw.csv` are the exact non-null year:value pairs returned.

## PISA values used (Official, OECD)
| Cycle | Math | Reading | Science |
|---|---|---|---|
| 2018 | 353 | 340 | 357 |
| 2022 | 355 | 347 | 356 |
Verified against the OECD PISA 2022 Philippines Country Note (URL above): PH scored 355 (math), 347 (reading), 356 (science) in 2022. 2018 values per `data_model.md` Sec.9 and the same OECD note series. OECD 2022 averages (benchmarks): Math 472, Reading 476, Science 485.

## NAT (K5) figures used (Official, DepEd) and the scale break
Grade 6: 2015 = 70.88; 2016 = 42.03; 2017 = 39.95; 2018 = 37.44.
Grade 10: 2014 = 53.77; 2017 = 44.08; 2018 = 44.59.
A **scale/methodology change ~2015->2016** makes MPS **not comparable across the break** (A-004). Every row with `year >= 2016` carries `break_flag = "NAT scale change (2016)"`. In the fact table these rows are anchored to the school year (`school_year_start_year = year - 1`, i.e. NAT reported year ~= end of school year). Source: DepEd Region II 2018 NAT results-and-analysis PDF (above), corroborated by Inquirer Opinion, "What happened to our basic education?" https://opinion.inquirer.net/125707/what-happened-to-our-basic-education .

## Measurement breaks flagged in the fact table
- **K-12 Senior High rollout (2016)** - K2 Secondary rows `year >= 2016` (secondary enrolment step-change is reform-driven, not growth; A-009).
- **NAT scale change (2016)** - K5 rows `year >= 2016` (A-004).
- **COVID-19 shock (2020)** - K7 (2020, 2021) and K8 (2021) rows (A-010). Note: basic-ed enrolment also dipped 2020-2021 (visible in K2) but is left unflagged to keep the K-12 annotation clean on the secondary series; call it out on the page.
- **PISA debut (2018)** - K6 2018 rows (first PH cycle; A-003).

## Metrics NOT sourced / partially sourced (honest gaps)
- **K4 Higher-Education Graduates - ILLUSTRATIVE-ESTIMATED (whole series).** CHED publishes national graduate totals only inside "Higher Education Facts & Figures" PDFs and HEMIS files; the CHED site (ched.gov.ph) returned HTTP 403 to automated fetch and the totals are not machine-extractable from the reachable index page. Rather than attach exact numbers to a source I could not read, the 8 K4 rows are labelled **Illustrative-Estimated**. **Basis:** order-of-magnitude national HE graduate counts rising over time (roughly ~180k in the mid-1970s to ~830k by AY2019-20), interpolated on a smooth upward trend consistent with the widely-reported scale of PH HEI output. The Stage-3/curator step should replace these with exact CHED Facts & Figures values (AY1999-2000 onward are officially available; pre-CHED-1994 stays illustrative per A-002). Dataset home: https://ched.gov.ph/statistics .
- **K1b (DepEd positions-basis PTR)** - no rows in v1. DepEd BEIS positions-basis figures were not cleanly sourceable via automated fetch; the metric member exists in `dim_metric.csv` (D-004) so Stage 3 can populate it later from DepEd BEIS without a model change. Never splice into the K1 WB line.
- **K5_G12 (NAT Grade 12)** - no rows in v1; no comparable published Grade-12 MPS series was sourceable. Metric member kept in `dim_metric.csv` for future load.
- **K3 DepEd-specific cohort survival** - not added; the World Bank `SE.PRM.CMPT.ZS` series is the real anchor used for K3. DepEd EBEIS cohort-survival figures can be added later (A-005: pre-1990s would be illustrative).

## Presidential terms (Official, requirements.md Sec.4)
Source: en.wikipedia.org/wiki/List_of_presidents_of_the_Philippines, corroborated by official records. Exact term start/end dates are in `dim_president.csv`. Marcos Jr. term end uses the `2026-12-31` open-term sentinel and is flagged `is_right_censored = true` (A-012).

## Files in this folder
- `fact_metric_raw.csv` - long fact staging table (273 observation rows).
- `dim_president.csv`, `dim_metric.csv`, `dim_education_level.csv`, `dim_data_status.csv`, `dim_source.csv`, `dim_measurement_break.csv`, `benchmarks.csv` - dimension/benchmark seeds (descriptive columns only; SQL Engineer adds surrogate keys).
- `SOURCES.md` - this file.