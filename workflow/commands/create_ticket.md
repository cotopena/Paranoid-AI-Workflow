# create_ticket.md

You generate a slim, brief-first intake artifact for Project product work. The command name stays `create_ticket`, but the artifact it creates is an intake brief that exists before neutral questions and research for work in `../your-product-repo`.

---

## Objectives

* Produce a short brief that captures the problem, scope, constraints, acceptance criteria, and open questions.
* Keep the brief independent from prior research. Do not require `.documents/research/.latest`.
* Preserve the existing ticket path and ID scheme so later commands can still locate the current artifact.
* Make downstream blockers explicit: planning is not ready until questions and research exist.

---

## Before You Run
- Read `workflow/README.md` for shared repo paths, artifact locations, and tool conventions.
- Consult `workflow/tooling.config.json` for `.documents/.tickets/`, `.documents/issues/`, `.documents/questions/`, the local docs under `docs/`, and any fallback paths into `../your-product-repo/docs/`.
- This command is the intake step for the staged workflow: `issue -> brief -> questions -> research`.
- Example Codex CLI prompt: `Follow workflow/commands/create_ticket.md to turn the latest mirrored Project issue into a brief-first intake artifact.`

---

## Input Sources (read minimally)

1. The user request in this conversation.
2. `.documents/issues/.latest` if it exists.
3. `docs/project-context.md` when product constraints matter.
4. `docs/implementation-notes.md` only for already-established constraints, not for solution design.
5. `docs/progress.md` when current project status changes scope or urgency.
6. `.documents/business-model.md` when business constraints materially affect the brief.
7. Other docs the user explicitly names.

Do not depend on `.documents/research/.latest` when creating the brief.

Optional grounding only:

- You may gather up to 5 high-signal context pointers from docs or code if they clarify terminology or obvious constraints.
- Do not perform broad codebase tracing, implementation mapping, or solution design. That belongs to `create_questions.md` plus `research_codebase.md`.

If `.documents/issues/.latest` is missing, proceed from the user request and record that the local issue mirror is missing in `Assumptions`.

Hard budget: keep the saved brief concise. Prefer sharp bullets over long prose.

---

## File Naming & ID Logic (must follow exactly)

* Ticket ID: `TICKET-####`
  * Read or initialize `.documents/.tickets/.counter`.
  * If present, `new_id = last + 1`. If missing, start at `1001`.
* Slug: kebab-case from the brief title, <= 7 words, only `[a-z0-9-]`.
* Filename: `TICKET-####-slug-YYYY-MM-DD.md`
* Directory:
  * Default: `.documents/.tickets/current/`
  * Drafts awaiting clarification: `.documents/.tickets/new/`
* After saving, update `.documents/.tickets/.latest` with the repository-relative path.

Command compatibility is retained through the existing `.documents/.tickets/` path, but the artifact content is now a brief-first intake doc.

---

## Process

1. Treat the artifact as a brief, not an execution-ready implementation ticket.
2. Read the mirrored issue or user request closely and restate the ask without adding implementation bias.
3. Capture:
   * the problem to solve
   * the scope boundary
   * the key constraints
   * observable acceptance criteria
   * unresolved questions that should drive neutral research
4. Keep context pointers sparse and factual.
   * Prefer issue/doc links over code spelunking.
   * If you cite code, use it only to ground present terminology or obvious integration surfaces.
5. Do not:
   * require or summarize a prior research artifact
   * propose implementation steps
   * turn open questions into hidden recommendations
   * write file-by-file change plans
6. Set `plan_blockers` honestly.
   * If no questions artifact exists yet, include `questions artifact missing`.
   * If no research artifact exists yet, include `research artifact missing`.
   * Planning should not be treated as ready while those blockers remain.
7. Save the brief, update `.latest`, and return:
   * `Created: .documents/.tickets/<status>/TICKET-####-slug-YYYY-MM-DD.md`
8. If open questions remain, direct the next step to `workflow/commands/create_questions.md`. Do not resolve them inline with solution proposals.

---

## Brief Template

Use this structure. Keep sections short. If a section does not apply yet, say `- None known yet.` instead of inventing detail.

```markdown
---
id: TICKET-####
title: <Short outcome-based title>
type: Feature|Bug|Chore|Spike
priority: P0|P1|P2|P3
risk_level: low|medium|high
status: draft|current|done
stage: brief
owner: unassigned
created: YYYY-MM-DD
linked_issue: path-or-none
plan_blockers: ["questions artifact missing", "research artifact missing"]
labels: [stage/brief, area/..., breaking-change:no]
---

# Summary
1-2 sentences explaining the problem and intended outcome without prescribing the solution.

## Problem / Goal
- Who is affected
- What problem exists today
- Why it matters now

## Scope (In)
- Concrete outcomes this brief is asking for

## Out of Scope
- Explicit exclusions that prevent scope creep

## Constraints
- Product, business, compliance, timeline, repo, or compatibility constraints

## Context Pointers
- `path/to/doc-or-file.md:line-line` - grounding context only
- `../your-product-repo/...` - optional only when it clarifies terminology or obvious boundaries

## Acceptance Criteria (testable)
- **Scenario:** brief name
  - **Verification:** Automated|Manual|TBD after research
  - **Given** current state
  - **When** the user or system acts
  - **Then** the observable outcome occurs

## Deliverables
- [ ] Brief scope is explicit
- [ ] Constraints are captured
- [ ] Open questions are isolated for neutral research

## Verification Commands
- [ ] Manual brief review against the mirrored issue
- [ ] Repo-level verification commands to finalize after research when implementation surfaces are known

## Non-Functional Requirements
- Performance, security, privacy, reliability, or audit constraints that are already known

## Access Semantics (auth/permissions tickets only)
- Unauthenticated behavior
- Authenticated but unauthorized behavior
- Not-found behavior only when explicitly intended

## Dependencies & Impact
- Upstream systems, docs, or business dependencies already known
- Risks to adjacent areas if the ask is misunderstood

## Decisions (resolved)
- Facts or decisions already settled before research begins

## Open Questions (keep <= 7)
- Neutral questions that need answering before research or planning can be trusted

## Assumptions (keep <= 5)
- Preconditions believed true but not yet verified

## Definition of Done
- [ ] The brief reflects the mirrored issue or user request faithfully
- [ ] Scope and out-of-scope are explicit
- [ ] Acceptance criteria are observable
- [ ] Open questions are ready for `create_questions.md`
- [ ] `plan_blockers` reflects whether questions and research are still missing
```

---

## Style Rules

* Prefer short bullets and tight headings.
* Outcome language only; avoid file-level change proposals.
* Keep acceptance criteria observable even when implementation is unknown.
* Use `TBD after research` instead of guessing technical verification details too early.
* If the user request is already solution-shaped, restate it as a problem/outcome brief before saving.

---

## Final Self-Check (must pass)

Before finishing, verify:

* The artifact reads like a brief, not a plan.
* The brief does not require a pre-existing research note.
* Open questions are neutral and not disguised solution advice.
* `plan_blockers` is non-empty whenever questions or research are still missing.
* The file naming/id logic and `.latest` update are correct.
