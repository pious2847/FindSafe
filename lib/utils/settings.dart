  import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    if (mode == 'active') {
      await prefs.setBool('isLostMode', false);
      await prefs.setBool('isActiveMode', true);
    } else if (mode == 'disable') {
      await prefs.setBool('isActiveMode', false);
      await prefs.setBool('isLostMode', true);
    }
}

  