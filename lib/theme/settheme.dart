import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeUtils {

static Future<bool> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDark') ?? false;
  Get.changeTheme(isDark ? ThemeData.dark() : ThemeData.light());

  return isDark;

}


  static Future<void> toggleTheme(bool isDark) async {
    if(!isDark){
    print('========================The value of the isDark is currentlly: $isDark' );
       final prefs = await SharedPreferences.getInstance();
       await prefs.setBool('isDark', false);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', true);
    Get.changeTheme(isDark ? ThemeData.light() : ThemeData.dark());
  }
}
