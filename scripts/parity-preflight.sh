#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

if ! git remote get-url upstream >/dev/null 2>&1; then
  echo "Error: upstream remote is missing."
  echo "Run: git remote add upstream https://github.com/0xMassi/stik_app.git"
  exit 1
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

echo "==> Fetching latest refs from origin + upstream..."
git fetch --prune origin
git fetch --prune upstream

echo "==> Comparing branch '$CURRENT_BRANCH' against 'upstream/main'"

echo
echo "--- Ahead/Behind ---"
git rev-list --left-right --count "upstream/main...$CURRENT_BRANCH" | awk '{print "upstream-only commits: "$1"\nfork-only commits: "$2}'

echo
echo "--- Upstream-only commits (top 20) ---"
git log --oneline "$CURRENT_BRANCH..upstream/main" | head -20 || true

echo
echo "--- Fork-only commits (top 20) ---"
git log --oneline "upstream/main..$CURRENT_BRANCH" | head -20 || true

echo
echo "--- Likely conflicting files (name-only diff) ---"
git diff --name-only "upstream/main...$CURRENT_BRANCH" | head -200 || true

echo
echo "Preflight complete. Ask user: run parity sync first?"
