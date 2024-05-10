// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/models/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
      },
    );
   print('Direction request has been made result =======: ${response.data ?? "No data"}');

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
