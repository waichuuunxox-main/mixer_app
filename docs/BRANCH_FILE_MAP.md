# Branch → File Map

This file summarizes which files were assigned to each split branch during the PR split.

split/automation-native
-----------------------
- `.github/workflows/*` (CI + publish workflows)
- `macos/Runner/*` (AppDelegate, entitlements, widget extension files)
- `scripts/*` (widget injection, ci dry-run, helpers)
- `.pbxproj_backups/*`, `artifacts/*`
- `lib/services/widget_sync.dart`, `test/widget_sync_test.dart`

split/ui-glam
-------------
- `lib/widgets/*` (GlassCard, major cards)
- `assets/fonts/*` (Noto Sans)
- `lib/theme/*`, `lib/pages/*`, `lib/main.dart`
- `pubspec.yaml` (fonts and asset references)

If something appears mis-assigned, please notify and I will adjust the branch contents before finalizing PRs.
