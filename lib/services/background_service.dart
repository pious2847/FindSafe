import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/services/websocket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:workmanager/workmanager.dart';
import 'location_service.dart';
import 'notification_service.dart';

Geolocator? _geolocator;


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    _geolocator ??= Geolocator();

   

    // Handle location update task
    if (task == 'updateLocation') {

      print('Task start');
      await updateLocationTask(_geolocator!);
   
      print('Task completed at ${DateTime.now()}');
       // Ensure WebSocket connection is handled properly
      WebSocketService webSocketService = WebSocketService();
       webSocketService.connect();
    }

    return Future.value(true);
  });
}


Future<void> initializeBackgroundService() async {
  final _locationservice = LocationService();
  final isLocationPermissionGranted =
      await _locationservice.isLocationPermissionGranted();


      // Initialize background execution
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Lost Mode App",
    notificationText: "Tracking your device's location",
    notificationImportance: AndroidNotificationImportance.Default,
  );

  bool hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
  if (hasPermissions)  {
   await FlutterBackground.enableBackgroundExecution();
  }

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
      initialDelay: Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: Duration(seconds: 10),
    );

 
  } else {
    // Handle the case when location permissions are not granted
    print('Location permissions are not granted');
  }

  // Initialize notifications
  await NotificationService().initializeNotifications();
}


Future<void> updateLocationTask(Geolocator geolocator) async {
  try {
    final currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(
        'Current Location: ${currentPosition.latitude}, ${currentPosition.longitude}');

    final deviceData = await SharedPreferences.getInstance();
    final deviceId = deviceData.getString('deviceId');

    // await updateLocation(deviceId!, currentPosition);
    if (deviceId != null) {
      await updateLocation(deviceId, currentPosition);
    } else {
      print('Device ID not found in SharedPreferences');
    }
  } catch (e) {
    print('Error updating location: $e');
  }
}

Future<void> updateLocation(String deviceId, Position position) async {
  print(
      'The passed Location Cordinates are ${position.latitude}  ${position.longitude} ');
  final dio = Dio();
  const url = '$APIURL/update-location';
  final data = {
    'deviceId': deviceId,
    'latitude': position.latitude,
    'longitude': position.longitude,
  };

  try {
    final response = await dio.post(url, data: data);
    print('Schedule task executed Response = $response');
  } catch (e) {
    print('Error updating location: $e');
  }
}
