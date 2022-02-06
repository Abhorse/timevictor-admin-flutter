import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/model/match.dart';
import 'package:timevictor_admin/model/student.dart';
import 'package:timevictor_admin/model/subject.dart';
import 'package:timevictor_admin/services/database.dart';
import 'package:timevictor_admin/utils/helper.dart';
import 'package:timevictor_admin/widgets/platform_dropdown.dart';

class AddStudent extends StatefulWidget {
  final List<Subject> subjects;
  final MatchData match;

  AddStudent({Key key, this.subjects, this.match});

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _studentFormKey = GlobalKey<FormState>();

  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _imageURLController = TextEditingController();
  TextEditingController _scoreController = TextEditingController();

  String defaultSubject = 'select subject';
  bool isLoading = false;
  String errorMsg = '';

  List<String> getSubjectList() {
    List<String> subjects = ['select subject'];

    widget.subjects.forEach((sub) {
      subjects.add(sub.subject);
    });

    return subjects;
  }

  Future<void> addStudent(bool isTeamAStudent) async {
    try {
      setState(() {
        isLoading = true;
        errorMsg = '';
      });

      FirestoreDatabase().addStudentToTeam(
        widget.match.matchID,
        isTeamAStudent,
        Student(
          id: _idController.text,
          name: _nameController.text,
          imageURL: _imageURLController.text,
          score: _scoreController.text,
          subject: defaultSubject,
        ),
      );
      resetForm();
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMsg = 'Error while adding student data';
      });
      print(e);
    }
  }

  void resetForm() {
    _idController.clear();
    _nameController.clear();
    _imageURLController.clear();
    _scoreController.clear();
    setState(() {
      defaultSubject = 'select subject';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FlatButton(
        shape: kCardShape(20.0),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 30.0,
              color: Colors.white,
            ),
            Text(
              'Add Student',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
        color: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(
                'Add Student',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: Form(
                  key: _studentFormKey,
                  child: Column(
                    children: [
                      Text(
                        errorMsg,
                        style: TextStyle(color: Colors.red),
                      ),
                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'id',
                        ),
                        validator: (value) {
                          if (value.isEmpty) return 'required';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'name',
                        ),
                        validator: (value) {
                          if (value.isEmpty) return 'required';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _imageURLController,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                        ),
                        validator: (value) {
                          // if (value.isEmpty) return 'required';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _scoreController,
                        decoration: InputDecoration(
                          labelText: 'Score',
                        ),
                        validator: (value) {
                          if (value.isEmpty) return 'required';
                          if (!Helper.isNumeric(value))
                            return 'enter numeric value';
                          return null;
                        },
                      ),
                      PlatformDropdown(
                        defaultItem: defaultSubject,
                        items: getSubjectList(),
                        onchange: (value) {
                          setState(() {
                            defaultSubject = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          color: kAppBarColor,
                          shape: kCardShape(20.0),
                          child: Text(
                            ' Add To ${widget.match.teamAName} ',
                            style: kButtonTextStyle,
                          ),
                          onPressed: () {
                            if (_studentFormKey.currentState.validate() &&
                                defaultSubject != 'select subject') {
                              // Navigator.pop(context);
                              addStudent(true);
                            }
                          },
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        FlatButton(
                          color: kAppBarColor,
                          shape: kCardShape(20.0),
                          child: Text(
                            ' Add To ${widget.match.teamBName} ',
                            style: kButtonTextStyle,
                          ),
                          onPressed: () {
                            if (_studentFormKey.currentState.validate() &&
                                defaultSubject != 'select subject') {
                              // Navigator.pop(context);
                              addStudent(false);
                            }
                          },
                        ),
                      ],
                    ),
                    FlatButton(
                      color: Colors.red,
                      shape: kCardShape(20.0),
                      child: Text(
                        'Cancel',
                        style: kButtonTextStyle,
                      ),
                      onPressed: () {
                        resetForm();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
