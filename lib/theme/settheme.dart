import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeUtils {

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    return isDark;
  }


  static Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', true);
    Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
  }
}
