#!/usr/bin/env bash
# Usage: ./copy_widget_to_xcode.sh /path/to/YourXcodeProject/WidgetTarget
set -euo pipefail
if [ $# -ne 1 ]; then
  echo "Usage: $0 /path/to/WidgetTarget"
  exit 1
fi
TARGET_DIR=$1
echo "Copying widget example files to $TARGET_DIR"
cp -v ios/WidgetExample/*.swift "$TARGET_DIR"
cp -v ios/WidgetExample/Info-Widget.plist "$TARGET_DIR/Info.plist"
echo "Done. Remember to set App Group and bundle identifiers in Xcode."
