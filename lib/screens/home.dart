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
          title: Text("Enable Mobile Data"),
          content: Text("Please enable mobile data to send your device's location."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text("FindSafe", style: TextStyle(fontWeight: FontWeight.w400),),
        backgroundColor: Colors.white,
        actions: [
          
        ],
        elevation: 0.0,
      ),
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
}
