import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timevictor_admin/initial_view.dart';
import 'package:timevictor_admin/views/auth/welcome_page.dart';
import 'package:timevictor_admin/widgets/circular_loader.dart';

class AuthServices {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData) {
          return HomeView();
        } else {
          return WelcomeScreen();
        }
        // } else {
        //   return CircularLoader();
        // }
      },
    );
  }

  Future<AuthResult> singin(String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return authResult;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
