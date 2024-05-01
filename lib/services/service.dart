import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserDataToLocalStorage(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setBool('isLoggedIn', true);
}

Future<Map<String, dynamic>> getUserDataFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final isLoggedIn = prefs.getBool('isLoggedIn') ??
      false; // Default value is false if not found
  return {'userId': userId, 'isLoggedIn': isLoggedIn};
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
  await prefs.setBool('isLoggedIn', false);
  await prefs.setBool('showHome', false);

  print("User Logged Out");
}
