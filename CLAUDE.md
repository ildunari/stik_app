# CLAUDE.md

## Project Intent
Personal fork of Stik for iterative customization while preserving the ability to sync with upstream.

## Daily Workflow
1. Run parity preflight first (required every session):
   - Run `npm run parity:preflight`.
   - Fetch both remotes and compare `upstream/main` vs current fork branch.
   - Detect divergence (ahead/behind/possible conflicts).
   - Ask user: "Do you want me to run parity sync first before new work?"
2. Build/test quickly with `npm run tauri dev`.
3. Install tested build using `npm run install:local` (or `install-stik`).
4. Commit small, focused changes.

## Upstream Sync Strategy
- Add upstream remote once:
  - `git remote add upstream https://github.com/0xMassi/stik_app.git`
- Sync loop:
  - `git fetch upstream`
  - `git checkout main`
  - `git merge upstream/main` (or rebase if preferred)
  - `git push origin main`
- Keep custom features isolated in branches to reduce merge conflicts.
- Preserve local tweaks when syncing:
  - Keep fork-only enhancements unless upstream has already implemented an equivalent.
  - If upstream added equivalent functionality, remove local duplicate patches and adopt upstream implementation.
  - Resolve conflicts intentionally; do not blindly accept one side.

## Explicit User Context
- The user does not want to manually manage parity.
- Agents should proactively check for upstream updates and fork divergence at the start of every session/run.
- Agents must ask whether to execute parity sync first before any other coding task.

## Notes
- Installed app path: `/Applications/Stik.app`
- Repo path: `/Users/kosta/LocalDev/stik_app`
- Parity preflight script: `scripts/parity-preflight.sh`
