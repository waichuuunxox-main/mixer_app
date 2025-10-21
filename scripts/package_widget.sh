#!/usr/bin/env bash
# Package the ios/WidgetExample directory into artifacts/widget_example.zip
set -euo pipefail
ARTIFACT_DIR=artifacts
SRC_DIR=ios/WidgetExample
OUT_ZIP="$ARTIFACT_DIR/widget_example.zip"

mkdir -p "$ARTIFACT_DIR"
rm -f "$OUT_ZIP"

echo "Creating $OUT_ZIP from $SRC_DIR"
cd "$SRC_DIR"
zip -r -q "$(pwd)/../../$OUT_ZIP" .
cd - >/dev/null

echo "Created $OUT_ZIP"
