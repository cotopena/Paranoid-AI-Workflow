---
description: Create a short design artifact and align with the human before structure or tactical planning
model: codex-high
---

# Create Design

Create a short, human-reviewable design artifact for Project product work. This command turns the brief, neutral questions, and research evidence into an intended end state that the human can cheaply correct before structure or tactical planning begins.

## Before You Run
- Read `workflow/README.md` for shared repo paths, artifact locations, and tool conventions.
- Consult `workflow/tooling.config.json` for `.documents/designs/`, `.documents/.tickets/`, `.documents/questions/`, `.documents/research/`, `.documents/issues/`, and the supporting docs root under `../your-product-repo/docs/`.
- Use this command after `create_ticket.md`, `create_questions.md`, and `research_codebase.md` when the work needs explicit design alignment before structure or planning.
- Example Codex CLI prompt: `Use workflow/commands/create_design.md with the latest brief, questions, and research artifacts to create a short design draft for Project.`

## Required Inputs

Use these inputs in order:

1. An explicitly provided design artifact path when continuing an existing draft.
2. An explicitly provided brief path.
3. `.documents/.tickets/.latest` when no brief path was supplied.
4. The linked questions artifact from the brief, or `.documents/questions/.latest`.
5. The linked research artifact from the brief, or `.documents/research/.latest`.
6. The linked mirrored issue from the brief or research, when present.
7. Relevant constraints docs from `../your-product-repo/docs/`, `docs/progress.md`, or `.documents/business-model.md`.

Hard gate:

- Design requires a brief, a neutral questions artifact, and a research artifact.
- If any of those inputs are missing, stop and respond with:

```text
Design needs the staged inputs below before it can align the future state:
- brief: <present|missing>
- questions: <present|missing>
- research: <present|missing>

Run the missing stage(s) first, then return to workflow/commands/create_design.md.
```

Do not create design from the raw feature request alone when the staged artifacts are missing.

## Design Guardrails

- Design is about where we are going, not how every file will change.
- Keep the artifact short enough for real human review. Prefer tight bullets over long prose.
- Use research to describe current truth first, then state the intended end state.
- Read the brief, questions artifact, research artifact, and relevant constraints docs. Do not rely on the raw feature request alone.
- The linked brief remains the canonical source of scope boundaries and acceptance criteria unless an approved design decision materially changes them.
- Separate unknowns explicitly:
  - factual unknowns -> return to research
  - human decision unknowns -> ask the human
  - later execution details -> defer to structure or plan
- Do not include:
  - file-by-file edits
  - phased implementation steps
  - pseudo-plans or rollout sequences disguised as design

## Process

1. Read the current design artifact first when continuing a draft. Otherwise read the brief, questions artifact, research artifact, linked issue, and only the most relevant constraints docs.
2. Summarize the current state from research evidence, not from stale request wording.
3. State the desired end state as a user- or system-visible outcome.
4. Record the patterns to follow and patterns to avoid.
5. Record resolved decisions that are already justified by the evidence or by prior human input.
6. Classify the remaining unknowns:
   - factual unknowns
   - human decision unknowns
   - deferred execution details
7. If factual unknowns materially block the design:
   - save the draft with `status: blocked_on_research`
   - list the factual gaps under `Open Questions`
   - direct the next step to `workflow/commands/research_codebase.md`
   - do not guess the missing design
8. If human decision unknowns remain:
   - save the draft with `approval_status: pending`
   - ask at most 3 targeted questions
   - stop and wait for human input
9. When the human answers:
   - update the same design artifact instead of creating a second competing design file
   - move the answers into `Human Review`
   - convert them into explicit resulting decisions
   - if those resulting decisions materially change scope, out-of-scope boundaries, or acceptance criteria, update the linked brief before marking the design approved
   - set `approval_status` to `approved` only when the design is sufficiently settled
10. Only after `approval_status: approved` should the next step be `workflow/commands/create_structure.md`.

## Output Rules

- Save the design artifact under `.documents/designs/`.
- Update `.documents/designs/.latest` with the repository-relative path.
- Prefer filenames tied to the brief when possible:
  - `DESIGN-TICKET-####-slug-YYYY-MM-DD.md`
- If no ticket ID exists, use:
  - `DESIGN-slug-YYYY-MM-DD.md`

## Design Artifact Template

```markdown
---
date: [ISO timestamp with timezone]
author: [name or handle]
repository: paranoid-ai-workflow
status: draft|blocked_on_research|approved
approval_status: pending|approved|rejected
approved_by: [name-or-none]
approved_on: [YYYY-MM-DD-or-none]
linked_brief: [path]
linked_questions: [path]
linked_research: [path]
linked_issue: [path-or-none]
topic: "[short topic]"
---

# Design: [Topic]

## Current State
- What is true today from research

## Desired End State
- What should be true after the work lands

## Patterns to Follow
- Existing repo patterns or constraints to keep

## Patterns to Avoid
- Existing anti-patterns, scope traps, or incorrect directions

## Resolved Decisions
- Decisions already justified by evidence or prior human input

## Open Questions

### Human Decision Unknowns
- Question for the human, or `- None.`

### Factual Unknowns
- Missing fact that requires more research, or `- None.`

### Deferred Execution Details
- Implementation detail that belongs in structure or plan, or `- None.`

## Major Risks
- Main design or scope risks

## Human Review
- Questions for the human:
  - `- None.` or up to 5 targeted questions
- Answers:
  - `- Pending.` or dated answer bullets
- Resulting decisions:
  - `- Pending until review.` or explicit post-review decisions

## Approval
- Status: `pending|approved|rejected`
- Next step: `wait for human input` or `workflow/commands/create_structure.md`
```

## Final Self-Check

Before finishing, verify:

* The artifact is short and human-reviewable.
* The design is grounded in the brief, questions, research, and relevant constraints docs.
* Current state and desired end state are both explicit.
* Patterns to follow, patterns to avoid, resolved decisions, unresolved questions, and major risks are recorded.
* Factual unknowns are redirected back to research instead of guessed.
* Human decision unknowns are turned into targeted questions instead of hidden assumptions.
* The same artifact is updated when human answers arrive.
* Any approved material scope or acceptance-criteria change is reflected back into the linked brief instead of living only in the design artifact.
* Structure is not started until the design is approved.
* The saved path and `.documents/designs/.latest` update are correct.
