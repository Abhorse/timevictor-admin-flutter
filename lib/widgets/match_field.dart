import 'package:flutter/material.dart';

class MatchDataCard extends StatelessWidget {
  final Function validateMatch;
  final TextEditingController matchIdController;
  final TextEditingController teamANameController;
  final TextEditingController teamBNameController;

  const MatchDataCard({
    this.validateMatch,
    this.matchIdController,
    this.teamANameController,
    this.teamBNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: matchIdController,
                  decoration: InputDecoration(labelText: 'Match ID'),
                  onChanged: (value) {
                    validateMatch();
                  },
                ),
              ),
              Expanded(
                  child: SizedBox(
                width: 10.0,
              )),
              Expanded(
                child: TextField(
                  controller: teamANameController,
                  decoration: InputDecoration(labelText: 'Team A Name'),
                  onChanged: (value) {
                    validateMatch();
                  },
                ),
              ),
              Expanded(
                  child: SizedBox(
                width: 10.0,
              )),
              Expanded(
                child: TextField(
                  controller: teamBNameController,
                  decoration: InputDecoration(labelText: 'Team B Name'),
                  onChanged: (value) {
                    validateMatch();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
