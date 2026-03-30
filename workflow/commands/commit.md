# Commit Changes

You package work for the workflow and product repos: create clean git commits and update `.documents/CHANGELOG.md`. Keep `workflow/README.md` + `workflow/tooling.config.json` handy for repo paths and tool fallbacks.

Run git commands in the repo that owns the changed files:
- `.` for workflow docs, tickets, plans, and changelog work
- `../your-product-repo` for product code changes

---

## Process (Overview)
1) **Think about what changed**  
2) **Plan your commit(s)**  
3) **Present your plan to the user (confirm)**  
4) **Execute upon confirmation**  
5) **Update `.documents/CHANGELOG.md` (confirm version title, then commit)**

> Policy guardrails  
> - Do **not** add co-authors or tool attributions.  
> - Commits are authored solely by the user.  
> - Write commit messages as if the user wrote them.  
> - Never use `git add -A` or `git add .` - always stage **specific files**.

---

## 1) Think About What Changed
- Review conversation history to understand intent and outcomes.
- Inspect the repo state:
  ```bash
  git status
  git diff
  ```
- If product code changed, run the same commands from `../your-product-repo`.
- Decide if changes should be **one commit** or **multiple atomic commits** tied to the active ticket/plan in `.documents/.tickets` or `.documents/.plans`.

**Checklist**
- [ ] I understand the scope of changes.
- [ ] I know which files were modified and why.

---

## 2) Plan Your Commit(s)
- Group **related files** together into logical commits.
- Draft **imperative** commit messages that explain **why** (not only what).
  - Conventional Commits style is encouraged (`feat:`, `fix:`, `docs:`, `refactor:`, `perf:`, `build:`, `ci:`, `test:`).
- Keep commits **focused and atomic**.
- If both repos changed, keep commits repo-local. Do not mix `.` and `../your-product-repo` files in one commit.

**Checklist**
- [ ] Files grouped by logical concern.
- [ ] Commit subjects are imperative, concise, and meaningful.
- [ ] Bodies (if needed) explain why/how and any side effects.

---

## 3) Present Your Plan (Confirmation Required)
Share the plan before committing:
- List the **files** to stage for each commit.
- If multiple repos changed, label which repo each commit belongs to.
- Provide the **exact commit message(s)**.
- Ask explicitly:  
  **"I plan to create [N] commit(s) with these changes. Shall I proceed?"**

**Example format**
```text
Commit 1 (../your-product-repo)
  Files:
    - src/app/dashboard/page.tsx
    - src/components/reporting/report-summary.tsx
  Message:
    feat(reporting): persist scenario snapshots for report generation

Commit 2 (.)
  Files:
    - .documents/CHANGELOG.md
    - workflow/README.md
  Message:
    docs(workflow): update release notes guidance
```

**Checklist**
- [ ] User has confirmed N commits and their messages.

---

## 4) Execute Upon Confirmation
Perform the exact staged adds and commits you proposed (no `-A`, no `.`):
```bash
git add path/to/fileA.py path/to/fileB.py
git commit -m "feat(scope): add X to enable Y because Z"

git add path/to/fileC.md
git commit -m "docs: update README with setup notes"
```
If the commit belongs to the sibling product repo, run the same commands with `git -C ../your-product-repo ...`.

Show the result:
```bash
git log --oneline -n 5
```
If multiple repos changed, show the short log for each repo that received a commit.

**Checklist**
- [ ] Only intended files were staged.
- [ ] Commits created with the planned messages.
- [ ] Short log shown to the user.

---

## 5) Update `.documents/CHANGELOG.md` (release-notes format; confirm title first)

**Target file:** `.documents/CHANGELOG.md`  
**Goal:** Add a new top entry using the release format and map bullets to the commits you just created.

### 5.1 Header Format & Bumps
- Header format:  
  ```text
  ## Release <MAJOR>.<MINOR> -- <YYYY-MM-DD>
  ```
- Default **patch** bump: increment `<MINOR>` by 1 (e.g., `0.4 -> 0.5 -> 0.6`).
- Larger release: increment `<MAJOR>` and reset `<MINOR>=0` (e.g., `0.9 -> 1.0`).
- Always confirm with the user which bump applies and the exact header text before editing.

### 5.2 Bootstrap If Missing
```bash
mkdir -p .documents
cat > .documents/CHANGELOG.md <<'EOF'
# Changelog

All notable changes to Project are documented here.
Entries follow Keep a Changelog conventions with simple release headers.
Dates use `YYYY-MM-DD` and newest entries belong at the top.

EOF
```

### 5.3 Compute the Next Title
Use the highest release version even if the file is out of order:
```bash
LAST_TITLE=$(grep -E '^## Release [0-9]+\.[0-9]+ -- ' .documents/CHANGELOG.md | sort -V -k3,3 | tail -n1)
DATE=$(date +"%Y-%m-%d")

if [ -z "$LAST_TITLE" ]; then
  MAJOR=0
  MINOR=0
else
  MAJOR=$(echo "$LAST_TITLE" | awk '{print $3}' | cut -d'.' -f1)
  MINOR=$(echo "$LAST_TITLE" | awk '{print $3}' | cut -d'.' -f2)
fi

NEXT_TITLE="Release ${MAJOR}.$((MINOR+1))"
echo "Proposed NEXT_TITLE: $NEXT_TITLE -- $DATE"
```
If the user requests a larger bump:
```bash
NEXT_TITLE="Release $((MAJOR+1)).0"
```

### 5.4 Sections & Bullets
- Prefer Keep a Changelog sections and the ones already used in this repo (Added, Changed, Fixed, Docs, Tooling, Tickets, etc.). Skip empty sections.
- Map Conventional Commit types to sections: `feat`->Added, `fix`->Fixed, `refactor`->Changed, `docs`->Docs, `perf`->Performance, `build`->Build, `ci`->CI, `test`->Test.
- Bullets are **imperative**, concise, and include the "why" when not obvious.
- Append ticket/plan provenance inline, mirroring existing entries:  
  `(Ticket: TICKET-####-slug-YYYY-MM-DD, Plan: PLAN-####-slug-YYYY-MM-DD | direct request)`.  
  If uncertain, ask the user before finalizing.

### 5.5 Entry Placement
- Prepend the new version block at the **top** so the latest release is first.
- If older entries are out of order, reorder so newest -> oldest before saving.

### 5.6 Choose Entry Mode
- **Per-Commit**: create a new version header per commit (default if unspecified).
- **Batch**: one version header summarizing the commits you just made.
Ask which mode to use if not stated.

### 5.7 Template (Prepend at Top)
```markdown
## Release X.Y -- YYYY-MM-DD

### Added
- feat(scope): summary + why (Ticket: ..., Plan: ...)

### Changed
- refactor(scope): summary + why (Ticket: ..., Plan: ...)

### Fixed
- fix(scope): summary + why (Ticket: ..., Plan: ...)

### Docs
- docs(scope): documentation updates (Ticket: ..., Plan: ...)

### Tooling
- build(scope): tooling updates (Ticket: ..., Plan: ...)

### Tickets
- ticket(scope): ticket hygiene (Ticket: ..., Plan: ...)

#### Commit details
- `HASH` - **subject**  
  *Files*: path/one.py, path/two.ts  
  *Notes*: short why/impact/testing
```
Remove empty sections before saving.

### 5.8 Handy Commands
```bash
# Show last N commit subjects + hashes (the ones you just created)
git log -n 5 --pretty=format:'%h %s'

# Files changed in a specific commit
git show --name-only --pretty=format:'' <HASH> | sed '/^$/d'

# Diffstat summary for notes
git show --stat --oneline <HASH>
```
If the summarized commits live in the sibling product repo, run the same commands with `git -C ../your-product-repo ...`.

### 5.9 Optional Scaffolding (adjust header after user confirmation)

**Batch the last N commits under one new release header**
```bash
N=3
DATE=$(date +"%Y-%m-%d")
LAST_TITLE=$(grep -E '^## Release [0-9]+\.[0-9]+ -- ' .documents/CHANGELOG.md | sort -V -k3,3 | tail -n1)

if [ -z "$LAST_TITLE" ]; then
  MAJOR=0; MINOR=0
else
  MAJOR=$(echo "$LAST_TITLE" | awk '{print $3}' | cut -d'.' -f1)
  MINOR=$(echo "$LAST_TITLE" | awk '{print $3}' | cut -d'.' -f2)
fi

# Default to patch bump; override to $((MAJOR+1)).0 if the user wants a larger release
NEXT_TITLE="Release ${MAJOR}.$((MINOR+1))"

COMMITS=$(git log -n $N --pretty=format:'- `%h` - **%s**' | sed 's/(.*): /: /')
TMP=$(mktemp)

{
  echo "## $NEXT_TITLE -- $DATE"
  echo
  echo "### Added"
  echo "### Changed"
  echo "### Fixed"
  echo "### Docs"
  echo "### Tooling"
  echo "### Tickets"
  echo "### Build"
  echo "### CI"
  echo "### Test"
  echo
  echo "#### Commit details"
  echo "$COMMITS"
  echo
} > "$TMP"

# Prepend to CHANGELOG (newest on top)
if [ -f .documents/CHANGELOG.md ]; then
  awk 'NR==1{print; system("cat '"$TMP"'"); next}1' .documents/CHANGELOG.md > "$TMP.prepended"
  mv "$TMP.prepended" .documents/CHANGELOG.md
else
  mkdir -p .documents
  {
    echo "# Changelog"
    echo
    echo "All notable changes to Project are documented here."
    echo
    cat "$TMP"
  } > .documents/CHANGELOG.md
fi

rm "$TMP"
```
If the summarized commits live in the sibling product repo, use `git -C ../your-product-repo log ...` in place of `git log ...`.

After scaffolding, open the file, move bullets into correct sections, drop empties, and confirm the header with the user.

### 5.10 Commit the Changelog Update
```bash
git add .documents/CHANGELOG.md
git commit -m "docs(changelog): update release notes for X.Y"
git log --oneline -n 3
```

**Checklist**
- [ ] Version header uses the confirmed release bump and today's date.
- [ ] Only sections with bullets are present.
- [ ] Bullets are imperative and concise; include why when non-obvious.
- [ ] Ticket/Plan references included or confirmed with the user.
- [ ] Commit hashes and useful notes included under **Commit details**.
- [ ] Only `.documents/CHANGELOG.md` was staged for this commit.

---
