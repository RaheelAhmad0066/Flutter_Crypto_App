import 'package:flutter/material.dart';

import '../View/RegisterScreen.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  hintColor: Colors.black87,
  scaffoldBackgroundColor: Colors.white,
  primaryIconTheme: IconThemeData(color: Colors.black87),
  colorScheme: ColorScheme.light(background: color),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: color),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black87,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey.withOpacity(0.3)),
  hintColor: Colors.black87,
  primaryIconTheme: IconThemeData(color: Colors.black87),
  scaffoldBackgroundColor: Color(0xff15161a),
  colorScheme: ColorScheme.dark(background: Colors.black87),
);
