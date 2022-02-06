import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timevictor_admin/constant.dart';
import 'dart:math' as math;
import 'package:timevictor_admin/dateTime_formater.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/views/match_controller/matchPole_view.dart';
import 'package:timevictor_admin/widgets/custom_clock.dart';
import 'package:timevictor_admin/widgets/team_name_image_widget.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({Key key, @required this.match, this.onApproval});
  final MatchData match;
  final Function onApproval;

  String getFomattedTime() {
    return FormattedDateTime.timeLeftFromNow(match.startTime, match.duration);
  }

  Color getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(0.4);
  }

  Future<void> approveMatch() async {
    await onApproval();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchPoleView(
                match: match,
              ),
            ),
          );
        },
        child: Card(
          elevation: 5.0,
          shape: kCardShape(15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  getRandomColor(),
                  Colors.white,
                  Colors.white,
                  getRandomColor(),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.04,
                  0.04,
                  0.96,
                  0.96,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      getRandomColor(),
                      Colors.white,
                      Colors.white,
                      getRandomColor(),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.01,
                      0.01,
                      0.99,
                      0.99,
                    ],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            match.teamAName,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            //TODO: can add Mega contest pool amount
                            '',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        TeamLogoWidget(
                          name: match.teamAName,
                          icon: FontAwesomeIcons.child,
                          imageURL: match.teamAImage,
                        ),
                        Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.clock,
                              color: kAppBarColor,
                              size: 18.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            CustomClock(
                              matchData: match,
                            ),
                            Visibility(
                              visible: !match.showToAll,
                              child: FlatButton(
                                shape: kCardShape(15.0),
                                color: kAppBarColor,
                                child: Text(
                                  'Approve',
                                  style: kButtonTextStyle,
                                ),
                                onPressed: approveMatch,
                              ),
                            ),
                          ],
                        ),
                        TeamLogoWidget(
                          name: match.teamBName,
                          imageURL: match.teamBImage,
                          icon: FontAwesomeIcons.clock,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            match.teamBName,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
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
