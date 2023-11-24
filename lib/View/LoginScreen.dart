import 'package:crypto/View/navBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controler/UserLoginControler.dart';
import 'RegisterScreen.dart';
import 'forgetpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key

  // editing controller

  String? errorMessage;
  final logincontorler = Get.put(LoginControler());
  @override
  Widget build(BuildContext context) {
    //email field
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final emailField = TextFormField(
        autofocus: false,
        controller: logincontorler.emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          logincontorler.emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color(0xffF004BFE),
            ))));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: logincontorler.passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          logincontorler.passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xffF004BFE),
          )),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF004BFE),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            logincontorler.login(context);
          },
          child: Obx(
            () => logincontorler.isLoading.value
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
          )),
    );

    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF004BFE),
            ),
            height: myHeight * 1,
          ),
          Container(
            color: color.withOpacity(0.4), // Adjust opacity as needed
            height: myHeight * 1,
          ),
          Positioned(
            top: myHeight * 0.03,
            left: myWidth * 0.2,
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/image/cry.png',
                    height: myHeight * 0.3,
                    color: Colors.grey[300],
                  ),
                  Text(
                    'Crypto Track',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: myHeight * 0.5,
            left: 10.0,
            right: 10.0,
            child: Container(
              height: myHeight * 0.5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(25),
                      topStart: Radius.circular(26))),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Please sign in to continue',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                      SizedBox(height: myHeight * 0.03),
                      emailField,
                      SizedBox(height: myHeight * 0.03),
                      passwordField,
                      SizedBox(height: myHeight * 0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.to(forgetpassword());
                          },
                          child: Text(
                            'Forget password ?',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Color(0xffF004BFE),
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: myHeight * 0.03),
                      loginButton,
                      SizedBox(height: myHeight * 0.02),
                      Center(
                        child: Row(
                          children: [
                            Text(
                              'Do not have an account?',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationScreen()));
                              },
                              child: Text(
                                'SignUp',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Color(0xffF004BFE),
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
