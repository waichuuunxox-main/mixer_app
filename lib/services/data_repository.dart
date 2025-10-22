import 'package:mixzer_app/models/match.dart';
import 'package:mixzer_app/models/player.dart';
import 'api_helper.dart';
import 'remote_service.dart';
import 'mock_service.dart';
import 'dart:developer' as developer;

/// DataRepository chooses between ApiService and MockService based on
/// whether an API key is configured. Callers use this repository to fetch
/// matches and top scorers without caring about the underlying service.
class DataRepository {
  /// Returns a RemoteService (ApiService or MockService)
  static Future<RemoteService> _provider() => ApiHelper.service();

  static Future<List<Match>> fetchMatches({bool useCache = true}) async {
    final svc = await _provider();
    try {
      return await svc.fetchMatches(useCache: useCache);
    } catch (e, st) {
      developer.log('DataRepository.fetchMatches failed: $e, falling back to MockService', error: e, stackTrace: st);
      // fallback to mock on any network/parse error
      final mock = MockService();
      return await mock.fetchMatches();
    }
  }

  static Future<List<Player>> fetchTopScorers({bool useCache = true}) async {
    final svc = await _provider();
    try {
      return await svc.fetchTopScorers(useCache: useCache);
    } catch (e, st) {
      developer.log('DataRepository.fetchTopScorers failed: $e, falling back to MockService', error: e, stackTrace: st);
      final mock = MockService();
      return await mock.fetchTopScorers();
    }
  }
}
