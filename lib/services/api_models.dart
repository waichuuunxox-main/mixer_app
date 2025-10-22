import 'package:mixzer_app/models/match.dart';
import 'package:mixzer_app/models/player.dart';

/// Converters between raw API map and local models.
class ApiModels {
  static Match matchFromMap(Map<String, dynamic> m) {
    return Match.fromJson(m);
  }

  static Player playerFromMap(Map<String, dynamic> m) {
    return Player.fromJson(m);
  }
}
