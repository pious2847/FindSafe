import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'updateLocation':
        await updateLocationTask();
        break;
      default:
        print('Task not found');
    }
    return Future.value(true);
  });
}

Future<void> updateLocationTask() async {
  try {
    final location = Location();
    final currentLocation = await location.getLocation();
    final deviceData = await SharedPreferences.getInstance();
      final deviceId = deviceData.getString('deviceId');

    // Update the device's current location
    await updateCurrentLocation(deviceId, currentLocation);

    // Add the previous location to the location history
    await addLocationToHistory(deviceId, currentLocation);
  } catch (e) {
    print('Error updating location: $e');
  }
}

Future<void> updateCurrentLocation(String deviceId, LocationData location) async {
  final dio = Dio();
  final url = '$APIURL/mobiledevices/$deviceId/currentLocation';
  final data = {
    'latitude': location.latitude,
    'longitude': location.longitude,
  };

  try {
    await dio.put(url, data: data);
  } catch (e) {
    print('Error updating current location: $e');
  }
}

Future<void> addLocationToHistory(String deviceId, LocationData location) async {
  final dio = Dio();
  final url = '$APIURL/mobiledevices/$deviceId/locationHistory';
  final data = {
    'latitude': location.latitude,
    'longitude': location.longitude,
  };

  try {
    await dio.post(url, data: data);
  } catch (e) {
    print('Error adding location to history: $e');
  }
}