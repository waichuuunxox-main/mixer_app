import Flutter
import UIKit
import Foundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  GeneratedPluginRegistrant.register(with: self)

  // Register a MethodChannel for widget sync
  let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
  let widgetChannel = FlutterMethodChannel(name: "mixzer_app/widget_sync", binaryMessenger: controller.binaryMessenger)
  widgetChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
    if call.method == "writeSummary" {
      if let args = call.arguments as? [String:Any], let json = args["json"] as? String {
  // Write JSON to App Group container. Update appGroup identifier accordingly.
  let appGroup = "group.com.waichuuun.mixzer"
        if let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) {
          let fileURL = container.appendingPathComponent("mixzer_widget_summary.json")
          do {
            try json.data(using: .utf8)?.write(to: fileURL)
            result(true)
          } catch {
            result(FlutterError(code: "write_error", message: "Failed to write summary", details: error.localizedDescription))
          }
        } else {
          result(FlutterError(code: "no_container", message: "App Group container not found", details: nil))
        }
        return
      }
      result(FlutterError(code: "invalid_args", message: "Missing json argument", details: nil))
    } else {
      result(FlutterMethodNotImplemented)
    }
  })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
