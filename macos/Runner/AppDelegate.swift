import Cocoa
import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    guard let flutterViewController = mainFlutterWindow?.contentViewController as? FlutterViewController else {
      return
    }

    let widgetChannel = FlutterMethodChannel(name: "mixzer_app/widget_sync", binaryMessenger: flutterViewController.engine.binaryMessenger)
    widgetChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "writeSummary" {
        if let args = call.arguments as? [String: Any], let json = args["json"] as? String {
          // Update this App Group identifier to match your Xcode signing settings
          let appGroup = "group.com.waichuuun.mixzer"
          if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) {
            let fileURL = containerURL.appendingPathComponent("mixzer_widget_summary.json")
            do {
              if let data = json.data(using: .utf8) {
                try data.write(to: fileURL)
                result(true)
                return
              } else {
                result(FlutterError(code: "write_error", message: "Invalid JSON data", details: nil))
                return
              }
            } catch {
              result(FlutterError(code: "write_error", message: "Failed to write summary", details: error.localizedDescription))
              return
            }
          } else {
            result(FlutterError(code: "no_container", message: "App Group container not found", details: nil))
            return
          }
        }
        result(FlutterError(code: "invalid_args", message: "Missing json argument", details: nil))
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
