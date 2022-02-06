import 'dart:js';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/dateTime_formater.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/views/create_team_view.dart';
import 'package:timevictor_admin/views/match_controller/add_student.dart';
import 'package:timevictor_admin/views/match_controller/contest_form.dart';
import 'package:timevictor_admin/views/match_controller/contest_list.dart';
import 'package:timevictor_admin/views/match_controller/student_manager.dart';

// import 'create_team_view.dart';

class MatchPoleView extends StatelessWidget {
  const MatchPoleView({@required this.match});
  final MatchData match;

  void createTeam(BuildContext context) {
    Database database = FirestoreDatabase();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder<List<Subject>>(
            stream: database.getSubjects(match.matchID),
            builder: (context, snapshot) {
              List<Subject> subjects = snapshot.data;
              if (snapshot.connectionState == ConnectionState.active) {
                return CreateTeamView(match: match, subjects: subjects);
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ));
  }

  void manageStudents(BuildContext context) {
    Database database = FirestoreDatabase();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder<List<Subject>>(
            stream: database.getSubjects(match.matchID),
            builder: (context, snapshot) {
              List<Subject> subjects = snapshot.data;
              if (snapshot.connectionState == ConnectionState.active) {
                return ManageStudents(match: match, subjects: subjects);
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ));
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ManageStudents(
    //       match: match,
    //     ),
    //   ),
    // );
  }

  Widget contestView(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text('Time'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Pool Prize'),
                          SizedBox(height: 5.0),
                          Text('Rs 600')
                        ],
                      ),
                      FlatButton(
                        child: Text('Entry Rs 200'),
                        color: Colors.green,
                        onPressed: () {
                          // createTeam(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isMatchLive() {
    //TODO: Default end time is 30 min but we need to read it from database
    /**
     * It Should not be hard coded
     */
    DateTime startTime = DateTime.parse(match.startTime.toDate().toString());
    var endTime = startTime.add(Duration(minutes: 30));
    if (endTime.isBefore(DateTime.now())) return false;
    if (startTime.isBefore(DateTime.now())) return true;
    return false;
  }

  Future<void> updateBoard(BuildContext context) async {
    bool isLive = isMatchLive();
    if (isLive == true) {
      try {
        print('Logger: Updating leaderboard..');
        Database database = FirestoreDatabase();
        await database.updateMatchScore(match.matchID);
      } catch (e) {
        print(e);
      }
    } else {
      print('Logger Alert');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            'Match Not Live',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content:
              Text('This match is either not started or it has been closed'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  String getStartTime() {
    // DateTime startTime = DateTime.parse(match.startTime.toDate().toString());
    return FormattedDateTime.formate(match.startTime, 30);
    // return '${startTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '${match.teamAName.toUpperCase()} vs ${match.teamBName.toUpperCase()}'),
          backgroundColor: kAppBarColor,
          bottom: TabBar(tabs: <Tab>[
            Tab(child: Text('Contests')),
            Tab(child: Text('Create Contest')),
          ]),
          actions: [
            // AddContest(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(Icons.timer),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(getStartTime()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.green,
                child: Text(
                  'Update Board',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => updateBoard(context),
              ),
            ),
            SizedBox(
              width: 50.0,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('View Students'),
          icon: Icon(FontAwesomeIcons.plus),
          // onPressed: () => createTeam(context),
          onPressed: () => manageStudents(context),
          backgroundColor: Colors.green,
        ),
        body: TabBarView(
          children: [
            // contestView(context),
            ContestWidgetList(
              matchID: match.matchID,
            ),
            // Icon(Icons.directions_bike),
            CreateContestForm(
              matchID: match.matchID,
            )
          ],
        ),
      ),
    );
  }
}
