import 'package:flutter/material.dart';
import 'package:lost_mode_app/screens/splashscreen.dart';
import 'package:get/get.dart';
import 'package:lost_mode_app/theme/theme_controller.dart';
import 'package:lost_mode_app/utils/deviceCards.dart';
import 'package:lost_mode_app/utils/location_worker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:lost_mode_app/services/websocket_service.dart';
import 'package:lost_mode_app/services/alarm_service.dart';
import 'dart:convert';

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
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommandNotifier()),
        Provider<AlarmService>(create: (_) => AlarmService()),
      ],
      child: MyApp(),
    ),
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
      themeMode:
          themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class WebSocketManager {
  static WebSocketChannel? _channel;
  static String? _currentDeviceId;

  static void connectWebSocket(String deviceId, BuildContext context) {
    if (_currentDeviceId != deviceId) {
      _channel?.sink.close();
      _channel = WebSocketService.connect(deviceId);
      _currentDeviceId = deviceId;

      _channel!.stream.listen((message) {
        final data = json.decode(message);
        if (data['command'] == 'play_alarm') {
          Provider.of<AlarmService>(context, listen: false).playAlarm();
        }
        Provider.of<CommandNotifier>(context, listen: false).addCommand(message);
      });
    }
  }

  static void closeConnection() {
    _channel?.sink.close();
    _channel = null;
    _currentDeviceId = null;
  }
}