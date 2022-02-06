import 'package:timevictor_admin/model/New/rank_and_prize.dart';

class Awards {
  final List<dynamic> awards;
  final String name;

  Awards({this.awards, this.name});

  factory Awards.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final List<dynamic> awards = data['awards'];
    final String name = data['name'];

    return Awards(
      awards: awards,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'awards': awards,
    };
  }
}
