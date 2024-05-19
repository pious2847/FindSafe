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
      body:const SingleChildScrollView(
        child: Column(
          children:[
            Stack(
              children: [
                Image(image: AssetImage('assets/images/avatar.jpg'))
              ],
            )
          ]
        )
      )
    );
  }
}