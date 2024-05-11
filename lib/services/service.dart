import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:lost_mode_app/.env.dart';

Future<void> saveUserDataToLocalStorage(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setBool('isLoggedIn', true);
}

Future<Map<String, dynamic>> getUserDataFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final isLoggedIn = prefs.getBool('isLoggedIn') ??
      false; // Default value is false if not found
  return {'userId': userId, 'isLoggedIn': isLoggedIn};
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
  await prefs.setBool('isLoggedIn', false);
  await prefs.setBool('showHome', false);
  await prefs.setBool('isRegisted', false);

  print("User Logged Out");
}

Future<void> addDeviceInfo(
  userId,
  devicename,
  modelNumer,
) async {
  final dio = Dio();
  try {
    final response = await dio.post(
      "$APIURL/register-device/$userId/$devicename/$modelNumer",
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isRegisted', true);
      final results = response.data;
      print('the deviceId is : $results');
      // final deviceId = response.data['deviceId'] as String;
      // await prefs.setString('deviceId', deviceId);
      print('The responds for adding new device: $response');
      print("device info inserted successfull");
    } else {
      print("Invalid response ${response.statusCode}: ${response.data}");
    }
  } catch (e) {
    print("Error occurred: $e");
    // Handle error, show toast or snackbar
  }
}
