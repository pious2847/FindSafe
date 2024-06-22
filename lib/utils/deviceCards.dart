// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lost_mode_app/models/devices.dart';
import 'package:lost_mode_app/services/devices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicesCards extends StatefulWidget {
  const DevicesCards({super.key});

  @override
  _DevicesCardsState createState() => _DevicesCardsState();
}

class _DevicesCardsState extends State<DevicesCards> {
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
    return Column(
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
                  scrollDirection: Axis.vertical,
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
                                TextButton.icon(
                                  icon: const Icon(Iconsax.audio_square_copy),
                                  onPressed: () async {},
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  label: const Text('Play Alarm'),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Iconsax.security_copy),
                                  onPressed: () async {},
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  label: const Text('Secure Device'),
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
    );
  }
}
