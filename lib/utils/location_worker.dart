import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

Geolocator? _geolocator;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    _geolocator ??= Geolocator();

    switch (task) {
      case 'updateLocation':
        print('Task start');
        await updateLocationTask(_geolocator!);
        print('Task completed at ${DateTime.now()}');
        break;
      default:
        print('Task not found');
    }

    return Future.value(true);
  });
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

    await updateLocation(deviceId!, currentPosition);
  } catch (e) {
    print('Error updating location: $e');
  }
}

Future<void> updateLocation(String deviceId, Position position) async {
  print('The passed Location Cordinates are ${position.latitude}  ${position.longitude} ');
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
