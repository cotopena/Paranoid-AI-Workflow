---
description: Create a stage-aware in-session handoff for the next Codex session
model: codex-high
---

# Create Handoff

Produce a concise, high-signal handoff in the current chat session so the user can copy and paste it into the next Codex session. Default to the primary artifact only, so the next session can reload the minimum necessary context. Do not create a new handoff document under `.documents/` for normal workflow handoffs.

## Before You Run
- Read `workflow/README.md` to align on the shipped workflow and `.documents` structure.
- Consult `workflow/tooling.config.json` for staged artifact roots, latest pointers, and the sibling product repo path at `../your-product-repo`.
- Example Codex CLI prompt: `Use workflow/commands/create_handoff.md to hand off STRUCTURE-TICKET-1005 after human review so the next session can continue with create_plan.md.`

## When to Use
- You are handing work between sessions for any staged workflow command:
  - `workflow/commands/create_ticket.md`
  - `workflow/commands/create_questions.md`
  - `workflow/commands/research_codebase.md`
  - `workflow/commands/create_design.md`
  - `workflow/commands/create_structure.md`
  - `workflow/commands/create_plan.md`
  - `workflow/commands/implement_plan.md`
  - `workflow/commands/manual_verification.md`
  - `workflow/commands/validate_plan.md`
- You are ending a session before the next workflow stage starts.
- Another session needs to continue from the current issue, brief or ticket, questions, research, design, structure, plan, or PR state.
- Branch, checkpoint, verification, blocker, or env context exists outside the saved staged artifacts and needs to be preserved.
- Manual verification failed or validation found issues and the next session should return to `workflow/commands/implement_plan.md` with a narrow fix-only scope.

## Initial Response

When invoked, reply with:

```text
I'll prepare an in-session handoff. I'll inspect the active staged artifacts, determine the correct next workflow command, and return a copy-paste prompt for the next session.
```

If the user already provided a specific artifact path, use it as the primary anchor.

## Stage Determination Rules

- `questions`, `design`, and `structure` are first-class workflow stages. Do not collapse them into `research` or `plan`.
- Do not infer readiness from artifact existence alone. Check linked paths, approval status, plan location, and recorded verification state.
- Prefer the exact workflow stage the user named when it is consistent with the saved artifacts.
- If a later-stage artifact conflicts with an upstream approved artifact, set `next_command` to the upstream command needed to fix the mismatch instead of sending the next session deeper downstream.
- If implementation or review evidence points to a slice checkpoint that says return upstream, preserve that exact command in the handoff.

## Workflow Stage Mapping

Map the current state to the next command:

- Mirrored issue ready -> `workflow/commands/create_ticket.md`
- Brief or ticket ready, but neutral questions are missing or stale -> `workflow/commands/create_questions.md`
- Questions ready, but research is missing or stale -> `workflow/commands/research_codebase.md`
- Research complete, but design is missing -> `workflow/commands/create_design.md`
- Design draft or design review pending -> `workflow/commands/create_design.md`
- Design approved, but structure is missing -> `workflow/commands/create_structure.md`
- Structure draft or structure review pending -> `workflow/commands/create_structure.md`
- Structure approved, but plan is missing or still needs revision -> `workflow/commands/create_plan.md`
- Plan still in `.documents/.plans/pending/` -> `workflow/commands/create_plan.md`
- Approved current plan ready and slice work is incomplete -> `workflow/commands/implement_plan.md`
- Implementation paused mid-slice or at a slice checkpoint -> `workflow/commands/implement_plan.md`
- Automated implementation complete and manual evidence is still pending -> `workflow/commands/manual_verification.md`
- Manual verification complete and validation is still pending -> `workflow/commands/validate_plan.md`
- Manual verification failed or was blocked and code changes are required -> `workflow/commands/implement_plan.md`
- Validation passed -> `workflow/commands/commit.md`
- Commit complete -> `workflow/commands/describe_pr.md`

If implementation, manual verification, or validation evidence shows a stage-boundary mismatch, override the default mapping:

- canonical scope or acceptance mismatch -> `workflow/commands/create_ticket.md`
- factual current-state gap -> `workflow/commands/research_codebase.md`
- future-state or tradeoff mismatch -> `workflow/commands/create_design.md`
- slice-order, checkpoint, or boundary mismatch -> `workflow/commands/create_structure.md`
- tactical ambiguity inside the saved plan -> `workflow/commands/create_plan.md`

## Step 1 - Gather Active Context

1. Read the primary artifact the user named.
2. If none was named, inspect the latest or current artifacts in this order:
   - `.documents/.plans/current_plan/`
   - `.documents/.plans/completed_plan/`
   - `.documents/.plans/pending/`
   - `.documents/structures/.latest`
   - `.documents/designs/.latest`
   - `.documents/research/.latest`
   - `.documents/questions/.latest`
   - `.documents/.tickets/.latest`
   - `.documents/issues/.latest`
   - `.documents/prs/.latest`
3. Read the staged artifacts linked from the primary artifact only as needed to determine the correct next workflow command.
4. Determine the next workflow command from actual saved state:
   - whether questions exist
   - whether design approval is pending or approved
   - whether structure approval is pending or approved
   - whether the plan is in `pending`, `current_plan`, or `completed_plan`
   - whether implementation is mid-slice, automation-complete, or waiting on upstream correction
   - whether manual verification and validation are pending, passed, failed, or blocked
5. Inspect repo state:
   - Workflow repo: `git status --short`, `git rev-parse --abbrev-ref HEAD`, `git rev-parse --short HEAD`
   - Product repo when code is in scope: `git -C ../your-product-repo status --short`, `git -C ../your-product-repo rev-parse --abbrev-ref HEAD`, `git -C ../your-product-repo rev-parse --short HEAD`
6. Capture workflow evidence:
   - completed slices, active slice, and next checkpoint when a plan is in play
   - which automated commands ran and passed, failed, or were skipped
   - whether manual verification is pending, passed, failed, or blocked
   - whether validation, commit, and PR description are still pending
   - if work must return upstream, the exact blocker and the exact next command
7. Note blockers, assumptions, setup requirements, seed-data caveats, user decisions, and branch context that are not fully reflected in the staged artifacts.

## Step 2 - Return the Handoff In Session

Do not save a `.documents/thoughts/HANDOFF-...` file.

Return one copy-paste prompt in the current chat session using this template:

```text
Use [next_command] with:
- primary_artifact: <path>

Goal:
<1-2 sentences on the exact goal of the next session>

Current stage:
- done: ...
- pending: ...
- why handing off now: ...

Stage decision:
- next command: [next_command]
- reason: ...
- do not reopen: ...

Slice / checkpoint status:
- last completed slice: <name-or-none>
- active slice: <name-or-none>
- continue when: <checkpoint evidence-or-none>
- stop and return to workflow/commands/<command>.md if: <condition-or-none>

Repo state:
- workflow repo: <branch>, <commit>, <dirty-or-clean>
- product repo: <branch-or-none>, <commit-or-none>, <dirty-or-clean>

Verification status:
- automated: <passed|failed|blocked|not run> -- <commands>
- manual: <passed|pending|failed|blocked>
- validation: <passed|pending|failed|blocked>
- commit and PR: <done|pending>

Open risks / blockers:
- <concrete blocker or None.>

Artifacts to read first:
1. <path>
2. <path>
3. <path>
```

If the next session does not need a handoff because the current session can proceed directly, say so plainly instead of fabricating one.

Only add extra artifact paths below `primary_artifact` when one of these is true:
- the primary artifact is missing a critical link
- the next session must return upstream to a specific staged artifact
- the current blocker or checkpoint cannot be understood from the primary artifact alone

## Step 3 - Quality Bar

Before finishing, verify:

- The response names the exact next `workflow/commands/...` command.
- The response includes linked `questions`, `design`, and `structure` artifacts when they exist.
- If the plan is still pending review, the handoff stays on `workflow/commands/create_plan.md` instead of jumping to implementation.
- If design or structure approval is still pending, the handoff stays on that same stage instead of skipping ahead.
- If manual verification failed, the handoff sends the next session back to `workflow/commands/implement_plan.md` and limits scope to the failed checks and required fixes.
- If a slice checkpoint sends work upstream, the handoff preserves that exact upstream command instead of defaulting to `implement_plan.md`.
- Active slice and checkpoint status are explicit whenever a plan is in scope.
- Branch and commit info are included for whichever repo or repos matter.
- Verification state is explicit. Do not imply manual verification, validation, commit, or PR work happened if they did not.
- The handoff is concise and readable. Do not paste large diffs or long code snippets.
- No new handoff file was created.

## Final Response

Return:

```text
Next-session handoff:

<copy-paste prompt>
```

Do not say a handoff file was saved, and do not update `.documents/thoughts/.latest`.
