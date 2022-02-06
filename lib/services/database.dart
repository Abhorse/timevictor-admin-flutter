import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timevictor_admin/model/New/awards.dart';
import 'package:timevictor_admin/model/New/notification.dart';
import 'package:timevictor_admin/model/New/rank_and_prize.dart';
import 'package:timevictor_admin/model/New/stud.dart';
import 'package:timevictor_admin/model/joined_pool.dart';
import 'package:timevictor_admin/model/joined_pool_list.dart';
import 'package:timevictor_admin/model/joined_users.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/model/pool.dart';
import 'package:timevictor_admin/model/student.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'api_paths.dart';
import 'firestore.dart';
import 'package:async/async.dart' show StreamGroup;

abstract class Database {
  void readMatches();
  Future<void> createMatch(MatchData matchData);
  Future<void> createPendingMatch(MatchData matchData);
  Stream<List<MatchData>> getActiveMatches();
  Stream<List<Student>> getStudents(String matchID);
  Stream<List<Subject>> getSubjects(String matchID);
  Future<void> updateLeaderBoardByMatchID(
      String matchID, List<StudentData> students);
  Stream<List<Pool>> getPoolsByMatch(String matchID);
  Future<void> updateMatchScore(String matchID);
  Future<void> createPoolByMatch(String matchID, Pool pool);
  Stream<int> getTotalPools(String matchID);
  Future<void> createAwardTemplate(String tamplateName, Awards awards);
  Stream<List<Awards>> getAwardTemplates();
  Stream<List<NotificationData>> getAllNotifications();
  Future<void> approvePendingMatch(String matchID);
}

class FirestoreDatabase implements Database {
  final _service = FirestoreService.instance;
  Future<void> createMatch(MatchData matchData) async {
    await _service.setData(
      path: APIPath.matches(matchData.matchID),
      data: matchData.toMap(),
    );
    matchData.teamA.students.forEach((student) async {
      await _service.setData(
        path: APIPath.teamA(matchData.matchID, student.name),
        data: student.toMap(),
      );
    });

    matchData.teamB.students.forEach((student) async {
      await _service.setData(
        path: APIPath.teamB(matchData.matchID, student.name),
        data: student.toMap(),
      );
    });

    matchData.subjects.forEach((subject) async {
      await _service.setData(
        path: APIPath.subjects(matchData.matchID, subject.subject),
        data: subject.toMap(),
      );
    });
  }

  Future<void> createPendingMatch(MatchData matchData) async {
    await _service.setData(
      path: APIPath.addToPandingMatches(matchData.matchID),
      data: matchData.toMap(),
    );
    matchData.teamA.students.forEach((student) async {
      await _service.setData(
        path: APIPath.pendingMatchTeamA(matchData.matchID, student.name),
        data: student.toMap(),
      );
    });

    matchData.teamB.students.forEach((student) async {
      await _service.setData(
        path: APIPath.pandingMatchTeamB(matchData.matchID, student.name),
        data: student.toMap(),
      );
    });

    matchData.subjects.forEach((subject) async {
      await _service.setData(
        path: APIPath.pandingMatchSubjects(matchData.matchID, subject.subject),
        data: subject.toMap(),
      );
    });
  }

  Future<void> createAwardTemplate(String tamplateName, Awards awards) async {
    List<dynamic> aw = awards.awards.map((e) => e.toMap()).toList();
    await _service.setData(
      path: APIPath.addPrizeTemplate(tamplateName),
      data: {
        'awards': aw,
        'name': tamplateName,
      },
    );
  }

  Stream<List<Awards>> getAwardTemplates() => _service.collectionStream(
        path: APIPath.getPrizeTemplate(),
        builder: (data) => Awards.fromMap(data),
      );

  void readMatches() {
    final path = APIPath.allMatches();
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    snapshots.listen((snapshot) =>
        {snapshot.documents.forEach((matches) => print(matches.data))});
  }

  Stream<List<MatchData>> getActiveMatches() =>
      _service.collectionStreamConditionally(
        field: 'startTime',
        value: Timestamp.now(),
        path: APIPath.allMatches(),
        builder: (data) => MatchData.fromMap(data),
      );

  Stream<List<MatchData>> getCompletedMatches() =>
      _service.collectionStreamWhereLessThan(
        field: 'startTime',
        fieldValue: Timestamp.now(),
        path: APIPath.allMatches(),
        builder: (data) => MatchData.fromMap(data),
      );
  Stream<List<MatchData>> getInActiveMatches() =>
      _service.collectionStreamWhere(
        field: 'showToAll',
        fieldValue: false,
        path: APIPath.allMatches(),
        builder: (data) => MatchData.fromMap(data),
      );

  Stream<List<MatchData>> getPendingMatches() => _service.collectionStream(
        path: APIPath.allPendingMatches(),
        builder: (data) => MatchData.fromMap(data),
      );

  Future<void> approvePendingMatch(String matchID) async {
    await _service.updateDoc(path: APIPath.matches(matchID), data: {
      'showToAll': true,
    });
  }

  Stream<List<Student>> getStudents(String matchID) {
    var teamAStudentStream = _service.collectionStream(
      path: APIPath.teamAStudents(matchID),
      builder: (data) => Student.fromMap(data),
    );
    // var teamBStudentStream = _service.collectionStream(
    //   path: APIPath.teamBStudents(matchID),
    //   builder: (data) => Student.fromMap(data),
    // );
    return teamAStudentStream;
  }

  Stream<List<Student>> getTeamBStudents(String matchID) {
    // var teamAStudentStream = _service.collectionStream(
    //   path: APIPath.teamAStudents(matchID),
    //   builder: (data) => Student.fromMap(data),
    // );
    var teamBStudentStream = _service.collectionStream(
      path: APIPath.teamBStudents(matchID),
      builder: (data) => Student.fromMap(data),
    );
    return teamBStudentStream;
  }

  Future<void> addStudentToTeam(
      String matchID, bool isTeamA, Student student) async {
    await _service.setData(
      path: isTeamA
          ? APIPath.teamA(matchID, student.id)
          : APIPath.teamB(matchID, student.id),
      data: student.toMap(),
    );
  }

  Stream<int> getTotalPools(String matchID) => _service.documentStream(
        path: 'matches/$matchID',
        builder: (data) => data['totalPools'],
      );

  Future<void> createPoolByMatch(String matchID, Pool pool) async {
    var future = await Firestore.instance.document('matches/$matchID').get();
    var totalPools = future.data['totalPools'];
    Pool poolNew = Pool(
      id: 'pool_${totalPools + 1}',
      awards: pool.awards,
      joinedUsers: pool.joinedUsers,
      currentCount: pool.currentCount,
      currentPrize: pool.currentPrize,
      maxLimit: pool.maxLimit,
      maxPrize: pool.maxPrize,
      entry: pool.entry,
    );
    await _service.setData(
      path: APIPath.addPoolByMatch(matchID, 'pool_${totalPools + 1}'),
      data: poolNew.toMap(),
    );
    await Firestore.instance
        .document('matches/$matchID')
        .updateData({'totalPools': totalPools + 1});
  }

  Stream<List<Pool>> getPoolsByMatch(String matchID) =>
      _service.collectionStream(
        path: APIPath.poolsByMatch(matchID),
        builder: (data) => Pool.fromMap(data),
      );

  Stream<List<Subject>> getSubjects(String matchID) =>
      _service.collectionStream(
        path: APIPath.getSubjects(matchID),
        builder: (data) => Subject.fromMap(data),
      );

  Future<void> updateMatchScore(String matchID) async {
    var teamAStudents = _service.collectionStream(
        path: APIPath.teamAStudents(matchID),
        builder: (data) => StudentData.fromMap(data));

    var teamBStudents = _service.collectionStream(
        path: APIPath.teamBStudents(matchID),
        builder: (data) => StudentData.fromMap(data));

    teamAStudents.listen((studentsA) {
      teamBStudents.listen((studentsB) {
        List<StudentData> students = studentsA + studentsB;
        updateLeaderBoardByMatchID(matchID, students);
      });
    });
  }

  Future<void> updateLeaderBoardByMatchID(
      String matchID, List<StudentData> students) async {
    Stream<List<Pool>> pools = _service.collectionStream(
      path: APIPath.getPools(matchID),
      builder: (data) => Pool.fromMap(data),
    );

    pools.listen((pools) {
      pools.forEach((pool) {
        pool.joinedUsers.forEach((user) {
          JoinedUsers joinedUser = JoinedUsers.fromMap(user);
          var selectedTeam = getSelectedTeam(joinedUser.id, matchID, pool.id);
          selectedTeam.then((teamName) => {
                getTeamScore(teamName, joinedUser.id, matchID, students)
                    .then((score) => {
                          // print(score),
                          updateData(
                              pool.id,
                              matchID,
                              JoinedUsers(
                                  name: joinedUser.name,
                                  quizTotalScore: score,
                                  rank: 0,
                                  id: joinedUser.id))
                        })
              });
        });

        // calculate rank here
        calculateRank(matchID, pool.id);
      });
    });
  }

  Future<void> calculateRank(String matchID, String poolID) async {
    print('have to evaluate rank of the pool with ID: $poolID');
    // var joinedPlayersStream = _service.collectionStream(
    //   path: APIPath.getJoinedPlayers(matchID, poolID),
    //   builder: (data) => JoinedUsers.fromMap(data),
    // );

    final reference = Firestore.instance
        .collection(APIPath.getJoinedPlayers(matchID, poolID))
        .orderBy('quizTotalScore', descending: true);
    final snapshots = reference.snapshots();
    // snapshots.forEach((element) { })
    Stream<List<JoinedUsers>> sortedList = snapshots.map(
      (snapshot) => snapshot.documents
          .map((snapshot) => JoinedUsers.fromMap(snapshot.data))
          .toList(),
    );

    sortedList.listen((players) {
      players.forEach((player) {
        // print(players.indexOf(player));
        updateRanks(poolID, matchID, player.id, players.indexOf(player));
      });
    });

    // joinedPlayersStream.forEach((element) { })
  }

  Future<void> updateRanks(
      String poolID, String matchID, String userID, int rank) async {
    // print(
    //     '${joinedUser.quizTotalScore}, ${joinedUser.name}, ${joinedUser.rank}');
    var pool = Firestore.instance
        .document(APIPath.getJoinedPlayer(matchID, poolID, userID));
    pool.updateData({'rank': rank + 1});
  }

  Future<void> updateData(
      String poolID, String matchID, JoinedUsers joinedUser) async {
    print(
        '${joinedUser.quizTotalScore}, ${joinedUser.name}, ${joinedUser.rank}');
    var pool = Firestore.instance
        .document(APIPath.getJoinedPlayer(matchID, poolID, joinedUser.id));
    pool.updateData({'quizTotalScore': joinedUser.quizTotalScore});
  }

  Future<double> getTeamScore(
      String teamName, uid, matchID, List<StudentData> students) async {
    var teamData = Firestore.instance
        .document(APIPath.getTeamData(uid, matchID, teamName))
        .get();
    double score;
    await teamData.then((value) => {
          score = calTotalScroe(value.data['studentsId'], students),
        });

    return score;
  }

  double calTotalScroe(
      List<dynamic> selectetStudentsId, List<StudentData> students) {
    double totalScroe = 0.0;

    selectetStudentsId.forEach((studentID) {
      totalScroe += students.firstWhere((std) => std.id == studentID).quizMarks;
    });
    return totalScroe;
  }

  Stream<List<NotificationData>> getAllNotifications() =>
      _service.orderedCollectionStream(
        path: APIPath.notification(),
        builder: (data) => NotificationData.fromMap(data),
        orderBy: 'date',
        descending: true,
      );

  Future<void> createNotification(NotificationData notificationData) async {
    var totalNotificationsData =
        await Firestore.instance.document(APIPath.adminNotification()).get();
    int totalNotifications = totalNotificationsData.data['total'];

    await _service.setData(
      path: APIPath.createNotification('notify-${totalNotifications + 1}'),
      data: notificationData.toMap(),
    );

    await Firestore.instance
        .document(APIPath.adminNotification())
        .updateData({'total': totalNotifications + 1});
  }

  Future<String> getSelectedTeam(
      String uid, String matchID, String poolID) async {
    var document = Firestore.instance
        .document(APIPath.getSelectedTeam(uid, matchID))
        .get();
    JoinedPoolList joinedPools;
    String teamName;

    await document.then((value) => {
          joinedPools = JoinedPoolList.fromMap(value.data),
          joinedPools.joinedPools.forEach((jp) {
            if (jp['poolId'] == poolID) {
              teamName = jp['teamName'];
            }
          })
        });

    return teamName;
  }
}
