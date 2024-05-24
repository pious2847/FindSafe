// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/models/User_model.dart';
import 'package:lost_mode_app/services/service.dart';
import 'package:lost_mode_app/utils/messages.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Image.asset(
                      'assets/images/avatar.jpg',
                      // height: 50,
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: -1,
                left: 20,
                child: FractionalTranslation(
                  translation: Offset(0.1, -0.1),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Personal Info:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          EditableCards(),
        ],
      ),
    );
  }

  Expanded EditableCards() {
    return Expanded(
          child: ListView(
            children: <Widget>[
              Card(
                child: ListTile(
                  title: const Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.username),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _showEditDialog('username', _user.username),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditDialog('email', _user.email),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    'Phone',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.phone ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _showEditDialog('phone', _user.phone ?? ''),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    'Area',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.addressInfo!.area ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditDialog(
                        'area', _user.addressInfo!.area ?? ''),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    'House No',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.addressInfo!.houseNo ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditDialog(
                        'houseNo', _user.addressInfo!.houseNo ?? ''),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    'Emergency  Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.emergencyContact!.name ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditDialog(
                        'emergencyName', _user.emergencyContact!.name ?? ''),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    'Emergency Contact',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_user.emergencyContact!.contact ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditDialog('emergencyContact',
                        _user.emergencyContact!.contact ?? ''),
                  ),
                ),
              ),
              // Add more ListTiles for other fields as needed
            ],
          ),
        );
  }

  Future<void> _updateUserData(String fieldName, String newValue) async {
    final userData = await getUserDataFromLocalStorage();
    final userId = userData['userId'] as String?;

    // final url = '$APIURL/update/$userId';
    final updatedFields = _getUpdatedFields(fieldName, newValue);
    print('updatedfields $updatedFields');
    final dio = Dio();
    final response = await dio.put(
      '$APIURL/update/$userId',
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
      data: json.encode(updatedFields),
    );

    if (response.statusCode == 200) {
      final resmsg = response.data['message'];
      SnackbarUtils.showCustomSnackBar(context, '$resmsg Updated successful',
          const Color.fromARGB(255, 76, 175, 80));

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
            _user.addressInfo?.area = newValue;
            break;
          case 'houseNo':
            _user.addressInfo?.houseNo = newValue;
            break;
          case 'emergencyName':
            _user.emergencyContact?.name = newValue;
            break;
          case 'emergencyContact':
            _user.emergencyContact?.contact = newValue;
            break;
          // Add cases for other fields as needed
        }
      });
      print(
          '\n================================ Results after updating the field: $response');
    } else {
      print('An Error Occurred: ${response.statusMessage}');
    }
  }

  Map<String, dynamic> _getUpdatedFields(String fieldName, String newValue) {
    switch (fieldName) {
      case 'username':
        return {'username': newValue};
      case 'email':
        return {'email': newValue};
      case 'phone':
        return {'phone': newValue};
      case 'area':
        return {'area': newValue};
      case 'houseNo':
        return {'houseNo': newValue};
      case 'emergencyName':
        return {'name': newValue};
      case 'emergencyContact':
        return {'contact': newValue};
      // Add cases for other fields as needed
      default:
        return {};
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
