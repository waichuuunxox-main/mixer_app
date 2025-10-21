class Player {
  final String id;
  final String name;
  final String team;
  final int goals;

  Player({required this.id, required this.name, required this.team, required this.goals});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(id: json['id'].toString(), name: json['name'] ?? '', team: json['team'] ?? '', goals: (json['goals'] ?? 0) as int);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'team': team, 'goals': goals};
}
