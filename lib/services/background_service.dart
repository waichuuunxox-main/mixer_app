import 'dart:async';

/// Background service skeleton.
///
/// - Android: consider using `workmanager` plugin to register background tasks.
/// - iOS/macOS: WidgetKit handles timeline updates; native code is required to
///   schedule background refreshes. Flutter-level periodic timers are unreliable
///   for background execution on mobile platforms.
class BackgroundService {
  Timer? _timer;

  /// Start periodic sync every [intervalSeconds]. In a real app you'd
  /// integrate with native background APIs or `workmanager` for reliability.
  void startPeriodicSync({int intervalSeconds = 60 * 15}) {
    stop();
    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      // Call your ApiService or Sync logic here
      // Example: final svc = await ApiHelper.service();
      // if (svc is ApiService) await svc.fetchMatches(useCache: false);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() => stop();

  /// Optional: initialize workmanager on Android. Call this from main()
  /// if you want to register background tasks. The code is commented out
  /// because the plugin requires additional Android setup.
  ///
  /// Example:
  ///
  /// ```dart
  /// import 'package:workmanager/workmanager.dart';
  ///
  /// void callbackDispatcher() {
  ///   Workmanager().executeTask((task, inputData) async {
  ///     // perform background fetch and write widget summary
  ///     return Future.value(true);
  ///   });
  /// }
  ///
  /// void initWorkManager() {
  ///   Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  ///   Workmanager().registerPeriodicTask('mixzer_periodic', 'sync',
  ///     frequency: const Duration(hours: 1));
  /// }
  /// ```
}
