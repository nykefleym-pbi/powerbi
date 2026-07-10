# Architecture — <Project Name>

> Produced by: **Data Architect** + **Documentation** · Readers: all
> The end-to-end technical picture: where data comes from, how it flows, how it's modeled and served.

## 1. Solution overview
<One paragraph + a diagram of the whole pipeline.>

```
[Source system(s)] → [SQL views (dim/fact/rpt)] → [Power Query ETL] → [Semantic model (star)]
   → [Measures / Calc groups] → [Report pages] → [Consumers]
```

## 2. Data sources
| Source | Type | Owner | Refresh | Notes |
|---|---|---|---|---|
| <system> | SQL / file / API | | | |

## 3. Ingestion & transformation
- SQL layer: which views, at what grain, doing what work (link `sql/`).
- Power Query: query groups, folding status, parameters, functions (link `powerquery/`).
- Refresh strategy: full vs. incremental; cadence; gateway.

## 4. Semantic model
- Star schema (link `data_model.md`), relationships, date table.
- Measure architecture: base measures + variants + calculation groups.
- RLS design.

## 5. Report layer
- Page inventory and navigation model.
- Interaction model (cross-filtering, drillthrough, bookmarks).
- Theme (`theme.json`).

## 6. Non-functional
- Performance budget & results (link `performance_report.md`).
- Accessibility conformance (AA).
- Security (RLS, no secrets in repo).

## 7. Deployment
- Environments, workspace, dataset/report separation, promotion path.

## 8. Key decisions
Link the important entries from `decision_log.md`.

## 9. Diagrams
- Star schema · pipeline · (optional) DAX dependency map.
