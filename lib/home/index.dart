import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/home/drawer.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/model/student.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'package:timevictor_admin/model/team.dart';
// import 'package:timevictor_admin/model/team.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/widgets/match_field.dart';
import 'package:timevictor_admin/widgets/platform_dropdown.dart';
import 'package:timevictor_admin/widgets/student_field_widget.dart';
// import 'package:timevictor_admin/widgets/team_widget.dart';

class AddMatchView extends StatefulWidget {
  static final String route = '/addMatch';

  @override
  _AddMatchViewState createState() => _AddMatchViewState();
}

class _AddMatchViewState extends State<AddMatchView> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _scoreController = TextEditingController();
  // TextEditingController _subjectController = TextEditingController();

  TextEditingController _subController = TextEditingController();

  TextEditingController matchIdController = TextEditingController();
  TextEditingController teamANameController = TextEditingController();
  TextEditingController teamBNameController = TextEditingController();

  List<Student> teamA = [];
  List<Student> teamB = [];
  List<String> subjects = ['Select'];
  String defualtSubject = 'Select';
  String minStudents = '0';
  String maxStudents = '0';

  List<Subject> sub = [
    Subject(subject: 'Select', maxStudents: 0, minStudents: 0)
  ];

  bool isValidMatch = false;
  bool isLoading = false;
  bool isFormReady = true;
  bool isValidStudent = false;

  Database database = FirestoreDatabase();

  void validateMatch() {
    setState(() {
      isValidMatch = !(matchIdController.text.isEmpty ||
          teamANameController.text.isEmpty ||
          teamBNameController.text.isEmpty);
    });
  }

  void validateStudnet() {
    setState(() {
      isValidStudent = !(_nameController.text.isEmpty ||
          _scoreController.text.isEmpty ||
          defualtSubject == 'Select');
    });
  }

  void addSubject() {
    setState(() {
      subjects.add(_subController.text);
      sub.add(Subject(
          subject: _subController.text,
          minStudents: int.parse(minStudents),
          maxStudents: int.parse(maxStudents)));
      minStudents = '0';
      maxStudents = '0';
    });
    _subController.clear();
  }

  List<Widget> getSubjectList() => sub
      .skip(1)
      .map((e) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                '${e.subject}  Min Students: ${e.minStudents}, Max Students: ${e.maxStudents}'),
          ))
      .toList();
  // subjects.skip(1).map((e) => Text(e)).toList();

  void addStudentToTeam({bool isTeamA}) {
    Student student = Student(
      name: _nameController.text,
      score: _scoreController.text,
      subject: defualtSubject,
    );
    setState(() {
      isTeamA ? teamA.add(student) : teamB.add(student);
    });

    _nameController.clear();
    _scoreController.clear();
    // _subjectController.clear();
    setState(() {
      isValidStudent = false;
      defualtSubject = 'Select';
    });
  }

  Widget studentCard(Student student) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Name: ${student.name}'),
              SizedBox(width: 10.0),
              Text('Score: ${student.score}'),
              SizedBox(width: 10.0),
              Text('Subject: ${student.subject}')
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> renderTeamB() {
    List<Widget> team = [];
    teamB.forEach((student) {
      team.add(studentCard(student));
    });
    return team;
  }

  List<Widget> renderTeamA() {
    List<Widget> team = [];
    teamA.forEach((student) {
      team.add(studentCard(student));
    });
    return team;
  }

  Future<void> onSubmitForm() async {
    setState(() => isLoading = true);
    try {
      MatchData matchData = MatchData(
          matchID: matchIdController.text,
          teamAName: teamANameController.text,
          teamBName: teamBNameController.text,
          teamA: TeamData(teamName: teamANameController.text, students: teamA),
          teamB: TeamData(teamName: teamBNameController.text, students: teamB),
          subjects: sub.skip(1).toList());
      await database.createMatch(matchData);
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
      resetForm();
    }
  }

  void resetForm() {
    _nameController.clear();
    _scoreController.clear();
    // _subjectController.clear();
    matchIdController.clear();
    teamBNameController.clear();
    teamANameController.clear();
    setState(() {
      teamA = [];
      teamB = [];
      isValidMatch = false;
      subjects = ['Select'];
      sub = [Subject(subject: 'Select', maxStudents: 0, minStudents: 0)];
    });
  }

  void teamAOnChange() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text(
          'Create Match',
        ),
      ),
      drawer: HomeDrawer(),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MatchDataCard(
                matchIdController: matchIdController,
                teamANameController: teamANameController,
                teamBNameController: teamBNameController,
                validateMatch: validateMatch,
              ),
              SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: isValidMatch,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      Text(
                        'Add Subjects',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration:
                                          InputDecoration(labelText: 'Subject'),
                                      controller: _subController,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text('Mininum Students'),
                                        PlatformDropdown(
                                          items: kNumberList,
                                          defaultItem: minStudents,
                                          onchange: (value) {
                                            setState(() {
                                              minStudents = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text('Maximun Students'),
                                        PlatformDropdown(
                                          items: kNumberList,
                                          defaultItem: maxStudents,
                                          onchange: (value) {
                                            setState(() {
                                              maxStudents = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  FlatButton(
                                    color: Colors.green,
                                    child: Icon(Icons.add),
                                    onPressed: () {
                                      print(_subController.text);
                                      addSubject();
                                    },
                                  )
                                ],
                              ),
                              Column(
                                children: getSubjectList(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: sub.length > 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StudentField(
                        nameController: _nameController,
                        scoreController: _scoreController,
                        // subjectController: _subjectController,
                        validateStudnet: validateStudnet,
                        platformDropdown: PlatformDropdown(
                          items: subjects,
                          defaultItem: defualtSubject,
                          onchange: (value) {
                            setState(() {
                              defualtSubject = value;
                            });
                            validateStudnet();
                          },
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: Colors.red,
                          child: Text('Add to ${teamANameController.text}'),
                          onPressed: !isValidStudent
                              ? null
                              : () => addStudentToTeam(isTeamA: true),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: Text('Add to ${teamBNameController.text}'),
                          onPressed: !isValidStudent
                              ? null
                              : () => addStudentToTeam(isTeamA: false),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: renderTeamA(),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: renderTeamB(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                color: kAppBarColor,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (isValidMatch &&
                        (teamB.length == teamA.length) &&
                        teamA.length > 0)
                    ? onSubmitForm
                    : null,
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: isValidMatch ? resetForm : null,
              )
            ],
          )),
        ),
      ),
    );
  }
}
