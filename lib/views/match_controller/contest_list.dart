import 'package:flutter/material.dart';
import 'package:timevictor_admin/model/pool.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/widgets/circular_loader.dart';
import 'package:timevictor_admin/widgets/pool_card.dart';

class ContestWidgetList extends StatelessWidget {
  final String matchID;

  const ContestWidgetList({Key key, this.matchID}) : super(key: key);

  List<Widget> contestWidgetList(List<Pool> pools) {
    List<Widget> contests = [];

    pools.forEach((pool) {
      contests.add(PoolCard(pool: pool));
    });

    return contests;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pool>>(
      stream: FirestoreDatabase().getPoolsByMatch(matchID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<Pool> pools = snapshot.data;
          if (pools != null && pools.length != 0) {
            return ListView(children: contestWidgetList(pools));
          } else
            return Center(
              child: Text('Please add pools',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  )),
            );
        } else
          return CircularLoader();
      },
    );
  }
}
