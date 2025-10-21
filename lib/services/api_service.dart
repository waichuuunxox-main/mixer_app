import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mixzer_app/models/match.dart';
import 'package:mixzer_app/models/player.dart';
import 'package:mixzer_app/services/cache_service.dart';

/// Skeleton API service. Replace baseUrl and endpoints with your chosen API.
class ApiService {
  final String apiKey;
  final String baseUrl;

  ApiService({required this.apiKey, this.baseUrl = 'https://api.example.com'}) : assert(apiKey.isNotEmpty);

  Future<List<Match>> fetchMatches({bool useCache = true}) async {
    const cacheKey = 'matches';
    if (useCache) {
      final cached = CacheService.read(cacheKey, maxAgeSeconds: 60 * 5);
      if (cached != null) {
        final data = cached['items'] as List;
        return data.map((e) => Match.fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    final uri = Uri.parse('$baseUrl/matches');
    final resp = await http.get(uri, headers: {'x-api-key': apiKey});
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as List;
      final matches = data.map((e) => Match.fromJson(e as Map<String, dynamic>)).toList();
      await CacheService.write(cacheKey, {'items': data});
      return matches;
    }
    throw Exception('Failed to load matches');
  }

  Future<List<Player>> fetchTopScorers({bool useCache = true}) async {
    const cacheKey = 'scorers';
    if (useCache) {
      final cached = CacheService.read(cacheKey, maxAgeSeconds: 60 * 5);
      if (cached != null) {
        final data = cached['items'] as List;
        return data.map((e) => Player.fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    final uri = Uri.parse('$baseUrl/scorers');
    final resp = await http.get(uri, headers: {'x-api-key': apiKey});
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as List;
      final players = data.map((e) => Player.fromJson(e as Map<String, dynamic>)).toList();
      await CacheService.write(cacheKey, {'items': data});
      return players;
    }
    throw Exception('Failed to load scorers');
  }
}
