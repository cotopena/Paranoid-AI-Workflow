# Validate Plan

Validate an implemented Project plan against the approved staged artifacts before commit or release. This is a review session: compare actual implementation and verification evidence to the plan, the canonical brief or ticket, the approved design, and the approved structure. Do not change code or rewrite artifacts to hide drift.

## Before You Run
- Read `workflow/README.md` for the shipped workflow and artifact paths.
- Consult `workflow/tooling.config.json` for plan, ticket, questions, research, design, and structure roots.
- Inputs required:
  - exact plan path under `.documents/.plans/current_plan/` or `.documents/.plans/completed_plan/`
  - recorded automated and manual verification evidence in or from that plan
- Hard gate: if manual verification is incomplete or missing, stop and respond with:

```text
Validation needs completed implementation evidence before review can begin:
- plan: <present|missing>
- automated verification recorded: <complete|incomplete|unknown>
- manual verification recorded: <complete|incomplete|unknown>

Finish workflow/commands/manual_verification.md first, then return to workflow/commands/validate_plan.md.
```

- Example Codex CLI prompt: `Use workflow/commands/validate_plan.md to review .documents/.plans/current_plan/PLAN-1001-persist-wizard-state-2026-03-18.md before commit.`

## Step 1 - Collect Evidence
- Read the plan first and treat it as the primary validation context.
- Re-open linked brief or ticket, questions, research, approved design, or approved structure only when the plan is missing enough context to validate safely or when the evidence points to scope, design, or checkpoint drift.
- Review the current diff, relevant commits, or touched files in `../your-product-repo` so you can map implementation back to the planned slices.
- Read the automated and manual verification evidence already recorded in the plan before re-running anything.
- Re-run only targeted commands when existing evidence is missing, stale, contradictory, or clearly insufficient for review.

Summarize:

```text
Plan: <filename>
Canonical scope: <ticket or brief path>
Approved design: <path>
Approved structure: <path>
Planned slices:
- Slice 1 - ...
- Slice 2 - ...
```

## Step 2 - Review Slice by Slice

For each slice:
1. Compare the implemented files and behavior to the slice goal, boundaries, and exact file paths in the approved plan.
2. Confirm the slice checkpoint was honored:
   - whether the `Continue when:` evidence exists
   - whether any `Stop and return to <command> if:` condition should have redirected work upstream
3. Compare the slice outcome back to the canonical brief or ticket, approved design decisions, and approved structure boundaries.
4. Record findings with code or artifact references. Keep the findings concrete and evidence-based.

## Step 3 - Review Verification Evidence

- Automated:
  - confirm the recorded commands are the ones the plan required
  - note pass, fail, blocked, or missing evidence
- Manual:
  - confirm the recorded checks cover the planned manual scenarios
  - note pass, fail, blocked, or missing evidence
- Scope and staged alignment:
  - confirm the implementation did not silently widen scope beyond the canonical brief or ticket
  - confirm design decisions and structure boundaries were preserved
  - confirm review evidence does not point to a required upstream return

## Step 4 - Produce the Validation Report

Use this structure:

```text
## Validation Report -- <Plan Name>

### Disposition
Ready for commit | Needs work

### Findings
1. <severity> <finding with reference>
2. <severity> <finding with reference>

### Slice Review
- Slice 1 -- ✅ / ⚠️ / ❌ with short rationale
- Slice 2 -- ✅ / ⚠️ / ❌ with short rationale

### Evidence Reviewed
- Automated: ...
- Manual: ...

### Next Command
- workflow/commands/<command>.md
```

Pick the next command from the evidence:

- implementation gap or failed verification -> `workflow/commands/implement_plan.md`
- canonical scope or acceptance mismatch -> `workflow/commands/create_ticket.md`
- factual current-state gap -> `workflow/commands/research_codebase.md`
- future-state or tradeoff mismatch -> `workflow/commands/create_design.md`
- slice-order, checkpoint, or boundary mismatch -> `workflow/commands/create_structure.md`
- validation passes cleanly -> `workflow/commands/commit.md`

## Guardrails
- Stay objective and evidence-driven.
- Keep this session review-focused. Do not edit source code.
- Do not rewrite the plan, ticket, design, or structure to make the implementation look compliant.
- Stop if you encounter unexpected work outside the approved staged scope and call it out explicitly.
- If validation passes, remind the user to finish commit and PR steps if not already done.
