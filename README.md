# Paranoid AI Workflow

Paranoid AI Workflow is a 12-step, artifact-driven process for using AI coding agents in high-consequence environments.

It is designed for teams that care more about output quality, traceability, and controlled execution than raw speed. The workflow is especially useful in regulated or operationally sensitive domains where a weak assumption, vague plan, or low-quality implementation can create real downstream risk.

The core idea is simple: do not run an entire project inside one long AI session.

This workflow assumes that overloaded context windows reduce output quality over time. Instead of asking one session to remember everything, each stage produces a small artifact that becomes the clean input for the next stage. That keeps context focused, makes failure visible earlier, and gives humans better review points.

## What This Workflow Optimizes For

- High-quality output over fast but sloppy output
- Fresh AI sessions instead of one bloated session
- Clear handoffs between thinking, research, design, planning, implementation, and verification
- Fail-fast checkpoints before expensive coding work starts
- Reviewable artifacts that other people can inspect

## The Operating Model

Each step in the process has one main job.

That step creates an artifact.

That artifact becomes the input to the next step.

If a step is weak, unclear, or fails review, you stop there and fix it before moving forward.

This is why the workflow is "paranoid": it assumes drift, ambiguity, and AI overconfidence will happen unless you actively constrain them.

## The 12 Steps

1. Mirror the source issue or request.
   Capture the original request locally so the workflow starts from a stable source.
2. Create the canonical brief or ticket.
   Define scope, acceptance criteria, constraints, and open questions.
3. Create neutral research questions.
   Frame what needs to be learned without biasing the implementation too early.
4. Research the current codebase.
   Gather evidence about how the system actually works today.
5. Create and review the design artifact.
   Define the intended future-state approach before implementation begins.
6. Create and review the structure artifact.
   Break the design into slices, boundaries, and execution order.
7. Create and approve the tactical plan.
   Turn the approved design and structure into an execution-ready plan.
8. Implement the approved plan.
   Build only from the approved plan in `.documents/.plans/current_plan/`.
9. Run manual verification.
   Check the real behavior in a separate, read-only verification pass.
10. Validate the plan against the evidence.
   Confirm the implementation matches the plan and the recorded verification.
11. Commit the work.
   Package the change only after validation passes.
12. Write the PR description.
   Summarize what changed, why it changed, and how it was verified.

## Why Fresh Sessions Matter

This workflow is built around a strong bias toward fresh sessions.

The assumption is that as an AI session gets longer, the model becomes more likely to:

- carry stale assumptions forward
- blur research, design, and implementation together
- miss constraints that were mentioned earlier
- produce confident but lower-quality output

So instead of one giant session, you intentionally use smaller sessions with narrower goals. A new session starts with the current artifact, not the entire project history.

In practice, that means:

- research should not be the same session as implementation
- planning should not depend on a huge conversational backlog
- manual verification should be a separate pass
- validation should check the plan and evidence, not just trust the implementation session

## Fail-Fast by Design

The workflow is meant to fail early, not late.

If the brief is weak, research will expose it.
If the research is weak, design should stop.
If the design is weak, structure should stop.
If the structure is weak, planning should stop.
If the plan is weak, implementation should not start.

That is the point.

It is cheaper to discover a bad assumption in a ticket, question set, or design artifact than after a risky code change has already landed.

## How This Repo Is Meant To Be Used

This repository is the workflow sidecar. It usually lives next to a sibling product repository:

```text
parent/
├── Paranoid-AI-Workflow/
└── your-product-repo/
```

Use this repo for:

- planning docs
- staged workflow artifacts
- research notes
- prompts and command docs
- PR drafts
- maintainer-only operating material

Use the sibling product repo for:

- application code
- builds
- tests
- runtime verification

The sibling product repo path is configured in `workflow/tooling.config.json`.

## Standard Flow

1. Start in this repo.
2. Mirror the source request into `.documents/issues/current/`.
3. Move through the workflow in order.
4. Use a fresh AI session for each major stage, especially planning, implementation, manual verification, and validation.
5. Only implement from `.documents/.plans/current_plan/`.
6. Do not implement from `.documents/.plans/pending/`.
7. Run code, build, and verification commands in the sibling product repo.

## Approval Gates

This workflow intentionally includes human review gates before tactical execution.

At minimum, review and approve:

- the design artifact
- the structure artifact
- the tactical plan

Those approvals reduce the chance that implementation starts from a bad direction that could have been caught earlier.

## Repository Layout

- `.documents/` stores staged artifacts and durable workflow notes
- `workflow/` stores command docs, agent docs, config, and lint scripts
- `docs/` stores workflow-side project context
- `scripts/` stores local helper scripts

Important plan paths:

- `.documents/.plans/pending/` is planning output that is not ready for execution
- `.documents/.plans/current_plan/` is the default execution entrypoint
- `.documents/.plans/completed_plan/` stores finished plans

## Setup

1. Clone this repo.
2. Clone your product repo as a sibling directory.
3. Update `workflow/tooling.config.json` if your product repo is not at `../your-product-repo`.
4. Run `./scripts/workspace-doctor`.
5. Review `workflow/README.md` and `docs/repo-workflow.md`.

## Anti-Patterns

Avoid these:

- using one giant AI session for the entire task
- skipping questions, research, design, or structure because the change "seems obvious"
- implementing from `.documents/.plans/pending/`
- mixing implementation and verification into the same unchecked pass
- treating AI output as trustworthy just because it sounds confident

## Who This Is For

This workflow is a good fit when:

- software changes need traceability
- the domain is regulated or quality-sensitive
- you want cleaner AI handoffs
- you want a repeatable process that other reviewers can inspect

It is probably overkill for small throwaway prototypes, one-off experiments, or work where speed matters more than rigor.

## Start Here

If you are reviewing this repository for the first time:

1. Read this `README.md`.
2. Read `workflow/README.md` for the command-level workflow.
3. Read `docs/repo-workflow.md` for the artifact map and stage sequence.
4. Inspect `.documents/` to see how the workflow is staged in practice.

This repo is not just a prompt collection. It is a system for keeping AI work scoped, reviewable, and high quality from request intake through PR creation.
