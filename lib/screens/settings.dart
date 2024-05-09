import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_mode_app/models/settings_model.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDark = false;
  Future<void> save() async {
    final dio = Dio();
    try {
      final response = await dio.post(
        "$APIURL/Settings",
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {},
      );
      print('Response: $response');

      if (response.statusCode == 200) {
        print(response.data);
      } else {
        print("Invalid response ${response.statusCode}: ${response.data}");
      }
    } catch (e) {
      print("Error occurred: $e");
      // Handle error, show toast or snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(title: Text("Settings"),),
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
                        title: "About Phone", icon: Iconsax.mobile_copy, trailing: Icon(Iconsax.arrow_right_3_copy),),
                    const Divider(),
                    CustomListTile(
                      icon: Iconsax.moon_copy,
                      title: "Dark theme",
                      trailing: Switch(
                          value: _isDark,
                          onChanged: (value) {
                            setState(() {
                              _isDark = value;
                            });
                          }),
                    ),
                    const Divider(),
                    CustomListTile(
                      icon: Iconsax.moon_copy,
                      title: "Lost Mode",
                      trailing: Switch(
                          value: _isDark,
                          onChanged: (value) {
                            setState(() {
                              _isDark = value;
                            });
                          }),
                    ),
                    const Divider(),
                    CustomListTile(
                      icon: Iconsax.moon_copy,
                      title: "Active Mode",
                      trailing: Switch(
                          value: _isDark,
                          onChanged: (value) {
                            setState(() {
                              _isDark = value;
                            });
                          }),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
