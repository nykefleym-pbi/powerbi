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
- **Direct Lake** caveats: falls back to DirectQuery on unsupported DAX/features; needs
  well-formed Delta tables (V-Order, good partitioning); framing/reframing controls freshness.
- **Large semantic model** format and XMLA read/write endpoints (edit via Tabular Editor / TMDL).

## Governance & deployment

- **Deployment pipelines** (Dev → Test → Prod) with **rules** to swap data-source params/params
  between stages; pair with source control (Git integration, TMDL/PBIP) for real CI/CD.
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
*Sources: Microsoft Learn (Fabric, semantic models, Direct Lake, deployment pipelines, OneLake).
Last reviewed: 2026-07-10.*
