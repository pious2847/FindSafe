import 'package:flutter/material.dart';
import 'package:lost_mode_app/screens/splashscreen.dart';
import 'package:get/get.dart';
import 'package:lost_mode_app/theme/theme_controller.dart';
import 'package:lost_mode_app/utils/location_worker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    // Initialize the WorkManager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
    // Register the periodic task
  await Workmanager().registerPeriodicTask(
    'updateLocation',
    'updateLocation',
    frequency: const Duration(minutes: 15),
  );
  
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // const initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return GetMaterialApp(
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Default dark theme
      themeMode:
          themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
