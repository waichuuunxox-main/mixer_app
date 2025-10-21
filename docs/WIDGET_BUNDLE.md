# Widget bundle & Xcode checklist

This document describes how to add the example Widget Kit files from
`ios/WidgetExample/` into your Xcode Widget extension target and set up
App Group sharing.

Steps:

1. Create a new Widget Extension in Xcode
   - File > New > Target > Widget Extension (choose Swift and SwiftUI)
   - Name it e.g. `MixzerWidget`

2. Set App Group capability
   - Select both the main app target and the widget target
   - Signing & Capabilities -> + Capability -> App Groups
   - Create a new App Group like `group.com.yourcompany.mixzer`
   - Add the App Group to both targets

3. Copy widget example files
   - Use the included script:

```bash
./scripts/copy_widget_to_xcode.sh /path/to/YourXcodeProject/Widgets/MixzerWidget
```

   - Or manually copy `ios/WidgetExample/*.swift` into the widget target
   - Replace the `Info-Widget.plist` with your widget's Info.plist content

4. Update App Group identifier in Swift code
   - The widget example reads a shared JSON file from the App Group container.
   - Open `WidgetProvider.swift` and replace `group.com.example.mixzer` with
     your App Group identifier (e.g. `group.com.yourcompany.mixzer`).

5. Ensure bundle identifiers & signing are correct
   - Update bundle id for the widget target (e.g. `com.yourcompany.mixzer.widget`)
   - Ensure both targets are signed with a development team

6. Run the app on a device or simulator (widget runs on device simulator as well)

Notes:
- The Flutter side writes `mixzer_widget_summary.json` via a MethodChannel
  into the App Group container. On iOS, native `AppDelegate.swift` already
  contains a handler that writes the JSON into the App Group. Ensure the
  App Group id matches in both places.

- The example Widget UI files are minimal and demonstrate reading the
  JSON file and showing the next match and top scorer.

If you want me to produce a ZIP of the `ios/WidgetExample` files, I can
create it and place it in the repository (or print the paste-ready code
into the chat).