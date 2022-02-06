import 'package:flutter/material.dart';

class ProfilePicView extends StatelessWidget {
  final String profilePicURL;

  const ProfilePicView({Key key, this.profilePicURL}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'profilePic',
            child: Image.network(profilePicURL),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
