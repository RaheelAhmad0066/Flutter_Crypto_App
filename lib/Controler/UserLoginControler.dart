import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/View/LoginScreen.dart';
import 'package:crypto/View/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/UserModal.dart';
import '../View/navBar.dart';

class LoginControler extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  void login(BuildContext context) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // If login is successful, navigate to the home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: ((context) => NavBar())),
        (route) => false,
      );

      Get.snackbar('Success', 'Login successful',
          backgroundColor: Colors.grey[300], colorText: Colors.black);
    } catch (e) {
      String errorMessage = 'Please try again.';

      // Check if the error is due to incorrect email or password
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'User not found. Please check your email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password. Please try again.';
        }
      }

      // Display the error message
      Get.snackbar('Error', errorMessage,
          backgroundColor: Colors.grey[300], colorText: Colors.black);
    } finally {
      isLoading.value = false;
    }
  }
}

class RagisterControler extends GetxController {
  // ... (existing code)
  RxBool isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameEditingController = TextEditingController();

  void register(BuildContext context) async {
    try {
      isLoading.value = true;
      await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          )
          .then((value) => postDetailsToFirestore());

      // Additional logic for saving user details, if needed
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) => NavBar())),
          (route) => false);
      Get.snackbar('Success', 'Registration successful',
          backgroundColor: Colors.grey[300], colorText: Colors.black);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The email address is already in use',
            backgroundColor: Colors.grey[300], colorText: Colors.black);
      } else if (e.code == 'invalid-email') {
        Get.snackbar('Error', 'Invalid email address',
            backgroundColor: Colors.grey[300], colorText: Colors.black);
      } else {
        Get.snackbar('Error', e.message ?? 'An error occurred',
            backgroundColor: Colors.grey[300], colorText: Colors.black);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.grey[300], colorText: Colors.black);
    } finally {
      isLoading.value = false;
    }
  }

  void postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
  }
}

class ForgetPassword extends GetxController {
  // ... (existing code)
  RxBool isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  void resetPassword() async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      Get.to(LoginScreen());
      Get.snackbar('Success', 'Password reset email sent',
          backgroundColor: Colors.grey[300], colorText: Colors.black);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.grey[300], colorText: Colors.black);
    } finally {
      isLoading.value = false;
    }
  }
}
