// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
// import 'package:lost_mode_app/screens/disablescreen.dart';


class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Abdul Hafis Mohammed"),
            accountEmail: const Text('abdulhafis2847@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/avatar.jpg'),
              ),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home_filled),
                      title: const Text('Dashboard'),
                      onTap: () => { 
                       }
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Dashboard'),
                      onTap: () => print('tapped'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Dashboard'),
                      onTap: () => print('tapped'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () => print('tapped'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () => print('tapped Settings'),
                    ),
                 ListTile(
                      leading: const Icon(Icons.logout_outlined),
                      title: const Text('Logout'),
                      onTap: () => print('tapped Logout'),
                    ),
                  ],
                ),
                  
              ],
            ),
          )
        ],
      ),
    );
  }
}
