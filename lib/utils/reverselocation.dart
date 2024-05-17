import 'package:dio/dio.dart';
import 'package:lost_mode_app/.env.dart';

class LocationService {
  final String _apiKey = googleAPIKey; // Replace with your API key

  Future<String> getPlaceName(double latitude, double longitude) async {
    final dio = Dio();
    final response = await dio.get(
      'https://maps.googleapis.com/maps/api/geocode/json',
      queryParameters: {
        'latlng': '$latitude,$longitude',
        'key': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final results = response.data['results'];
      if (results.isNotEmpty) {
        return results[0]['formatted_address'];
      } else {
        return 'No address found';
      }
    } else {
      throw Exception('Failed to get address');
    }
  }
}
