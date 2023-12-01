import 'package:flutter/material.dart';

import '../View/RegisterScreen.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    hintColor: Color(0xff3B3B3B),
    scaffoldBackgroundColor: Colors.white,
    primaryIconTheme: IconThemeData(color: Colors.black87),
    colorScheme: ColorScheme.light(background: color),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: color),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.white),
    textTheme: TextTheme(
        labelLarge: TextStyle(
      color: Color(0xff3B3B3B),
    )),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black)));

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xff3B3B3B),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey.withOpacity(0.3)),
    hintColor: Color(0xff3B3B3B),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Color(0xff3B3B3B)),
    primaryIconTheme: IconThemeData(
      color: Color(0xff3B3B3B),
    ),
    scaffoldBackgroundColor: Color(0xff3B3B3B),
    colorScheme: ColorScheme.dark(
      background: Color(0xff3B3B3B),
    ),
    textTheme: TextTheme(labelLarge: TextStyle(color: Colors.white)),
    appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff3B3B3B),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white)));
