class Match {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final DateTime date;
  final int? homeScore;
  final int? awayScore;

  Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    this.homeScore,
    this.awayScore,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'].toString(),
      homeTeam: json['homeTeam'] ?? json['home'] ?? '',
      awayTeam: json['awayTeam'] ?? json['away'] ?? '',
      date: DateTime.parse(json['date']),
      homeScore: json['homeScore'] != null ? (json['homeScore'] as num).toInt() : null,
      awayScore: json['awayScore'] != null ? (json['awayScore'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'date': date.toIso8601String(),
        'homeScore': homeScore,
        'awayScore': awayScore,
      };
}
