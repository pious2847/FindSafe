// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:lost_mode_app/screens/login.dart';
import 'package:lost_mode_app/screens/usermap.dart';
import 'package:lost_mode_app/services/service.dart';
// import 'package:lost_mode_app/screens/disablescreen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
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
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ListTile(
                        leading: const Icon(Iconsax.home_1_copy, color: Colors.purple,),
                        title: const Text('Dashboard'),
                        onTap: () => {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapScreen()),
                        )
                        }),

                    ListTile(
                      leading: const Icon(Iconsax.user_octagon_copy,  color: Colors.purple),
                      title: const Text('Profile'),
                      onTap: () => print('tapped'),
                    ),
                                        ListTile(
                      leading: const Icon(Iconsax.mobile_copy, color: Colors.purple),
                      title: const Text('Devices'),
                      onTap: () => print('tapped'),
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.data_copy,  color: Colors.purple),
                      title: const Text('Locations'),
                      onTap: () => print('tapped'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Iconsax.settings, color: Colors.purple),
                      title: const Text('Settings'),
                      onTap: () => print('tapped Settings'),
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.logout_1_copy, color: Colors.purple),
                      title: const Text('Logout'),
                      onTap: () async => {
                        await logout(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()),
                        )
                      },
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
