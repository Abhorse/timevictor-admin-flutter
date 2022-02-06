import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/data/provider.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.onPress})
      : super(key: key);

  final String title;
  final IconData icon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: kAppBarColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: kAppBarColor,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onPress,
    );
  }
}
