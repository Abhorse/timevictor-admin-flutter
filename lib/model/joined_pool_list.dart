import 'package:timevictor_admin/model/joined_pool.dart';

class JoinedPoolList {
  final List<dynamic> joinedPools;
  final String matchID;

  JoinedPoolList({this.joinedPools, this.matchID});

  factory JoinedPoolList.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    final List<dynamic> joinedPools = data['joinedPools'];
    final String matchID = data['matchID'];

    return JoinedPoolList(
      joinedPools: joinedPools,
      matchID: matchID,
    );
  }
}
