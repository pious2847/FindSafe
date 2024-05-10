import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeUtils {
  static late ThemeData _theme;

  static Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    _theme = isDark ? ThemeData.dark() : ThemeData.light();
  }

  static ThemeData getTheme() {
    return _theme;
  }

  static Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
    _theme = isDark ? ThemeData.dark() : ThemeData.light();
  }
}
