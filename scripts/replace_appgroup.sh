#!/usr/bin/env bash
# Replace APP_GROUP_PLACEHOLDER in Swift files with provided App Group ID
# Usage: ./scripts/replace_appgroup.sh group.com.yourcompany.mixzer
set -euo pipefail
if [ $# -ne 1 ]; then
  echo "Usage: $0 <app_group_id>"
  exit 1
fi
APP_GROUP=$1
SRC_DIR=ios/WidgetExample
echo "Replacing placeholder App Group with $APP_GROUP in $SRC_DIR"
for f in "$SRC_DIR"/*.swift; do
  sed -i '' "s|group.com.example.mixzer|$APP_GROUP|g" "$f" || true
done
# regenerate artifacts zip
./scripts/package_widget.sh

echo "Done. Updated files and regenerated artifacts/widget_example.zip"
