import 'package:flutter_test/flutter_test.dart';
import 'package:mixzer_app/services/mock_service.dart';

void main() {
  test('MockService returns matches and scorers', () async {
    final svc = MockService();
    final matches = await svc.fetchMatches();
    final scorers = await svc.fetchTopScorers();

    expect(matches, isNotNull);
    expect(matches.length, greaterThanOrEqualTo(1));

    expect(scorers, isNotNull);
    expect(scorers.length, greaterThanOrEqualTo(1));
  });
}
