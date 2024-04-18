import 'package:flutter/services.dart';

class TrackingForegroundService {
  static const MethodChannel _channel =
      MethodChannel('tracking_foreground_service');

  static Future<void> startService() async {
    try {
      await _channel.invokeMethod('startService');
    } on PlatformException catch (e) {
      print("Failed to start service: '${e.message}'.");
    }
  }
}
