import 'package:flutter/material.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/home/drawer.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'package:timevictor_admin/utils/helper.dart';

class CreateMatch extends StatefulWidget {
  static String route = '/createMatch';
  @override
  _CreateMatchState createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  final _matchDataformKey = GlobalKey<FormState>();
  final _subjectDataformKey = GlobalKey<FormState>();

  // DateTime _matchStartDate;
  // TimeOfDay _matchStartTime;
  bool _showSubjectForm = false;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _teamANameController = TextEditingController();
  TextEditingController _teamALogoURLController = TextEditingController();
  TextEditingController _teamBNameController = TextEditingController();
  TextEditingController _teamBLogoURLController = TextEditingController();

  TextEditingController _subNameController = TextEditingController();
  TextEditingController _subMinController = TextEditingController();
  TextEditingController _subMaxController = TextEditingController();

  List<Subject> subjecList = [];
  List<Widget> getSubjects() {
    return subjecList
        .map((sub) => Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name: ${sub.subject}'),
                    Text('Max Students: ${sub.maxStudents}'),
                    Text('MIn Students: ${sub.minStudents}'),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          subjecList.remove(sub);
                        });
                      },
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  List<Widget> getChildrens() {
    return [
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: matchDataForm(),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 15.0,
        width: 15.0,
      ),
      Expanded(
        child: Visibility(
          visible: _showSubjectForm,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: getSubjects(),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _subjectDataformKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _subNameController,
                              decoration:
                                  InputDecoration(labelText: 'Subject Name'),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please Enter Subject Name';
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _subMinController,
                              decoration:
                                  InputDecoration(labelText: 'Mininum Student'),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please Enter Minimum Sudents';
                                if (!Helper.isNumeric(value))
                                  return 'Please Enter Interger Value';
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _subMaxController,
                              decoration: InputDecoration(
                                labelText: 'Maximum Students',
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please Enter Maximum Students';
                                if (!Helper.isNumeric(value))
                                  return 'Please Enter Interger Value';
                                return null;
                              },
                            ),
                            FlatButton(
                              color: kAppBarColor,
                              shape: kCardShape(15.0),
                              child: Text(
                                'Add Subject',
                                style: kButtonTextStyle,
                              ),
                              onPressed: () {
                                if (_subjectDataformKey.currentState
                                    .validate()) {
                                  print('add subject');
                                  setState(() {
                                    subjecList.add(Subject(
                                      subject: _subNameController.text,
                                      maxStudents:
                                          int.parse(_subMaxController.text),
                                      minStudents:
                                          int.parse(_subMinController.text),
                                    ));
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ];
  }

  Form matchDataForm() {
    return Form(
      key: _matchDataformKey,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: _teamANameController,
              decoration: InputDecoration(labelText: 'Team A Name'),
              validator: (value) {
                if (value.isEmpty) return 'Please Enter Team A Name';
                return null;
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: _teamALogoURLController,
              decoration: InputDecoration(labelText: 'Team A Logo URL'),
              validator: (value) {
                if (value.isEmpty) return 'Please Enter Team A Logo URL';
                return null;
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: _teamBNameController,
              decoration: InputDecoration(labelText: 'Team B Name'),
              validator: (value) {
                if (value.isEmpty) return 'Please Enter Team B Name';
                return null;
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: _teamBLogoURLController,
              decoration: InputDecoration(labelText: 'Team B Logo URL'),
              validator: (value) {
                if (value.isEmpty) return 'Please Enter Team B Logo URL';
                return null;
              },
            ),
          ),
          SizedBox(
            height: 15.0,
            width: 15.0,
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Year-Month-Day'),
                    validator: (value) {
                      if (value.isEmpty) return 'Please Select Date';
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(labelText: 'Hour: Min'),
                    validator: (value) {
                      if (value.isEmpty) return 'Please Select Time';
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
            width: 15.0,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: Colors.green,
                  child: Text(
                    'Select Date',
                    style: kButtonTextStyle,
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        Duration(days: 365),
                      ),
                    ).then(
                      (date) => {
                        if (date != null)
                          {
                            setState(() {
                              _dateController.text = date.toString();
                            })
                          }
                      },
                    );
                  },
                ),
                FlatButton(
                  color: Colors.green,
                  child: Text(
                    'Select Start Time',
                    style: kButtonTextStyle,
                  ),
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 0, minute: 15),
                    ).then(
                      (time) => {
                        if (time != null)
                          {
                            setState(() {
                              _timeController.text =
                                  time.format(context).toString();
                            })
                          }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 15.0,
          //   width: 15.0,
          // ),
          FlatButton(
            color: kAppBarColor,
            shape: kCardShape(15.0),
            child: Text(
              'Add Subjects',
              style: kButtonTextStyle,
            ),
            onPressed: () {
              if (_matchDataformKey.currentState.validate()) {
                print('valid form');
                setState(() {
                  _showSubjectForm = true;
                });
              } else {
                setState(() {
                  _showSubjectForm = false;
                });
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text(
          'Create Match',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: HomeDrawer(),
      body: Container(
        child: Column(
          children: [
            MediaQuery.of(context).size.width > 450
                ? Expanded(
                    child: Row(
                      children: getChildrens(),
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: getChildrens(),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
