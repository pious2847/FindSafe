import 'package:flutter/material.dart';
import 'package:lost_mode_app/constants/NavBar.dart';
import 'package:lost_mode_app/utils/usermap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: _AppBar(),
      body: const Column(
        children: [
          MapScreen(),

        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar _AppBar() {
    return AppBar(
      title: const Text(
        "FindSafe",
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
      ),
      backgroundColor: Colors.white,
      actions: const [
        SizedBox(
          width: 60,
          child: Padding(
            padding: EdgeInsets.all(13.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/avatar.jpg',
              ),
            ),
          ),
        )
      ],
      elevation: 0.0,
    );
  }
}
