


  import 'package:dio/dio.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/services/service.dart';

Future<void> updatemode(String mode) async {
    final dio = Dio();
    try {
      final userData = await getUserDataFromLocalStorage();
      final userId = userData['userId'] as String?;
      
      final response = await dio.post(
        "$APIURL/devicemode/$userId",
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          "mode": "$mode"
        },
      );
      print('Response: $response');

      if (response.statusCode == 200) {
        print(response.data);
      } else {
        print("Invalid response ${response.statusCode}: ${response.data}");
      }
    } catch (e) {
      print("Error occurred: $e");
      // Handle error, show toast or snackbar
    }
  }
