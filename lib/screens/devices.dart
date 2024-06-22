// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lost_mode_app/models/devices.dart';
import 'package:lost_mode_app/screens/login.dart';
import 'package:lost_mode_app/services/devices.dart';
import 'package:lost_mode_app/services/service.dart';
import 'package:lost_mode_app/utils/messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  late ApiService apiService;
  List<Device> devices = [];
  Device? selectedDevice;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchDevices();
  }

  Future<List<Device>> fetchDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId != null) {
        return await apiService.fetchDevices(userId);
      } else {
        throw Exception('User ID not found in preferences');
      }
    } catch (e) {
      print('Failed to fetch devices: $e');
      throw Exception('Failed to fetch devices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Devices",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<List<Device>>(
                future: fetchDevices(), // Replace with the actual userId
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final devices = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return ExpansionTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(device.image),
                          ),
                          title: Text(device.devicename),
                          subtitle: Text(device.mode),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        final shouldDelete =
                                            await showDeleteConfirmationDialog(
                                                context, device.id);
                                        if (shouldDelete) {
                                          await apiService
                                              .deleteDevices(device.id);
                                          // Refresh the device list or navigate back
                                        }
                                        else{
                                           await apiService
                                              .deleteDevices(device.id);
                                              setState(() {
                                                
                                              });
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  Future<bool> showDeleteConfirmationDialog(
      BuildContext context, String deviceId) async {
    final deviceData = await SharedPreferences.getInstance();
    final storedDeviceId = deviceData.getString('deviceId');

    if (deviceId == storedDeviceId) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this device?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async => {
                Navigator.of(context).pop(true),
                await logout(),
                Get.to(const Signin()),
                SnackbarUtils.showCustomSnackBar(
                    context,
                    'Device has been Removed please Login',
                    const Color.fromARGB(255, 76, 175, 80)),
                    setState(() {
                      
                    }),
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    } else {
      return false;
    }
  }
}
