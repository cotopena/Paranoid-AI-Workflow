---
description: Convert a brief or mirrored issue into neutral research questions
model: codex-high
---

# Create Questions

Create a durable neutral-questions artifact for Project product work. This command converts the current brief or mirrored issue into research questions that describe what needs to be learned from the codebase without prescribing the implementation.

## Before You Run
- Read `workflow/README.md` for shared repo paths, artifact locations, and tool conventions.
- Consult `workflow/tooling.config.json` for `.documents/questions/`, `.documents/.tickets/`, `.documents/issues/`, and `.documents/research/`.
- Use this command after `create_ticket.md` when intake work needs research that stays blind to the intended implementation.
- Example Codex CLI prompt: `Use workflow/commands/create_questions.md to turn the latest Project brief into neutral research questions.`

## Input Priority

1. An explicitly provided brief path.
2. `.documents/.tickets/.latest` if it exists.
3. An explicitly provided mirrored issue path.
4. `.documents/issues/.latest` if it exists.
5. The user request in this conversation when no durable intake artifact exists yet.

Do not read `.documents/research/.latest`, plans, or implementation handoffs to generate the questions artifact. The goal is to protect research from inheriting a solution.

## Output Rules

- Save the questions artifact under `.documents/questions/`.
- Update `.documents/questions/.latest` with the repository-relative path.
- Prefer filenames tied to the brief when possible:
  - `QUESTIONS-TICKET-####-slug-YYYY-MM-DD.md`
- If no ticket ID exists yet, use:
  - `QUESTIONS-slug-YYYY-MM-DD.md`

The questions artifact must be durable, concise, and reusable in a later fresh-context research session.

## What Good Questions Look Like

Good research questions:

- ask how the repo works today
- ask where relevant logic or data lives
- ask what constraints or patterns already exist
- ask what remains unknown from code and docs

Bad research questions:

- smuggle in the desired implementation
- ask for a plan
- assume a specific file or architecture change should happen
- ask for phased delivery or rollout steps

Prefer:

- `How is X currently derived?`
- `Where does Y state live today?`
- `What existing pattern handles Z?`
- `What constraints would any change in this area need to respect?`

Avoid:

- `How should we add X by storing it in Y?`
- `What files do we need to change to implement Z?`
- `What is the plan for building ...?`

## Process

1. Read the current brief first. If there is no brief, read the mirrored issue.
2. Extract the user-visible problem, scope, constraints, known terminology, and unresolved questions.
3. Rewrite those into neutral research questions.
4. Group the questions by theme when helpful.
5. Preserve known constraints separately so research can honor them without turning them into a solution.
6. If the source request is already implementation-shaped, strip the implementation assumptions out of the questions and call out the stripped assumptions in `Biases Removed`.
7. Save the artifact and update `.latest`.
8. Return the saved path and recommend `workflow/commands/research_codebase.md` as the next step.

## Questions Artifact Template

```markdown
---
date: [ISO timestamp with timezone]
author: [name or handle]
repository: paranoid-ai-workflow
status: current
linked_brief: [path-or-none]
linked_issue: [path-or-none]
linked_research: none
topic: "[short topic]"
---

# Questions: [Topic]

## Intent
1-2 sentences on what the next research session needs to understand.

## Source Summary
- Brief or issue summary captured without implementation advice

## Neutral Research Questions

### [Theme 1]
- Question phrased to learn how the current system works
- Question phrased to identify current constraints or patterns

### [Theme 2]
- ...

## Known Constraints To Preserve
- Facts from the brief or issue that research should keep in mind

## Biases Removed
- Implementation assumptions stripped out before research, or `- None.`

## Out of Bounds For Research
- Planning, design selection, file-by-file changes, and solution proposals

## Suggested Next Step
- Run `workflow/commands/research_codebase.md` using this questions artifact
```

## Final Self-Check

Before finishing, verify:

* The artifact can be handed to a fresh-context research session without the original solution-shaped ask.
* Every question is neutral and evidence-seeking.
* The artifact does not include implementation steps, plans, or recommended file edits.
* The saved path and `.documents/questions/.latest` update are correct.
