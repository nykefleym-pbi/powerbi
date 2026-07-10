# Power Query (M) Guidelines

> **Owner:** Power Query Engineer · **Readers:** Power Query Engineer, Performance Optimizer, QA

## Query organization

Structure every model's queries into groups:

- **`00 Parameters`** — connection and config parameters (`pServerName`, `pStartYear`).
- **`01 Functions`** — reusable `fn*` functions.
- **`02 Staging`** — `stg*` queries, **load disabled**, one per raw source.
- **`03 Dimensions`** — `Dim*` queries, load enabled.
- **`04 Facts`** — `Fact*` queries, load enabled.

Load only what the model needs. Everything intermediate is a disabled staging query.

## Query folding (non-negotiable)

- **Preserve query folding** as far down the chain as possible — filtering, grouping,
  and joins should execute at the source, not in the mashup engine.
- Order steps so folding-breakers come last: remove columns and filter rows **early**;
  put `Table.Buffer`, custom functions, and index columns **late**.
- Verify folding with **View Native Query**; if it greys out earlier than expected,
  note it in `decision_log.md` and justify.
- Prefer source-native filtering (SQL view / `pStartYear` parameter) over M-side filtering
  for large tables.

## Step discipline

- One transformation per step; **rename steps** to describe intent (`RemovedInternalOrders`,
  not `Filtered Rows1`).
- No orphan or dead steps. No "Changed Type" stacked repeatedly — set types once, deliberately.
- Set explicit data types at the **end** of each query (single `Changed Type` step), matching
  `naming_conventions.md` (PascalCase columns, `Date` types for dates, Currency for money).

## Reusability

- Extract repeated logic into `fn*` functions in `01 Functions` (e.g. `fnCleanText`,
  `fnTrimAndProper`, `fnGetExchangeRate`).
- Parameterize environment specifics (server, database, date range) — never hard-code.
- Use a **folder import** pattern (`Folder.Files` / `Folder.Contents` → combine) for
  multi-file sources, with a sample-file function so schema changes propagate once.

## Robustness & refresh safety

- Reference columns by name, never by position/index.
- Handle nulls and type errors explicitly (`try ... otherwise`, `Table.ReplaceErrorValues`)
  so a bad row doesn't fail the whole refresh.
- Make transforms **schema-tolerant** where feasible: select/rename the columns you need
  rather than assuming exact source shape.
- No dependence on locale — set explicit culture in `Date.From`/`Number.From` when parsing text.
- Keep credentials out of M; use parameters and the gateway/data source settings.

## Shaping to the star schema

- Power Query's job is to land clean tables at the **correct grain** the Data Architect specified.
- Dimensions: deduplicate to one row per business key, add surrogate keys if required, trim/clean text.
- Facts: keep at declared grain, carry foreign keys, no descriptive attributes that belong in a dimension.
- Do **not** implement business calculations here that belong in DAX (that's the DAX Engineer's scope);
  Power Query cleans and shapes, DAX calculates.

## Anti-patterns (QA rejects)

- Folding broken early by an avoidable step ordering.
- `Changed Type` referencing columns by index.
- Business logic (KPI math) implemented in M instead of DAX.
- Loading staging/intermediate queries into the model.
- Hard-coded server names, file paths, or date ranges.

## Handoff

Document each loaded query in the project `data_dictionary.md`: source, grain, key columns,
transformations applied, and refresh considerations.
