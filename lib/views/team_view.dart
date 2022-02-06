import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timevictor_admin/model/student.dart';

import '../constant.dart';

class TeamView extends StatelessWidget {
  const TeamView({
    @required List<Student> students,
  }) : _students = students;

  final List<Student> _students;

  List<Widget> selectedStudents() {
    List<Widget> list = [];
    _students.forEach((student) => list.add(studentCard(student)));
    return list;
  }

  Widget studentCard(Student student) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              child: Icon(FontAwesomeIcons.user),
            ),
            Text(student.name),
            Text('Score: ${student.score}'),
            Text('Subject: ${student.subject}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Team'),
      ),
      // body: Center(
      //   child: ListView(
      //     children: selectedStudents(),
      //   ),
      // ),
      body: _students.length == 0
          ? Center(
              child: Text('Your team is Empty'),
            )
          : GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: selectedStudents(),
            ),
    );
  }
}
