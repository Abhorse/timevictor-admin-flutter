import 'package:timevictor_admin/model/New/stud.dart';

class TeamList {
  final List<StudentData> students;

  TeamList({this.students});

  factory TeamList.formMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final List<StudentData> students = data['ds'];

    return TeamList(
      students: students,
    );
  }
}
