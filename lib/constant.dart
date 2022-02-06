import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color kAppBarColor = Color(0xFF20232a);

const TextStyle kLableStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

const String kRupeeSymbol = '\u{20B9}';

ShapeBorder kButtonShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));

const List<String> kMonths = [
  'Jan',
  'Feb',
  'March',
  'April',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec'
];

const List<String> kNumberList = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11'
];

ShapeBorder kCardShape(double radius) =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

const TextStyle kButtonTextStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.white,
);
