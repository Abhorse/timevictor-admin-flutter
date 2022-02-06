import 'package:flutter/foundation.dart';

class StudentData {
  final String id;
  final String name;
  final String points;
  final String subject;
  final num quizMarks;

  StudentData(
      {@required this.name,
      @required this.points,
      @required this.subject,
      @required this.id,
      @required this.quizMarks});

  factory StudentData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final String name = data['name'];
    final String points = data['score'];
    final String subject = data['subject'];
    final num quizMarks = data['quizMarks'];

    return StudentData(
        id: id,
        name: name,
        points: points,
        subject: subject,
        quizMarks: quizMarks);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'points': points,
      'subject': subject,
      'quizMarks': quizMarks,
    };
  }
}
