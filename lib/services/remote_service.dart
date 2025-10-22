import 'package:mixzer_app/models/match.dart';
import 'package:mixzer_app/models/player.dart';

/// Service interface implemented by real API and mock service.
abstract class RemoteService {
  Future<List<Match>> fetchMatches({bool useCache = true});
  Future<List<Player>> fetchTopScorers({bool useCache = true});
}
