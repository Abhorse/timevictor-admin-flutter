import 'package:flutter/foundation.dart';

// enum Subject {
//   Physics,
//   Chemistry,
//   Maths,
//   English,
//   Bio,
//   Hindi,
// }

class Student {
  String id;
  String name;
  String imageURL;
  String score;
  String subject;

  Student({
    @required this.name,
    @required this.score,
    @required this.subject,
    this.id,
    this.imageURL,
  });

  factory Student.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final String name = data['name'];
    final String score = data['score'];
    final String subject = data['subject'];
    final String imageURL = data['profilePic'];

    return Student(
      id: id,
      name: name,
      score: score,
      subject: subject,
      imageURL: imageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profilePic': imageURL,
      'score': score,
      'subject': subject,
      'quizMarks': null,
    };
  }
}
