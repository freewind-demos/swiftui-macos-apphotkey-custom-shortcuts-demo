#!/usr/bin/env bash

set -euo pipefail

export DEVELOPER_DIR=/System/Volumes/Data/Applications/Xcode.app/Contents/Developer

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME="SwiftUIAppHotkeyCustomShortcutsDemo"
PROJECT_PATH="$ROOT_DIR/${PROJECT_NAME}.xcodeproj"
SCHEME="$PROJECT_NAME"
BUILD_DIR="$ROOT_DIR/.build/DerivedData"

cd "$ROOT_DIR"

rtk xcodegen generate

rtk xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -configuration Debug \
  -derivedDataPath "$BUILD_DIR" \
  build

APP_PATH="$(rtk fd -a "${PROJECT_NAME}.app" "$BUILD_DIR/Build/Products/Debug" -t d | rtk head -n 1)"

if [[ -n "${APP_PATH}" ]]; then
  rtk open "$APP_PATH"
fi
