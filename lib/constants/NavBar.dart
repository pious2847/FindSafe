import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Abdul Hafis Mohammed"),
            accountEmail: const Text('abdulhafis2847@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('assets/images/avatar.jpg'),),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background.jpg'))
            ),
          )
        ],
      ),
    );
  }
}
