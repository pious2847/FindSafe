import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/constants/colors.dart';
import 'package:lost_mode_app/models/User_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_mode_app/screens/login.dart';
import 'package:lost_mode_app/utils/messages.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false; // Add this line

  Future<void> save() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    final dio = Dio();
    try {
      final response = await dio.post(
        "$APIURL/signup",
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'username': user.username,
          'email': user.email,
          'password': user.password,
        },
      );
      print('Response: $response');

      if (response.statusCode == 200) {
        print(response.data);
        final resMsg = response.data['message'];
        ToastMsg.showToastMsg(
          context,
          resMsg,
          const Color.fromARGB(255, 76, 175, 80),
        );

        Get.to(const Signin());
      } else {
        final resMsg = response.data['message'];
        ToastMsg.showToastMsg(
          context,
          resMsg,
          Color.fromARGB(255, 255, 37, 37),
        );
        print("Invalid response ${response.statusCode}: ${response.data}");
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

  User user = User('', '', '');

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
                    "Sign up to continue",
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
                          controller: TextEditingController(text: user.username),
                        onChanged: (value) {
                          user.email = value;
                        },
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Iconsax.user_octagon_copy),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your username';
                            } 
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
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
                            'Sign Up',
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
                 
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signin(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign In',
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
          )),
    );
  }
}
