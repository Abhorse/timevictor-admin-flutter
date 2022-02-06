
import 'package:flutter/material.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/home/create_match_new.dart';
import 'package:timevictor_admin/initial_view.dart';
import 'package:timevictor_admin/views/Awards_template/create_template.dart';
import 'package:timevictor_admin/views/landing_view.dart';
import 'package:timevictor_admin/views/match_list.dart';
import 'package:timevictor_admin/views/notifications/notifications.dart';
import 'package:timevictor_admin/widgets/drawer_listtile.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({
    Key key,
    // @required this.route,
  }) : super(key: key);

  // final String route;

  void navigateToRoute(String route, BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: MediaQuery.of(context).size.width > 600,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: kAppBarColor,
            width: 3.0,
          ),
          // borderRadius: BorderRadius.circular(10.0),
        ),
        child: SizedBox(
          width: 300.0,
          child: Scaffold(
            body: Container(
              // color: kAppBarColor,
              child: SizedBox(
                width: 300.0,
                child: ListView(
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: Container(
                        color: kAppBarColor,
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/images/tvLogoFinal.png"),
                                  height: 100.0,
                                  width: 100.0,
                                ),
                                Text(
                                  'Home',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => navigateToRoute(LandingView.route, context),
                        ),
                      ),
                    ),
                    DrawerListTile(
                      title: 'Match List',
                      icon: Icons.list,
                      onPress: () => navigateToRoute(MatchList.route, context),
                    ),
                    DrawerListTile(
                      title: 'Add Match',
                      icon: Icons.add,
                      onPress: () =>
                          navigateToRoute(CreateMatchNew.route, context),
                    ),
                    DrawerListTile(
                      title: 'Awards \u{20B9} Template',
                      icon: Icons.attach_money,
                      onPress: () =>
                          navigateToRoute(AwardTemplate.route, context),
                    ),
                    DrawerListTile(
                      title: 'Notifications',
                      icon: Icons.notifications,
                      onPress: () =>
                          navigateToRoute(NotificationPage.route, context),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
