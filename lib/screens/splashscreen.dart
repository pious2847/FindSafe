// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lost_mode_app/constants/colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lost_mode_app/screens/onboarding.dart';
import 'package:lost_mode_app/screens/usermap.dart';
import 'package:lost_mode_app/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
  with SingleTickerProviderStateMixin {
  bool showHome = false;

  @override
  void initState() {
    super.initState();
    Authenticatepage();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    SharedPreferences.getInstance().then((prefs) {
      bool showHome = prefs.getBool('showHome') ?? false;

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          showHome = showHome;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => showHome ? const MapScreen() : const Onbording(),
          ),
        );
      });
    }
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.map_copy,
              size: 140,
              color: secondarytextcolor,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Secure and Locate',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 27,
                  color: Colors.white),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'track your missing or stolen phone',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> Authenticatepage() async {
    try {
      final userData = await getUserDataFromLocalStorage();
      final userId = userData['userId'];
      final isLoggedIn = userData['isLoggedIn'];
      if (userId != null && isLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('showHome', true);
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('showHome', false);
      }
    } catch (e) {
      print("Error occurred: $e");
      // Handle error, show toast or snackbar
    }
  }
}
