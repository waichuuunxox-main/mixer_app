#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  cat <<EOF
Usage: $0 <AppGroupId> <XcodeWidgetTargetDir> [--overwrite]
Example: $0 group.com.yourcompany.mixzer /path/to/YourXcodeProject/Widgets/MixzerWidget --overwrite

This script copies the repo's Widget example files into an existing Xcode widget target
and replaces the placeholder App Group identifier inside the Swift files. It does NOT
automatically change Xcode project files (you still need to open Xcode and set the
widget target's bundle identifier and signing team).
EOF
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

# Copy files (optionally overwrite)
if [ "$OVERWRITE" = true ]; then
  echo "Overwriting existing files in $TARGET_DIR"
  find "$TARGET_DIR" -maxdepth 1 -type f -name "*.swift" -print0 | xargs -0 rm -f || true
  rm -f "$TARGET_DIR/Info.plist" || true
fi

cp -v "$SRC_DIR"/*.swift "$TARGET_DIR"
cp -v "$SRC_DIR/Info-Widget.plist" "$TARGET_DIR/Info.plist"

# Replace App Group identifier placeholder inside the copied Swift files
# Supports both placeholder 'group.com.example.mixzer' and 'APP_GROUP_PLACEHOLDER'
for f in "$TARGET_DIR"/*.swift; do
  if [ -f "$f" ]; then
    sed -i '' "s|group.com.example.mixzer|$APP_GROUP|g" "$f" || true
    sed -i '' "s|APP_GROUP_PLACEHOLDER|$APP_GROUP|g" "$f" || true
  fi
done

# Regenerate the packaged artifact for distribution/attachment if the artifacts dir exists
ARTIFACTS_DIR=$(cd "$(dirname "$0")/.." && pwd)/artifacts
mkdir -p "$ARTIFACTS_DIR"
(cd "$SRC_DIR" && zip -r "$ARTIFACTS_DIR/widget_example.zip" .) >/dev/null

echo "Widget installed to $TARGET_DIR and App Group set to $APP_GROUP"
echo "Artifact created at: $ARTIFACTS_DIR/widget_example.zip"

echo "Next steps: open Xcode, set the widget target's bundle identifier and signing team, enable the App Group"
echo "(both in the main app and the widget target). Then build the project in Xcode once."
