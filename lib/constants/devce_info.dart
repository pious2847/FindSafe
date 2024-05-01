import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, dynamic>> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return {
        'platform': 'android',
        'version': androidInfo.version.sdkInt,
        'manufacturer': androidInfo.manufacturer,
        'model': androidInfo.model,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return {
        'platform': 'ios',
        'version': iosInfo.systemVersion,
        'manufacturer': 'Apple',
        'model': iosInfo.model,
      };
    } else {
      return {
        'platform': 'unknown',
        'version': 'unknown',
        'manufacturer': 'unknown',
        'model': 'unknown',
      };
    }
  } catch (e) {
    print('Error getting device info: $e');
    return {
      'platform': 'error',
      'version': 'error',
      'manufacturer': 'error',
      'model': 'error',
    };
  }
}
