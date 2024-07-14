// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
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
      body: CustomScrollView(
        
        slivers: [
          Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/avatar.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
         SliverToBoxAdapter(
         child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Info',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard('Email', _user.email, Icons.email),
                  _buildInfoCard('Phone', _user.phone ?? '', Icons.phone),
                  _buildInfoCard('Area', _user.addressInfo!.area ?? '', Icons.location_on),
                  _buildInfoCard('House No', _user.addressInfo!.houseNo ?? '', Icons.home),
                  _buildInfoCard('Emergency Name', _user.emergencyContact!.name ?? '', Icons.person),
                  _buildInfoCard('Emergency Contact', _user.emergencyContact!.contact ?? '', Icons.contact_phone),
                ],
              ),
            ),
         ),
          // EditableCards(),
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
                onPressed: () => _showEditDialog('username', _user.username),
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
                onPressed: () => _showEditDialog('phone', _user.phone ?? ''),
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
                onPressed: () =>
                    _showEditDialog('area', _user.addressInfo!.area ?? ''),
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
                onPressed: () => _showEditDialog(
                    'emergencyContact', _user.emergencyContact!.contact ?? ''),
              ),
            ),
          ),
          // Add more ListTiles for other fields as needed
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.poppins(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () => _showEditDialog(title.toLowerCase(), value),
        ),
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
      SnackbarUtils.showCustomSnackBar(
          context, '$resmsg', const Color.fromARGB(255, 76, 175, 80));

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
          title: Text('Edit $fieldName',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _editingController,
            decoration: InputDecoration(
              hintText: 'Enter new $fieldName',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _editingController.text),
              child: Text('Save', style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
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
