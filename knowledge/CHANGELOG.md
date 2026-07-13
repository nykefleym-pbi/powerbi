# Knowledge Changelog

Append-only log of changes to the [knowledge library](README.md). The
[knowledge-curator](../agents/knowledge-curator.md) adds an entry whenever it revises a knowledge
file, refreshes a "Last reviewed" date, or recommends a change to `shared/` or an agent. This closes
the maintenance loop: readers can see *what* changed and *why* without diffing every file.

**Format** — newest first, one dated block per review pass:

```
## YYYY-MM-DD — <curator run / trigger>
- <file>: <what changed> (source: <anchor>)
- Recommended: <shared/ or agent change> → status: proposed | accepted | declined
```

Guidance: record the *substance* of a change, not formatting. A pure "Last reviewed" date bump with
no content change is still worth one line so freshness is auditable. Recommendations to `shared/` or
agents are logged here but only applied by their owners — the Curator never edits them directly.

---

## 2026-07-11 — `/refresh-knowledge` pass (Microsoft / SQLBI / Deneb)
First live curator refresh (WebSearch/WebFetch now available). Validated the 2026-07-10 baseline
against upstream; three files had material upstream changes, two got note+date bumps.

- **dax-best-practices.md**: added **"User-defined functions (UDFs) — the code-reuse tool"** and
  **"Visual calculation functions"** sections; reframed calc groups as a *user-selectable
  filter/transform*, **not** a code-reuse mechanism (that's now a UDF); added a checklist line.
  (source: SQLBI — [UDFs vs. calculation groups](https://www.sqlbi.com/articles/dax-user-defined-functions-udf-vs-calculation-groups/); MS Learn visual calculations)
- **fabric.md**: split Direct Lake into **two variants** — Direct Lake *on OneLake* (multi-source,
  no DQ fallback, composite with Import tables, OneLake-file RLS) vs. *on SQL endpoint* (single
  source, DQ fallback, honors SQL RLS/OLS/CLS); added deployment-pipeline **rebind gotcha**
  (rules supported on SQL, not natively on OneLake → parameterize the OneLake URI).
  (source: MS Learn — [Direct Lake overview](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview))
- **deneb.md**: added **"Version note"** — Deneb 1.9.x bundles Vega-Lite 5.x; 5.21+ validation can
  make previously-working (warning-only) specs fail to render. (source: Deneb docs, Vega-Lite docs)
- **vega-lite.md**: added matching **validation gotcha** (5.21+ warnings → render failures); date bump.
- Footers refreshed to **2026-07-11** on the four files above.

Recommended (Curator advises; owners apply — not edited here):
- **Recommended:** `shared/dax_guidelines.md` + `dax-engineer` agent — adopt UDFs as the standard
  code-reuse mechanism and stop steering calc groups toward reuse → status: proposed
- **Recommended:** `fabric-engineer` + `data-architect` agents — when recommending Direct Lake,
  require choosing the variant (OneLake vs SQL endpoint) and note the deployment rebind constraint
  → status: proposed

## 2026-07-10 — Baseline (library created)
- Established the 13-file knowledge library (see [README.md](README.md)) aligned to Microsoft Learn,
  SQLBI, Deneb docs, and Data Goblins. All files stamped "Last reviewed: 2026-07-10."
- No recommendations outstanding. Next scheduled review: run `/refresh-knowledge` once WebSearch /
  WebFetch are available to the curator.
