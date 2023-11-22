import 'package:crypto/View/LoginScreen.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/image/cry.png'),
              Column(
                children: [
                  Text(
                    'The Future',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Learn more about cryptocurrency, look to',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  Text(
                    ' the future in Crypto Track',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.14),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF004BFE),
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.05,
                          vertical: myHeight * 0.013),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GET STARTED...',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          RotationTransition(
                              turns: AlwaysStoppedAnimation(310 / 360),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}