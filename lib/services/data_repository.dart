import 'package:mixzer_app/models/match.dart';
import 'package:mixzer_app/models/player.dart';
import 'api_helper.dart';
import 'api_service.dart';
import 'mock_service.dart';

/// DataRepository chooses between ApiService and MockService based on
/// whether an API key is configured. Callers use this repository to fetch
/// matches and top scorers without caring about the underlying service.
class DataRepository {
  /// Returns either ApiService or MockService depending on stored API key.
  static Future<Object> _provider() => ApiHelper.service();

  static Future<List<Match>> fetchMatches({bool useCache = true}) async {
    final svc = await _provider();
    if (svc is ApiService) {
      return svc.fetchMatches(useCache: useCache);
    }
    if (svc is MockService) {
      return svc.fetchMatches();
    }
    return [];
  }

  static Future<List<Player>> fetchTopScorers({bool useCache = true}) async {
    final svc = await _provider();
    if (svc is ApiService) {
      return svc.fetchTopScorers(useCache: useCache);
    }
    if (svc is MockService) {
      return svc.fetchTopScorers();
    }
    return [];
  }
}
