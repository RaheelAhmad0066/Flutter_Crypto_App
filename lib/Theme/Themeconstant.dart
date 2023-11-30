import 'package:crypto/View/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Localstorage/storage.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  late ThemeMode themeMode;

  ThemeProvider(String theme) {
    _lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white, // Light mode background color
      appBarTheme: AppBarTheme(
        color: Colors.blue,
        systemOverlayStyle:
            SystemUiOverlayStyle.dark, // Light mode app bar color
      ),
      colorScheme: ColorScheme.light(background: color),
    );

    _darkTheme = ThemeData(
        primaryColor: Colors.blue, // Dark mode accent color
        scaffoldBackgroundColor: Colors.black87, // Dark mode background color
        appBarTheme: AppBarTheme(
          color: Colors.black,
          systemOverlayStyle:
              SystemUiOverlayStyle.light, // Dark mode app bar color
        ),
        colorScheme: ColorScheme.dark(background: Colors.black87)
        // Add more theme customization as needed
        );

    if (theme == "light") {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
  }

  ThemeData getTheme() {
    return themeMode == ThemeMode.light ? _lightTheme : _darkTheme;
  }

  void toggleTheme() async {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
      await LocalStorage.saveTheme("dark");
    } else {
      themeMode = ThemeMode.light;
      await LocalStorage.saveTheme("light");
    }
    notifyListeners();
  }
}
