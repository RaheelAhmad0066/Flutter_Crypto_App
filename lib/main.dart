import 'package:crypto/View/io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'Admobservices/nativelinepage.dart';
import 'Constant/themeconstant.dart';
import 'Localstorage/storage.dart';
import 'Theme/Themeconstant.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  Permission.notification;
  // Request permission to receive notifications
  await FirebaseMessaging.instance.requestPermission();
  // loadappopenadd();
  String currentTheme = await LocalStorage.getTheme() ?? "light";
  runApp(MyApp(theme: currentTheme));
}

class MyApp extends StatelessWidget {
  final String theme;
  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(theme),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: IO(),
          );
        },
      ),
    );
  }
}
