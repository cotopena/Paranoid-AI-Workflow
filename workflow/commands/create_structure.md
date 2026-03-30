---
description: Create a short structure outline from an approved design before tactical planning
model: codex-high
---

# Create Structure

Create a short, human-reviewable structure artifact for Project product work. This command turns an approved design into vertical slices, checkpoints, validation flow, and implementation boundaries without collapsing into a low-level task list.

## Before You Run
- Read `workflow/README.md` for shared repo paths, artifact locations, and tool conventions.
- Consult `workflow/tooling.config.json` for `.documents/structures/`, `.documents/designs/`, `.documents/.tickets/`, `.documents/questions/`, and `.documents/research/`.
- Use this command after `create_design.md` when the work needs an approved execution shape before tactical planning begins.
- Example Codex CLI prompt: `Use workflow/commands/create_structure.md with the latest approved design artifact to create a short vertical-slice structure outline for Project.`

## Required Inputs

Use these inputs in order:

1. An explicitly provided structure artifact path when continuing an existing draft.
2. An explicitly provided design artifact path.
3. `.documents/designs/.latest` when no design path was supplied.
4. The linked brief, questions artifact, and research artifact from the design.
5. The linked mirrored issue from the design, when present.
6. Relevant constraints docs from `../your-product-repo/docs/`, `docs/progress.md`, or `.documents/business-model.md` only when they materially affect slice boundaries or validation flow.

Hard gate:

- Structure requires an approved design artifact.
- The design must already link the staged brief, questions, and research inputs.
- If the design is missing or not approved, stop and respond with:

```text
Structure needs an approved design before the work can be broken into execution slices:
- design: <present|missing>
- design approval: <approved|pending|rejected>

Finish `workflow/commands/create_design.md` first, then return to `workflow/commands/create_structure.md`.
```

Do not create structure from the raw feature request alone.

## Structure Guardrails

- Structure is about how the approved design should be broken down, not what every file should do.
- Keep the artifact short enough for real human review. Prefer 2-5 vertical slices.
- Prefer end-to-end slices that produce usable evidence early.
- The linked brief remains the canonical source of scope boundaries and acceptance criteria unless an approved structure decision materially refines them.
- Each slice must define:
  - outcome
  - validation
  - rollback notes or clear boundaries
- Record checkpoints between slices so later planning can stay incremental.
- Keep the artifact above the tactical level. Do not include:
  - file-by-file edit lists
  - exhaustive implementation commands
  - pseudo-plans disguised as slices
  - design-option debates that should have been settled in the design stage
- If structure uncovers a new factual gap, redirect back to research.
- If structure uncovers a new design choice, redirect back to design instead of smuggling it into the slice order.

## Process

1. Read the current structure artifact first when continuing a draft. Otherwise read the approved design, then its linked brief, questions artifact, research artifact, linked issue, and only the most relevant constraints docs.
2. Restate the ordering principles implied by the approved design and research evidence.
3. Break the work into 2-5 vertical slices that each create a bounded, testable outcome.
4. For each slice, record:
   - the outcome
   - what the slice includes
   - the validation checkpoint
   - rollback notes or clear implementation boundaries
5. Add cross-slice checkpoints and validation flow so the later plan can stay incremental.
6. Separate remaining unknowns explicitly:
   - human review unknowns
   - deferred tactical details for planning
7. Save the draft with `approval_status: pending`, ask at most 3 targeted structure-review questions, and stop for human input when slice order or boundaries need review.
8. When the human answers:
   - update the same structure artifact instead of creating a competing file
   - move the answers into `Human Review`
   - convert them into explicit resulting decisions
   - if those resulting decisions materially change scope, out-of-scope boundaries, or acceptance criteria, update the linked brief before marking the structure approved
   - set `approval_status` to `approved` only when the slice order, checkpoints, and boundaries are settled
9. Only after `approval_status: approved` should the next step be `workflow/commands/create_plan.md`.

## Output Rules

- Save the structure artifact under `.documents/structures/`.
- Update `.documents/structures/.latest` with the repository-relative path.
- Prefer filenames tied to the brief when possible:
  - `STRUCTURE-TICKET-####-slug-YYYY-MM-DD.md`
- If no ticket ID exists, use:
  - `STRUCTURE-slug-YYYY-MM-DD.md`

## Structure Artifact Template

```markdown
---
date: [ISO timestamp with timezone]
author: [name or handle]
repository: paranoid-ai-workflow
status: draft|blocked|approved
approval_status: pending|approved|rejected
approved_by: [name-or-none]
approved_on: [YYYY-MM-DD-or-none]
linked_design: [path]
linked_brief: [path]
linked_questions: [path]
linked_research: [path]
linked_issue: [path-or-none]
topic: "[short topic]"
---

# Structure: [Topic]

## Intent
- 1-2 bullets on what this structure is organizing

## Ordering Principles
- Why the slices are ordered this way
- What horizontal rollout patterns are being avoided

## Vertical Slices

### Slice 1: [Name]
- Outcome:
- Includes:
- Validation:
- Rollback / Boundary Notes:

### Slice 2: [Name]
- Outcome:
- Includes:
- Validation:
- Rollback / Boundary Notes:

### Slice 3: [Name]
- Outcome:
- Includes:
- Validation:
- Rollback / Boundary Notes:

## Checkpoints & Validation Flow
- Checkpoint after Slice 1:
- Checkpoint after Slice 2:
- Final checkpoint before planning:

## Open Questions

### Human Review Unknowns
- Question for the human, or `- None.`

### Deferred Tactical Details
- Implementation detail that belongs in plan, or `- None.`

## Human Review
- Questions for the human:
  - `- None.` or up to 3 targeted questions
- Answers:
  - `- Pending.` or dated answer bullets
- Resulting decisions:
  - `- Pending until review.` or explicit post-review decisions

## Approval
- Status: `pending|approved|rejected`
- Next step: `wait for human input` or `workflow/commands/create_plan.md`
```

## Final Self-Check

Before finishing, verify:

* The artifact is short and human-reviewable.
* The structure is grounded in the approved design plus its linked brief, questions, and research evidence.
* The work is broken into vertical slices rather than horizontal layers.
* Every slice includes outcome, validation, and rollback notes or clear boundaries.
* Checkpoints and validation flow are explicit.
* Tactical implementation details are deferred to plan.
* The same artifact is updated when human answers arrive.
* Any approved material scope or acceptance-criteria change is reflected back into the linked brief instead of living only in the structure artifact.
* Planning is not started until the structure is approved.
* The saved path and `.documents/structures/.latest` update are correct.
