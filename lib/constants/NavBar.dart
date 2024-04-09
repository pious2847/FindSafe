import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(accountName: Text("Abdul Hafis Mohammed"), accountEmail: Text('abdulhafis2847@gmail.com'))
        ],
      ),
    );
  }
}