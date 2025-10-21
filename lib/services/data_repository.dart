import 'package:mixzer_app/models/match.dart';
import 'package:mixzer_app/models/player.dart';
import 'api_helper.dart';
import 'remote_service.dart';

/// DataRepository chooses between ApiService and MockService based on
/// whether an API key is configured. Callers use this repository to fetch
/// matches and top scorers without caring about the underlying service.
class DataRepository {
  /// Returns a RemoteService (ApiService or MockService)
  static Future<RemoteService> _provider() => ApiHelper.service();

  static Future<List<Match>> fetchMatches({bool useCache = true}) async {
    final svc = await _provider();
    return svc.fetchMatches(useCache: useCache);
  }

  static Future<List<Player>> fetchTopScorers({bool useCache = true}) async {
    final svc = await _provider();
    return svc.fetchTopScorers(useCache: useCache);
  }
}
