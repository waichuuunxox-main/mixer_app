import 'package:mixzer_app/models/match.dart';
import 'package:mixzer_app/models/player.dart';

class MockService {
  Future<List<Match>> fetchMatches() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      Match(id: '1', homeTeam: 'Team A', awayTeam: 'Team B', date: DateTime.now().add(const Duration(days: 1))),
      Match(id: '2', homeTeam: 'Team C', awayTeam: 'Team D', date: DateTime.now().add(const Duration(days: 2)), homeScore: 2, awayScore: 1),
      Match(id: '3', homeTeam: 'Team E', awayTeam: 'Team F', date: DateTime.now().subtract(const Duration(days: 1)), homeScore: 0, awayScore: 0),
    ];
  }

  Future<List<Player>> fetchTopScorers() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return [
      Player(id: 'p1', name: 'John Doe', team: 'Team A', goals: 12),
      Player(id: 'p2', name: 'Alex Smith', team: 'Team C', goals: 10),
      Player(id: 'p3', name: 'Lee Chen', team: 'Team E', goals: 9),
    ];
  }
}
