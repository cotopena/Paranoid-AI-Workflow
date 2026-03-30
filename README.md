# Paranoid-AI-Workflow

Reusable workflow repo for planning, researching, implementing, verifying, and shipping product changes with Codex or similar agentic coding tools.

This repo is meant to live next to a product repo. The default layout is:

```text
parent/
├── Paranoid-AI-Workflow/
└── your-product-repo/
```

The workflow repo stores staged artifacts in `.documents/` and durable command docs in `workflow/`. The sibling product repo stores the actual application code.

## What You Get

- A staged workflow: `issue -> brief -> questions -> research -> design -> structure -> plan -> implement -> manual verification -> validate -> commit -> PR`
- A reusable `.documents/` scaffold with latest pointers, ticket counters, and archive folders
- Command docs under `workflow/commands/` that explain how each stage should run
- Basic maintenance scripts such as `scripts/workspace-doctor` and `scripts/public-plan-branch`

## Setup

1. Clone this repo wherever you keep your workflow or planning material.
2. Clone your product repo as a sibling directory.
3. Edit [`workflow/tooling.config.json`](workflow/tooling.config.json) and set `publicRepoRoot` if your product repo is not `../your-product-repo`.
4. Update [`docs/project-context.md`](docs/project-context.md), [`docs/implementation-notes.md`](docs/implementation-notes.md), and [`docs/progress.md`](docs/progress.md) for your project.
5. Run `./scripts/workspace-doctor`.

## Repo Layout

- `.documents/` holds issue mirrors, tickets, questions, research, designs, structures, plans, PR drafts, changelog entries, and durable notes.
- `workflow/` holds the command docs, agent docs, config, and lint scripts that define the operating model.
- `docs/` holds workflow-side context docs that should not be buried in the product repo.
- `scripts/` holds helper scripts for workspace checks and branch setup.

## Notes

- The default examples assume a TypeScript/Next.js-style app repo, but the workflow itself is not tied to one stack.
- `scripts/workspace-doctor` treats `../your-product-repo` as a template placeholder until you update it.
- The current script name `public-plan-branch` is kept for compatibility with the command docs. It targets the sibling product repo.
