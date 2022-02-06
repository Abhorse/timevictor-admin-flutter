import 'package:flutter/material.dart';
import 'package:timevictor_admin/home/drawer.dart';
import 'package:timevictor_admin/services/auth.dart';
import 'package:timevictor_admin/views/home/home_view.dart';
import 'package:timevictor_admin/widgets/sidebar_widget.dart';
import 'constant.dart';

class HomeView extends StatelessWidget {
  static final String route = '/';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SideBarWidget(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Text('TIME-VICTOR-ADMIN'),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_tab,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      AuthServices().logout();
                    },
                  )
                ],
                backgroundColor: kAppBarColor,
              ),
              drawer:
                  MediaQuery.of(context).size.width > 600 ? null : HomeDrawer(),
              body: HomePage(),
              // body: LandingView(),
            ),
          ),
        ],
      ),
    );
  }
}
