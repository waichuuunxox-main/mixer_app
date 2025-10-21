#!/usr/bin/env bash
set -euo pipefail

echo "This script helps to build a macOS release using flutter and package the .app into a zip." 

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found. Install Flutter and ensure it's on PATH"
  exit 1
fi

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild not found. You need Xcode installed to build macOS releases."
  exit 2
fi

echo "Running flutter pub get..."
flutter pub get

echo "Building macOS release..."
flutter build macos --release

APP_PATH=build/macos/Build/Products/Release/macos/Runner.app
OUT_DIR=artifacts
mkdir -p "$OUT_DIR"
ZIP_NAME="$OUT_DIR/mixzer_macos_release.zip"

if [ ! -d "$APP_PATH" ]; then
  echo "Could not find built app at $APP_PATH"
  exit 3
fi

echo "Packaging $APP_PATH -> $ZIP_NAME"
cd "$APP_PATH"/.. || exit 4
zip -r "$(pwd)/../../$ZIP_NAME" Runner.app
cd - >/dev/null

echo "Packaged release artifact: $ZIP_NAME"

echo "NOTE: For App Store or notarization you must sign and notarize the build in Xcode with your Apple Developer account."
