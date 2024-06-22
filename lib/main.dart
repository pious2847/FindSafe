import 'package:flutter/material.dart';
import 'package:lost_mode_app/screens/splashscreen.dart';
import 'package:get/get.dart';
import 'package:lost_mode_app/theme/theme_controller.dart';
import 'package:lost_mode_app/utils/deviceCards.dart';
import 'package:lost_mode_app/utils/location_worker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<bool> _isLocationPermissionGranted() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLocationPermissionGranted = await _isLocationPermissionGranted();
  if (isLocationPermissionGranted) {
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
  } else {
    // Handle the case when location permissions are not granted
    print('Location permissions are not granted');
  }

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

  runApp(  ChangeNotifierProvider(
      create: (_) => CommandNotifier(),
      child: MyApp(),
    ),);
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