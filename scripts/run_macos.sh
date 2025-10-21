#!/usr/bin/env bash
set -euo pipefail

echo "Checking prerequisites for running Mixzer macOS app..."

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found. Install Flutter and ensure it's on PATH: https://flutter.dev/docs/get-started/install"
  exit 2
fi

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild not found. You need Xcode / Xcode command line tools installed to run macOS builds."
  echo "Install Xcode from the App Store and run 'sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer'"
  exit 3
fi

echo "Running flutter pub get..."
flutter pub get

echo "Launching app on macOS (debug). Use Ctrl+C to quit."
flutter run -d macos
