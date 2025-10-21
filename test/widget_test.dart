// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:mixzer_app/main.dart';

void main() {
  testWidgets('App shows Mixzer title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  // allow initial frames and small async tasks to run without waiting
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));

    // Expect to find app title in the AppBar
    expect(find.text('Mixzer'), findsWidgets);
  });
}
