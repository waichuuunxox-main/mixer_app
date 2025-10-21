# PR: chore(widget): add mixzer_widget target and automation scripts

## Overview
This PR adds a sample WidgetKit extension (`mixzer_widget`) and automation scripts to help package and safely insert the widget into the Xcode project.

## Changes
- Added widget example files (macOS Runner target):
  - `macos/Runner/mixzer_widget/Info.plist`
  - `macos/Runner/mixzer_widget/Widget.swift`
  - `macos/Runner/mixzer_widget/mixzer_widget.entitlements`
- Added automation scripts:
  - `scripts/finalize_widget.sh` — parameterized finalize script (supports `--bundle-id`, `--app-group`, `--team`, `--dry-run`).
  - `scripts/ci_widget_dryrun.sh` — CI helper script that runs finalize in `--dry-run` and fails when pbxproj diffs exist.
- Modified:
  - `macos/Runner.xcodeproj/project.pbxproj` — added PBX entries for the widget target and files.

## Why
Automates the repetitive steps of adding a WidgetKit extension to the macOS target and makes the process reproducible and verifiable in CI.

## Important notes / Reviewer checklist
- Open `macos/Runner.xcodeproj` in Xcode and verify:
  - `mixzer_widget` target exists
  - Signing & Capabilities: set correct Development Team and add App Group (default `group.com.waichuuun.mixzer`)
  - `Widget.swift` is present in Build Phases -> Sources
- The finalize script creates a timestamped backup under `.pbxproj_backups/` before making any pbxproj changes.
- The CI script `scripts/ci_widget_dryrun.sh` will run the finalize script in dry-run and fail the job when unexpected pbxproj diffs appear.

## How to test locally
1. Run finalize script in dry-run mode:

```bash
./scripts/finalize_widget.sh --dry-run
```

2. Run CI dry-run locally (will return non-zero exit code if diffs exist):

```bash
./scripts/ci_widget_dryrun.sh
```

3. Open Xcode and verify the widget target & signing.

## Merge notes
- After merging, run finalize (non-dry-run) locally to ensure pbxproj is consistent:

```bash
./scripts/finalize_widget.sh --bundle-id com.waichuuun.mixzer.widget --app-group group.com.waichuuun.mixzer
```

---

*Auto-generated PR draft file.*
