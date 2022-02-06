import 'package:flutter/material.dart';
import 'package:timevictor_admin/widgets/student_field_widget.dart';

class TeamWidget extends StatelessWidget {
  final String teamName;

  const TeamWidget({this.teamName});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          teamName.toUpperCase()?? 'Team Students',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        StudentField(),
        StudentField()
      ],
    );
  }
}
