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
        child: Column(
          children:[
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                child:const Image(image: AssetImage('assets/images/avatar.jpg'), height: 200,),
   
                ),
                const Positioned( 
                  bottom: 30,
                  left: 20,
                  child: CircleAvatar(

                  radius: 50,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
                ),
                
                
              ],
            )
          ]
        )
      )
    );
  }
}