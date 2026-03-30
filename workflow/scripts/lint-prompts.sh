#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${PROMPT_DIR}/.." && pwd)"

cd "$REPO_ROOT"

pass() {
  printf '✓ %s\n' "$1"
}

fail() {
  printf '✗ %s\n' "$1"
  exit 1
}

require_file() {
  local path="$1"
  [[ -f "$path" ]] && pass "Exists: $path" || fail "Missing: $path"
}

count_pattern() {
  local pattern="$1"
  local target="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -n "$pattern" "$target"
  else
    # Fallback when ripgrep is unavailable (e.g., minimal CI images)
    grep -R -n "$pattern" "$target"
  fi
}

has_fixed() {
  local needle="$1"
  shift
  if command -v rg >/dev/null 2>&1; then
    rg -n -F -m1 "$needle" "$@" >/dev/null 2>&1
  else
    grep -R -n -F -m1 "$needle" "$@" >/dev/null 2>&1
  fi
}

require_count() {
  local desc="$1"
  local pattern="$2"
  local target="$3"
  local min="$4"
  local count
  count=$(count_pattern "$pattern" "$target" | wc -l | tr -d '[:space:]')
  if (( count >= min )); then
    pass "$desc ($count >= $min)"
  else
    fail "$desc ($count < $min)"
  fi
}

require_fixed() {
  local desc="$1"
  local needle="$2"
  shift 2
  if has_fixed "$needle" "$@"; then
    pass "$desc"
  else
    fail "$desc"
  fi
}

require_file "workflow/tooling.config.json"
require_file "workflow/README.md"
require_file "workflow/scripts/lint-ticket.sh"

require_count '"Before You Run" blocks in command docs' "Before You Run" "workflow/commands" 5
require_count 'Command docs referencing tooling.config.json' "tooling.config.json" "workflow/commands" 5
require_count 'Command docs referencing README' "workflow/README.md" "workflow/commands" 5

require_count '"Tools & Defaults" sections in agents' "Tools & Defaults" "workflow/agents" 6
require_count 'Agent briefs referencing tooling.config.json' "tooling.config.json" "workflow/agents" 6
require_count 'Agent briefs referencing README' "workflow/README.md" "workflow/agents" 6

deprecated_targets=(
  "workflow/README.md"
  "workflow/tooling.config.json"
  "workflow/commands"
)

deprecated_refs=(
  '`task-board.md`'
  '`plan.md`'
  '"taskBoard"'
  '"projectPlan"'
)

for ref in "${deprecated_refs[@]}"; do
  if rg -n -F "$ref" "${deprecated_targets[@]}" >/dev/null 2>&1; then
    fail "Workflow still references deprecated task board or plan docs: $ref"
  fi
done
pass "No deprecated task board or plan doc references remain"

require_fixed "README documents questions stage" "workflow/commands/create_questions.md" "workflow/README.md"
require_fixed "README documents design stage" "workflow/commands/create_design.md" "workflow/README.md"
require_fixed "README documents structure stage" "workflow/commands/create_structure.md" "workflow/README.md"
require_fixed "README documents approved current-plan entrypoint" ".documents/.plans/current_plan/" "workflow/README.md"
require_fixed "README documents in-session handoffs" "stay in session as a copy-paste prompt" "workflow/README.md"

require_fixed "Repo workflow documents questions stage" "workflow/commands/create_questions.md" "docs/repo-workflow.md"
require_fixed "Repo workflow documents design stage" "workflow/commands/create_design.md" "docs/repo-workflow.md"
require_fixed "Repo workflow documents structure stage" "workflow/commands/create_structure.md" "docs/repo-workflow.md"
require_fixed "Repo workflow documents approved current-plan entrypoint" ".documents/.plans/current_plan/" "docs/repo-workflow.md"
require_fixed "Repo workflow documents in-session handoffs" "in-session copy-paste prompt" "docs/repo-workflow.md"

require_fixed "Config captures staged workflow order" "\"stageOrder\"" "workflow/tooling.config.json"
require_fixed "Config marks saved handoff docs as disabled" "\"savedThoughtHandoffsAllowed\": false" "workflow/tooling.config.json"

require_fixed "Research gates on questions artifacts" "run workflow/commands/create_questions.md first" "workflow/commands/research_codebase.md"
require_fixed "Design gates on brief, questions, and research" "Design requires a brief, a neutral questions artifact, and a research artifact." "workflow/commands/create_design.md"
require_fixed "Structure gates on approved design" "Structure requires an approved design artifact." "workflow/commands/create_structure.md"
require_fixed "Plan gates on approved design and structure" "Planning requires a brief or ticket, a research artifact, an approved design artifact, and an approved structure artifact." "workflow/commands/create_plan.md"
require_fixed "Implementation requires current plans" ".documents/.plans/current_plan/" "workflow/commands/implement_plan.md"
require_fixed "Implementation blocks pending plans" 'if it is still in `.documents/.plans/pending/`' "workflow/commands/implement_plan.md"
require_fixed "Manual verification uses approved plan roots" 'Load the plan from `.documents/.plans/current_plan/` or `.documents/.plans/completed_plan/`.' "workflow/commands/manual_verification.md"
require_fixed "Validation blocks until manual verification runs" "Finish workflow/commands/manual_verification.md first, then return to workflow/commands/validate_plan.md." "workflow/commands/validate_plan.md"
require_fixed "Handoffs stay in session" 'Do not save a `.documents/thoughts/HANDOFF-...` file.' "workflow/commands/create_handoff.md"

runtime_dependency_targets=(
  "workflow/README.md"
  "docs/repo-workflow.md"
  "workflow/tooling.config.json"
  "workflow/commands"
)

redesign_dependency_refs=(
  "docs/workflow-redesign-tracker.md"
  "docs/dex-rpi-adjustments-handoff.md"
  "workflow-redesign-tracker"
  "dex-rpi-adjustments-handoff"
)

for ref in "${redesign_dependency_refs[@]}"; do
  if has_fixed "$ref" "${runtime_dependency_targets[@]}"; then
    fail "Operational workflow docs or commands depend on redesign-session docs: $ref"
  fi
done
pass "Operational workflow docs and commands do not depend on redesign-session docs"

pass "Prompt lint checks complete"
