import 'package:dio/dio.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/models/devices.dart';
import 'package:lost_mode_app/models/location_model.dart';

class ApiService {

 Future<List<Device>> fetchDevices(String userId) async {
  final dio = Dio();
  try {
    final response = await dio.get('${Uri.parse(APIURL)}/mobiledevices/$userId');
    print('Response of devices: ${response.data}');
    if (response.statusCode == 200) {
      // Since response.data is already decoded, use it directly
      List jsonResponse = response.data['mobileDevices'];
      print(jsonResponse);
      return jsonResponse.map((device) => Device.fromJson(device)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  } catch (error) {
    print('Error fetching devices: $error');
    throw Exception('Failed to load devices');
  }
}

  Future<List<Location>> fetchLocationHistory(String deviceId) async {
    try {
    final dio = Dio();

      final response = await dio.get('$APIURL/mobiledevices/$deviceId/locations');
      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse.map((location) => Location.fromJson(location)).toList();
      } else {
        throw Exception('Failed to fetch location history');
      }
    } catch (error) {
      throw Exception('Failed to fetch location history: $error');
    }
  }

Future<void> deleteDevices(String deviceId) async {
  final dio = Dio();
  try {
    final response = await dio.delete('${Uri.parse(APIURL)}/deletedevice/$deviceId');
    print('Response of devices: ${response.data}');
    if (response.statusCode == 200) {
      print(response.data['message']);
      // Refresh the device list or navigate back
    } else {
      throw Exception('Failed to delete device');
    }
  } catch (error) {
    print('Error deleting device: $error');
    throw Exception('Failed to delete device');
  }
}
static Future<Map<String, dynamic>> sendAlarmCommand(String deviceId) async {
  final dio = Dio();
    final url = '$APIURL/device/$deviceId/alarm';
    final response = await dio.post(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error: ${response.data}');
    }
  }
}


  Future<List<Location>> fetchLocationHistories(String deviceId) async {
    final dio = Dio();
    try {
      final response = await dio
          .get('${Uri.parse(APIURL)}/mobiledevices/$deviceId/locations');
      if (response.statusCode == 200) {
        List jsonResponse = response.data['locationHistory'];
        print('The List of fetched devices are : $jsonResponse');
        return jsonResponse
            .map((location) => Location.fromJson(location))
            .toList();
      } else {
        throw Exception('Failed to load location history');
      }
    } catch (error) {
      print('Error fetching location history: $error');
      throw Exception('Failed to load location history');
    }
  }
