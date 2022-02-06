import 'package:flutter/material.dart';
import 'package:timevictor_admin/model/pool.dart';

class PoolCard extends StatelessWidget {
  final Pool pool;

  const PoolCard({Key key, this.pool}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 20.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Max Prize',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('Rs ${pool.maxPrize}',
                          style: TextStyle(fontSize: 20.0)),
                    ],
                  ),
                  Column(
                    children: [
                      FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            // isJoined(context) ? 'Joined' : 'Entry',
                            // getButtonText(context),
                            'View Board',
                            style: TextStyle(color: Colors.white),
                          ),
                          disabledColor: Colors.grey[300],
                          color: Colors.green,
                          onPressed: pool.currentCount == pool.maxLimit
                              ? null
                              // : () => viewLeaderBoard(context),
                              : () {
                                  print('btn');
                                }),
                      Text('Entry: Rs ${pool.entry}'),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  backgroundColor: Colors.grey,
                  value: (pool.currentCount / pool.maxLimit),
                  minHeight: 10.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Available Seats: ${pool.maxLimit - pool.currentCount}'),
                  Text('Max Seats: ${pool.maxLimit}')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
