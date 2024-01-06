import 'package:crypto/View/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controler/GoolgleAuth.dart';
import '../Controler/UserLoginControler.dart';

const color = Color.fromARGB(255, 24, 80, 209);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // string for displaying the error Message
  String? errorMessage;

  // our form key
  // editing Controller

  final controler = Get.put(RagisterControler());

  final googleauth = Get.put(GoogleAuth());

  Future<void> loaddata() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('userName') ?? '';
    prefs.getString('userEmail') ?? '';
    prefs.getString('userImage') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    //first name field
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final firstNameField = TextFormField(
        autofocus: false,
        controller: controler.firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          controler.firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            errorStyle: TextStyle(color: Colors.red),
            hintText: "User Name",
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color(0xffF004BFE),
            ))));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: controler.emailController,
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
          controler.firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.red),
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
        controller: controler.passwordController,
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
          controler.firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            errorStyle: TextStyle(color: Colors.red),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color(0xffF004BFE),
            ))));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF004BFE),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            controler.register(context);
          },
          child: Obx(
            () => controler.isLoading.value
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    "SignUp",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
          )),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
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
                    ),
                    Text(
                      'Crypto Track',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: myHeight * 0.4,
              left: 10.0,
              right: 10.0,
              child: Container(
                height: myHeight * 0.6,
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
                          'Create Account',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Please sign up to continue',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        SizedBox(height: myHeight * 0.02),
                        firstNameField,

                        SizedBox(height: myHeight * 0.02),
                        emailField,
                        SizedBox(height: myHeight * 0.02),
                        passwordField,
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
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  'Sign In',
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

                        signUpButton,
                        // loginButton,
                        SizedBox(height: myHeight * 0.02),

                        Center(
                          child: Text(
                            'Or Login with',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        ),
                        SizedBox(height: myHeight * 0.02),
                        InkWell(
                          onTap: () {
                            googleauth.handleSignInAndNavigateToHome(context);
                          },
                          child: Center(
                              child: Image.asset(
                            'assets/image/google.png',
                            width: myWidth * 0.1,
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}



// login code 
