import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mixzer_app/services/widget_sync.dart';

void main() {
  const channel = MethodChannel('mixzer_app/widget_sync');

  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  group('WidgetSync', () {
    final log = <MethodCall>[];

    setUp(() {
      binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
      log.clear();
    });

    tearDown(() {
      binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });

    test('writeSummary calls native writeSummary with json payload', () async {
      final payload = {'nextMatch': 'A vs B', 'timestamp': DateTime.now().toIso8601String()};
      await WidgetSync.writeSummary(payload);

      expect(log, isNotEmpty);
      expect(log.first.method, 'writeSummary');
      final args = log.first.arguments as Map<dynamic, dynamic>?;
      expect(args, isNotNull);
      expect(args!['json'], jsonEncode(payload));
    });
  });
}
