# Contributing

This system is designed to grow **without breaking existing agents**. The rules below keep it
modular, low-context, and maintainable.

## The modularity contract

- Each agent owns a **narrow slice** and a **small set of files** (see the ownership map in
  [docs/agent-interaction.md](docs/agent-interaction.md)).
- Agents never edit files they don't own — they **request** changes via the Orchestrator.
- Durable knowledge lives in `shared/`; agents read it, they don't restate it.
- The runnable sub-agent (`.claude/agents/`) stays short; depth lives in the charter (`agents/`).

Follow these and you can add a specialist by dropping in two files — nothing else changes.

## Add a new specialist agent

1. **Write the charter** `agents/<role>.md` using the standard sections:
   Purpose · Responsibilities · Scope · Non-responsibilities · Inputs · Outputs · Decision rules ·
   Coding standards · Communication protocol · Completion checklist · Escalation rules · Examples.
2. **Write the runnable sub-agent** `.claude/agents/<role>.md`:
   - Frontmatter: `name`, an action-oriented `description` (say *when to use it*), a minimal
     `tools` list, and a `model`.
   - Body: a short brief — "Before you start" (files to read), Core rules, Boundaries, Handoff.
3. **Declare ownership** — add the agent's files to the ownership map in
   [docs/agent-interaction.md](docs/agent-interaction.md).
4. **Slot it into the pipeline** (if it's a stage) in
   [docs/project-lifecycle.md](docs/project-lifecycle.md), or note it as an on-demand helper.
5. **Add any standards it enforces** to a `shared/` file (or a new one) rather than to the agent body.
6. **Update the Orchestrator** only if it needs to route a new stage — otherwise leave it alone.

### Tool assignment guidance
- Give the fewest tools the role needs. File tools (`Read, Write, Edit, Glob, Grep`) for most.
- Add `powerbi-modeling` MCP tools only to agents that act on a live tabular model
  (Data Architect, DAX, Power Query, Performance, QA). Reviewers and the Analyst stay file-only.
- Only the Orchestrator gets `Task` (to delegate) and `TodoWrite`.

### Model guidance
- `opus` for judgment-heavy roles (Orchestrator, Analyst, Architect, DAX, reviewers, Critic).
- `sonnet` for execution-heavy roles (SQL, Power Query, Visualization, Performance, QA, Docs).
- Adjust to taste; these are defaults, not rules.

## Change a shared standard

- Edit the relevant `shared/` file; it propagates to every agent automatically (they read it).
- If the change alters an agent's behavior materially, note it in that agent's charter examples.
- Breaking changes to naming/rules can invalidate existing projects — call it out in the PR.

## Editing agents

- Keep `.claude/agents/*.md` **short**. If you're adding paragraphs, they probably belong in the
  charter (`agents/*.md`) or a `shared/` file.
- Preserve each agent's **Non-responsibilities** — the boundaries are what keep the system clean.
- Don't give an agent a second job. Two jobs = two agents.

## Style

- Markdown, wrapped ~100 cols, tables where they help.
- Reference files by repo-relative path.
- Prefer examples over prose; show a good and a bad case.

## Definition of done for a contribution
- [ ] Charter + runnable sub-agent both present and consistent.
- [ ] Ownership map and (if applicable) lifecycle updated.
- [ ] Standards live in `shared/`, not hard-coded in the agent.
- [ ] No existing agent needed editing (or the change is justified in the PR).
- [ ] The runnable sub-agent is still short.
