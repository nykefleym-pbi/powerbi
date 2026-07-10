# Visual & UX Guidelines

> **Owner:** Visualization & UX Designer · **Readers:** Visualization, Dashboard Critic, QA
> Tokens (color/type/spacing) live in `design_system.md`. This file is about *choosing and
> building the right visuals*.

## Chart selection heuristic

| Question the user is asking | Default visual |
|---|---|
| How much in total? (single number) | KPI card |
| How does it compare across categories? | Horizontal bar (sorted) |
| How has it changed over time? | Line (or area for one series) |
| Part-to-whole (few parts, one point in time) | Stacked bar / 100% bar (avoid pie > 4 slices) |
| Relationship between two measures | Scatter |
| Distribution | Histogram / box |
| Geographic pattern | Filled map (only if geography matters) |
| Detailed records | Table / matrix (on a detail or drillthrough page) |

Rules of thumb:
- **Sort bars by value**, not alphabetically, unless the category has a natural order.
- **Lines for time, bars for categories.** Don't rotate axis labels — use horizontal bars instead.
- **No dual-axis** unless the two series genuinely share an x and the reader is sophisticated.
- **Pie/donut** only for ≤ 4 parts that sum to a meaningful whole; otherwise a bar.
- Avoid 3D, gauges (except a deliberate single-KPI gauge), and gratuitous custom visuals.

## Page architecture

- **One primary question per page.** If a page answers three questions, it's three pages
  (or a drillthrough).
- Standard portfolio set: **Executive Summary** (KPIs + trend + top drivers) → **Detail
  pages** (by dimension) → **Drillthrough** (record-level context).
- Every page needs a title, a clear reading order, and a "so what" — the insight, not just data.

## Interactions

- **Bookmarks** for saved states, reset buttons, and show/hide panels — name them per
  `naming_conventions.md`.
- **Drillthrough** from summary to detail; always include a back button.
- **Tooltips**: use report-page tooltips for a mini-context view; keep default tooltips concise.
- **Edit Interactions** deliberately — not every visual should cross-filter every other.
- Slicers: minimal, grouped, with a visible "clear" affordance. Prefer a single filter panel.

## Accessibility (WCAG AA baseline)

- Contrast ≥ 4.5:1 text, ≥ 3:1 large text / non-text UI (verified against `design_system.md`).
- **Never encode meaning by color alone** — add labels, icons, or position.
- Set **tab order** and **alt text** on every meaningful visual.
- Readable font sizes (≥ 9pt), avoid tight tables, ensure keyboard navigability.
- Provide a colorblind-safe palette; test with a simulator.

## Mobile

- Build a **mobile layout** for the executive summary at minimum: KPI cards stacked,
  one key trend, largest touch targets, fewest slicers.

## Storytelling

- Lead with the answer. Titles state the insight: "Revenue up 12% YoY, driven by West region."
- Use reference lines, targets, and variance-to-target coloring to make "good/bad" instant.
- Annotate anomalies. Guide the eye with layout, not with decoration.

## Wireframe-first rule

The Visualization agent **produces a wireframe (see `templates/wireframe.md`) and gets it
approved by the Orchestrator (and challenged by the Critic) before building any report
visuals.** No pixels before the wireframe is signed off.

## Anti-patterns (Critic & QA flag)

- A visual with no clear question it answers.
- More than ~8 visuals competing on one page.
- Color used decoratively / inconsistently with semantic roles.
- Pie charts with many slices; dual axes; truncated bar-chart axes that mislead.
- Tables of raw data on a summary page instead of a drillthrough.
