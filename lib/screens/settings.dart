import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lost_mode_app/models/settings_model.dart';
import 'package:lost_mode_app/screens/about.dart';
import 'package:lost_mode_app/services/settings_service.dart';
import 'package:lost_mode_app/utils/messages.dart';
import 'package:lost_mode_app/utils/settings.dart';
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

  Future<void> _loadModes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLostMode = prefs.getBool('isLostMode') ?? false;
      _isActiveMode = prefs.getBool('isActiveMode') ?? false;
    });
  }

  void handleModeUpdate(String mode) async {
    final responseMessage = await updatemode(mode);
    print('resmsg:  $responseMessage');
    SnackbarUtils.showCustomSnackBar(
      // ignore: use_build_context_synchronously
      context,
      responseMessage,
      responseMessage.startsWith('Error')
          ? Colors.red
          : const Color.fromARGB(255, 76, 175, 80),
    );
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
                CustomListTile(
                  icon: Iconsax.danger_copy,
                  title: "Lost Mode",
                  trailing: Switch(
                    value: _isLostMode,
                    onChanged: (value) {
                      setState(() {
                        _isLostMode = value;
                        if (value) {
                          _isActiveMode =
                              false; // Turn off Active Mode if Lost Mode is turned on
                          handleModeUpdate('disable');
                          updateMode('disable');
                        }
                      });
                    },
                  ),
                ),
                const Divider(),
                CustomListTile(
                  icon: Iconsax.activity_copy,
                  title: "Active Mode",
                  trailing: Switch(
                    value: _isActiveMode,
                    onChanged: (value) {
                      setState(() {
                        _isActiveMode = value;
                        if (value) {
                          _isLostMode =
                              false; // Turn off Lost Mode if Active Mode is turned on
                          handleModeUpdate('active');
                          updateMode('active');
                        }
                      });
                    },
                  ),
                ),
                const Divider(),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
