import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeUtils {
  static Future<void> loadTheme(Function(ThemeData) setState) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    setState(isDark ? ThemeData.dark() : ThemeData.light());
  }

  static void toggleTheme(bool isDark, Function(ThemeData) setState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
    setState(isDark ? ThemeData.dark() : ThemeData.light());
  }
}


