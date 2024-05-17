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

Future<List<Location>> fetchLocationHistories(String deviceId) async {
    final dio = Dio();
    try {
      final response = await dio.get('${Uri.parse(APIURL)}/devices/$deviceId/locationhistory');
      if (response.statusCode == 200) {
        List jsonResponse = response.data['locationHistory'];
        return jsonResponse.map((location) => Location.fromJson(location)).toList();
      } else {
        throw Exception('Failed to load location history');
      }
    } catch (error) {
      print('Error fetching location history: $error');
      throw Exception('Failed to load location history');
    }
  }

}
