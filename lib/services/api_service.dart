import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mixzer_app/models/match.dart';
import 'package:mixzer_app/models/player.dart';
import 'package:mixzer_app/services/cache_service.dart';

import 'remote_service.dart';

/// Robust ApiService with injectable http.Client for testability.
class ApiService implements RemoteService {
  final String apiKey;
  final String baseUrl;
  final http.Client httpClient;
  final Duration timeout;

  ApiService({
    required this.apiKey,
    this.baseUrl = 'https://api.example.com',
    http.Client? httpClient,
    Duration? timeout,
  })  : httpClient = httpClient ?? http.Client(),
        timeout = timeout ?? const Duration(seconds: 8) {
    assert(apiKey.isNotEmpty);
  }

  @override
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

    try {
      final resp = await httpClient
          .get(uri, headers: {'x-api-key': apiKey}).timeout(timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List;
        final matches = data.map((e) => Match.fromJson(e as Map<String, dynamic>)).toList();
        try {
          await CacheService.write(cacheKey, {'items': data});
        } catch (_) {
          // best-effort cache write: ignore in test or uninitialized Hive environments
        }
        return matches;
      }

      final err = _parseError(resp);
      throw ApiException(resp.statusCode, err);
    } on TimeoutException catch (e) {
      throw ApiException(-1, 'Request timed out: ${e.message}');
    }
  }

  @override
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

    try {
      final resp = await httpClient
          .get(uri, headers: {'x-api-key': apiKey}).timeout(timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List;
        final players = data.map((e) => Player.fromJson(e as Map<String, dynamic>)).toList();
        try {
          await CacheService.write(cacheKey, {'items': data});
        } catch (_) {
          // best-effort cache write
        }
        return players;
      }

      final err = _parseError(resp);
      throw ApiException(resp.statusCode, err);
    } on TimeoutException catch (e) {
      throw ApiException(-1, 'Request timed out: ${e.message}');
    }
  }

  String _parseError(http.Response resp) {
    try {
      final json = jsonDecode(resp.body);
      if (json is Map && json['message'] != null) return json['message'].toString();
      return resp.body;
    } catch (_) {
      return resp.body;
    }
  }
}

class ApiException implements Exception {
  final int code;
  final String message;
  ApiException(this.code, this.message);

  @override
  String toString() => 'ApiException($code): $message';
}
