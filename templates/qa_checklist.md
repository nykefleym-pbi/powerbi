# QA Checklist — <Project Name>

> Produced by: **QA Validator** · Output: `qa_report.md` (pass/fail per item + evidence)
> Every item is Pass / Fail / N/A with a note. Fails become defects routed to the owning agent.

## Data & model correctness
- [ ] No broken measures / errors in the field list
- [ ] All relationships valid; correct cardinality & direction; no unintended bi-di
- [ ] Date table marked; time intelligence returns correct values at each grain
- [ ] Fact grain matches `data_model.md`; no fan-out / double counting
- [ ] Row counts & key totals reconcile to source within tolerance
- [ ] No orphan keys (facts referencing missing dimension rows)

## Measures & business rules
- [ ] Every KPI matches its `business_rules.md` definition
- [ ] `DIVIDE` used (no divide-by-zero); blank behavior correct
- [ ] Format strings set on all measures (currency/%/thousands)
- [ ] Base/variant pattern followed; no duplicated time-intel logic
- [ ] Measure dictionary matches the model (no undocumented measures)

## Naming & standards
- [ ] Tables, columns, measures follow `naming_conventions.md`
- [ ] Keys and internal helpers hidden; field list clean
- [ ] Display folders organized

## Report & UX
- [ ] Matches approved `wireframe.md`
- [ ] Slicers work; defaults correct; sync scope intended
- [ ] Drillthrough works both ways with back button
- [ ] Bookmarks behave; reset restores clean state
- [ ] Edit Interactions intentional (no accidental cross-filter chaos)
- [ ] Tooltips informative and consistent
- [ ] Titles state insight; no "Chart 1" placeholders

## Accessibility
- [ ] Contrast ≥ AA in light and dark; verified pairs
- [ ] No color-only encoding; labels/icons present
- [ ] Alt text + tab order on meaningful visuals
- [ ] Font sizes ≥ 9pt; mobile layout present for exec page

## Security (RLS)
- [ ] RLS roles defined per spec; tested with "View as"
- [ ] No data leakage across roles; measures respect RLS

## Performance regressions
- [ ] Page render within budget (`performance_guidelines.md`)
- [ ] No new slow visuals vs. last baseline (Performance Analyzer)
- [ ] Model size within budget

## Documentation
- [ ] Data & measure dictionaries current
- [ ] Assumptions & decisions logged
- [ ] README/deployment/maintenance present (for final gate)

## Result
- **Overall:** PASS / FAIL
- **Defects:** list with owner + severity
