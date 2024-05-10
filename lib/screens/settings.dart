import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_mode_app/models/settings_model.dart';
import 'package:lost_mode_app/services/settings_service.dart';
import 'package:lost_mode_app/theme/settheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDarkMode = false;
  bool _isLostMode = false;
  bool _isActiveMode = true;

  @override
  void initState() {
    loadCurrentTheme();
    super.initState();
  }

  Future<void> loadCurrentTheme() async {
    _isDarkMode = await ThemeUtils.loadTheme();
    print('the value of _isdarkmode is: $_isDarkMode');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
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
                  const CustomListTile(
                    title: "About Phone",
                    icon: Iconsax.mobile_copy,
                    trailing: Icon(Iconsax.arrow_right_3_copy),
                  ),
                  const Divider(),
                  CustomListTile(
                    icon: Iconsax.moon_copy,
                    title: "Dark theme",
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (value) async {
                        setState(() {
                          _isDarkMode = value;
                        });
                        await ThemeUtils.toggleTheme(value);
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
                      setState(()  {
                        _isLostMode = value;
                        if (value) {
                          _isActiveMode =
                              false; // Turn off Active Mode if Lost Mode is turned on
                              setState(() async {
                                await updatemode(
                              'disable'); // Update the mode in the backend
                              });
                          
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
                          setState(() async {
                            await updatemode(
                                'active'); // Update the mode in the backend
                          });
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
