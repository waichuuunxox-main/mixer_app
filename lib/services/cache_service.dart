import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const String boxName = 'mixzer_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  /// Write with timestamp
  static Future<void> write(String key, Map<String, dynamic> value) async {
    final box = Hive.box(boxName);
    final payload = {'ts': DateTime.now().toIso8601String(), 'data': value};
    await box.put(key, jsonEncode(payload));
  }

  /// Read with optional maxAge seconds; returns null if missing or expired
  static Map<String, dynamic>? read(String key, {int? maxAgeSeconds}) {
    final box = Hive.box(boxName);
    final raw = box.get(key) as String?;
    if (raw == null) return null;
    final Map<String, dynamic> payload = jsonDecode(raw) as Map<String, dynamic>;
    final ts = DateTime.parse(payload['ts'] as String);
    if (maxAgeSeconds != null) {
      if (DateTime.now().difference(ts).inSeconds > maxAgeSeconds) return null;
    }
    return (payload['data'] as Map).cast<String, dynamic>();
  }
}
