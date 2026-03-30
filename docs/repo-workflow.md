# Repo Workflow

This workflow repo stores the process artifacts. Product code and app commands referenced below target the sibling product repo configured in [`workflow/tooling.config.json`](../workflow/tooling.config.json).

## End-to-End Sequence

The expected order is:

1. Mirror the source issue or request
2. Create the canonical brief or ticket
3. Create neutral research questions
4. Research the current codebase
5. Create and approve the design artifact
6. Create and approve the structure artifact
7. Create and approve the tactical plan
8. Implement the approved plan
9. Run manual verification
10. Validate the plan against implementation and evidence
11. Commit the work
12. Write the PR description

The source of truth for this order is [`workflow/README.md`](../workflow/README.md).

## Artifact Map

Each step creates or updates a specific artifact:

- Issue mirror: `.documents/issues/current/`
- Canonical brief or ticket: `.documents/.tickets/current/`
- Neutral questions artifact: `.documents/questions/`
- Research note: `.documents/research/`
- Design artifact: `.documents/designs/`
- Structure artifact: `.documents/structures/`
- Plan: `.documents/.plans/pending/`, then `.documents/.plans/current_plan/`, then `.documents/.plans/completed_plan/`
- PR description: `.documents/prs/`
- Changelog: `.documents/CHANGELOG.md`
- Normal handoff: an in-session copy-paste prompt from `workflow/commands/create_handoff.md`

Latest pointers are usually tracked in:

- `.documents/issues/.latest`
- `.documents/.tickets/.latest`
- `.documents/questions/.latest`
- `.documents/research/.latest`
- `.documents/designs/.latest`
- `.documents/structures/.latest`

Important artifact rules:

- `workflow/commands/create_ticket.md` stays named `create_ticket`, but the artifact is brief-first and exists before research.
- A plan in `.documents/.plans/pending/` is still planning input.
- The approved plan in `.documents/.plans/current_plan/` is the default execution and review entrypoint.
- Normal workflow handoffs are an in-session copy-paste prompt. Do not create a new `.documents/thoughts/HANDOFF-...` file for routine stage transitions.

## Stage Notes

- `workflow/commands/create_questions.md` exists to keep research blind to the intended implementation.
- `workflow/commands/create_design.md` is the future-state alignment gate.
- `workflow/commands/create_structure.md` is the slice-order and boundary gate.
- `workflow/commands/create_plan.md` writes the tactical execution contract.
- `workflow/commands/manual_verification.md` and `workflow/commands/validate_plan.md` both start from the approved plan path.

## Common Failure Modes

- Starting implementation from `.documents/.plans/pending/` instead of `.documents/.plans/current_plan/`
- Skipping `workflow/commands/create_questions.md`, `workflow/commands/create_design.md`, or `workflow/commands/create_structure.md`
- Treating research as design, or design as plan
- Creating a new `.documents/thoughts/HANDOFF-...` file for routine stage transitions

## Related Files

- [`workflow/README.md`](../workflow/README.md)
- [`workflow/tooling.config.json`](../workflow/tooling.config.json)
