import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/model/New/awards.dart';
import 'package:timevictor_admin/model/pool.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/utils/helper.dart';
import 'package:timevictor_admin/widgets/circular_loader.dart';

class CreateContestForm extends StatefulWidget {
  final String matchID;

  const CreateContestForm({this.matchID});
  @override
  _CreateContestFormState createState() => _CreateContestFormState();
}

class _CreateContestFormState extends State<CreateContestForm> {
  final _poolPrizeDataformKey = GlobalKey<FormState>();

  TextEditingController _poolPrizeController = TextEditingController(text: '0');
  TextEditingController _poolLimitController = TextEditingController(text: '0');
  TextEditingController _poolEntryController = TextEditingController(text: '0');

  bool isLoading = false;
  Awards selectedAward;

  void onChange(String value) {
    setState(() {});
  }

  int calEarning() {
    int earning = 0;
    int mpp = _poolPrizeController.text.isEmpty
        ? 0
        : int.tryParse(_poolPrizeController.text);
    int mp = _poolLimitController.text.isEmpty
        ? 0
        : int.tryParse(_poolLimitController.text) ?? 0;
    int ea = _poolEntryController.text.isEmpty
        ? 0
        : int.tryParse(_poolEntryController.text) ?? 0;

    earning = mp * ea - mpp;

    return earning;
  }

  void toggleLoader(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  Pool getPoolData() {
    int mpp = int.parse(_poolPrizeController.text) ?? 0;
    int mp = int.parse(_poolLimitController.text) ?? 0;
    int ea = int.parse(_poolEntryController.text) ?? 0;
    return Pool(
        id: 'pool_',
        currentCount: 0,
        currentPrize: mpp,
        entry: ea,
        maxLimit: mp,
        maxPrize: mpp,
        awards: selectedAward.awards,
        joinedUsers: []);
  }

  Future<void> addContestInFirebase() async {
    print('Aashish Create this pool');
    try {
      toggleLoader(true);
      final Database database = FirestoreDatabase();
      await database.createPoolByMatch(widget.matchID, getPoolData());
    } catch (e) {
      print(e);
    } finally {
      toggleLoader(false);
    }
  }

  void selectAwardTemp(Awards awards) {
    setState(() {
      selectedAward = awards;
    });
  }

  bool isAwardSelected(Awards awards) {
    if (selectedAward == null) {
      return false;
    } else if (selectedAward.name == awards.name) {
      return true;
    } else
      return false;
  }

  Widget awardCard(Awards awards) {
    List<Widget> row = awards.awards
        .map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  e['from'] == e['to']
                      ? '${e['from']}'
                      : '${e['from']}-${e['to']}',
                ),
                Text('${e['prize']}%')
              ],
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 40.0,
        shape: kButtonShape,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                        '${awards.name}',
                        style: kLableStyle,
                      )),
                  Expanded(
                    child: FlatButton(
                      color:
                          isAwardSelected(awards) ? Colors.red : Colors.green,
                      shape: kButtonShape,
                      child: Text('select'),
                      onPressed: () => selectAwardTemp(awards),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Rank',
                    style: kLableStyle,
                  ),
                  Text(
                    'Prize',
                    style: kLableStyle,
                  )
                ],
              ),
              Column(
                children: row,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> awardListViewWidget(List<Awards> awards) {
    return awards.map((e) => awardCard(e)).toList();
  }

  @override
  void dispose() {
    _poolPrizeController.dispose();
    _poolLimitController.dispose();
    _poolEntryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 400.0,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Card(
                  shape: kCardShape(10.0),
                  elevation: 20.0,
                  child: Form(
                    key: _poolPrizeDataformKey,
                    child: Column(
                      children: [
                        TextInputWidget(
                          textController: _poolPrizeController,
                          labelText: 'Pool Prize',
                          onChange: onChange,
                        ),
                        TextInputWidget(
                          textController: _poolLimitController,
                          labelText: 'Max Player',
                          onChange: onChange,
                        ),
                        TextInputWidget(
                          textController: _poolEntryController,
                          labelText: 'Entry Amount',
                          onChange: onChange,
                        ),
                        // Text('Award Template')
                        Divider(),
                        Text(
                          'Max Earning: $kRupeeSymbol ${calEarning()}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FlatButton(
                          color: Colors.green,
                          shape: kCardShape(20.0),
                          child: Text(
                            '   Create   ',
                            style: kButtonTextStyle,
                          ),
                          onPressed: () {
                            if (_poolPrizeDataformKey.currentState.validate()) {
                              addContestInFirebase();
                            }
                          },
                          // calEarning() < 0 ? null : addContestInFirebase,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 500.0,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Card(
                    shape: kCardShape(10.0),
                    child: StreamBuilder<List<Awards>>(
                      stream: FirestoreDatabase().getAwardTemplates(),
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.active) {
                          List<Awards> awds = snapshots.data;
                          print(awds);
                          return ListView(
                            children: awardListViewWidget(awds),
                          );
                        } else
                          return CircularLoader();
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrizeBreakUpWidget extends StatelessWidget {
  const PrizeBreakUpWidget({
    Key key,
    @required TextEditingController poolPrizeController,
  })  : _poolPrizeController = poolPrizeController,
        super(key: key);

  final TextEditingController _poolPrizeController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.all(30.0),
      child: Card(
        elevation: 20.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Prize for Breakup $kRupeeSymbol ${_poolPrizeController.text}',
              style: kLableStyle,
            ),
            Text(
              'Remaining Prize',
              style: kLableStyle,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(labelText: 'From rank'),
                  )),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(labelText: 'to rank'),
                  )),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(labelText: '% Prize'),
                  )),
                ],
              ),
            ),
            FlatButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Text('Add'),
              onPressed: () {},
            )
          ],
        ),
      ),
    ));
  }
}

class TextInputWidget extends StatelessWidget {
  const TextInputWidget({
    Key key,
    @required TextEditingController textController,
    @required this.labelText,
    @required this.onChange,
  })  : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  final String labelText;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: labelText),
              controller: _textController,
              onChanged: onChange,
              validator: (value) {
                if (value.isEmpty) return 'Please enter $labelText';
                if (!Helper.isNumeric(value))
                  return 'Please enter interger value';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
