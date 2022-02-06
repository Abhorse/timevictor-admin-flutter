import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/home/drawer.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/views/matches/match_tile_widget.dart';
import 'package:timevictor_admin/widgets/match_template.dart';
import 'package:timevictor_admin/widgets/sidebar_widget.dart';

class MatchList extends StatefulWidget {
  static final String route = '/matchList';

  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  List<Widget> matchList = [];

  void readMatchData() {
    try {
      Database database = FirestoreDatabase();
      var activeMatches = database.getActiveMatches();
      activeMatches.listen((matches) {
        matches.forEach((match) {
          print(
              'MatchID: ${match.matchID}, TeamA: ${match.teamAName}, TeamB: ${match.teamBName}');
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> approveMatch(String matchID) async {
    try {
      Database database = FirestoreDatabase();
      await database.approvePendingMatch(matchID);
      print('approved , Welcome.');
    } catch (e) {
      print(e);
    }
  }

  List<Widget> getMatchList(List<MatchData> matches) {
    List<Widget> matchList = [];
    matches.forEach((match) {
      matchList.add(
        MatchCard(
          match: match,
          onApproval: () {
            print('please');
            approveMatch(match.matchID);
          },
        ),
      );
    });
    return matchList;
  }

  @override
  Widget build(BuildContext context) {
    final database = FirestoreDatabase();
    return DefaultTabController(
      length: 4,
      child: Container(
        child: Row(
          children: [
            SideBarWidget(),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: kAppBarColor,
                  title: Text('All Matches'),
                  bottom: TabBar(
                    tabs: [
                      new Tab(
                        // text: 'Pending',
                        icon: Icon(
                          Icons.report_problem,
                          color: Colors.red,
                        ),
                      ),
                      new Tab(
                        // text: 'Upcoming',
                        icon: Icon(Icons.insert_invitation),
                      ),
                      new Tab(
                        // text: 'Live',
                        icon: Icon(Icons.live_tv),
                      ),
                      new Tab(
                        // text: 'Closed',
                        icon: Icon(
                          Icons.done_all,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                ),
                drawer: MediaQuery.of(context).size.width > 600
                    ? null
                    : HomeDrawer(),
                body: TabBarView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<List<MatchData>>(
                          stream: database.getInActiveMatches(),
                          // stream: database.getPendingMatches(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              List<MatchData> matches = snapshot.data;
                              if (matches != null && matches.length != 0) {
                                return Expanded(
                                  child: ListView(
                                    children: getMatchList(matches),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text('There are no pending matches'),
                                );
                              }
                            } else
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<List<MatchData>>(
                          stream: database.getActiveMatches(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              List<MatchData> matches = snapshot.data;
                              if (matches != null && matches.length != 0) {
                                return Expanded(
                                  child: ListView(
                                    children: getMatchList(matches),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text('There are no upcoming matches'),
                                );
                              }
                            } else
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                          },
                        ),
                      ],
                    ),
                    Center(
                      child: Icon(Icons.live_help),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<List<MatchData>>(
                          stream: database.getCompletedMatches(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              List<MatchData> matches = snapshot.data;
                              // print(matches[0].endTime);
                              // print(matches[0].endTime.compareTo(Timestamp.now()));
                              print('end');
                              if (matches != null && matches.length != 0) {
                                return Expanded(
                                  child: ListView(
                                    children: getMatchList(matches),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text(
                                      'None of the matches completed yet!'),
                                );
                              }
                            } else
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
