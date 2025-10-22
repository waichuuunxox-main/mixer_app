# Mixzer — Football app

Mixzer is a Flutter starter app that shows football information (results, fixtures, top scorers) and includes a sample integration path for native iOS/macOS widgets (WidgetKit).

## What I added in this iteration

- Data models: `Match`, `Player`
- Mock service: `lib/services/mock_service.dart` (sample data for development)
- Main UI: `lib/pages/home_page.dart` with tabs for Results/Fixtures/Scorers
- Widgets: `lib/widgets/match_card.dart`, `scorer_card.dart`, and an in-app preview `today_card.dart`
- Flutter -> Native sync: `lib/services/widget_sync.dart` (MethodChannel helper)
- iOS example: `ios/WidgetExample/WidgetProvider.swift` and `ios/README_WIDGET_SETUP.md` showing how to create a Widget extension and read a shared JSON file
- API skeleton: `lib/services/api_service.dart` (replace with a real API base URL and key)

## Run locally

Install dependencies and run:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```


### macOS

To run the macOS app locally you need Xcode and Flutter installed. A helper script is provided:

```bash
chmod +x scripts/run_macos.sh
./scripts/run_macos.sh
```

If you don't have a macOS dev environment you can use the provided GitHub Actions workflow to build a macOS release artifact:

1. Push your changes to GitHub.  
2. In GitHub go to Actions → Build macOS → Run workflow.  
3. After the workflow completes download the `mixzer_macos_release.zip` artifact.

For full macOS development instructions (environment setup, signing, debugging, and troubleshooting), see `docs/macos_development.md`.


## Push to your GitHub repository

If you want to publish this project to your GitHub repository (for example `https://github.com/waichuuunxox-main/mixer_app.git`), run:

```bash
# add remote and push
git remote add origin https://github.com/waichuuunxox-main/mixer_app.git
git branch -M main
git push -u origin main
```

After pushing, you can trigger the `Publish Widget Artifact` workflow from the GitHub Actions tab (it is configured as a manual `workflow_dispatch`): choose a tag (e.g. `v1.0.0`) and run the workflow to create a release and upload `artifacts/widget_example.zip`.

## Widget (iOS/macOS) integration overview

1. Create an App Group in Xcode and enable it for the Runner target and the Widget target.
2. Add a Widget Extension target (SwiftUI) in Xcode.
3. Copy `ios/WidgetExample/WidgetProvider.swift` into your widget target and update the App Group identifier.
4. From Flutter call `WidgetSync.writeSummary({...})` (or use the AppBar sync button) — the native iOS code in `AppDelegate.swift` writes `mixzer_widget_summary.json` into the App Group container.

See `ios/README_WIDGET_SETUP.md` for step-by-step instructions.

## Widget assets & Info.plist

- When creating a Widget target, add an Info.plist (see `ios/WidgetExample/Info-Widget.plist` as an example).
- Provide a 1x/2x/3x set of icons for the widget if needed (use `Assets.xcassets` inside the widget target). Common sizes: 40x40, 80x80, 120x120 for thumbnails; full app icon sizes for large assets.

## Prepackaged widget example

For convenience this repo contains a prepackaged widget example you can drop into Xcode:

- `artifacts/widget_example.zip` — contains the Swift files and example Info.plist from `ios/WidgetExample/`.

To use it:

```bash
# unzip into your widget target folder (replace path accordingly)
unzip artifacts/widget_example.zip -d /path/to/YourXcodeProject/Widgets/MixzerWidget
```

Then follow the steps in `docs/WIDGET_BUNDLE.md` to set the App Group, update identifiers, and wire up signing.

## Pull-to-refresh & auto-sync

- The app supports pull-to-refresh on the main lists; when a refresh succeeds the app will update the widget summary via MethodChannel. Use the top-right sync button to force a sync immediately.

## Automation & CI

This repo includes a sample GitHub Actions workflow at `.github/workflows/flutter-ci.yml` which runs `flutter pub get`, `flutter analyze`, and `flutter test` on pushes and PRs to `main`.

Local helper scripts:

- `scripts/run_checks.sh` — runs `flutter pub get`, `flutter analyze`, `flutter test` locally.
- `scripts/copy_widget_to_xcode.sh /path/to/WidgetTarget` — copies the example Swift widget files into your Xcode widget target directory (you still need to set App Group and bundle id in Xcode).

Use these to keep CI and local checks consistent.

## Switch to real API

Implement `ApiService` by supplying an API key and base URL. Replace usages of `MockService` with `ApiService` when ready. See `lib/services/api_service.dart` for a skeleton using `http`.

## Next steps (you can ask me to implement any):

- Scaffold the Widget target Swift files and wiring (I can produce the exact Swift files to paste into Xcode).
- Add persistent caching for offline access (Hive / sqflite)
- Integrate a real football API and add authentication handling
- Improve UI/animations and add macOS-specific layouts
