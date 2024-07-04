import 'package:flutter/material.dart';
import 'package:lost_mode_app/screens/splashscreen.dart';
import 'package:get/get.dart';
import 'package:lost_mode_app/services/background_service.dart';
import 'package:lost_mode_app/theme/theme_controller.dart';



void main() async {

 WidgetsFlutterBinding.ensureInitialized();
  await initializeBackgroundService();

  runApp(
  MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

