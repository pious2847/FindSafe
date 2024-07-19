import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/constants/colors.dart';
import 'package:lost_mode_app/constants/devce_info.dart';
import 'package:lost_mode_app/models/User_model.dart';
import 'package:lost_mode_app/screens/signup.dart';
import 'package:lost_mode_app/screens/usermap.dart';
import 'package:lost_mode_app/services/service.dart';
import 'package:lost_mode_app/utils/messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  bool isRegisted = false;
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false; // Add this line

  Future<void> save() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    final dio = Dio();
    print( "email" + user.email,);
    print('Password'+ user.password,);
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
      print('Response: $response');

      if (response.statusCode == 200) {
        // print('Userid ' + response.data);

        Map<String, dynamic> deviceInfo = await getDeviceInfo();
        print(deviceInfo);
        String deviceName = deviceInfo['model']; // Get the device name
        String deviceModel = deviceInfo['manufacturer']; // Get the device model

        final prefs = await SharedPreferences.getInstance();
        final isRegisted = prefs.getBool('isRegisted') ?? false;

        if (!isRegisted) {
          await addDeviceInfo(
            response.data['userId'],
            deviceName,
            deviceModel,
          );
        }
        await saveUserDataToLocalStorage(response.data['userId']);
        prefs.setBool('showHome', true);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
        final resMsg = 'Welcome Back !!!';
        ToastMsg.showToastMsg(
          context,
          resMsg,
          const Color.fromARGB(255, 76, 175, 80),
        );
        // Dismiss the loading dialog after successful login
      } else {
        print("Invalid response ${response.statusCode}: ${response.data}");
        ToastMsg.showToastMsg(
          context,
          'Login Failed Please try again',
          Color.fromARGB(255, 255, 37, 37),
        );
        setState(() {
          _isLoading = false; // Set loading state to true
        });
      }
    } catch (e) {
      print("Error occurred: $e");

      ToastMsg.showToastMsg(
        context,
          'Login Failed Please try again',
        Color.fromARGB(255, 255, 37, 37),
      );
      // Handle error, show toast or snackbar
      setState(() {
        _isLoading = false; // Set loading state to true
      });
    }
  }

  User user = User(
    '',
    '',
    '',
  );

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Welcome Back",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to continue",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: TextEditingController(text: user.email),
                        onChanged: (value) {
                          user.email = value;
                        },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Iconsax.message_2_copy),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(text: user.password),
                        onChanged: (value) {
                          user.password = value;
                        },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Iconsax.lock_1_copy),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Iconsax.eye_copy
                                    : Iconsax.eye_slash_copy,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: secondarytextcolor,
                            backgroundColor: primcolorlight,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await save();
                            }
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signup(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              
              ),
            ),
          ),
        ),
      ),
    );
  }
}
