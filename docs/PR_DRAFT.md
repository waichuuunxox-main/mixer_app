# PR Draft: Add WidgetKit automation + macOS widget sync + glam UI

Summary
-------
This PR contains several related changes:

- Automation scripts to inject a WidgetKit extension into Xcode project files in an idempotent manner (`scripts/finalize_widget.sh`, `scripts/ci_widget_dryrun.sh`).
- Native macOS and iOS MethodChannel handler to receive JSON summaries from Flutter and write them into an App Group container (`mixzer_app/widget_sync`).
- A `GlassCard` Flutter widget and related UI updates to give a glamorous 2025 look across major cards.
- Helper script `scripts/clear_api_key.sh` and dev docs to switch the app to MockService when developing.

Why
---
Developers need an automated, safe way to add and validate WidgetKit targets and to have Flutter reliably sync data with native widgets. The UI changes are separate but included here for visual testing and widget preview.

How to review
-------------
1. Run `flutter analyze` and `flutter test` locally. Tests include a `widget_sync_test.dart` that mocks the MethodChannel.
2. Run `./scripts/ci_widget_dryrun.sh` to verify the pbxproj changes are a no-op or expected.
3. For macOS testing: `flutter run -d macos --verbose` and check `logs/macos_run_verbose_after_glam_run.log` for `[WidgetSync] writeSummary payload` messages.

Files of interest
-----------------
- `macos/Runner/AppDelegate.swift` — MethodChannel handler that writes `mixzer_widget_summary.json` into App Group container.
- `lib/services/widget_sync.dart` — Flutter wrapper for the channel.
- `lib/widgets/glass_card.dart` — New glam UI building block.
- `scripts/finalize_widget.sh`, `scripts/ci_widget_dryrun.sh`, `scripts/clear_api_key.sh` — automation and dev helpers.

CI
--
This repo now includes a GitHub Actions workflow `.github/workflows/ci.yml` that runs analyze, tests and the ci dry-run script.

Risks & Rollback
----------------
- The pbxproj script attempts textual edits; although backups are created, reviewers should carefully inspect changes before merging. If unwanted changes appear, revert the commit and restore the `.pbxproj_backups/` snapshot.

Notes
-----
I recommend splitting the PR into two if reviewers prefer: (1) automation + native changes and (2) UI/glam styling changes.
