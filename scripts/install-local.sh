#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

APP_NAME="Stik.app"
APP_DEST="/Applications/${APP_NAME}"
BACKUP_SUFFIX="$(date +%Y%m%d-%H%M%S)"
DARWINKIT_SRC="src-tauri/darwinkit/.build/release/darwinkit"
DARWINKIT_DEST="src-tauri/binaries/darwinkit-aarch64-apple-darwin"

echo "==> Ensuring DarwinKit sidecar is built..."
git submodule update --init --recursive
mkdir -p src-tauri/binaries
(
  cd src-tauri/darwinkit
  swift build -c release
)
cp "$DARWINKIT_SRC" "$DARWINKIT_DEST"
chmod +x "$DARWINKIT_DEST"

echo "==> Building Tauri app bundle..."
npm run tauri build

APP_SRC="$(find src-tauri/target/release/bundle -type d -name "$APP_NAME" | head -n 1 || true)"
if [[ -z "$APP_SRC" ]]; then
  echo "Error: built app bundle not found under src-tauri/target/release/bundle"
  exit 1
fi

echo "==> Quitting running Stik process (if any)..."
osascript -e 'tell application "Stik" to quit' >/dev/null 2>&1 || true
pkill -x stik >/dev/null 2>&1 || true
sleep 1

if [[ -d "$APP_DEST" ]]; then
  BACKUP_PATH="${APP_DEST}.backup-${BACKUP_SUFFIX}"
  echo "==> Backing up existing app to: $BACKUP_PATH"
  mv "$APP_DEST" "$BACKUP_PATH"
fi

echo "==> Installing new build to $APP_DEST"
cp -R "$APP_SRC" "$APP_DEST"
xattr -dr com.apple.quarantine "$APP_DEST" >/dev/null 2>&1 || true

echo "Done. Installed: $APP_DEST"
echo "Tip: run 'open \"$APP_DEST\"' to launch it."
