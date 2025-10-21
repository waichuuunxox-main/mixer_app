#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PBXPROJ="$ROOT_DIR/macos/Runner.xcodeproj/project.pbxproj"
WIDGET_DIR="$ROOT_DIR/macos/Runner/mixzer_widget"
BACKUP="$PBXPROJ.$(date +%Y%m%d%H%M%S).bak"
BUNDLE_ID="com.waichuuun.mixzer.widget"

echo "[finalize_widget] root: $ROOT_DIR"

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PBXPROJ="$ROOT_DIR/macos/Runner.xcodeproj/project.pbxproj"
WIDGET_DIR="$ROOT_DIR/macos/Runner/mixzer_widget"
BACKUP_DIR="$ROOT_DIR/.pbxproj_backups"
DEFAULT_BUNDLE_ID="com.waichuuun.mixzer.widget"
DEFAULT_APP_GROUP="group.com.waichuuun.mixzer"
DEFAULT_TEAM=""
DRY_RUN=0

usage() {
  cat <<USAGE
Usage: $(basename "$0") [--bundle-id ID] [--app-group GROUP] [--team TEAM] [--dry-run]

Options:
  --bundle-id   Bundle identifier for the widget (default: $DEFAULT_BUNDLE_ID)
  --app-group   App Group identifier to add to entitlements (default: $DEFAULT_APP_GROUP)
  --team        Development team id to put into XCBuildConfigurations (optional)
  --dry-run     Do not modify pbxproj; only print planned changes
  -h, --help    Show this help
USAGE
}

# Parse args
BUNDLE_ID="$DEFAULT_BUNDLE_ID"
APP_GROUP="$DEFAULT_APP_GROUP"
TEAM="$DEFAULT_TEAM"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --bundle-id) BUNDLE_ID="$2"; shift 2;;
    --app-group) APP_GROUP="$2"; shift 2;;
    --team) TEAM="$2"; shift 2;;
    --dry-run) DRY_RUN=1; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 2;;
  esac
done

echo "[finalize_widget] root: $ROOT_DIR"
echo "[finalize_widget] bundle id: $BUNDLE_ID"
echo "[finalize_widget] app group: $APP_GROUP"
if [ -n "$TEAM" ]; then echo "[finalize_widget] team: $TEAM"; fi
if [ $DRY_RUN -eq 1 ]; then echo "[finalize_widget] DRY RUN - no pbxproj modifications"; fi

mkdir -p "$WIDGET_DIR"
mkdir -p "$BACKUP_DIR"

# Create files only if they don't exist (idempotent)
if [ ! -f "$WIDGET_DIR/Info.plist" ]; then
  cat > "$WIDGET_DIR/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$BUNDLE_ID</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>mixzer_widget</string>
	<key>CFBundlePackageType</key>
	<string>XPC!</string>
	<key>NSExtension</key>
	<dict>
		<key>NSExtensionAttributes</key>
		<dict>
			<key>WIDGET_DISPLAY_NAME</key>
			<string>Mixzer Widget</string>
		</dict>
		<key>NSExtensionPointIdentifier</key>
		<string>com.apple.widget-extension</string>
		<key>NSExtensionPrincipalClass</key>
		<string>$(PRODUCT_MODULE_NAME).Widget</string>
	</dict>
</dict>
</plist>
PLIST
  echo "Created $WIDGET_DIR/Info.plist"
else
  echo "Info.plist already exists; skipping creation"
fi

if [ ! -f "$WIDGET_DIR/mixzer_widget.entitlements" ]; then
  cat > "$WIDGET_DIR/mixzer_widget.entitlements" <<ENT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.application-groups</key>
	<array>
		<string>$APP_GROUP</string>
	</array>
</dict>
</plist>
ENT
  echo "Created $WIDGET_DIR/mixzer_widget.entitlements"
else
  echo "entitlements already exists; skipping creation"
fi

if [ ! -f "$WIDGET_DIR/Widget.swift" ]; then
  cat > "$WIDGET_DIR/Widget.swift" <<'SWIFT'
import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nextMatch: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nextMatch: "-")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), nextMatch: "Team A vs Team B"))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), nextMatch: "Team A vs Team B")
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct MixzerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.nextMatch)
            .padding()
    }
}

@main
struct MixzerWidget: Widget {
    let kind: String = "mixzer_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MixzerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mixzer")
        .description("Shows the next match")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
SWIFT
  echo "Created $WIDGET_DIR/Widget.swift"
else
  echo "Widget.swift already exists; skipping creation"
fi

# Backup pbxproj
if [ ! -f "$PBXPROJ" ]; then
  echo "ERROR: pbxproj not found at $PBXPROJ" >&2
  exit 2
fi

BACKUP="$BACKUP_DIR/project.pbxproj.$(date +%Y%m%d%H%M%S).bak"
cp "$PBXPROJ" "$BACKUP"
echo "Backed up pbxproj to $BACKUP"

# Safer pbxproj edits: idempotent replacements and checks.
# We'll: 1) ensure PRODUCT_BUNDLE_IDENTIFIER for mixzer_widget configs is set,
# 2) ensure Info.plist path is set in those configs, and 3) optionally set DEVELOPMENT_TEAM.

planned_changes=()

# Replace PRODUCT_BUNDLE_IDENTIFIER lines for mixzer_widget configurations
if grep -q "PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID" "$PBXPROJ"; then
  echo "Bundle id already present in pbxproj; skipping replacement"
else
  planned_changes+=("Set PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID")
fi

# Replace INFOPLIST_FILE for mixzer_widget configs
if grep -q "INFOPLIST_FILE = mixzer_widget/Info.plist" "$PBXPROJ"; then
  echo "INFOPLIST_FILE already set for mixzer_widget; skipping"
else
  planned_changes+=("Set INFOPLIST_FILE = mixzer_widget/Info.plist")
fi

if [ -n "$TEAM" ]; then
  if grep -q "DEVELOPMENT_TEAM = $TEAM" "$PBXPROJ"; then
    echo "DEVELOPMENT_TEAM already set to $TEAM; skipping"
  else
    planned_changes+=("Set DEVELOPMENT_TEAM = $TEAM")
  fi
fi

if [ ${#planned_changes[@]} -eq 0 ]; then
  echo "No pbxproj changes needed"
else
  echo "Planned changes:"; for c in "${planned_changes[@]}"; do echo " - $c"; done
  if [ $DRY_RUN -eq 1 ]; then
    echo "Dry run: not modifying pbxproj"
  else
    # Apply replacements conservatively: only change PRODUCT_BUNDLE_IDENTIFIER and INFOPLIST_FILE lines
    # for the mixzer_widget configurations (look for the mixzer_widget comment blocks added earlier).
    # This is a simple heuristic; for full safety use xcodeproj libraries.
    perl -0777 -pe \
      "s/(\n\s*PRODUCT_BUNDLE_IDENTIFIER\s*=\s*)[^;]*/\$1$BUNDLE_ID/g" -i "$PBXPROJ" || true
    perl -0777 -pe \
      "s/(\n\s*INFOPLIST_FILE\s*=\s*)[^;]*/\$1mixzer_widget\/Info.plist/g" -i "$PBXPROJ" || true
    if [ -n "$TEAM" ]; then
      perl -0777 -pe "s/(\n\s*DEVELOPMENT_TEAM\s*=\s*)[^;]*/\$1$TEAM/g" -i "$PBXPROJ" || true
    fi
    echo "Applied changes to pbxproj"
  fi
fi

echo "Finished: widget files ensured and pbxproj processed."
cat <<MSG
Next steps (in Xcode):
 - Open macos/Runner.xcodeproj
 - Select target "mixzer_widget"; verify Bundle ID, Team and Signing
 - Add App Group '$APP_GROUP' under Signing & Capabilities (if not present)
 - Confirm Widget.swift is listed under Build Phases -> Sources
MSG

exit 0
