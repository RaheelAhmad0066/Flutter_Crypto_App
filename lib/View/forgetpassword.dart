import 'package:crypto/View/LoginScreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controler/UserLoginControler.dart';
import 'RegisterScreen.dart';

class forgetpassword extends StatefulWidget {
  const forgetpassword({Key? key}) : super(key: key);

  @override
  _forgetpasswordState createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller

  String? errorMessage;
  final logincontorler = Get.put(ForgetPassword());
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

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF004BFE),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            logincontorler.resetPassword();
          },
          child: Obx(
            () => logincontorler.isLoading.value
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    "Change Password",
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
              image: DecorationImage(
                image: AssetImage('assets/image/crypto.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            height: myHeight * 1,
          ),
          Container(
            color:
                Color(0xffF004BFE).withOpacity(0.4), // Adjust opacity as needed
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
                    color: Colors.white,
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
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(25),
                      topStart: Radius.circular(26))),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forget Password',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Change forget password',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    SizedBox(height: myHeight * 0.03),
                    emailField,
                    SizedBox(height: myHeight * 0.07),
                    loginButton,
                    SizedBox(height: myHeight * 0.05),
                    Center(
                      child: Row(
                        children: [
                          Text(
                            'Do you have an account?',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.grey,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
