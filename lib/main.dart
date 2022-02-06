import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/data/provider.dart';
import 'package:timevictor_admin/home/create_match.dart';
import 'package:timevictor_admin/home/create_match_new.dart';
import 'package:timevictor_admin/home/drawer.dart';
import 'package:timevictor_admin/home/index.dart';
import 'package:timevictor_admin/initial_view.dart';
import 'package:timevictor_admin/views/Awards_template/create_template.dart';
import 'package:timevictor_admin/views/landing_view.dart';
import 'package:timevictor_admin/views/match_list.dart';
import 'package:timevictor_admin/views/notifications/notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (_) => Data(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: HomeView.route,
        routes: {
          CreateMatchNew.route: (_) => CreateMatchNew(),
          LandingView.route: (context) => LandingView(),
          // HomeView.route: (context) => HomeView(),
          AwardTemplate.route: (context) => AwardTemplate(),
          NotificationPage.route: (context) => NotificationPage(),
          AddMatchView.route: (context) => AddMatchView(),
          MatchList.route: (_) => MatchList(),
        },
        title: 'Time Victor Admin',
        // home: ,
      ),
    );
  }
}
