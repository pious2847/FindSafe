import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lost_mode_app/main.dart';
import 'package:lost_mode_app/models/settings_model.dart';
import 'package:lost_mode_app/screens/about.dart';
import 'package:lost_mode_app/utils/messages.dart';
import 'package:lost_mode_app/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isLostMode = false;
  bool _isActiveMode = true;
  final ThemeController themeController = Get.find();
  @override
  void initState() {
    _loadModes();
    super.initState();
  }

  Future<void> showLostModeNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'lost_mode_channel',
      'Lost Mode',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    // const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Lost Mode Enabled',
      'Your device has been put in lost mode.',
      platformChannelSpecifics,
      payload: 'lost_mode_notification',
    );
  }

  Future<void> _loadModes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLostMode = prefs.getBool('isLostMode') ?? false;
      _isActiveMode = prefs.getBool('isActiveMode') ?? false;
    });
  }

  Future<void> handleModeUpdate(String mode) async {
    bool proceedWithUpdate = await showConfirmationDialog(context, mode);

    if (proceedWithUpdate) {
      final prefs = await SharedPreferences.getInstance();

      if (mode == 'active') {
        await prefs.setBool('isLostMode', false);
        await prefs.setBool('isActiveMode', true);
      } else if (mode == 'disable') {
        await prefs.setBool('isActiveMode', false);
        await prefs.setBool('isLostMode', true);
        await showLostModeNotification(); // Show notification when lost mode is enabled
      }

      final responseMessage = 'Mode updated successfully';
      print('resmsg:  $responseMessage');
      SnackbarUtils.showCustomSnackBar(
        context,
        responseMessage,
        const Color.fromARGB(255, 76, 175, 80),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              SingleSection(
                title: "General",
                children: [
                  const Divider(),
                  CustomListTile(
                    title: "About Phone",
                    icon: Iconsax.mobile_copy,
                    trailing: const Icon(Iconsax.arrow_right_3_copy),
                    onTap: () {
                      Get.to(const AboutPhone());
                    },
                  ),
                  const Divider(),
                  CustomListTile(
                    icon: Iconsax.moon_copy,
                    title: "Dark theme",
                    trailing: Switch(
                      value: themeController.isDarkMode.value,
                      onChanged: (value) {
                        setState(() {
                          themeController.toggleTheme();
                        });
                      },
                    ),
                  ),
                  const Divider(),
                ],
              ),
              SingleSection(title: "Modes", children: [
                const Divider(),
                CustomListTile(
                  icon: Iconsax.danger_copy,
                  title: "Lost Mode",
                  trailing: Switch(
                    value: _isLostMode,
                    onChanged: (value) async {
                      bool proceedWithUpdate = await showConfirmationDialog(
                          context, value ? 'disable' : 'active');
                      if (proceedWithUpdate) {
                        setState(() {
                          _isLostMode = value;
                          _isActiveMode =
                              !value; // Set active mode to the opposite of lost mode
                          handleModeUpdate(value ? 'disable' : 'active');
                        });
                      }
                    },
                  ),
                ),
                const Divider(),
                CustomListTile(
                  icon: Iconsax.activity_copy,
                  title: "Active Mode",
                  trailing: Switch(
                    value: _isActiveMode,
                    onChanged: (value) async {
                      bool proceedWithUpdate = await showConfirmationDialog(
                          context, value ? 'active' : 'disable');
                      if (proceedWithUpdate) {
                        setState(() {
                          _isActiveMode = value;
                          _isLostMode =
                              !value; // Set lost mode to the opposite of active mode
                          handleModeUpdate(value ? 'active' : 'disable');
                        });
                      }
                    },
                  ),
                ),
                const Divider(),
              ]),
              
              SingleSection(
                title: 'Privacy and Policies',
                children: [
                  const Divider(),
                  CustomListTile(
                    title: "Security",
                    icon: Iconsax.lock_1_copy,
                    trailing: const Icon(Iconsax.arrow_right_3_copy),
                    onTap: () {
                      Get.to(const AboutPhone());
                    },
                  ),
                  const Divider(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showConfirmationDialog(BuildContext context, String mode) {
    return showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: Text(
            mode == 'disable'
                ? 'Are you sure you want to disable the mode?'
                : 'Are you sure you want to switch to active mode?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Proceed
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
