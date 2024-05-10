import 'package:flutter/material.dart';
import 'package:lost_mode_app/screens/splashscreen.dart';
// Import the ThemeUtils class
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          buttonTheme: ButtonThemeData(
        buttonColor: Theme.of(context).primaryColor,
      )),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
