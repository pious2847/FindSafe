// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_mode_app/screens/locations.dart';
import 'package:lost_mode_app/screens/login.dart';
import 'package:lost_mode_app/screens/profile.dart';
import 'package:lost_mode_app/screens/settings.dart';
import 'package:lost_mode_app/screens/usermap.dart';
import 'package:lost_mode_app/services/service.dart';
import 'package:lost_mode_app/utils/messages.dart';
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
                          Get.to(const MapScreen())
                        }),

                    ListTile(
                      leading: const Icon(Iconsax.user_octagon_copy,  color: Colors.purple),
                      title: const Text('Profile'),
                      onTap: () => {
                        Get.to(const UserProfile())
                      },
                    ),
                                        ListTile(
                      leading: const Icon(Iconsax.mobile_copy, color: Colors.purple),
                      title: const Text('Devices'),
                      onTap: () => print('tapped'),
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.data_copy,  color: Colors.purple),
                      title: const Text('Locations'),
                      onTap: () => {
                        Get.to(const LocationHistory())
                      },
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.activity_copy,  color: Colors.purple),
                      title: const Text('Modes'),
                      onTap: () => print('tapped'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Iconsax.settings, color: Colors.purple),
                      title: const Text('Settings'),
                      onTap: ()  async =>{
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Settings()),
                        )
                      } ,
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.logout_1_copy, color: Colors.purple),
                      title: const Text('Logout'),
                      onTap: () async => {
                        await logout(),
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()),
                        ),
                      // ignore: use_build_context_synchronously
                      SnackbarUtils.showCustomSnackBar(context, 'Logout successful', const Color.fromARGB(255, 76, 175, 80)),
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
