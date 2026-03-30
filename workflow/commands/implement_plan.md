---
description: Execute approved plans one vertical slice at a time with explicit checkpoints
model: codex-high
---

# Implement Plan

Implement approved Project work one vertical slice at a time. The approved plan is the primary execution context. It should already compress the needed staged inputs so implementation can stay focused; reopen upstream artifacts only when the plan is missing something material, appears stale, or a saved checkpoint sends work back upstream.

## Before You Run
- Read `workflow/README.md` so you follow the documented order from approved plan -> implementation -> manual verification -> validation -> commit.
- Inspect `workflow/tooling.config.json` to confirm the current plan directory, staged artifact roots, and sibling product repo path at `../your-product-repo`.
- Input required:
  - exact plan path under `.documents/.plans/current_plan/`
- Hard gate: after reading the plan, if it is still in `.documents/.plans/pending/`, or if the plan does not identify the staged chain it depends on well enough to execute safely, stop and respond with:

```text
Implementation needs an approved current plan with a usable staged chain before coding can begin:
- plan: <current_plan|pending|missing>
- brief_or_ticket link in plan: <present|missing>
- questions link in plan: <present|missing>
- research link in plan: <present|missing>
- design link or approval evidence in plan: <present|missing>
- structure link or approval evidence in plan: <present|missing>

Fix the plan or the upstream artifact(s), then return to workflow/commands/implement_plan.md.
```

- Ensure the product repo is on a non-`main` implementation branch that matches the approved plan. Use `workflow/commands/make_branch.md` or let this command create or switch the branch before coding.
- Example Codex CLI prompt: `Run workflow/commands/implement_plan.md to implement .documents/.plans/current_plan/PLAN-1001-persist-wizard-state-2026-03-18.md.`

## Initial Response

When invoked:
1. Confirm the approved current-plan path.
2. Reply with:

```text
I'll implement PLAN-####-slug.md one slice at a time. I'll first ensure ../your-product-repo is on the correct non-main branch, then I'll restate the current slice contract and checkpoint before coding.
```

## Step 0 - Prepare the Public Repo Branch

1. Derive the public branch from the approved plan path by running:
   - `./scripts/public-plan-branch <plan-path>`
2. Use the default branch type `feat` unless the approved ticket or the user clearly calls for `fix`, `chore`, `docs`, `test`, or `refactor`.
3. Confirm the active branch in `../your-product-repo` is not `main` before editing files.
4. If the product repo has uncommitted changes that block a safe branch switch, stop and ask the user how to proceed.
5. Report the product repo branch name before moving into execution.

## Step 1 - Load the Staged Execution Contract

1. Read the approved plan first and treat it as the primary execution context:
   - `Inputs`
   - `Scope Controls`
   - `Current State Anchors`
   - the active slice
   - checkpoint rules
2. Re-open the code and doc references cited by the current slice so you know their current state before editing.
3. Re-open linked brief or ticket, questions, research, design, or structure artifacts only when one of these is true:
   - the plan link is missing or clearly stale
   - the plan summary is too compressed to execute the current slice safely
   - a saved checkpoint or discovered mismatch requires an upstream return
4. Determine the active slice:
   - use the first unfinished slice in plan order
   - if a legacy plan still says `Phase`, treat each phase as a slice and preserve the same checkpoint discipline
5. Extract and restate the execution controls for that slice:
   - canonical scope boundaries and acceptance criteria from the brief or ticket
   - the slice goal
   - boundaries or rollback notes
   - exact file paths to touch
   - automated and manual checks
   - `Continue when:` evidence
   - `Stop and return to <command> if:` conditions
6. Share a short execution summary:

```text
Plan: PLAN-1234-...
Canonical scope: <ticket or brief path>
Current slice: Slice N - ...
Files:
- ../your-product-repo/...
- ../your-product-repo/...
Checks:
- ...
Checkpoint:
- Continue when: ...
- Stop and return to workflow/commands/<command>.md if: ...
```

7. If the approved plan is missing exact file paths, the current slice is unclear, or the saved checkpoint cannot be interpreted without new tactical planning, stop and return to `workflow/commands/create_plan.md`.

## Step 2 - Execute One Slice at a Time

For each slice:

1. Restate the slice contract before editing:
   - goal
   - boundaries or rollback notes
   - exact files to touch
   - automated checks for this slice
   - manual checks that later sessions must run
   - the slice checkpoint
2. Implement only the current slice. Do not bundle unfinished later slices into the same edit batch.
3. Run the slice-specific automated checks early and again after risky edits. Prefer the commands already named in the plan, such as:
   - `cd ../your-product-repo && npm run convex:codegen`
   - `cd ../your-product-repo && npm run lint`
   - `cd ../your-product-repo && npm run typecheck`
   - `cd ../your-product-repo && npm run build`
   - `cd ../your-product-repo && npm run dev:convex` when the plan depends on live Convex validation
4. Update the plan inline as evidence is created:
   - mark automated checklist items `[x]` only after they pass
   - append short evidence notes such as `-- Passed: ...`, `-- Failed: ...`, or `-- Blocked: ...`
   - record any narrow deviation or follow-up next to the slice that triggered it
5. Enforce the saved checkpoint exactly:
   - continue to the next slice only when every `Continue when:` condition is backed by current evidence
   - if any `Stop and return to <command> if:` condition is hit, stop additional coding and point the next step to that exact command
6. If execution uncovers a stage-boundary problem, hand work back to the right upstream command instead of patching around it:
   - canonical scope or acceptance mismatch -> `workflow/commands/create_ticket.md`
   - factual current-state gap -> `workflow/commands/research_codebase.md`
   - future-state or tradeoff mismatch -> `workflow/commands/create_design.md`
   - slice-order, checkpoint, or boundary mismatch -> `workflow/commands/create_structure.md`
   - tactical ambiguity inside the saved plan -> `workflow/commands/create_plan.md`
7. Only after the current slice checkpoint passes should you move to the next slice and repeat this step.

## Step 3 - Final Automated Verification Before Manual Checks

1. After the last slice is complete, run the full automated suite listed in the plan.
2. Update the plan file checkboxes for automated criteria with pass, fail, or blocked notes.
3. Share status with the user:

```text
Slice 1 - Complete ✅
Slice 2 - Complete ✅
Slice 3 - Complete ✅
Checks: ../your-product-repo lint ✅ | typecheck ✅ | build ✅
Manual verification: pending via workflow/commands/manual_verification.md
```

4. Manual verification happens in a separate read-only session via `workflow/commands/manual_verification.md`.

## Step 4 - Handoff Alignment

- If all slices and automated checks are complete, the next workflow command is `workflow/commands/manual_verification.md`.
- If the session stops mid-slice or between slices without an upstream mismatch, the next workflow command remains `workflow/commands/implement_plan.md`, and the handoff must name the active slice plus the checkpoint evidence still missing.
- If a slice checkpoint sends work back upstream, the next workflow command is the exact `workflow/commands/<command>.md` named by that checkpoint, not `implement_plan.md`.
- If a handoff is needed, use `workflow/commands/create_handoff.md` and return an in-session copy-paste prompt that preserves the current slice, completed slices, automation status, blocker, and exact next command.

## Guardrails & Best Practices

- Keep execution vertical. Do not convert the approved slice order into a horizontal refactor.
- Keep changes tightly scoped. A materially larger implementation shape requires an upstream return, not an on-the-fly rewrite.
- Never implement directly on `main` in `../your-product-repo`.
- Do not change secrets, seed accounts, or external settings without explicit instruction.
- Do not silently widen scope or acceptance criteria during coding. Approved scope changes must go back into the canonical brief or ticket first.
- Manual verification and validation are separate review stages. Do not treat implementation as a substitute for either one.
