class UserScore {
  final String name;
  final int score;

  UserScore({required this.name, required this.score});

  factory UserScore.fromMap(Map<String, dynamic> json) {
    return UserScore(
      name: json['name'],
      score: json['score'],
    );
  }
}
