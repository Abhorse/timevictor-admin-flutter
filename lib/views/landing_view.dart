import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor_admin/data/provider.dart';
import 'package:timevictor_admin/home/index.dart';
import 'package:timevictor_admin/services/auth.dart';
import 'package:timevictor_admin/views/match_list.dart';

class LandingView extends StatelessWidget {
  static final String route = '/';

  @override
  Widget build(BuildContext context) {
    // if (Provider.of<Data>(context).isHomeView) {
    //   return MatchList();
    // } else {
    //   return AddMatchView();
    // }
    return AuthServices().handleAuth();
  }
}
