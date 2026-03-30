# 12-Factor Prompts — Paranoid AI Workflow

This folder standardizes how Codex runs commands and how agents use tools across the workflow repo and the sibling product repo.

## Before You Run
1. Inspect `workflow/tooling.config.json` for the latest workflow-repo, product-repo, workflow-stage, documents, and tool fallback mappings.
2. Update `publicRepoRoot` if your sibling app repo is not `../your-product-repo`.
3. Confirm `.documents/` mirrors the structure in the config: issues, tickets, questions, research, designs, structures, plans, PR drafts, thoughts/debug artifacts, and `CHANGELOG.md`.
4. Remember that `workflow/commands/create_ticket.md` is a brief-first intake command. The command name stays `create_ticket`, but it runs before questions, research, design, and planning.
5. Note whether you are in Codex CLI or an IDE agent so you follow the right Search/Read/List fallbacks.
6. Keep network access in mind. Skip Web tooling automatically when it is restricted and rely on local repo evidence instead.
7. When code context is needed, read it from `../your-product-repo`, not from this workflow repo.

## Paths
- Workflow repo root: `./`
- Product repo root: `../your-product-repo`
- Documents root: `.documents/`
- Internal docs root: `docs/`
- Supporting docs root: `../your-product-repo/docs/`
- Local issue mirrors: `.documents/issues/`
- Brief / ticket artifacts: `.documents/.tickets/`
- Neutral questions artifacts: `.documents/questions/`
- Research notes: `.documents/research/`
- Design artifacts: `.documents/designs/`
- Structure artifacts: `.documents/structures/`
- Plans: `.documents/.plans/`
- Pending plans: `.documents/.plans/pending/`
- Approved execution plans: `.documents/.plans/current_plan/`
- Completed plans: `.documents/.plans/completed_plan/`
- Historical notes and debug artifacts: `.documents/thoughts/`
- PR descriptions: `.documents/prs/`
- Changelog: `.documents/CHANGELOG.md`
- Business model: `.documents/business-model.md`
- Workflow guide: `docs/repo-workflow.md`
- Project context: `docs/project-context.md`
- Implementation notes: `docs/implementation-notes.md`
- Progress tracker: `docs/progress.md`
- App routes: `../your-product-repo/src/app/`
- Components: `../your-product-repo/src/components/`
- Shared logic: `../your-product-repo/src/lib/`
- Finance engine: `../your-product-repo/src/engine/`
- Convex backend: `../your-product-repo/convex/`
- Static assets: `../your-product-repo/public/`
- Config map: `workflow/tooling.config.json`

## Tools & Defaults
Agents should follow the priorities encoded in `tooling.config.json`:
- Search -> IDE (`builtin:Search`, `builtin:CodeSearch`) or CLI (`rg`, `grep`)
- Glob/List -> IDE (`builtin:ListFiles`, `builtin:List`) or CLI (`rg --files`, `find`, `ls`)
- Read -> IDE (`builtin:Read`) before CLI fallbacks (`sed -n`, `cat`)
- Web -> only when network access allows (`builtin:WebSearch`, `builtin:WebFetch`)

## Workflow (Your Order)
1. The source request usually lives in Linear, GitHub, or a pasted brief. Mirror it locally into `.documents/issues/current/` with `workflow/commands/mirror_issue.md` before planning or coding.
2. Create or refine the canonical brief or ticket with `workflow/commands/create_ticket.md` so problem framing, scope, acceptance criteria, constraints, and open questions are explicit in `.documents/.tickets/current/`.
3. Convert that brief or ticket into neutral research questions with `workflow/commands/create_questions.md` and save them under `.documents/questions/`.
4. Run `workflow/commands/research_codebase.md` from the questions artifact and save the evidence-first research note under `.documents/research/`.
5. Run `workflow/commands/create_design.md` using the brief or ticket, questions, and research artifacts. Stop for human review until the design is approved.
6. Run `workflow/commands/create_structure.md` using the approved design. Stop for human review until the structure is approved.
7. In a new session, run `workflow/commands/create_plan.md` using the current brief or ticket, questions, research, approved design, and approved structure. Save the tactical plan to `.documents/.plans/pending/`, spot-check it, then move it to `.documents/.plans/current_plan/`. A plan in `pending/` is still planning input, not execution input.
8. In a new session, run `workflow/commands/implement_plan.md` for the approved current plan. The approved plan is the default execution payload. Re-open linked staged artifacts only when the plan is missing material context, appears stale, or a saved checkpoint sends work back upstream.
9. In a new session, run `workflow/commands/manual_verification.md` for the same approved or completed plan. This session must stay read-only except for concise pass/fail evidence updates in the plan file.
10. Run `workflow/commands/validate_plan.md` against that same plan and its recorded automated plus manual evidence before shipping.
11. When validation passes, move the plan to `.documents/.plans/completed_plan/`, move the ticket to `.documents/.tickets/done/`, run `workflow/commands/commit.md`, then use `workflow/commands/describe_pr.md`.

Before implementation, create or switch the product repo onto a non-`main` branch with `workflow/commands/make_branch.md` or let `workflow/commands/implement_plan.md` do it automatically.

Optional: use `workflow/commands/create_handoff.md` when another session needs to resume the work. Normal handoffs stay in session as a copy-paste prompt; do not create a new `.documents/thoughts/HANDOFF-...` file for routine stage transitions.

Optional: use `workflow/commands/make_worktree.md` when you want isolated plan-specific worktrees.

## Prompt Linting
- Run `bash workflow/scripts/lint-prompts.sh` from the repo root to verify command and agent docs still meet the acceptance checks in this README and `tooling.config.json`, including staged workflow gates and the redesign-doc dependency boundary.
- Run `bash workflow/scripts/lint-ticket.sh <ticket-path>` (or no argument to lint `.documents/.tickets/.latest`) before planning.

## Conventions
- Use paths relative to this workflow repo in prompts, including references into `../your-product-repo/...` when code is involved.
- Keep local issue mirrors faithful to the source issue; do not silently rewrite requirements during intake.
- Treat `workflow/commands/create_ticket.md` output as the canonical brief or ticket for scope boundaries and acceptance criteria.
- Create neutral questions under `.documents/questions/` before codebase research when the desired implementation should stay out of research framing.
- Keep research evidence under `.documents/research/` and treat it as a prerequisite for design and planning.
- Treat `docs/` here as the workflow-side source of truth for process, project context, and implementation notes. Use `../your-product-repo/docs/` when the product repo already has durable docs worth citing.
- Keep tickets focused and name them `TICKET-####-short-slug-YYYY-MM-DD.md`.
- Keep design and structure artifacts short enough for real human review before tactical planning starts.
- Prefer small, iterative plans with explicit slice checkpoints, acceptance criteria, and real verification commands.
- Treat `.documents/.plans/current_plan/` as the default execution and review entrypoint. `manual_verification.md` and `validate_plan.md` should also start from the approved plan path.
- Normal workflow handoffs stay in session as copy-paste prompts. `.documents/thoughts/` is for debug or durable notes with lasting value, not routine session resumption.
- Run code verification commands from `../your-product-repo`.
- For this project, the most common verification set is `npm run convex:codegen`, `npm run lint`, `npm run typecheck`, and `npm run build`.
- Archive debugging reports under `.documents/thoughts/debug/DBG-YYYYMMDD-ss-slug.md`.

## Local Service Reminder
- Run local app commands from `../your-product-repo`.
- `npm run dev` starts the Next.js app.
- `npm run dev:convex` starts the local Convex backend.
- `npm run convex:run:manual -- <functionName> '<jsonArgs>'` runs auth-gated Convex helpers with a stable manual-verification identity for terminal-only checks.
- Use `/app/dev/foundation-seed` or `/app/dev/reporting-seed` after signing into the local app when seeded verification data must be owned by the same Clerk user you are inspecting in the browser.
- If Clerk, Stripe, Convex, or OpenAI env vars are missing, some flows will show placeholder or configuration states instead of full behavior.

If a tool is unavailable, agents should automatically use the next fallback defined in `workflow/tooling.config.json`.
