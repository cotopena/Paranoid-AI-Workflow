---
description: Create a tactical implementation plan from the approved staged artifacts
model: codex-high
---

# Create Plan

Create a tactical implementation plan for Project product work. This command turns the approved brief or ticket, research evidence, approved design, and approved structure into executable slice-by-slice instructions without reopening design or structure inline.

## Before You Run
- Read `workflow/README.md` for the shared workflow, artifact paths, and repo split.
- Consult `workflow/tooling.config.json` for `.documents/.plans/`, `.documents/.tickets/`, `.documents/designs/`, `.documents/structures/`, `.documents/questions/`, `.documents/research/`, `.documents/issues/`, and the sibling code roots under `../your-product-repo/`.
- Use this command after `workflow/commands/create_structure.md` when the work needs a tactical execution plan grounded in approved staged artifacts.
- Example Codex CLI prompt: `Use workflow/commands/create_plan.md with the latest approved brief, research, design, and structure artifacts to write a tactical implementation plan for Project.`

## Required Inputs

Use these inputs in order:

1. An explicitly provided plan path when continuing an existing draft.
2. An explicitly provided brief or ticket path.
3. An explicitly provided structure artifact path.
4. An explicitly provided design artifact path.
5. `.documents/.tickets/.latest` when no brief or ticket path was supplied.
6. `.documents/structures/.latest` when no structure path was supplied.
7. `.documents/designs/.latest` when no design path was supplied.
8. The linked questions artifact, research artifact, and mirrored issue from the brief, design, or structure.
9. Relevant constraints docs from `../your-product-repo/docs/`, `docs/progress.md`, or `.documents/business-model.md` only when they materially affect tactical steps or verification.

Hard gate:

- Planning requires a brief or ticket, a research artifact, an approved design artifact, and an approved structure artifact.
- If any staged input is missing or not approved, stop and respond with:

```text
Planning needs the approved staged inputs below before tactical steps can be written:
- brief_or_ticket: <present|missing>
- research: <present|missing>
- design: <present|missing>
- design approval: <approved|pending|rejected|missing>
- structure: <present|missing>
- structure approval: <approved|pending|rejected|missing>

Finish the missing stage(s) first, then return to workflow/commands/create_plan.md.
```

Do not create a tactical plan from the raw feature request alone.

## Planning Guardrails

- Planning is about tactical execution details only. It does not reopen design decisions or invent a new slice order.
- The linked brief or ticket remains the canonical source of scope boundaries and acceptance criteria during planning.
- Approved design and approved structure refine the intended end state and execution shape, but they must not silently replace the brief or ticket.
- If approved design or structure materially changed scope, out-of-scope boundaries, or acceptance criteria and the brief or ticket has not been updated to match, stop and reconcile the brief or ticket first.
- Use the approved structure as the backbone for slice order, checkpoints, and validation flow.
- Use research as current-state evidence and read the cited code yourself before writing file-level steps.
- Every implementation step in the final plan must name one exact existing file path or one exact new file path.
- Do not leave tactical forks in the final plan. Phrases such as `A or B`, `and/or`, `adjacent helper if needed`, `new component under ... if helpful`, or directory-only targets mean planning is not finished.
- Do not include:
  - design-option pros and cons framing
  - new structure proposals
  - unresolved design debates
  - scope additions that do not exist in the canonical brief or ticket

## Process

1. Read the current plan first when continuing a draft. Otherwise read the brief or ticket, approved design, approved structure, research artifact, linked questions artifact, linked issue, and only the most relevant constraints docs.
2. Extract the planning controls:
   - `risk_level`
   - `plan_blockers`
   - canonical scope boundaries and acceptance criteria from the brief or ticket
   - approved design decisions that must be preserved
   - approved structure slices, checkpoints, and validation flow
3. If `plan_blockers` is non-empty, stop with:

```text
Planning blocked by brief/ticket plan_blockers:
- <blocker 1>
- <blocker 2>

Resolve blockers in the brief or ticket before running create_plan.md.
```

4. Compare the approved design and approved structure against the canonical brief or ticket:
   - If they materially changed scope, out-of-scope boundaries, or acceptance criteria and the brief or ticket does not reflect that approved change, stop with:

```text
Tactical planning stopped because approved scope drift is not reflected in the canonical brief/ticket:
- <mismatch 1>
- <mismatch 2>

Update <brief-or-ticket-path> so scope boundaries and acceptance criteria match the approved design/structure, then return to workflow/commands/create_plan.md.
```

5. If Step 4 fails because the canonical brief or ticket must be reconciled, emit an in-session restart prompt for `workflow/commands/create_ticket.md` or the exact upstream command needed. Do not create a separate handoff file.
6. Read the cited code and docs yourself. Run only targeted follow-up tracing when a tactical step would otherwise be speculative. Do not redo broad research, design, or structure discovery.
7. Classify any remaining planning gap before writing the plan:
   - factual current-state gap -> stop and hand off to `workflow/commands/research_codebase.md`
   - future-state, tradeoff, or human-preference gap -> stop and hand off to `workflow/commands/create_design.md`
   - slice-order, checkpoint, or boundary gap -> stop and hand off to `workflow/commands/create_structure.md`
   - canonical scope or acceptance mismatch -> stop and hand off to `workflow/commands/create_ticket.md`
   - narrowly tactical gap that does not change scope, design, or structure -> ask the human up to 3 targeted questions
8. When a handoff is required, emit the restart prompt in-session only. The handoff must include:
   - the command to run next
   - the exact artifact paths to use
   - the specific blocking gaps
   - what must be preserved
   - the instruction to return to `workflow/commands/create_plan.md` in a fresh session after the upstream artifact is updated and approved
9. Map each approved structure slice into one plan phase or slice. Preserve the approved ordering and checkpoints unless the upstream staged artifacts are deliberately revised first.
10. Fill in the tactical details for each slice:
   - concrete files or modules
   - bounded implementation steps
   - automated verification
   - manual verification
   - checkpoint before the next slice
   - rollback notes or clear boundaries
11. Each implementation step must choose one path only:
   - exact existing file path, or
   - exact new file path
   If you cannot name one exact file path, planning is not done. Resolve the gap first through more code reading, a narrowly tactical human question, or an upstream handoff.
12. Each slice checkpoint must state:
   - `Continue when:` the evidence needed to proceed
   - `Stop and return to <command> if:` the condition that invalidates continued planning or implementation
13. Write the plan so it can be executed without guessing. No unresolved open questions, tactical forks, or stage-boundary ambiguities may remain in the final plan.

## Output Rules

- Save the plan under `.documents/.plans/pending/`.
- Prefer filenames tied to the brief or ticket:
  - `PLAN-####-short-slug-YYYY-MM-DD.md`
- Keep the final plan tactical. It should be detailed enough for implementation, but it should not re-argue the approved design or structure.
- If planning must stop and hand work back upstream, provide the restart prompt in the session response only. Do not create another `.md` handoff artifact.
- After the plan is spot-checked and approved, move it to `.documents/.plans/current_plan/` and update the linked brief or ticket with the approved plan path.

## Upstream Restart Prompt Templates

When planning must stop, use one of these in-session prompt shapes and fill in the exact paths and blocking gaps.

### Brief / Ticket Reconciliation

```text
Use workflow/commands/create_ticket.md with:
- brief_or_ticket: <path>
- research: <path-or-none>
- design: <path>
- structure: <path>

Goal:
Reconcile the canonical brief/ticket so it matches the approved upstream decisions now blocking tactical planning:
- <gap 1>
- <gap 2>

Constraints:
- Preserve the approved scope unless the approved design/structure explicitly changed it
- Update the existing brief/ticket artifact instead of creating a competing one
- Keep the brief/ticket canonical for later planning

At the end, provide:
- updated brief/ticket path
- exact scope or acceptance changes made
- confirmation that workflow/commands/create_plan.md can restart in a fresh session
```

### Research Restart

```text
Use workflow/commands/research_codebase.md with:
- questions: <path>
- brief_or_ticket: <path>
- current_research: <path-or-none>

Goal:
Resolve the factual current-state gaps blocking tactical planning:
- <gap 1>
- <gap 2>

Constraints:
- Keep research factual and read-only
- Update the existing research artifact if one already exists
- Do not propose implementation options or slice order

At the end, provide:
- updated research path
- the factual answers found
- confirmation that workflow/commands/create_plan.md can restart in a fresh session
```

### Design Restart

```text
Use workflow/commands/create_design.md with:
- brief_or_ticket: <path>
- questions: <path>
- research: <path>
- current_design: <path>

Goal:
Resolve the future-state or tradeoff ambiguity blocking tactical planning:
- <gap 1>
- <gap 2>

Constraints:
- Preserve the existing brief/ticket unless an approved design decision requires a canonical update
- Update the same design artifact instead of creating a competing one
- Ask only the smallest set of targeted human questions needed

At the end, provide:
- updated design path
- resulting decisions
- any brief/ticket changes required
- confirmation that workflow/commands/create_plan.md can restart in a fresh session
```

### Structure Restart

```text
Use workflow/commands/create_structure.md with:
- design: <path>
- brief_or_ticket: <path>
- research: <path>
- current_structure: <path>

Goal:
Resolve the slice-order, checkpoint, or boundary ambiguity blocking tactical planning:
- <gap 1>
- <gap 2>

Constraints:
- Preserve the approved design unless new evidence forces a return to design
- Update the same structure artifact instead of creating a competing one
- Keep the result above the tactical level

At the end, provide:
- updated structure path
- resulting slice/checkpoint decisions
- any brief/ticket or design changes required
- confirmation that workflow/commands/create_plan.md can restart in a fresh session
```

## Tactical Plan Template

````markdown
# [Feature/Task Name] Implementation Plan

## Overview
[brief purpose + the approved slice-first execution summary]

## Inputs
- Issue: `.documents/issues/...` or `none`
- Brief/Ticket: `.documents/.tickets/...`
- Questions: `.documents/questions/...`
- Research: `.documents/research/...`
- Approved Design: `.documents/designs/...`
- Approved Structure: `.documents/structures/...`

## Scope Controls
- Canonical scope source: `.documents/.tickets/...`
- In scope:
  - ...
- Out of scope:
  - ...
- Acceptance criteria carried forward:
  - ...
- Approved design decisions to preserve:
  - ...
- Approved structure checkpoints to preserve:
  - ...

## Current State Anchors
- `../your-product-repo/...:line` - current behavior the plan depends on
- `../your-product-repo/...:line` - current behavior the plan depends on

## Implementation Approach
- Tactical execution strategy derived from the approved design and structure
- Why this slice order stays aligned to the approved structure

## Slice 1 - [Name]
### Goal
[why this slice exists]
### Boundaries / Rollback
- ...
### Implementation Steps
1. `exact/existing/file/path` - change
2. `exact/new/file/path` - add
### Acceptance Criteria
#### Automated
- [ ] command
- [ ] command
#### Manual
- [ ] exact scenario to verify
### Checkpoint
- Continue when:
  - evidence required before Slice 2 starts
- Stop and return to `workflow/commands/<command>.md` if:
  - condition that invalidates continued tactical planning or implementation
### Assets / Docs
- related docs, fixtures, or notes

## Slice 2 - [Name]
...

## Testing Strategy
- Unit or module-level coverage
- Integration or route-level coverage
- Manual verification flow

## Risks / Migration Notes
- auth, billing, AI, performance, migration, or rollback concerns when in scope

## References
- issue path
- brief or ticket path
- questions path
- research path
- approved design path
- approved structure path
- key code references
````

## Final Self-Check

Before finishing, verify:

* The plan is grounded in the brief or ticket, research, approved design, and approved structure.
* The brief or ticket remains the canonical source of scope boundaries and acceptance criteria.
* Any approved scope or acceptance-criteria change was reflected back into the brief or ticket instead of living only in downstream artifacts.
* The plan no longer performs design-option framing inline.
* The plan no longer creates or revises structure inline.
* Every implementation step names one exact existing file path or one exact new file path.
* No implementation step contains tactical fork wording such as `or`, `and/or`, or `if needed`.
* The slices and checkpoints stay aligned to the approved structure.
* Each checkpoint states both `Continue when:` and `Stop and return to <command> if:`.
* If planning had to stop, the session emitted an in-session restart prompt instead of creating another handoff file.
* The implementation steps are tactical, concrete, and rollback-aware.
* The saved plan path is correct and ready for spot-check review before moving to `.documents/.plans/current_plan/`.
