# Data Dictionary (System Reference)

> **Owner:** Data Architect (source tables) + Power Query Engineer (transformations)
> **Readers:** all agents. This is the *reference/how-to*; each project fills in its own copy
> generated from `templates/data_dictionary.md`.

The data dictionary is the authoritative catalog of every **table** and **column** in the
semantic model: what it is, where it comes from, its type, and its grain.

## What every table entry records

- Table name (per `naming_conventions.md`) and type (Fact / Dimension / Bridge / Helper).
- **Grain** — one row represents exactly what.
- Source (SQL view / file / API) and refresh cadence.
- Row count (approx) and key column(s).
- Relationships (to which dimension, on which key, direction, active/inactive).

## What every column entry records

| Field | Meaning |
|---|---|
| Column | Physical name (PascalCase) |
| Display name | Friendly name shown to users |
| Data type | Whole / Decimal / Currency / Date / Text / Boolean |
| Description | One line — feeds tooltips and docs |
| Key? | Surrogate / Business / — |
| Hidden? | Yes for keys and internals |
| Source column | Origin column in the source system |
| Transformations | What Power Query did to it |
| Example values | Representative sample |

## Column classification

- **Keys** — hidden, integer where possible, used only for relationships.
- **Attributes** — descriptive columns used for slicing/grouping (in dimensions).
- **Measures source columns** — numeric columns in facts that measures aggregate.
- **Audit columns** — load date, source system; hidden, for lineage/debugging.

## Maintenance

- The Power Query Engineer updates transformation details as queries change.
- The Data Architect owns table-level structure, grain, and relationships.
- QA checks the dictionary matches the actual model (no ghost columns, no undocumented tables).
- The Documentation Writer publishes the final, human-readable version into the project README.
