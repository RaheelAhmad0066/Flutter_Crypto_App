import 'dart:async';

import 'package:crypto/View/LoginScreen.dart';
import 'package:crypto/View/home.dart';
import 'package:crypto/View/navBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'splash.dart';

class IO extends StatefulWidget {
  const IO({Key? key}) : super(key: key);

  @override
  State<IO> createState() => _IOState();
}

class _IOState extends State<IO> {
  @override
  void initState() {
    // TODO: implement initState
    islogin();
    super.initState();
  }

  void islogin() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => NavBar())),
            (route) => false);
      });
    } else {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => LoginScreen())),
            (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffF004BFE),
          body: Stack(
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
                color: Colors.blue.withOpacity(0.5), // Adjust opacity as needed
                height: myHeight * 1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(''),
                  Text(
                    'Crypto Track',
                    style: TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Creat by',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: myWidth * 0.02,
                          ),
                          Image.asset(
                            'assets/image/cry.png',
                            height: myHeight * 0.03,
                            color: Colors.white,
                          )
                        ],
                      ),
                      SizedBox(
                        height: myHeight * 0.005,
                      ),
                      Image.asset(
                        'assets/image/loading1.gif',
                        height: myHeight * 0.015,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}



//  Container(
//           height: myHeight,
//           width: myWidth,
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: myHeight * 0.05),
        
//           ),
//         ),