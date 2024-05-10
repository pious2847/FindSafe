import 'package:flutter/material.dart';
import 'package:lost_mode_app/screens/splashscreen.dart';
import 'package:lost_mode_app/theme/settheme.dart'; // Import the ThemeUtils class

void main() async {
  // Load the theme before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeUtils.loadTheme();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  static ThemeData theme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashScreen(),
    );
  }
}
