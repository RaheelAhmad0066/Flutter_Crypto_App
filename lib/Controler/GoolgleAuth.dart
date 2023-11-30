import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../View/navBar.dart';

class GoogleAuth extends GetxController {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> handleSignInAndNavigateToHome(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential? userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential != null) {
          // Store user information in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userName', userCredential.user?.displayName ?? '');
          prefs.setString('userEmail', userCredential.user?.email ?? '');
          prefs.setString('userImage', userCredential.user?.photoURL ?? '');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: ((context) => NavBar())),
              (route) => false);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
