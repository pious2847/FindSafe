import 'package:flutter/material.dart';
import 'package:lost_mode_app/constants/NavBar.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> requestPermissions() async {
    // ignore: unused_local_variable
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
  }

  void promptEnableMobileData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enable Mobile Data"),
          content:
              const Text("Please enable mobile data to send your device's location."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: _AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await requestPermissions();
            // Check if location permission is granted before proceeding
            if (await Permission.location.isGranted) {
              // Prompt user to enable mobile data
              promptEnableMobileData();
            }
          },
          child: const Text("Request Permissions"),
        ),
      ),
    );
  }

  AppBar _AppBar() {
    return AppBar(
      title: const Text(
        "FindSafe",
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
      ),
      backgroundColor: Colors.white,
      actions: const [
        SizedBox(
          width: 60,
          child: Padding(
            padding: EdgeInsets.all(13.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/avatar.jpg',
              ),
            ),
          ),
        )
      ],
      elevation: 0.0,
    );
  }
}
