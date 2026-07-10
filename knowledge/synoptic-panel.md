# Synoptic Panel

> For the **Synoptic Panel specialist**. The Synoptic Panel by OKViz maps data onto **custom
> areas drawn over an image** — floor plans, org charts, process flows, jerseys, anatomy,
> non-standard geographies. Use when the story is spatial but not a standard map
> (see [`shared/tech_selection.md`](../shared/tech_selection.md)).

## Concept

- An **image** (PNG/JPG/SVG) + a **map** of named areas (polygons) linked to a category field.
- Measures color/saturate each area (choropleth-style) and drive states, tooltips, and selection.
- Areas cross-filter the rest of the report like a native visual.

## Authoring the areas map

- Create areas with the **Synoptic Designer** (synoptic.design) by drawing over the image, or
  import an **SVG** whose shapes carry `id`/`title` matching your category values.
- **Area name must match the data category value exactly** (e.g., `id="North"` ↔ `Region = "North"`).
- Prefer clean vector SVG for crisp scaling; keep the area count reasonable for performance.
- Save the `.svg`/map file in the project `report/assets/` and version it.

## Data binding & states

- **Category** = the field that matches area names; **Measures** drive fill color and saturation.
- Define **states** (e.g., value thresholds → color) or a continuous gradient using the
  design-system semantic colors ([`shared/design_system.md`](../shared/design_system.md)).
- Legends and tooltips explain the encoding; never rely on color alone (accessibility).

## Good use cases

- Store/warehouse floor performance, plant/line status, stadium/venue seating, org/process maps,
  sales territories that aren't standard admin boundaries, human-body/parts diagrams.
- **Not** for standard country/state maps (use the native filled map) or for plain category
  comparison (use a sorted bar).

## Accessibility & limits

- Provide a data table alternative; areas + color are hard for screen readers → add labels and a
  companion visual. Coordinate with the Accessibility specialist.
- Third-party custom visual: check organizational visual allow-listing and certification status;
  note the dependency in `tech_decision.md`.

## Handoff

Deliver: the base image, the areas map (SVG/JSON), the category→area mapping, the state/gradient
rules, and the required measures. Log the technology choice and the third-party dependency.

---
*Sources: OKViz Synoptic Panel documentation, Synoptic Designer, Data Goblins (image maps).
Last reviewed: 2026-07-10.*
