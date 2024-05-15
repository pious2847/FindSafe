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
        print('Task start');
        await updateLocationTask();
        break;
      default:
        print('Task not found');
    }
    return Future.value(true);
  });
}

late Location _location;

Future<LocationData> _getLocation() async {
  LocationData currentLocation = await _location.getLocation();
  print('Current location: $currentLocation');
  return currentLocation;
}

Future<void> updateLocationTask() async {
  try {

    final currentLocation = _getLocation() as LocationData;

    print('Current Location:  $currentLocation');
    final deviceData = await SharedPreferences.getInstance();
    final deviceId = deviceData.getString('deviceId');

    await updateLocation(deviceId!, currentLocation);
  } catch (e) {
    print('Error updating location: $e');
  }
}

Future<void> updateLocation(String deviceId, LocationData location) async {
  final dio = Dio();
  const url = '$APIURL/update-location';
  final data = {
    'deviceId': deviceId,
    'latitude': location.latitude,
    'longitude': location.longitude,
  };

  try {
    final response = await dio.post(url, data: data);
    print('Schedule task executed Response = $response');
  } catch (e) {
    print('Error updating location: $e');
  }
}
