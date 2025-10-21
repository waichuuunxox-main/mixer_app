#!/usr/bin/env bash
# Build release artifact for iOS/macOS and package widget Swift files.
# Usage: ./scripts/build_release.sh ios|macos /path/to/xcode/WidgetTarget
set -euo pipefail
if [ $# -lt 1 ]; then
  echo "Usage: $0 <platform: ios|macos> [widget_target_path]"
  exit 1
fi
PLATFORM=$1
WIDGET_DIR=${2:-}

echo "Running flutter pub get and building for $PLATFORM"
flutter pub get
if [ "$PLATFORM" = "ios" ]; then
  flutter build ipa --release
elif [ "$PLATFORM" = "macos" ]; then
  flutter build macos --release
else
  echo "Unsupported platform: $PLATFORM"
  exit 2
fi

if [ -n "$WIDGET_DIR" ]; then
  echo "Packaging widget example files into $WIDGET_DIR"
  mkdir -p "$WIDGET_DIR"
  cp -v ios/WidgetExample/*.swift "$WIDGET_DIR" || true
  cp -v ios/WidgetExample/Info-Widget.plist "$WIDGET_DIR/Info.plist" || true
  echo "Widget files copied. Remember to set App Group and bundle identifiers in Xcode."
fi

echo "Build finished."
