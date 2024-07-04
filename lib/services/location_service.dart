import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> isLocationPermissionGranted() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

}

