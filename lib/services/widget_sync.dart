import 'dart:convert';
import 'package:flutter/services.dart';

class WidgetSync {
  static const MethodChannel _channel = MethodChannel('mixzer_app/widget_sync');

  /// Writes a small JSON summary for widgets. On iOS/macOS this will call
  /// into native code which should write the JSON into the App Group container.
  static Future<void> writeSummary(Map<String, dynamic> summary) async {
    final payload = jsonEncode(summary);
    try {
      await _channel.invokeMethod('writeSummary', {'json': payload});
    } catch (e) {
      // ignore errors for now, could log
    }
  }
}
