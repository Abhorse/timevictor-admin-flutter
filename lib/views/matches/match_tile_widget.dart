import 'package:flutter/material.dart';
import 'package:timevictor_admin/dateTime_formater.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/views/match_controller/matchPole_view.dart';
// import 'package:timevictor_admin/views/matchPole_view.dart';

class MatchTileWidget extends StatelessWidget {
  const MatchTileWidget({
    Key key,
    @required this.context,
    @required this.match,
  }) : super(key: key);

  final BuildContext context;
  final MatchData match;

  Future<void> updateLeaderboard() async {
    print('Logger: going to do the magic here..');
    // try {
    //   Database database = FirestoreDatabase();
    //   await database.updateMatchScore(match.matchID);
    //   // await database.updateLeaderBoardByMatchID(match.matchID);
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(FormattedDateTime.formate(match.startTime, 30)),
              Text(match.teamAName),
              SizedBox(width: 10.0),
              Text('vs'),
              SizedBox(width: 10.0),
              Text(match.teamBName),
              SizedBox(width: 10.0),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: Text('More'),
                color: Colors.green,
                onPressed: () {
                  //TODO: will add named route here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchPoleView(
                        match: match,
                      ),
                    ),
                  );
                },
              ),
              // FlatButton(
              //   color: Colors.red[400],
              //   child: Text('Update Leaderboard'),
              //   onPressed: updateLeaderboard,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
