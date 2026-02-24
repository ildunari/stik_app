# AGENTS.md

## Scope
These instructions apply to this repository (`stik_app`) and all subdirectories.

## Working Rules
- Keep diffs minimal and focused on the requested behavior.
- Prefer patch-style edits over broad file rewrites.
- Do not reformat unrelated files.
- Run targeted verification after changes (`cargo check` for Rust/Tauri changes).

## Local Build + Install
- Dev run: `npm run tauri dev`
- Install local build to `/Applications/Stik.app`: `npm run install:local`
- Global shortcut command (from anywhere): `install-stik`
- Parity preflight command: `npm run parity:preflight`

## Branching + Parity
- Keep `main` close to upstream-compatible state.
- Put custom features on topic branches, then merge back after review.
- Rebase or merge upstream `0xMassi/main` regularly to maintain parity.

## Mandatory Session-Start Parity Preflight
- On every new session/run in this repository, do this first before feature work:
  1. Run `npm run parity:preflight` (canonical preflight script).
  2. Compare official upstream (`upstream/main`) against current fork branch.
  3. Check whether divergence exists and summarize:
     - commits only in upstream
     - commits only in fork
     - files likely to conflict
- After that check, ask the user whether to run parity sync first before any other task.
- If user says yes, perform sync carefully so local tweaks persist:
  - Prefer merge/rebase strategy that keeps custom fork behavior intact.
  - Resolve conflicts by preserving local improvements unless upstream has an equivalent/better implementation.
  - If upstream now includes the same feature, remove duplicate local patching to reduce maintenance burden.
- Never skip the session-start parity check in this repo.
