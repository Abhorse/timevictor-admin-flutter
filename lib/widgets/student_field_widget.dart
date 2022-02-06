import 'package:flutter/material.dart';
import 'package:timevictor_admin/widgets/platform_dropdown.dart';

class StudentField extends StatelessWidget {
  final Function validateStudnet;
  final TextEditingController nameController;
  final TextEditingController scoreController;
  // final TextEditingController subjectController;
  final PlatformDropdown platformDropdown;

  const StudentField(
      {this.validateStudnet,
      this.nameController,
      this.scoreController,
      // this.subjectController,
      this.platformDropdown});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Student Data',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                            onChanged: (value) {
                              validateStudnet();
                            },
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          width: 10.0,
                        )),
                        Expanded(
                          child: TextField(
                            controller: scoreController,
                            decoration: InputDecoration(labelText: 'Score'),
                            onChanged: (value) {
                              validateStudnet();
                            },
                          ),
                        ),
                        // Expanded(
                        //     child: SizedBox(
                        //   width: 10.0,
                        // )),
                        // Expanded(
                        //   child: TextField(
                        //     controller: subjectController,
                        //     decoration: InputDecoration(labelText: 'Subject'),
                        //     onChanged: (value) {
                        //       validateStudnet();
                        //     },
                        //   ),
                        // ),
                        Expanded(
                            child: SizedBox(
                          width: 10.0,
                        )),
                        Expanded(
                          child: platformDropdown,
                        )
                      ],
                    ),
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
