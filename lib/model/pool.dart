class Pool {
  Pool({
    this.id,
    this.maxLimit,
    this.maxPrize,
    this.currentPrize,
    this.entry,
    this.currentCount,
    this.joinedUsers,
    this.awards,
  });

  final String id;
  final int maxLimit;
  final int maxPrize;
  final int currentPrize;
  final int entry;
  final int currentCount;
  final List<dynamic> joinedUsers;
  final List<dynamic> awards;

  factory Pool.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final int maxLimit = data['maxLimit'];
    final int maxPrize = data['maxPrize'];
    final int entry = data['entry'];
    // final int currentCount = data['currentCount'];
    final int currentCount = data['joinedUsers'].length ?? 0;
    final int currentPrize = data['currentPrize'];
    final List<dynamic> joinedUsers = data['joinedUsers'] ?? null;

    return Pool(
      id: id,
      maxLimit: maxLimit,
      maxPrize: maxPrize,
      entry: entry,
      currentCount: currentCount,
      currentPrize: currentPrize,
      joinedUsers: joinedUsers,
    );
  }

  Map<String, dynamic> toMap() {
    // List<dynamic> aw = awards.awards.map((e) => e.toMap()).toList();

    return {
      'id': id,
      'maxLimit': maxLimit,
      'maxPrize': maxPrize,
      'entry': entry,
      'currentCount': currentCount,
      'currentPrize': currentPrize,
      'joinedUsers': joinedUsers,
      'awards': awards,
    };
  }
}
