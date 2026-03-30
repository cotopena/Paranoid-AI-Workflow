---
description: Answer neutral codebase questions with evidence from the repo as it exists today
model: codex-high
---

# Research Codebase

Conduct evidence-first, read-only research for Project product work driven by a neutral questions artifact. The purpose of this command is to answer how the codebase works today without inheriting the intended implementation.

## Before You Run
- Read `workflow/README.md` for shared repo paths, artifact locations, and tool conventions.
- Consult `workflow/tooling.config.json` for `.documents/questions/`, `.documents/.tickets/`, `.documents/issues/`, `.documents/research/`, and the code roots under `../your-product-repo/`.
- Use this command after `create_questions.md` to research the product codebase from neutral questions rather than a solution-shaped request.
- Example Codex CLI prompt: `Use workflow/commands/research_codebase.md with .documents/questions/.latest to answer the neutral questions about Project scenario snapshots.`

## Critical Guardrail: Questions Gate Research

- Preferred input is an explicit questions artifact or `.documents/questions/.latest`.
- If a neutral questions artifact exists, treat it as the primary framing input.
- Do not let a raw feature request, implementation sketch, or plan override the questions framing.
- If no questions artifact exists yet, stop before researching and direct the next step to `workflow/commands/create_questions.md`.
- Do not silently convert a solution-shaped request into research findings.

Research is not planning. Research is not design. Research is not a file-change proposal.

## Initial Setup

When invoked without a questions artifact, respond with:

```text
I'm ready to research from a neutral questions artifact. Share a questions file, or run workflow/commands/create_questions.md first so research stays blind to the intended implementation.
```

Then wait.

## Inputs (in priority order)

1. An explicitly provided questions artifact.
2. `.documents/questions/.latest` if it exists.
3. The linked brief from the questions artifact, when present.
4. The linked mirrored issue from the questions artifact, when present.
5. Existing research notes only as supporting history after fresh code reading begins.
6. Product repo code and docs under `../your-product-repo/`.

Do not start from a raw feature request when a questions artifact is available.

## Research Rules

- Answer the questions with code and doc evidence.
- Prefer current source code as the primary source of truth.
- Use the brief or mirrored issue only for background and terminology.
- Keep findings factual:
  - what exists
  - where it exists
  - how it behaves
  - what patterns already exist
  - what constraints or unknowns remain
- Do not:
  - recommend solutions
  - choose an architecture
  - list files to edit
  - turn unknowns into implementation advice

If the session explicitly authorizes delegation, sub-agents may gather bounded evidence in parallel. Otherwise use the normal repo search/read tools directly.

## Steps

1. Read the questions artifact in full before touching code.
2. Extract the questions into investigation areas.
3. Read the linked brief or issue for background only.
4. Gather evidence from live code and relevant docs.
5. Organize findings by question.
6. Call out unanswered questions or ambiguity as unknowns, not recommendations.
7. Save the research artifact under `.documents/research/`.
8. Update `.documents/research/.latest`.
9. Return a concise in-session summary with the saved path and the main findings.

## File Naming

- Directory: `.documents/research/`
- Prefer linking back to the brief ID when available:
  - `RSRCH-####-description-YYYY-MM-DD.md`
- If no linked ticket ID exists, use:
  - `research-description-YYYY-MM-DD.md`

## Research Document Template

```markdown
---
date: [ISO timestamp with timezone]
researcher: [name or handle]
git_commit: [commit hash]
branch: [branch name]
repository: [repository name]
topic: "[research topic]"
tags: [research, codebase, neutral-questions]
status: complete
last_updated: [YYYY-MM-DD]
last_updated_by: [name or handle]
linked_questions: [path-or-none]
linked_brief: [path-or-none]
linked_issue: [path-or-none]
---

# Research: [Topic]

## Source Questions
- Link to the questions artifact
- Optional note on the framing scope

## Summary
High-level factual summary of what exists today.

## Findings By Question

### Q1. [Question text]
- `path:line` - evidence
- Related files or interactions

### Q2. [Question text]
- ...

## Current Constraints
- Constraints found in code or docs

## Unknowns
- Facts still not knowable from the available evidence

## Code References
- `path:line` - short description

## Historical Context
- `.documents/...` notes that help explain prior decisions, if any

## Related Research
- `.documents/research/...`
```

## Final Self-Check

Before finishing, verify:

* Research was driven by neutral questions, not a solution-shaped request.
* Findings are organized by question and cite repository-relative `path:line` references.
* Unknowns remain unknowns; they are not converted into plans.
* The saved path and `.documents/research/.latest` update are correct.
