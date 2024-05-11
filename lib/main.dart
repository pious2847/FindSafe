import 'package:flutter/material.dart';
import 'package:lost_mode_app/screens/splashscreen.dart';
import 'package:get/get.dart';
import 'package:lost_mode_app/theme//theme_controller.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return GetMaterialApp(
       theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Default dark theme
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
