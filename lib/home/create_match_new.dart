import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/home/drawer.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/model/student.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'package:timevictor_admin/model/team.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/utils/helper.dart';
import 'package:timevictor_admin/widgets/platform_dropdown.dart';
import 'package:timevictor_admin/widgets/sidebar_widget.dart';

class CreateMatchNew extends StatefulWidget {
  static String route = '/createMatchNew';
  @override
  _CreateMatchNewState createState() => _CreateMatchNewState();
}

class _CreateMatchNewState extends State<CreateMatchNew> {
  final _matchDataformKey = GlobalKey<FormState>();
  final _subjectDataformKey = GlobalKey<FormState>();
  final _studentDataformKey = GlobalKey<FormState>();

  String defualtSubject = 'select subject';
  bool _showSubjectForm = false;
  bool _showMatchDataForm = true;
  bool _showStudentDataForm = false;
  bool _showTeamAStudent = true;
  bool _showTeamBStudent = false;
  bool _showReview = false;
  bool isLoading = false;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _teamANameController = TextEditingController();
  TextEditingController _teamALogoURLController = TextEditingController();
  TextEditingController _teamBNameController = TextEditingController();
  TextEditingController _teamBLogoURLController = TextEditingController();
  TextEditingController _matchDurationController = TextEditingController();

  TextEditingController _subNameController = TextEditingController();
  TextEditingController _subMinController = TextEditingController();
  TextEditingController _subMaxController = TextEditingController();

  TextEditingController _stuNameController = TextEditingController();
  TextEditingController _stuIDController = TextEditingController();
  TextEditingController _stuTMScoreController = TextEditingController();
  TextEditingController _stuImageController = TextEditingController();
  TextEditingController _stuSubjectController = TextEditingController();

  DateTime _startDate;
  TimeOfDay _startTime;
  List<Subject> subjecList = [];
  List<String> subjectNameList = ['select subject'];
  List<Student> teamAStudentList = [];
  List<Student> teamBStudentList = [];
  List<Widget> getSubjects() {
    return subjecList
        .map((sub) => Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('Name'),
                        Text(sub.subject),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Max Students'),
                        Text(sub.maxStudents.toString()),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Min Students'),
                        Text(sub.minStudents.toString()),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          subjecList.remove(sub);
                          subjectNameList.remove(sub.subject);
                        });
                      },
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  List<Widget> getTeamAStudents() {
    return teamAStudentList
        .map((stu) => Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('id'),
                        Text(stu.id),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Name'),
                        Text(stu.name),
                      ],
                    ),
                    Column(
                      children: [
                        Text('TM Score'),
                        Text(stu.score),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Subject'),
                        Text(stu.subject),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          teamAStudentList.remove(stu);
                        });
                      },
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  List<Widget> getTeamBStudents() {
    return teamBStudentList
        .map((stu) => Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('id'),
                        Text(stu.id),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Name'),
                        Text(stu.name),
                      ],
                    ),
                    Column(
                      children: [
                        Text('TM Score'),
                        Text(stu.score),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Subject'),
                        Text(stu.subject),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          teamBStudentList.remove(stu);
                        });
                      },
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  Widget subjectForm() {
    return Visibility(
      visible: _showSubjectForm,
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
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
                            if (_subjectDataformKey.currentState.validate()) {
                              print('add subject');
                              setState(() {
                                subjecList.add(Subject(
                                  subject: _subNameController.text,
                                  maxStudents:
                                      int.parse(_subMaxController.text),
                                  minStudents:
                                      int.parse(_subMinController.text),
                                ));
                                subjectNameList.add(_subNameController.text);
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: getSubjects(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    color: kAppBarColor,
                    shape: kCardShape(15.0),
                    child: Text(
                      'Back',
                      style: kButtonTextStyle,
                    ),
                    onPressed: () {
                      setState(() {
                        _showSubjectForm = false;
                        _showMatchDataForm = true;
                      });
                    },
                  ),
                  FlatButton(
                    color: kAppBarColor,
                    shape: kCardShape(15.0),
                    child: Text(
                      'Save & Next',
                      style: kButtonTextStyle,
                    ),
                    onPressed: () {
                      if (subjecList.length > 0) {
                        setState(() {
                          _showSubjectForm = false;
                          _showStudentDataForm = true;
                        });
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Form matchDataForm() {
    return Form(
      key: _matchDataformKey,
      child: Column(
        children: [
          SizedBox(
            height: 65,
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
            height: 65,
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
            height: 65,
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
            height: 65,
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
          SizedBox(
            height: 65,
            child: TextFormField(
              controller: _matchDurationController,
              decoration: InputDecoration(labelText: 'Match Duration (in min)'),
              validator: (value) {
                if (value.isEmpty) return 'Please Enter Match Duration';
                if (!Helper.isNumeric(value))
                  return 'Please enter interger value';
                return null;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            _startDate = date;
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
                            _startTime = time;
                          })
                        }
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
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
              Expanded(
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
          SizedBox(
            height: 15.0,
            width: 15.0,
          ),
          FlatButton(
            color: kAppBarColor,
            shape: kCardShape(15.0),
            child: Text(
              'Save & Next',
              style: kButtonTextStyle,
            ),
            onPressed: () {
              if (_matchDataformKey.currentState.validate()) {
                print('valid form');
                setState(() {
                  _showSubjectForm = true;
                  _showMatchDataForm = false;
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

  Widget studentDataForm() {
    return Visibility(
      visible: _showStudentDataForm,
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _studentDataformKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stuIDController,
                                decoration: InputDecoration(labelText: 'Id'),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please Enter Student ID';
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _stuNameController,
                                decoration:
                                    InputDecoration(labelText: 'Student Name'),
                                validator: (value) {
                                  if (value.isEmpty) return 'Please Enter Name';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _stuImageController,
                          decoration:
                              InputDecoration(labelText: 'Student Image URL'),
                          validator: (value) {
                            // if (value.isEmpty) return 'Please Enter Name';
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stuTMScoreController,
                                decoration: InputDecoration(
                                    labelText: 'Timemarks Score'),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please Enter TM Score';
                                  if (!Helper.isNumeric(value))
                                    return 'Please Enter Interger Value';
                                  if (double.parse(value) > 10)
                                    return 'please enter score <= 10';
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: PlatformDropdown(
                                items: subjectNameList,
                                defaultItem: defualtSubject,
                                onchange: (value) {
                                  setState(() {
                                    defualtSubject = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              color: kAppBarColor,
                              shape: kCardShape(15.0),
                              child: Text(
                                'Add to Team A',
                                style: kButtonTextStyle,
                              ),
                              onPressed: () {
                                if (_studentDataformKey.currentState
                                        .validate() &&
                                    defualtSubject != 'select subject') {
                                  print('add student');
                                  setState(() {
                                    teamAStudentList.add(
                                      Student(
                                        id: _stuIDController.text,
                                        name: _stuNameController.text,
                                        imageURL: _stuImageController.text,
                                        score: _stuTMScoreController.text,
                                        subject: defualtSubject,
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                            FlatButton(
                              color: kAppBarColor,
                              shape: kCardShape(15.0),
                              child: Text(
                                'View Team A (${teamAStudentList.length})',
                                style: kButtonTextStyle,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showTeamAStudent = true;
                                  _showTeamBStudent = false;
                                });
                              },
                            ),
                            FlatButton(
                              color: kAppBarColor,
                              shape: kCardShape(15.0),
                              child: Text(
                                'Add to Team B',
                                style: kButtonTextStyle,
                              ),
                              onPressed: () {
                                if (_studentDataformKey.currentState
                                        .validate() &&
                                    defualtSubject != 'select subject') {
                                  print('add student');
                                  setState(() {
                                    teamBStudentList.add(
                                      Student(
                                        id: _stuIDController.text,
                                        name: _stuNameController.text,
                                        imageURL: _stuImageController.text,
                                        score: _stuTMScoreController.text,
                                        subject: defualtSubject,
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                            FlatButton(
                              color: kAppBarColor,
                              shape: kCardShape(15.0),
                              child: Text(
                                'View Team B (${teamBStudentList.length})',
                                style: kButtonTextStyle,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showTeamAStudent = false;
                                  _showTeamBStudent = true;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _showTeamAStudent
                      ? getTeamAStudents()
                      : getTeamBStudents(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    color: kAppBarColor,
                    shape: kCardShape(15.0),
                    child: Text(
                      'Back',
                      style: kButtonTextStyle,
                    ),
                    onPressed: () {
                      setState(() {
                        _showSubjectForm = true;
                        _showStudentDataForm = false;
                      });
                    },
                  ),
                  FlatButton(
                    color: kAppBarColor,
                    shape: kCardShape(15.0),
                    child: Text(
                      'Review',
                      style: kButtonTextStyle,
                    ),
                    onPressed: () {
                      if (teamAStudentList.length > 0
                          // && teamAStudentList.length == teamBStudentList.length
                          ) {
                        setState(() {
                          _showStudentDataForm = false;
                          _showReview = true;
                        });
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget review() {
    return Visibility(
      visible: _showReview,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              color: kAppBarColor,
              shape: kCardShape(15.0),
              child: Text(
                'Back',
                style: kButtonTextStyle,
              ),
              onPressed: () {
                if (teamAStudentList.length > 0) {
                  setState(() {
                    _showStudentDataForm = true;
                    _showReview = false;
                  });
                }
              },
            ),
            FlatButton(
              color: kAppBarColor,
              shape: kCardShape(15.0),
              child: Text(
                'Done',
                style: kButtonTextStyle,
              ),
              onPressed: () {
                onSubmitForm();
                // reset();
              },
            ),
          ],
        ),
      ),
    );
  }

  void reset() {
    defualtSubject = 'select subject';
    _showSubjectForm = false;
    _showMatchDataForm = true;
    _showStudentDataForm = false;
    _showTeamAStudent = true;
    _showTeamBStudent = false;
    _showReview = false;

    _dateController.clear();
    _timeController.clear();
    _teamANameController.clear();
    _teamALogoURLController.clear();
    _teamBNameController.clear();
    _teamBLogoURLController.clear();
    _matchDurationController.clear();

    _subNameController.clear();
    _subMinController.clear();
    _subMaxController.clear();

    _stuNameController.clear();
    _stuIDController.clear();
    _stuTMScoreController.clear();
    _stuImageController.clear();
    _stuSubjectController.clear();

    subjecList = [];
    subjectNameList = ['select subject'];
    teamAStudentList = [];
    teamBStudentList = [];

    setState(() {});
  }

  Future<void> onSubmitForm() async {
    setState(() => isLoading = true);
    try {
      DateTime startTime = new DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      int duration = int.parse(_matchDurationController.text);
      DateTime endTime = startTime.add(Duration(minutes: duration));
      MatchData matchData = MatchData(
        showToAll: false,
        matchID:
            '${_teamANameController.text}VS${_teamBNameController.text}-${startTime.toString()}',
        startTime: Timestamp.fromDate(startTime),
        endTime: Timestamp.fromDate(endTime),
        duration: duration,
        teamAName: _teamANameController.text,
        teamAImage: _teamALogoURLController.text,
        teamBName: _teamBNameController.text,
        teamBImage: _teamBLogoURLController.text,
        totalPools: 0,
        teamA: TeamData(
            teamName: _teamANameController.text, students: teamAStudentList),
        teamB: TeamData(
            teamName: _teamBNameController.text, students: teamBStudentList),
        subjects: subjecList,
      );
      Database database = FirestoreDatabase();
      await database.createMatch(matchData);
      reset();
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
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
                backgroundColor: kAppBarColor,
                title: Text(
                  'Create Match',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              drawer:
                  MediaQuery.of(context).size.width > 600 ? null : HomeDrawer(),
              body: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: Container(
                  child: Column(
                    children: [
                      Visibility(
                        visible: _showMatchDataForm,
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                    child: matchDataForm()),
                              ),
                            ),
                          ),
                        ),
                      ),
                      subjectForm(),
                      studentDataForm(),
                      review(),
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
