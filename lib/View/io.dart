import 'dart:async';
import 'dart:io';

import 'package:crypto/View/LoginScreen.dart';
import 'package:crypto/View/navBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class IO extends StatefulWidget {
  const IO({Key? key}) : super(key: key);

  @override
  State<IO> createState() => _IOState();
}

class _IOState extends State<IO> {
  late AppOpenAd appOpenAd;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    islogin();
    loadAppOpenAd();
  }

  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/9257395921'
          : 'ca-app-pub-3940256099942544/5575463023',
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            appOpenAd = ad;
            isLoading = false;
            appOpenAd.show();
          });
        },
        onAdFailedToLoad: ((error) {
          setState(() {
            isLoading = false;
          });
          print('Ad failed to load: $error');
        }),
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
  }

  void islogin() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(const Duration(seconds: 11), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => NavBar())),
            (route) => false);
      });
    } else {
      Timer(const Duration(seconds: 11), () {
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
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            children: [
              Container(
                height: myHeight * 1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: myHeight * 0.1,
                  ),
                  Text(
                    'Crypto Track',
                    style: TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  isLoading
                      ? Column(
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: myHeight * 0.02,
                            ),
                            Text(
                              'Ads Loading.....',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      : Container(),
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