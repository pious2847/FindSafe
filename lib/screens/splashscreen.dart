import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lost_mode_app/constants/colors.dart';
import 'package:lost_mode_app/screens/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>  Onbording(),
        ),
      );
    });
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
              Icons.location_on_outlined,
              size: 140,
              color: secondarybgcolor,
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
}
