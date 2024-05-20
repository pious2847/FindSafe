import 'dart:ui';

import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Image.asset(
                      'assets/images/avatar.jpg',
                      height: 100,
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: 30,
                left: 20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
              ),
            ],
          )
        ])));
  }
}
