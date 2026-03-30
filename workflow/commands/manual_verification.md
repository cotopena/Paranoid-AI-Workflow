# Manual Verification

Run read-only hands-on checks against an implemented Project plan. This session records evidence; it does not change product code, redesign workflow stages, or rewrite the approved plan to fit the outcome.

## Before You Run
- Read `workflow/README.md` to align on the shipped workflow and `.documents` structure.
- Consult `workflow/tooling.config.json` for plan paths, sibling repo paths, and tool fallbacks.
- Input you need:
  - exact plan path under `.documents/.plans/current_plan/` or `.documents/.plans/completed_plan/`
  - local URLs, feature flags, test accounts, or env setup mentioned in the plan
- Hard gate: if automated implementation checks are incomplete or the plan path is missing, stop and respond with:

```text
Manual verification needs completed implementation evidence before review can begin:
- plan: <present|missing>
- automated verification recorded in plan: <complete|incomplete|unknown>

Finish workflow/commands/implement_plan.md first, then return to workflow/commands/manual_verification.md.
```

- If the plan uses Clerk-authenticated local verification, sign in first. In Clerk dev test mode, test identifiers follow `name+clerk_test@example.com`; use `424242` only for email-code verification flows, and use the password you created if password auth is enabled instead.

## Guardrails
- Read-only repo except for plan checklist updates and concise verification notes.
- Do not reorder, rewrite, or delete plan content.
- Do not change product code, fixtures, or data shape during this session.
- Use terminal commands plus Playwright MCP only.
- Evidence over memory: record what you observed, not what you expected.
- Do not create or mutate real data unless the user explicitly approves it.

## Workflow
1. Load the plan from `.documents/.plans/current_plan/` or `.documents/.plans/completed_plan/`.
2. Treat the plan as the primary review context.
3. Re-open the linked brief or ticket, approved design, or approved structure only when the plan is too compressed to verify safely or when the recorded evidence suggests a scope or checkpoint mismatch.
4. Confirm from the plan:
   - the canonical scope
   - the out-of-scope boundaries
   - the slice order you are verifying
5. List the unchecked manual items in plan order, grouped by slice when the plan is slice-based.
6. Start services if needed:
   - App: run `npm run dev` from `../your-product-repo`
   - Convex: run `npm run dev:convex` from `../your-product-repo`
   - For browser-owned seeded data, sign into the local app and use the local helper route if one exists, for example `/app/dev/foundation-seed` or `/app/dev/reporting-seed`
7. Run manual checks one at a time:
   - use Playwright MCP for UI flows
   - use read-only `npx convex run <queryFunction>` checks if the plan calls for them
   - for auth-gated terminal helpers, prefer `npm run convex:run:manual -- <functionName> '<jsonArgs>'` from `../your-product-repo`
   - capture concise evidence such as route, seed or scenario used, observed result, and any clear repro signal
8. Update the plan inline immediately after each check:
   - completed or pass: always change the checklist marker to `[x]`; never leave a completed manual item unchecked
   - pass: `- [x] ... -- Passed: <short evidence>`
   - fail: keep `[ ]` and append `-- Failed: <short repro + observed behavior>`
   - blocked: keep `[ ]` and append `-- Blocked: <what is missing>`
9. Stay review-focused:
   - if a manual check fails because the code is wrong, record the minimal repro and the likely affected slice
   - if a manual check suggests a scope, design, or structure mismatch, record the evidence without rewriting those upstream artifacts in this session
10. Report results in-session and recommend the exact next workflow command:
   - all manual items passed -> `workflow/commands/validate_plan.md`
   - manual failures or blocks that require code changes -> `workflow/commands/implement_plan.md`
   - evidence that points to an upstream artifact mismatch -> the exact upstream command that must resolve it first

## Reporting Template
```text
Manual Verification Results -- <plan path>
- ✅ <check name>: evidence
- ❌ <check name>: failing behavior and repro signal
- ⏸️ <check name>: blocked and what is missing

Next command:
- workflow/commands/<command>.md
```

## Quick Reference
- Browser UI: Playwright MCP only
- Read-only Convex checks: `npx convex run <queryFunction>`
- Authenticated terminal Convex checks: `cd ../your-product-repo && npm run convex:run:manual -- <functionName> '<jsonArgs>'`
- Browser-owned dev seeding: sign into the local app, then use `/app/dev/foundation-seed` or `/app/dev/reporting-seed` when the seeded scenario must belong to the same Clerk user you are inspecting in the browser
- Most common local services:
  - `cd ../your-product-repo && npm run dev`
  - `cd ../your-product-repo && npm run dev:convex`

## Troubleshooting
- UI will not load: confirm the app and Convex dev processes are running from `../your-product-repo` and env vars are set.
- Missing plan path: pause and ask for the exact `.documents/.plans/...` file.
- Automated checks were never recorded in the plan: stop and return to `workflow/commands/implement_plan.md`.
- Flaky UI behavior: rerun the flow and capture timestamps, console output, and network errors.
- Environment mismatches: confirm you are testing the intended local or deployed URL.
- `Unauthorized` from `npx convex run`: use `npm run convex:run:manual -- ...` for terminal-only checks, or sign into the local app and use a browser-owned local helper route when the browser must be able to read the same seeded scenario.
