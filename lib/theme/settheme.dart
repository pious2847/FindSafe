import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeUtils {

static Future<bool> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDark') ?? false;
  Get.changeTheme(isDark ? ThemeData.dark() : ThemeData.light());

    print('========================The value of the isDark is currentlly: $isDark' );
  return isDark;

}


  static Future<void> toggleTheme(bool isDark) async {
    if(isDark){
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', true);
    print('========================The value of the isDark is currentlly is false: $isDark' );
    
    final isDarktheme = prefs.getBool('isDark') ?? false;
    Get.changeTheme(isDarktheme ? ThemeData.light() : ThemeData.dark());
    }else{
      print('========================The value of the isDark is currentlly is true: $isDark' );
      final prefs = await SharedPreferences.getInstance();
       await prefs.setBool('isDark', false);

       final isDarktheme = prefs.getBool('isDark') ?? false;

       Get.changeTheme(isDarktheme ? ThemeData.light() : ThemeData.dark());

    }
  }
}
