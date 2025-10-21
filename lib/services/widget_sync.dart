import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mixzer_app/models/match.dart';

class WidgetSync {
  static const MethodChannel _channel = MethodChannel('mixzer_app/widget_sync');

  /// Writes a small JSON summary for widgets. On iOS/macOS this will call
  /// into native code which should write the JSON into the App Group container.
  static Future<void> writeSummary(Map<String, dynamic> summary) async {
    final payload = jsonEncode(summary);
    try {
      if (kDebugMode) {
        // Small debug aid when running in debug mode
        // ignore: avoid_print
        print('[WidgetSync] writeSummary payload: $payload');
      }
      await _channel.invokeMethod('writeSummary', {'json': payload});
    } catch (e) {
      // ignore errors for now, could log
    }
  }

  /// Convenience helper to write a summary for a single match (next match).
  static Future<void> writeNextMatchSummary(Match? match) async {
    final nextMatchText = match != null ? '${match.homeTeam} vs ${match.awayTeam}' : 'No upcoming match';
    final score = (match != null && match.homeScore != null && match.awayScore != null) ? '${match.homeScore}-${match.awayScore}' : null;
    final summary = <String, dynamic>{
      'nextMatch': nextMatchText,
      'score': score,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await writeSummary(summary);
  }
}
