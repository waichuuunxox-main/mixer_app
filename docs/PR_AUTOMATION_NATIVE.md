# PR: Automation + Native — WidgetKit automation, pbxproj changes, native sync

Summary
-------
This PR contains the automation and native pieces required to add a WidgetKit extension safely and keep Flutter → native widget sync working:

- Scripts to inject/validate a WidgetKit extension into Xcode project files in an idempotent way (under `scripts/`).
- Native `MethodChannel` handler and entitlements to write widget JSON summaries into the App Group container.
- CI workflow to run `flutter analyze`, `flutter test`, and a pbxproj dry-run.

Must-check (reviewer checklist)
--------------------------------
- [ ] Verify the pbxproj textual patch is expected: inspect `.pbxproj_backups/` and `artifacts/pbx_widget_patch.diff`.
- [ ] Run locally: `./scripts/ci_widget_dryrun.sh` and confirm no unexpected edits.
- [ ] Confirm App Group id in `macos/Runner/AppDelegate.swift` and entitlements matches the App Group used by the widget (`group.com.waichuuun.mixzer`).
- [ ] Run `flutter analyze` and `flutter test` (unit tests include `test/widget_sync_test.dart`).
- [ ] Validate entitlements files (`macos/Runner/*.entitlements`, `ios/Runner/*.entitlements`) do not leak secrets.

How to test locally
--------------------
1. From repo root:

```bash
flutter pub get
flutter analyze
flutter test
./scripts/ci_widget_dryrun.sh
```

2. For macOS runtime check: `flutter run -d macos --verbose` and open `logs/macos_run_verbose_after_glam_run.log` to look for `[WidgetSync] writeSummary payload` messages.

Rollback guidance
-----------------
- If pbxproj edits cause issues, revert the commit and restore the most recent `.pbxproj_backups/` snapshot: remove the unwanted changes and re-run the injection script after fixing the patch.

Important notes for reviewers
---------------------------
- The pbxproj modification scripts create timestamped backups under `.pbxproj_backups/` in the repo. Inspect the backup corresponding to this change.
- Prefer merging automation/native first so CI can validate pbxproj edits before UI changes are merged.
