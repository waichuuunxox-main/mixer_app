#!/usr/bin/env bash
# Script: scripts/add_widget_target_to_pbxproj.sh
# Purpose: Create a safe helper that inserts a minimal Widget extension PBX target fragment
# into macos/Runner.xcodeproj/project.pbxproj. The script creates a backup and writes a
# separate patch file (pbx_fragment.txt) that can be manually inspected and applied.

set -euo pipefail

PBX_PATH="macos/Runner.xcodeproj/project.pbxproj"
BACKUP_PATH="${PBX_PATH}.backup-$(date +%Y%m%d%H%M%S)"
FRAGMENT_OUT="artifacts/pbx_widget_fragment.txt"

if [ ! -f "$PBX_PATH" ]; then
  echo "Error: $PBX_PATH not found. Run this script from the repo root."
  exit 1
fi

mkdir -p artifacts
cp "$PBX_PATH" "$BACKUP_PATH"

echo "Backup created at: $BACKUP_PATH"

cat > "$FRAGMENT_OUT" <<'PBX'
/*
Minimal PBX fragment to add a Widget extension target.
This fragment is illustrative — it needs correct UUIDs and references updated
for your project. Apply carefully or use Xcode to add an 'App Extension > WidgetKit Extension' target.
*/

/* Begin PBXFileReference section */
		WIDGET_FILE_REF_UUID /* WidgetExtension */ = {isa = PBXFileReference; lastKnownFileType = wrapper.app-extension; includeInIndex = 0; path = "MixzerWidget.appex"; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXNativeTarget section */
		WIDGET_NATIVE_TARGET_UUID /* MixzerWidget */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = WIDGET_BUILD_CONFIG_LIST_UUID /* Build configuration list for PBXNativeTarget "MixzerWidget" */;
			buildPhases = (
				WIDGET_SOURCES_PHASE_UUID /* Sources */,
				WIDGET_RESOURCES_PHASE_UUID /* Resources */,
			);
			dependencies = (
			);
			name = "MixzerWidget";
			productName = MixzerWidget;
			productReference = WIDGET_FILE_REF_UUID /* MixzerWidget.appex */;
			productType = "com.apple.product-type.app-extension";
		};
/* End PBXNativeTarget section */

/* Begin PBXSourcesBuildPhase section */
		WIDGET_SOURCES_PHASE_UUID /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin PBXResourcesBuildPhase section */
		WIDGET_RESOURCES_PHASE_UUID /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin XCConfigurationList section */
		WIDGET_BUILD_CONFIG_LIST_UUID /* Build configuration list for PBXNativeTarget "MixzerWidget" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				WIDGET_BUILD_CONFIG_DEBUG_UUID /* Debug */,
				WIDGET_BUILD_CONFIG_RELEASE_UUID /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */

PBX

echo "Wrote PBX fragment to: $FRAGMENT_OUT"

echo "IMPORTANT: This fragment is a template. To safely add a widget target please either:"
echo "  1) Open Xcode, add a new 'Widget Extension' target and then replace the generated files with the example widget source files."
echo "  2) Inspect $FRAGMENT_OUT, replace the placeholder UUIDs with new unique UUIDs and integrate the fragment into $PBX_PATH (advanced)."

echo "If you want, I can attempt to auto-insert the fragment now (risky). Reply 'apply' to let me try; otherwise run the script locally and review the fragment."

exit 0
