---
name: refresh-knowledge
description: >-
  Audit and refresh the knowledge/ library against upstream sources (Microsoft Learn, SQLBI,
  Deneb, Data Goblins), flag outdated guidance, and recommend agent/standards updates — without
  touching project implementation. Run by the Knowledge Curator. Invoke as /refresh-knowledge.
---

# Refresh the Knowledge Library

Run by the **Knowledge Curator**. Scope is the reference layer and recommendations **only** —
never edit `projects/**` or a specialist's implementation. Reference: `knowledge/README.md`
(source map + review dates), `agents/knowledge-curator.md`.

## Procedure

1. **Pick scope** — a source (Microsoft / SQLBI / Deneb / Data Goblins) or a `knowledge/*.md`
   file due for review (check the footer "Last reviewed" date).
2. **Gather current guidance** — use WebSearch/WebFetch on the primary source; capture what
   changed since the file's last review (new features, renamed concepts, deprecations).
3. **Diff against the file** — list: outdated statements, gaps, and newly relevant practices.
4. **Update the knowledge file** — apply concise, sourced edits; refresh the footer
   "Last reviewed" date and source anchors. Keep it a summary, not a copy.
5. **Assess ripple** — does the change affect a `shared/` standard or an agent's behavior? If so,
   **recommend** the edit (don't silently change enforced standards without Orchestrator/owner
   sign-off). Note breaking changes.
6. **Write the changelog** — a short "Knowledge update" note: source, what changed, files touched,
   recommended follow-ups for agents/standards, and any deprecations to stop teaching.

## Boundaries

- Advisory + reference maintenance only. Recommends changes to `shared/` and agents via the
  Orchestrator; **never** modifies implementation work or approves gates.
- Every claim is sourced; when unsure, defer to the primary source and flag for human review.

## Output

Updated `knowledge/*.md` file(s) with fresh review dates + a changelog of recommendations.
