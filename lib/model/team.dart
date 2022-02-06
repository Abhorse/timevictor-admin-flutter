import 'package:flutter/foundation.dart';
import 'package:timevictor_admin/model/student.dart';

class TeamData {
  final List<Student> students;
  final String teamName;

  TeamData({
    @required this.students,
    @required this.teamName,
  });
}
