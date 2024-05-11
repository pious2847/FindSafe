// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/constants/devce_info.dart';
import 'package:lost_mode_app/models/User_model.dart';
import 'package:lost_mode_app/screens/signup.dart';
import 'package:lost_mode_app/screens/usermap.dart';
import 'package:lost_mode_app/services/service.dart';
import 'package:lost_mode_app/utils/messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';


class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  bool isRegisted = false;
  bool _obscureText = true;

  Future<void> save() async {
    final dio = Dio();
    try {
      final response = await dio.post(
        "$APIURL/login",
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'email': user.email,
          'password': user.password,
        },
      );

      if (response.statusCode == 200) {
        print('Userid ' + response.data);

        Map<String, dynamic> deviceInfo = await getDeviceInfo();
        print(deviceInfo);
        String deviceName = deviceInfo['model']; // Get the device name
        String deviceModel = deviceInfo['manufacturer']; // Get the device model

        final prefs = await SharedPreferences.getInstance();
        final isRegisted = prefs.getBool('isRegisted') ?? false;

        if (!isRegisted) {
          await addDeviceInfo(
            response.data,
            deviceName,
            deviceModel,
          );
          print('=============================== Error==========================***++');
          }
        await saveUserDataToLocalStorage(response.data);
        prefs.setBool('showHome', true);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
        SnackbarUtils.showCustomSnackBar(context, 'Login successful', const Color.fromARGB(255, 76, 175, 80));
      } else {
        print("Invalid response ${response.statusCode}: ${response.data}");
      }
    } catch (e) {
      print("Error occurred: $e");
      SnackbarUtils.showCustomSnackBar(context, 'An error occurred: $e', Colors.red);
      // Handle error, show toast or snackbar
    }
  }

  User user = User(
    '',
    '',
    '',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        // Positioned(
        //     top: 0,
        //     child: SvgPicture.asset(
        //       'images/top.svg',
        //       width: 400,
        //       height: 150,
        //     )),
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  Text(
                    "Signin",
                    style: GoogleFonts.pacifico(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.purple),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: TextEditingController(text: user.email),
                      onChanged: (value) {
                        user.email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter something';
                        } else if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return null;
                        } else {
                          return 'Enter valid email';
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter Email',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.purple)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.purple)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: TextEditingController(text: user.password),
                      onChanged: (value) {
                        user.password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter something';
                        }
                        return null;
                      },
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          hintText: 'Enter Password',
                           suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.purple)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.purple)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red))),
                    ),
                  ),
                    Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled button color
                              }
                              return Get.isDarkMode ? Colors.purple[700]! : Colors.purple; // Button color based on theme
                            },
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            save();
                          } else {
                            print("not ok");
                          }
                        },
                        child: const Text(
                          "Signin",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(95, 20, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "Not have Account ? ",
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ),
                            );
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(
                              color: Get.isDarkMode ? Colors.purple[300] : Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
