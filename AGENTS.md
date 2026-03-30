# Repository Guidance

## Purpose
This repository is the workflow sidecar for a sibling product repo.

Keep planning docs, workflow prompts, tickets, research notes, PR drafts, and maintainer-only operating material here.

When a task requires product code changes, inspect and edit files in the sibling product repo configured by `workflow/tooling.config.json` unless the user explicitly asks to work only in this repo.

## Default Working Model

- Workflow/docs work: start Codex in this repo
- Product code work: start Codex in the sibling product repo
- If paths drift, run `./scripts/workspace-doctor`

## Structure

- `.documents/` contains staged artifacts and durable notes
- `workflow/` contains command docs, agent docs, lint scripts, and config
- `docs/` contains workflow-side context docs for the project
- `scripts/` contains local helper scripts

## Guardrails

- Treat `.documents/.plans/current_plan/` as the default execution entrypoint.
- Do not implement from `.documents/.plans/pending/`.
- Keep normal handoffs in session unless you intentionally want a durable note under `.documents/thoughts/`.
