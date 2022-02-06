import 'dart:js';

import 'package:flutter/material.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/model/student.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/views/match_controller/add_student.dart';
import 'package:timevictor_admin/widgets/circular_loader.dart';
import 'package:timevictor_admin/widgets/profile_pic_widget.dart';

class ManageStudents extends StatelessWidget {
  final MatchData match;
  final List<Subject> subjects;

  const ManageStudents({Key key, this.match, this.subjects}) : super(key: key);

  List<Widget> getStudentsCard(List<Student> students) {
    return students
        .map((s) => Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        ProfilePicWidget(
                          profilePicURL: s.imageURL,
                          radius: 25.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          '${s.name.toUpperCase()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'S.P.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              s.score,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          children: [
                            Text(
                              'Subject',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              s.subject,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  Widget getTeamAStudents() {
    return StreamBuilder(
      stream: FirestoreDatabase().getStudents(match.matchID),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.active) {
          List<Student> students = snapshots.data;
          if (students != null && students.length > 0) {
            return ListView(
              children: getStudentsCard(students),
            );
          } else {
            return Center(
              child: Text('${match.teamAName} don\'t have any students yet!'),
            );
          }
        } else {
          return CircularLoader();
        }
      },
    );
  }

  Widget getTeamBStudents() {
    return StreamBuilder(
      stream: FirestoreDatabase().getTeamBStudents(match.matchID),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.active) {
          List<Student> students = snapshots.data;
          if (students != null && students.length > 0) {
            return ListView(
              children: getStudentsCard(students),
            );
          } else {
            return Center(
              child: Text('${match.teamBName} don\'t have any students yet!'),
            );
          }
        } else {
          return CircularLoader();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          actions: [
            AddStudent(subjects: subjects, match: match,),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: match.teamAName.toUpperCase(),
              ),
              Tab(
                text: match.teamBName.toUpperCase(),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            getTeamAStudents(),
            getTeamBStudents(),
          ],
        ),
      ),
    );
  }
}
