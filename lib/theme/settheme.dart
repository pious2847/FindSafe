import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeUtils {
  static late ThemeData _theme;

  static Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());

  }

  static ThemeData getTheme() {
    return _theme;
  }

  static Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
    Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
  }
}
