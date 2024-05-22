import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/models/User_model.dart';
import 'package:lost_mode_app/services/service.dart';

class UserProfile extends StatefulWidget {
  final UserProfileModel user;

  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late UserProfileModel _user;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
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
                bottom: 2,
                left: 20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 140,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.username),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        _showEditDialog('username', _user.username),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.email),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditDialog('email', _user.email),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Phone',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.phone ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        _showEditDialog('phone', _user.phone ?? ''),
                  ),
                ),
                // Add more ListTiles for other fields as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUserData(String fieldName, String newValue) async {
    final userData = await getUserDataFromLocalStorage();
    final userId = userData['userId'] as String?;

    final url = '$APIURL/update/$userId';
    final body = {fieldName: newValue};
    final dio = Dio();
    final response = await dio.put(
      Uri.parse(url) as String,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
      data: json.encode(body),
    );

    if (response.statusCode == 200) {
      setState(() {
        switch (fieldName) {
          case 'username':
            _user.username = newValue;
            break;
          case 'email':
            _user.email = newValue;
            break;
          case 'phone':
            _user.phone = newValue;
            break;
          case 'area':
            _user.addressInfo!.area = newValue;
            break;
          case 'house':
            _user.addressInfo!.houseNo = newValue;
            break;
          case 'name':
            _user.emergencyContact?.name = newValue;
            break;
          case 'contact':
            _user.emergencyContact?.contact = newValue;
            break;
          // Add cases for other fields as needed
        }
      });
    } else {
      print('An Error Occured');
    }
  }

  Future<void> _showEditDialog(String fieldName, String initialValue) async {
    _editingController.text = initialValue;

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: _editingController,
            decoration: InputDecoration(hintText: 'Enter new $fieldName'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _editingController.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await _updateUserData(fieldName, result);
    }
  }
}
