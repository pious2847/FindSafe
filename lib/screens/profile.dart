// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
      body: SingleChildScrollView(
        child: Column(
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
            ExpansionTile(
              title: Text(
                _user.username,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w200,
                  fontSize: 17,
                ),
              ),
              subtitle: Text(
                _user.email,
                style: GoogleFonts.poppins(color: Colors.grey, fontSize:12),
              ),
              children: [
              EditableCards(),
              ],
            ),
          ],
        ),
      ),
    );
  }
 Widget EditableCards() {
    return Column(
      children: <Widget>[
        _buildEditableListTile(
          icon: Iconsax.user,
          title: 'Username',
          value: _user.username,
          onEdit: () => _showEditDialog('username', _user.username),
        ),
        _buildEditableListTile(
          icon: Iconsax.sms,
          title: 'Email',
          value: _user.email,
          onEdit: () => _showEditDialog('email', _user.email),
        ),
        _buildEditableListTile(
          icon: Iconsax.call,
          title: 'Phone',
          value: _user.phone ?? '',
          onEdit: () => _showEditDialog('phone', _user.phone ?? ''),
        ),
        _buildEditableListTile(
          icon: Iconsax.location,
          title: 'Area',
          value: _user.addressInfo!.area ?? '',
          onEdit: () => _showEditDialog('area', _user.addressInfo!.area ?? ''),
        ),
        _buildEditableListTile(
          icon: Iconsax.home,
          title: 'House No',
          value: _user.addressInfo!.houseNo ?? '',
          onEdit: () => _showEditDialog('houseNo', _user.addressInfo!.houseNo ?? ''),
        ),
        _buildEditableListTile(
          icon: Iconsax.user,
          title: 'Emergency Name',
          value: _user.emergencyContact!.name ?? '',
          onEdit: () => _showEditDialog('emergencyName', _user.emergencyContact!.name ?? ''),
        ),
        _buildEditableListTile(
          icon: Iconsax.call,
          title: 'Emergency Contact',
          value: _user.emergencyContact!.contact ?? '',
          onEdit: () => _showEditDialog('emergencyContact', _user.emergencyContact!.contact ?? ''),
        ),
      ],
    );
  }

  Widget _buildEditableListTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple,
),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.poppins(),
      ),
      trailing: IconButton(
        icon: Icon(Iconsax.edit_copy, size: 16, ),
        onPressed: onEdit,
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
      SnackbarUtils.showCustomSnackBar(context, '$resmsg',
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
