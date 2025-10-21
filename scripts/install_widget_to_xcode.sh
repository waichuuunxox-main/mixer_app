#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <AppGroupId> <XcodeWidgetTargetDir> [--overwrite]"
  echo "Example: $0 group.com.yourcompany.mixzer /path/to/YourXcodeProject/Widgets/MixzerWidget --overwrite"
  exit 1
fi

APP_GROUP=$1
TARGET_DIR=$2
OVERWRITE=false
if [ "${3:-}" = "--overwrite" ]; then
  OVERWRITE=true
fi

SRC_DIR=$(cd "$(dirname "$0")/../ios/WidgetExample" && pwd)

echo "Installing widget example from $SRC_DIR to $TARGET_DIR"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Target directory $TARGET_DIR does not exist"
  exit 2
fi

# Copy files
if [ "$OVERWRITE" = true ]; then
  echo "Overwriting existing files in $TARGET_DIR"
  rm -f "$TARGET_DIR"/*.swift || true
  rm -f "$TARGET_DIR/Info.plist" || true
fi

cp -v "$SRC_DIR"/*.swift "$TARGET_DIR"
cp -v "$SRC_DIR/Info-Widget.plist" "$TARGET_DIR/Info.plist"

# Replace App Group identifier
for f in "$TARGET_DIR"/*.swift; do
  if [ -f "$f" ]; then
    sed -i '' "s|group.com.example.mixzer|$APP_GROUP|g" "$f" || true
  fi
done

# Regenerate the packaged artifact with the requested App Group
(cd "$SRC_DIR" && zip -r "$(pwd)/../../artifacts/widget_example.zip" .)

echo "Widget installed to $TARGET_DIR and App Group set to $APP_GROUP"

echo "Remember to open Xcode, set the widget target's bundle identifier and signing team, and enable the App Group in both app and widget targets."
