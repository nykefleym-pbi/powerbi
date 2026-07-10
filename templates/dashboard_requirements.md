# Dashboard Requirements — <Project Name>

> Produced by: **Business Analyst** · Approved by: **Orchestrator**
> Fill every section. Unknowns go to `assumptions.md`, not blank fields.

## 1. Overview
- **Business context:** <the situation / opportunity>
- **Primary goal (one sentence):** <what this dashboard is for>
- **Audience & personas:** <role — what they decide with it — how often>
- **Decisions enabled:** <the concrete decisions this supports>

## 2. Business questions
List the questions the dashboard must answer, most important first.
1. <question> — *why it matters*
2. ...

## 3. KPIs / metrics
| KPI | Definition (link to business_rules) | Target/benchmark | Grain | Owner page |
|---|---|---|---|---|
| <Revenue> | net of returns & discounts | +10% YoY | per order line | Exec Summary |

## 4. Dimensions & filters
- Slicing dimensions: <date, region, product, customer segment...>
- Default filters / date range: <e.g., trailing 24 months>
- Required drill paths: <e.g., Region → Store → Product>

## 5. Pages & storytelling
| Page | Question it answers | Key visuals (intent) | Audience |
|---|---|---|---|
| Executive Summary | How is the business doing overall? | KPI row, trend, top drivers | Executives |
| ... | | | |

Narrative arc: <how a viewer moves from overview → insight → action>

## 6. User stories
- As a **<persona>**, I want **<capability>** so that **<outcome>**.

## 7. Acceptance criteria
Testable statements QA will verify.
- [ ] <e.g., Revenue YoY % matches business_rules definition and reconciles to source within 0.1%>
- [ ] <e.g., Executive Summary renders in < 2s on the dev dataset>
- [ ] <e.g., All KPIs have targets and variance indicators>

## 8. Scope
- **In scope:** <...>
- **Out of scope (explicitly):** <...>
- **Data sources:** <systems / files / APIs>
- **Refresh expectation:** <cadence>

## 9. Assumptions & open questions
Link to `assumptions.md` entries A-xxx. List anything awaiting confirmation.
