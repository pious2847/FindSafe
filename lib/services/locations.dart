import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/utils/messages.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getLocationHistory() async {
  final dio = Dio();
  final response = await dio.get(
    '$APIURL/location_history',
  );
  try {
    if (response.statusCode == 200) {
      ToastMsg.showToastMsg(
          context as BuildContext,
          'Location History fetch Succeeded ',
          Color.fromARGB(213, 71, 238, 65));
      print(response.data);
    }
  } catch (e) {
    ToastMsg.showToastMsg(
        context as BuildContext,
        'Error occured fetching Location History',
        Color.fromARGB(214, 238, 77, 65));
  }
}

 Future<List<dynamic>> fetchLocationHistory() async {
   final dio = Dio();

   try {
     final deviceData = await SharedPreferences.getInstance();
     final deviceId = deviceData.getString('deviceId');
     final response =
         await dio.get('$APIURL/mobiledevices/$deviceId/locations');
     print('Resloc: $response');
     if (response.statusCode == 200) {
       return response.data;
     } else {
       throw Exception('Failed to fetch location history');
     }
   } catch (e) {
     throw Exception('Failed to make API call: $e');
   }
 }

 Future<LatLng?> fetchLatestLocation(String deviceId) async {
   final dio = Dio();
   final apiUrl = '$APIURL/mobiledevices/$deviceId/locations';

   try {
     final response = await dio.get(apiUrl);

     if (response.statusCode == 200 && response.data.isNotEmpty) {
       final latestLocation = response.data[0];
       return LatLng(latestLocation['latitude'], latestLocation['longitude']);
     } else {
       return null;
     }
   } catch (e) {
     print('Failed to fetch latest location: $e');
     return null;
   }
 }
