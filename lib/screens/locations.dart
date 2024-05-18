import 'package:flutter/material.dart';
import 'package:lost_mode_app/models/devices.dart';
import 'package:lost_mode_app/models/location_model.dart';
import 'package:lost_mode_app/services/devices.dart';
import 'package:lost_mode_app/utils/reverselocation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationHistory extends StatefulWidget {
  const LocationHistory({super.key});

  @override
  State<LocationHistory> createState() => _LocationHistoryState();
}

class _LocationHistoryState extends State<LocationHistory> {
  late ApiService apiService;
  late LocationService locationservice;
  List<Device> devices = [];
  Device? selectedDevice;
  List<Location> locationHistory = [];

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    locationservice = LocationService();
    fetchDevices();
  }

  fetchDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId != null) {
        devices = await apiService.fetchDevices(userId);
        if (devices.isNotEmpty) {
          setState(() {
            selectedDevice = devices[0];
            fetchLocationHistory(selectedDevice!);
          });
        }
      } else {
        throw Exception('User ID not found in preferences');
      }
    } catch (e) {
      print('Failed to fetch devices: $e');
    }
  }

  fetchLocationHistory(Device device) async {
    try {
      List<Location> history = await apiService.fetchLocationHistory(device.id);
      setState(() {
        locationHistory = history;
      });
    } catch (e) {
      print('Failed to fetch location history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Location History",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (devices.isNotEmpty)
              DropdownButtonFormField<Device>(
                value: selectedDevice,
                onChanged: (Device? newValue) {
                  setState(() {
                    selectedDevice = newValue!;
                    fetchLocationHistory(selectedDevice!);
                  });
                },
                items: devices.map<DropdownMenuItem<Device>>((Device device) {
                  return DropdownMenuItem<Device>(
                    value: device,
                    child: Text(device.devicename),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Device',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
            if (locationHistory.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: locationHistory.length,
                  itemBuilder: (context, index) {
                    final location = locationHistory[index];
                    return FutureBuilder<String>(
                      future: locationservice.getPlaceName(
                          location.latitude, location.longitude),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return ListTile(
                            title: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          final locationName =
                              snapshot.data ?? 'Unknown location';
                          return ListTile(
                            title: Text('Location: $locationName'),
                            subtitle: Text('Timestamp: ${location.timestamp}'),
                          );
                        }
                      },
                    );
                  },
                ),
              )
            else if (selectedDevice != null)
              const Center(child: CircularProgressIndicator())
            else
              const Center(child: Text('No location history available')),
          ],
        ),
      ),
    );
  }
}
