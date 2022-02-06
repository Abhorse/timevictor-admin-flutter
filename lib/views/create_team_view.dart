import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/model/student.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/views/team_view.dart';

import '../constant.dart';

class CreateTeamView extends StatefulWidget {
  const CreateTeamView({
    @required this.match,
    @required this.subjects,
  });

  final MatchData match;
  final List<Subject> subjects;

  @override
  _CreateTeamViewState createState() => _CreateTeamViewState();
}

class _CreateTeamViewState extends State<CreateTeamView> {
  List<Student> _students = [];

  List<Widget> getStudentList(List<Student> studnets) {
    List<Widget> studentList = [];
    studnets.forEach((student) {
      bool isSelected = false;
      studentList.add(
        StudentTile(
            students: _students, student: student, isSelected: isSelected),
      );
    });
    return studentList;
  }

  List<Tab> tabList() {
    return widget.subjects
        .map((e) => Tab(
              text: e.subject,
            ))
        .toList();
  }

  List<Tab> tabBarList() {
    return widget.subjects
        .map((e) => Tab(
              text: e.subject,
            ))
        .toList();
  }

  List<Widget> tabBarView(List<Student> students) {
    List<Widget> list = [];
    widget.subjects.forEach((subject) {
      list.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'You can select minimun ${subject.minStudents?? 0} students and maximun ${subject.maxStudents?? 'All'} students in this catagory',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: getStudentList(students
                  .where((student) => student.subject == subject.subject)
                  .toList()),
            ),
          ),
        ],
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final Database database = FirestoreDatabase();
    return DefaultTabController(
      length: widget.subjects.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: Text('Create Team  ${widget.match.matchID.toUpperCase()}'),
          bottom: TabBar(
            tabs: tabList(),
          ),
        ),
        body: Column(
          children: [
            // Center(
            //   child: Text(widget.match.matchID),
            // ),
            StreamBuilder<List<Student>>(
              stream: database.getStudents(widget.match.matchID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  List<Student> students = snapshot.data;
                  return Expanded(
                      child: TabBarView(
                    children: tabBarView(students),
                  ));
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
            FlatButton(
              child: Text('View Team'),
              color: Colors.green,
              onPressed: _students.length != 0
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamView(students: _students),
                        ),
                      );
                    },
            )
          ],
        ),
      ),
    );
  }
}

class StudentTile extends StatefulWidget {
  const StudentTile(
      {@required List<Student> students,
      @required this.student,
      @required this.isSelected})
      : _students = students;
  final Student student;
  final List<Student> _students;
  final bool isSelected;

  @override
  _StudentTileState createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  bool select = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        child: Icon(FontAwesomeIcons.user),
                      ),
                      SizedBox(height: 5.0),
                      Text(widget.student.name),
                    ],
                  ),
                  Text('Points: ${widget.student.score}'),
                  FlatButton(
                    child: widget._students.contains(widget.student)
                        ? Icon(
                            FontAwesomeIcons.minus,
                            color: Colors.red,
                          )
                        : Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.blue,
                          ),
                    onPressed: () {
                      setState(() {
                        if (!widget._students.contains(widget.student)) {
                          widget._students.add(widget.student);
                        } else {
                          widget._students.remove(widget.student);
                        }
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          // CheckboxListTile(
          //   value: select,
          //   onChanged: (value) {
          //     print(value);
          //     setState(() {
          //       select = value;
          //     });
          //     if (!widget._students.contains(widget.student)) {
          //       widget._students.add(widget.student);
          //     } else {
          //       widget._students.remove(widget.student);
          //     }
          //   },
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Column(
          //         children: [
          //           CircleAvatar(
          //             child: Icon(FontAwesomeIcons.user),
          //           ),
          //           SizedBox(height: 5.0),
          //           Text(widget.student.name),
          //         ],
          //       ),
          //       Text('Points: ${widget.student.score}')
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
