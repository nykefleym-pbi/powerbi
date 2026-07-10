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

## 2026-07-10 — Baseline (library created)
- Established the 13-file knowledge library (see [README.md](README.md)) aligned to Microsoft Learn,
  SQLBI, Deneb docs, and Data Goblins. All files stamped "Last reviewed: 2026-07-10."
- No recommendations outstanding. Next scheduled review: run `/refresh-knowledge` once WebSearch /
  WebFetch are available to the curator.
