# Microsoft Fabric & Semantic Models

> For the **Fabric engineer**, Data Architect, and Performance. Covers Fabric platform, semantic
> models as first-class citizens, storage modes, and deployment. Complements
> [`shared/performance_guidelines.md`](../shared/performance_guidelines.md).

## Fabric in one page

Fabric is Microsoft's unified SaaS analytics platform organized into **workspaces** with items:
- **OneLake** — one logical data lake for the tenant; all engines read/write the same Delta/Parquet.
- **Lakehouse** (files + Delta tables, Spark/SQL) and **Warehouse** (T-SQL, transactional).
- **Data Factory** (pipelines, Dataflows Gen2) for ingest/transform.
- **Semantic model** (formerly "dataset") — the Power BI model layer.
- **Power BI reports**, **Notebooks**, **Eventstream/KQL** (real-time), **Data Agent**.

## Semantic models

- The semantic model = tables, relationships, measures, RLS, calc groups — the thing DAX and
  data-architect agents build. Treat it as a **product**: named, documented, versioned.
- **Storage modes:** Import (VertiPaq, fastest, needs refresh) · DirectQuery (live, source-bound,
  slower) · **Direct Lake** (Fabric-only: reads Delta tables in OneLake directly — Import-like
  speed with no refresh copy) · Composite (mix + aggregations).
- **Two Direct Lake variants** (choose deliberately — they differ on composite modeling and
  deployment, below):
  - **Direct Lake on OneLake** — reads Delta tables from *one or more* Fabric sources; **no
    DirectQuery fallback**; **can add Import tables** (true composite in web modeling); supports
    unmaterialized calculated columns/tables (preview). Requires OneLake file access (SQL-endpoint
    RLS is *not* applied).
  - **Direct Lake on SQL endpoint** — single lakehouse/warehouse source; **falls back to
    DirectQuery** (SQL views, SQL-based RLS/OLS/CLS); honors SQL-endpoint security. Cannot mix
    Direct Lake + DirectQuery/Dual in the same model.
- **Direct Lake** caveats (both): needs well-formed Delta tables (V-Order, good partitioning);
  framing/reframing controls freshness; cloud connections only (no gateway); Fabric capacity (F SKU)
  required. RLS: use a **fixed-identity** cloud connection. On guardrail breach, OneLake *fails* the
  refresh while SQL *falls back* to DirectQuery.
- **Large semantic model** format and XMLA read/write endpoints (edit via Tabular Editor / TMDL;
  requires `compatibilityLevel` 1604+ for Direct Lake).
- Since **2025-09-05**, default semantic models are **no longer auto-created** with a lakehouse /
  warehouse / mirrored item — create the model explicitly.

## Governance & deployment

- **Deployment pipelines** (Dev → Test → Prod) with **rules** to swap data-source params
  between stages; pair with source control (Git integration, TMDL/PBIP) for real CI/CD.
- **Direct Lake + pipelines gotcha:** data-source **rebind rules are supported for Direct Lake on
  SQL** but **not natively for Direct Lake on OneLake**. A deployed Direct Lake model stays bound
  to the *source-stage* item until rebound. For OneLake, **parameterize the OneLake URI** (or use
  Fabric CLI / Semantic Link Labs) so each stage points at its own workspace/item.
- **Endorsement** (Promoted / Certified), sensitivity labels, and lineage view for trust.
- **Workspace roles** (Admin/Member/Contributor/Viewer) + item permissions; RLS/OLS enforced in
  the model, not the report.

## What the Fabric engineer decides / advises

- Storage mode per semantic model (Import vs Direct Lake vs DirectQuery vs Composite) and why.
- Refresh strategy (incremental refresh, Direct Lake framing) and capacity considerations.
- Deployment-pipeline setup and parameterized data sources for portable dev→prod.
- Whether a workload belongs in Lakehouse vs Warehouse; when to push transforms upstream (SQL /
  Dataflow) vs Power Query.

## Portfolio note

For a portfolio piece, Import mode + PBIP + a documented "how this would scale in Fabric
(Direct Lake, deployment pipelines)" section demonstrates platform fluency without needing a
paid capacity. The Fabric engineer writes that section for the Documentation agent.

---
*Sources: Microsoft Learn — [Direct Lake overview](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview)
(on OneLake vs on SQL, composite models, deployment-pipeline binding), Fabric fundamentals,
semantic models, deployment pipelines, OneLake. Last reviewed: 2026-07-11.*
