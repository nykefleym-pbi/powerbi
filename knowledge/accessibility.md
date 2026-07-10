# Accessibility (WCAG 2.2 AA) in Power BI

> For the **Accessibility specialist**, QA, and Visualization. Companion to the a11y rules in
> [`shared/visual_guidelines.md`](../shared/visual_guidelines.md) and
> [`shared/design_system.md`](../shared/design_system.md). This is the depth + audit workflow.

## Target: WCAG 2.2 Level AA

Four principles — **Perceivable, Operable, Understandable, Robust (POUR)**. Practical AA bar for
a Power BI report:

| Area | Requirement |
|---|---|
| Text contrast | ≥ 4.5:1 normal, ≥ 3:1 large (≥18pt/14pt bold) |
| Non-text contrast | ≥ 3:1 for UI/graphical objects, focus indicators |
| Color independence | Never convey meaning by color alone — add label/icon/shape/position |
| Text size | ≥ 9pt (larger for KPIs); scalable |
| Keyboard | All interactions reachable and operable by keyboard |
| Focus | Visible focus order; logical **tab order** set per visual |
| Alt text | Meaningful **alt text** on every informative visual |
| Motion | No essential info via motion; respect reduced-motion |

## Power BI accessibility features to use

- **Tab order** per page (Selection pane → Tab order): set a logical reading order; hide
  decorative items from the tab order.
- **Alt text** on each visual (can be dynamic via a measure to describe the current state).
- **Show data** / **See data** (Alt+Shift+F11) and keyboard nav — verify they work.
- **High-contrast mode** inheritance from Windows; test it.
- **Themes** with colorblind-safe palettes; validate with a simulator (deuteranopia/protanopia).
- Report-level accessible **titles**, and a screen-reader-friendly reading order.

## Custom visuals (Deneb / HTML / SVG / Synoptic)

Custom visuals **bypass native accessibility**. For each:
- Provide alt text / a companion accessible table.
- Ensure palette contrast and non-color encoding.
- Document keyboard/reader limitations so QA can weigh them.
See [deneb.md](deneb.md), [html-visuals.md](html-visuals.md), [svg.md](svg.md),
[synoptic-panel.md](synoptic-panel.md).

## Audit workflow (what the specialist delivers)

1. Automated contrast check of every text/background and non-text pair vs. `design_system.md`.
2. Color-independence pass (simulate colorblindness; confirm labels/icons carry meaning).
3. Keyboard + tab-order + focus walkthrough of each page.
4. Alt-text presence/quality on informative visuals; decorative items hidden.
5. Custom-visual exceptions listed with remediation or accepted-risk note.
6. Output: an **accessibility audit** (pass/finding/severity/owner) that feeds QA — the
   specialist advises; **QA still owns the pass/fail gate**.

---
*Sources: WCAG 2.2, Microsoft Learn (Power BI accessibility — design, consumption, tab order,
alt text). Last reviewed: 2026-07-10.*
