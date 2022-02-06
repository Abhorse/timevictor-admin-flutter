import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/home/drawer.dart';
import 'package:timevictor_admin/model/New/awards.dart';
import 'package:timevictor_admin/model/New/rank_and_prize.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/widgets/circular_loader.dart';
import 'package:timevictor_admin/widgets/sidebar_widget.dart';

class AwardTemplate extends StatefulWidget {
  static final String route = '/awardTemplate';
  @override
  _AwardTemplateState createState() => _AwardTemplateState();
}

class _AwardTemplateState extends State<AwardTemplate> {
  int totalAwards = 100;
  int totalPlayers = 100;
  bool isLoading = false;

  TextEditingController _fromRankController = TextEditingController();
  TextEditingController _toRankController = TextEditingController();
  TextEditingController _prizeController = TextEditingController();
  TextEditingController _tempNameController = TextEditingController();

  List<RankPrizePair> awards = [];

  toggleLoader(bool status) {
    setState(() => isLoading = status);
  }

  Future<void> addAwardsToFirebase() async {
    try {
      toggleLoader(true);
      Database database = FirestoreDatabase();
      await database.createAwardTemplate(
        _tempNameController.text,
        Awards(awards: awards),
      );
      _tempNameController.clear();
      awards.clear();
    } catch (e) {
      print(e);
    } finally {
      toggleLoader(false);
    }
  }

  void addAwardToList() {
    if (_fromRankController.text.isNotEmpty &&
        _toRankController.text.isNotEmpty &&
        _prizeController.text.isNotEmpty) {
      int from = int.parse(_fromRankController.text);
      int to = int.parse(_toRankController.text);
      int prize = int.parse(_prizeController.text);
      //TODO: check for integer type of rank and prize
      if (totalAwards - (to - from + 1) * prize >= 0) {
        awards.add(RankPrizePair(
          from: from,
          to: to,
          prize: prize,
        ));
        setState(() {
          totalAwards -= (to - from + 1) * prize;
        });
        clearTextFieldsAndList();
      }
    }
  }

  Widget rankPrizeCard(RankPrizePair rankPrizePair, bool isReal) {
    String rank = rankPrizePair.from == rankPrizePair.to
        ? rankPrizePair.from.toString()
        : rankPrizePair.from.toString() + '-' + rankPrizePair.to.toString();
    String prize = rankPrizePair.prize.toString() + '%';

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                isReal ? rank : 'RANK',
                style: kLableStyle,
              ),
              Text(
                isReal ? prize : 'PRIZE',
                style: kLableStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getAwardList() =>
      awards.map((e) => rankPrizeCard(e, true)).toList();

  void clearTextFieldsAndList() {
    _fromRankController.clear();
    _toRankController.clear();
    _prizeController.clear();
  }

  @override
  void dispose() {
    _prizeController.dispose();
    _fromRankController.dispose();
    _toRankController.dispose();
    super.dispose();
  }

  Widget createAwardTempView(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
            child: Card(
              elevation: 40.0,
              shape: kButtonShape,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                child: TextField(
                  controller: _tempNameController,
                  decoration: InputDecoration(
                      labelText:
                          'Template Name (Without space Ex. team1VSteam2Default'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Center(
              child: Text(
            'Award left $totalAwards%',
            style: kLableStyle,
          )),
          Center(
              child: Text(
            'Players left $totalPlayers%',
            style: kLableStyle,
          )),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              shape: kButtonShape,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _fromRankController,
                      decoration: InputDecoration(labelText: 'From rank'),
                    )),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                        child: TextField(
                      controller: _toRankController,
                      decoration: InputDecoration(labelText: 'to rank'),
                    )),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                        child: TextField(
                      controller: _prizeController,
                      decoration: InputDecoration(labelText: '% Prize'),
                    )),
                    SizedBox(
                      width: 60.0,
                    ),
                    Expanded(
                      child: FlatButton(
                        color: Colors.green,
                        shape: kButtonShape,
                        child: Text('Add'),
                        onPressed: addAwardToList,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          rankPrizeCard(RankPrizePair(), false),
          Expanded(
              child: ListView(
            children: getAwardList(),
          )),
          Center(
            child: FlatButton(
              color: Colors.green,
              disabledColor: Colors.grey[300],
              shape: kButtonShape,
              child: Text('Add To Firebase'),
              onPressed: totalAwards == 0 && _tempNameController.text.isNotEmpty
                  ? addAwardsToFirebase
                  : null,
            ),
          )
        ],
      ),
    );
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
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
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

  Widget viewAwardTemp(BuildContext context) {
    return StreamBuilder<List<Awards>>(
      stream: FirestoreDatabase().getAwardTemplates(),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.active) {
          List<Awards> awds = snapshots.data;
          print(awds);
          return ListView(
            children: awardListViewWidget(awds),
          );
        } else
          return CircularLoader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SideBarWidget(),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                drawer: MediaQuery.of(context).size.width > 600
                    ? null
                    : HomeDrawer(),
                appBar: AppBar(
                  title: Text('Create Prize Break up Template'),
                  backgroundColor: kAppBarColor,
                  bottom: TabBar(tabs: <Tab>[
                    Tab(child: Text('All Templates')),
                    Tab(child: Text('Create Template')),
                  ]),
                ),
                body: ModalProgressHUD(
                  inAsyncCall: isLoading,
                  child: TabBarView(
                    children: [
                      viewAwardTemp(context),
                      createAwardTempView(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
