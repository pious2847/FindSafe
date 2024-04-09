import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            decoration: BoxDecoration(
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
                      leading: Icon(Icons.home_filled),
                      title: Text('Dashboard'),
                      onTap: () => print('tapped'),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Dashboard'),
                      onTap: () => print('tapped'),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Dashboard'),
                      onTap: () => print('tapped'),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () => print('tapped'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () => print('tapped Settings'),
                    ),
                 ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text('Logout'),
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
