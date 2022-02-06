import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/home/drawer.dart';
import 'package:timevictor_admin/model/New/notification.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/widgets/circular_loader.dart';
import 'package:timevictor_admin/widgets/sidebar_widget.dart';

class NotificationPage extends StatefulWidget {
  static final String route = '/notificationPage';

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _messagetextController = TextEditingController();
  final _msgformKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<Widget> notificationCard(List<NotificationData> notifications) {
    return notifications
        .map((notify) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
              child: Card(
                // shape: kCardShape(5),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notify.title,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(notify.date),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(notify.message),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }

  void toggleLoader(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  Future<void> sendNotification() async {
    if (_msgformKey.currentState.validate()) {
      // await widget.payout(_amountController.text);
      print(_messagetextController.text);
      print(_titleTextController.text);
      try {
        toggleLoader(true);
        await FirestoreDatabase().createNotification(NotificationData(
          title: _titleTextController.text,
          message: _messagetextController.text,
        ));
        _titleTextController.clear();
        _messagetextController.clear();
      } catch (e) {
        print(e);
      } finally {
        toggleLoader(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SideBarWidget(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Notifications Manager'),
                backgroundColor: kAppBarColor,
              ),
              drawer:
                  MediaQuery.of(context).size.width > 600 ? null : HomeDrawer(),
              body: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Card(
                        child: Form(
                          key: _msgformKey,
                          child: Column(
                            children: [
                              Text(
                                'Send New Notification',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: _titleTextController,
                                  decoration:
                                      InputDecoration(labelText: 'Title'),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Please enter title';
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: _messagetextController,
                                  decoration:
                                      InputDecoration(labelText: 'Message'),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Please enter message';
                                    return null;
                                  },
                                ),
                              ),
                              FlatButton(
                                color: Colors.green,
                                child: Text('Send'),
                                onPressed: sendNotification,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: FirestoreDatabase().getAllNotifications(),
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.active) {
                          List<NotificationData> notfications = snapshots.data;
                          if (notfications != null &&
                              notfications.length != 0) {
                            return Expanded(
                              child: ListView(
                                children: notificationCard(notfications),
                              ),
                            );
                          } else
                            return Text('You dont have any notification yet.');
                        } else
                          return CircularLoader();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
