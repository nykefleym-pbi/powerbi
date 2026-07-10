# Design System

> **Owner:** Visualization & UX Designer · **Readers:** Visualization, QA, Documentation
> The system-wide default look. A project may override tokens in its own copy, logged in
> `decision_log.md`. `visual_guidelines.md` covers *how to choose and build* visuals; this
> file defines *the tokens* (color, type, spacing).
> **Deep reference:** `knowledge/figma.md` (design tokens/components → theme.json workflow) and
> `knowledge/accessibility.md` (contrast targets). Custom visuals must honor these tokens too.

## Design tokens

### Color palette (accessible, brand-neutral placeholders)

Swap the hex values for a project/brand palette, but keep the **roles** and contrast ratios.

| Role | Token | Hex | Use |
|---|---|---|---|
| Canvas | `--bg` | `#F7F8FA` | Page background |
| Surface | `--surface` | `#FFFFFF` | Cards, visual backgrounds |
| Ink | `--text` | `#1A1D23` | Primary text (≥ 7:1 on surface) |
| Muted | `--text-muted` | `#5B6472` | Secondary text (≥ 4.5:1) |
| Primary | `--primary` | `#2F6BFF` | Key series, active state, focus |
| Positive | `--positive` | `#1F9E6E` | Good variance, growth |
| Negative | `--negative` | `#E5484D` | Bad variance, decline |
| Warning | `--warning` | `#E0A400` | Attention thresholds |
| Neutral series | `--n1..--n5` | `#8E9AAF #B7C0CF #6C7A92 #A0AEC0 #495468` | Categorical series |
| Grid/border | `--border` | `#E3E6EB` | Gridlines, dividers |

**Rules:** never encode meaning by color alone (add label/icon/position); positive/negative
are the only semantically colored series; keep categorical series ≤ 6 before switching to a
"Top N + Other" grouping. Verify every text/background pair meets WCAG AA (4.5:1; 3:1 for
large text and non-text UI).

### Typography

- Family: **Segoe UI** (Power BI native) — no external font dependency.
- Scale: Page title 20–24, Section header 14–16 semibold, Card KPI value 28–40,
  Body/axis 10–12, Footnote 9. Never below 9pt.
- Weight for hierarchy, not size alone. Left-align text; right-align numbers.

### Spacing & grid

- **12-column grid**, 8px base unit. Gutters 12–16px. Outer page margin 16–24px.
- Card padding 12–16px. Consistent vertical rhythm between rows.
- Align to the grid — no free-floating visuals; edges snap.

### Elevation

- Flat by default. Subtle 1px `--border` on cards; avoid heavy drop shadows.
- One accent (`--primary`) per view for the primary call-to-attention; everything else neutral.

## Layout patterns

- **Z-pattern for landing pages:** brand/title top-left, filters top-right, KPI row across the
  top, primary chart center, supporting detail below.
- **KPI card row:** 3–5 cards max, each = value + label + trend/variance vs. comparison.
- **Consistent placement across pages:** filters and page nav in the same spot every page.

## Light & dark

- Design light-first; provide a dark theme by swapping tokens (canvas `#12151A`, surface
  `#1B1F27`, ink `#F1F3F6`) while preserving semantic colors. Re-check contrast in both.

## Deliverable: theme JSON

The Visualization agent produces a Power BI **theme JSON** encoding this palette, type sizes,
and visual defaults, so the look is applied once and consistently. Store it in the project
folder as `theme.json`.
