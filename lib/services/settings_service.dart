import 'package:dio/dio.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> updatemode(String mode) async {
  final dio = Dio();
  try {
    final userData = await getUserDataFromLocalStorage();
    final userId = userData['userId'] as String?;
    final deviceData = await SharedPreferences.getInstance();
    final deviceId = deviceData.getString('deviceId');

    print("UserId $userId ");
    print("deviceId $deviceId ");
    print('mode passed is : $mode');
    final response = await dio.post(
      "$APIURL/devicemode/$userId/$deviceId",
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
      data: {"mode": "$mode"},
    );
    print('Response: $response');
      final responsemessage = response.data['message'] as String;

    if (response.statusCode == 200) {
      print('Responsemsg: $responsemessage');
      return responsemessage;
    } else {
      print("Invalid response ${response.statusCode}: ${response.data}");
      return "Error: ${response.statusCode}"; // Return an error message
    }
  } catch (e) {
    print("Error occurred: $e");
    return "Error: $e";
    // Handle error, show toast or snackbar
  }
}
