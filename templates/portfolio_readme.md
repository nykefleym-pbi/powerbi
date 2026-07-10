# <Project Name> — Power BI Dashboard

> Portfolio README. Produced by **Documentation**, reviewed by **Portfolio Reviewer**.
> Written for a hiring manager skimming for 60 seconds — lead with impact and a visual.

![Dashboard preview](./assets/preview.png)

## TL;DR
<One paragraph: the business problem, who it's for, and the headline insight the dashboard
delivers. State the "so what.">

## Business problem
<The situation and the decisions this dashboard supports. Personas and how often they use it.>

## What it answers
- <business question 1>
- <business question 2>
- <business question 3>

## Key features
- 📊 <Executive summary with X KPIs and YoY variance>
- 🔎 <Drillthrough from region → store → product>
- 🎛️ <Calculation group for time intelligence (Current/YTD/PY/YoY)>
- ♿ <Accessible: AA contrast, alt text, mobile layout>

## Data model
<One-line description + star schema image.>
![Model](./assets/model.png)

- Grain: <...> · Tables: <n facts, m dims> · Rows: <~N>

## Notable DAX
```dax
Revenue YoY % =
VAR Cur = [Total Revenue]
VAR Prior = CALCULATE ( [Total Revenue], DATEADD ( DimDate[Date], -1, YEAR ) )
RETURN DIVIDE ( Cur - Prior, Prior )
```
<Why it's interesting — the modeling choice it demonstrates.>

## Tech & techniques
Power BI · Power Query (M) · DAX · Star schema · Calculation groups · RLS · <SQL source>

## How it was built
Built with a multi-agent BI workflow (business analysis → architecture → SQL → Power Query →
DAX → design → performance → QA → docs → review → critique). See `docs/`.

## Data source & disclaimer
<Source; synthetic/public data note; not real company data.>

## Screenshots
<gallery>

## Contact
<name · portfolio link · email>
