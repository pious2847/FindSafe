import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'updateLocation':
        print('Task start');
        await updateLocationTask();
        print(
            'Task completed at ${DateTime.now()}'); // Print a message with the current time
        break;
      default:
        print('Task not found');
    }
    return Future.value(true);
  });
}

void initializeService() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

   Workmanager().registerPeriodicTask(
    'updateLocationTask',
    'updateLocationTask',
    frequency: const Duration(minutes: 1),
  );
}

Future<Position> _getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

Future<void> updateLocationTask() async {
  try {
    final currentPosition = await _getCurrentPosition();
    print(
        'Current Location: ${currentPosition.latitude}, ${currentPosition.longitude}');

    final deviceData = await SharedPreferences.getInstance();
    final deviceId = deviceData.getString('deviceId');

    await updateLocation(deviceId!, currentPosition);
  } catch (e) {
    print('Error updating location: $e');
  }
}

Future<void> updateLocation(String deviceId, Position position) async {
  final dio = Dio();
  final url = '$APIURL/update-location';
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
