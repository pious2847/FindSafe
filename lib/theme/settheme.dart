import 'package:shared_preferences/shared_preferences.dart';

Future<void> setTheme() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDark', true);
}

Future<Map<String, dynamic>> getTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDark') ??
      false; // Default value is false if not found
  return { 'isDark': isDark};
}