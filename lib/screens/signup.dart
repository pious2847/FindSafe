// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/models/User_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_mode_app/screens/login.dart';
import 'package:lost_mode_app/utils/messages.dart';
import 'package:get/get.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  Future<void> save() async {
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
        SnackbarUtils.showCustomSnackBar(context, 'Account Created successful', const Color.fromARGB(255, 85, 189, 89));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Signin()),
        );
      } else {
        print("Invalid response ${response.statusCode}: ${response.data}");
      }
    } catch (e) {
      SnackbarUtils.showCustomSnackBar(context, 'An error occurred: $e', Colors.red);
      print("Error occurred: $e");
      // Handle error, show toast or snackbar
    }
  }


  User user = User('', '', '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
      
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
                    "Signup",
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
                      controller: TextEditingController(text: user.username),
                      onChanged: (value) {
                        user.username = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter something';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                         
                          hintText: 'Enter Username',
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
                              borderSide: const BorderSide(color: Color.fromARGB(255, 103, 10, 119))),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: SizedBox(
                      height: 50,
                      width: 400,
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
                          "Signup",
                          style: TextStyle(color: Colors.white, ),
                        ),
                      ),
                    
                    ),
                  ),
                  
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
                      child: Row(
                        
                        children: [
                          const Text(
                            "Already have Account ? ",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Signin()));
                            },
                            child: const Text(
                              "Signin",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
