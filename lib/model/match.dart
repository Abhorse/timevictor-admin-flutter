import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'package:timevictor_admin/model/team.dart';

class MatchData {
  final bool showToAll;
  final String matchID;
  final String teamAName;
  final String teamBName;
  final List<Subject> subjects;
  final Timestamp startTime;
  final Timestamp endTime;
  final TeamData teamA;
  final TeamData teamB;
  final int duration;
  final int totalPools;
  final String teamAImage;
  final String teamBImage;

  MatchData({
    this.showToAll,
    @required this.matchID,
    @required this.teamAName,
    @required this.teamBName,
    this.subjects,
    this.teamA,
    this.teamB,
    this.startTime,
    this.endTime,
    this.duration,
    this.totalPools,
    this.teamAImage,
    this.teamBImage,
  })  : assert(matchID != null),
        assert(teamAName != null),
        assert(teamBName != null);

  factory MatchData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final bool showToAll = data['showToAll'] ?? true;
    final String matchID = data['matchID'];
    final String teamAName = data['teamAName'];
    final String teamBName = data['teamBName'];
    final Timestamp startTime = data['startTime'];
    final Timestamp endTime = data['endTime'];
    final int duration = data['duration'];
    final String teamAImage = data['teamAImage'];
    final String teamBImage = data['teamBImage'];

    return MatchData(
      showToAll: showToAll,
      matchID: matchID,
      teamAName: teamAName,
      teamBName: teamBName,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      teamAImage: teamAImage,
      teamBImage: teamBImage,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'showToAll': showToAll,
      'matchID': matchID,
      'teamAName': teamAName,
      'teamAImage': teamAImage,
      'teamBName': teamBName,
      'teamBImage': teamBImage,
      'duration': duration,
      'startTime': startTime,
      'endTime': endTime,
      'totalPools': totalPools,
    };
  }
}
