# PR: UI + Glam — GlassCard and visual polish

Summary
-------
This PR contains UI-focused, non-breaking visual changes to the Flutter app:

- `GlassCard` component and related visual refactors for major cards.
- Embedded Noto Sans fonts and theme updates to match the glam look-and-feel.
- Visual-only changes — ideally reviewed separately from native/automation changes.

Must-check (reviewer checklist)
--------------------------------
- [ ] Verify visuals across screen sizes, including accessibility font scaling.
- [ ] Run `flutter analyze` and `flutter test`.
- [ ] Run the app and confirm `GlassCard` performance on macOS/iOS devices (especially with blur/backdrop filters).

How to test locally
--------------------
```bash
flutter pub get
flutter run -d macos
flutter run -d ios
```

Notes
-----
- This PR intentionally does not modify native pbxproj; any small build settings changes were avoided.
