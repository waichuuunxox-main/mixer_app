WidgetKit setup for Mixzer (iOS/macOS)
=====================================

Steps to add a native WidgetKit extension that reads a JSON summary from the App Group:

1. Open the workspace
   - Open `ios/Runner.xcworkspace` in Xcode.

2. Add App Group capability
   - Select the Runner project > Signing & Capabilities > + Capability > App Groups.
   - Add a new App Group identifier, e.g. `group.com.example.mixzer`.

3. Add Widget Extension target
   - File > New > Target... > Widget Extension (iOS).
   - Choose SwiftUI, give it a name (e.g. MixzerWidget), finish.
   - In the new target, add the same App Group under Signing & Capabilities.

4. Copy the example Swift files
   - Copy `ios/WidgetExample/WidgetProvider.swift` into the widget extension's source files.
   - Update the `appGroup` constant inside `readSharedJSON()` to your App Group id.

5. From Flutter write summary JSON
   - Use the Flutter `MethodChannel` (see `lib/services/widget_sync.dart`) to call native iOS code which writes a JSON file into the App Group container:
     - Native iOS handler should implement `writeSummary` and save the JSON to `container.appendingPathComponent("mixzer_widget_summary.json")`.

6. Example JSON shape
   - { "nextMatch": "Team A vs Team B", "timestamp": "2025-10-21T12:00:00Z" }

7. Debugging
   - Run the main app on device/simulator to write the JSON, then run the widget in the widget preview.

Notes
 - Widgets can't execute arbitrary background network requests; the host app should keep the share file updated.
 - On macOS, WidgetKit also works with similar steps (be sure to select macOS widget capability when creating the target).
