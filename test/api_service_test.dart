import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mixzer_app/services/api_service.dart';
import 'package:mixzer_app/models/match.dart';

void main() {
  test('fetchMatches returns parsed matches on 200', () async {
    final mockClient = MockClient((request) async {
      final body = jsonEncode([
        {'id': '1', 'homeTeam': 'A', 'awayTeam': 'B', 'date': DateTime.now().toIso8601String()}
      ]);
      return http.Response(body, 200);
    });

    final svc = ApiService(apiKey: 'test', httpClient: mockClient);
    final matches = await svc.fetchMatches(useCache: false);
    expect(matches, isA<List<Match>>());
    expect(matches.first.homeTeam, 'A');
  });

  test('fetchMatches throws ApiException on 500', () async {
    final mockClient = MockClient((request) async {
      return http.Response('internal error', 500);
    });

    final svc = ApiService(apiKey: 'test', httpClient: mockClient);
    expect(() async => await svc.fetchMatches(useCache: false), throwsA(isA<ApiException>()));
  });
}
