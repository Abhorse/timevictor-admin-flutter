class JoinedUsers {
  final String id;
  final String name;
  final int rank;
  final double quizTotalScore;

  JoinedUsers({this.id, this.rank, this.name, this.quizTotalScore});

  factory JoinedUsers.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final int rank = data['rank'];
    final dynamic quizTotalScore = data['quizTotalScore'];
    final String userId = data['userId'];

    return JoinedUsers(
      rank: rank,
      name: name,
      quizTotalScore: quizTotalScore.toDouble(),
      id: userId
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': id,
      'rank': rank,
      'name': name,
      'quizTotalScore': quizTotalScore,
    };
  }
}
