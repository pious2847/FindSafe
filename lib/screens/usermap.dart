// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:lost_mode_app/.env.dart';
import 'package:lost_mode_app/constants/NavBar.dart';
import 'package:lost_mode_app/models/directions_model.dart';
import 'package:lost_mode_app/utils/directions_repository.dart';
import 'package:lost_mode_app/utils/phonecard.dart';
import 'package:lost_mode_app/models/phone_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../services/service.dart';
// import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _googleMapController;
  late LocationPermission permission; // Add this line to track permission status
  Marker? _origin;
  Marker? _destination;
  Directions? _info;
  String? _selectedDeviceId;
  late CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0), // Set a default initial position
    zoom: 11.5,
  );

Future<void> _getLocation() async {
    permission = await Geolocator.requestPermission(); // Request permission

    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return; // Handle the case when permissions are denied
    }

    try {
      Position currentPosition = await Geolocator.getCurrentPosition();
      print('Current location: $currentPosition');

      setState(() {
        _initialCameraPosition = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 11.5,
        );
      });
    } catch (e) {
      print('Error getting location: $e');
      // Handle the error accordingly
    }
  }

  @override
  void initState() {
    _getLocation();
    super.initState();
    fetchMobileDevices();
    _setOriginAndDestinationMarkers();
    // cancelTask('updateLocationTask');
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // void cancelTask(String uniqueName) {
  //   Workmanager().cancelByUniqueName(uniqueName);
  //   print("Task Cancel");
  // }

  List<Phone> phones = [];
  List<dynamic> locationHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: _AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                  markers: {
                    if (_origin != null) _origin!,
                    if (_destination != null) _destination!,
                  },
                  polylines: {
                    if (_info != null)
                      Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: Colors.red,
                        width: 5,
                        points: _info!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                  // onLongPress: _addMarker,
                ),
                if (_info != null)
                  Positioned(
                    top: 20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      child: Text(
                        '${_info?.totalDistance}, ${_info?.totalDuration}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  'Connected Devices ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: phones.length,
                  itemBuilder: (context, index) {
                    final phone = phones[index];
                    return PhoneListCard(
                      phone: phone,
                      onTap: (deviceId) async {
                        setState(() {
                          _selectedDeviceId =
                              deviceId; // Update the selected device ID
                        });
                        // Fetch the latest location for the device
                        final latestLocation =
                            await fetchLatestLocation(deviceId);
                        if (latestLocation != null) {
                          setState(() {
                            _destination = Marker(
                              markerId: const MarkerId('destination'),
                              infoWindow:
                                  const InfoWindow(title: 'Destination'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue,
                              ),
                              position: latestLocation,
                            );
                          });
                          // Get directions from the origin to the new destination
                          final directions =
                              await DirectionsRepository().getDirections(
                            origin: _origin!.position,
                            destination: latestLocation,
                          );
                          setState(() => _info = directions);
                        }
                      },
                      isActive: phone.deviceId ==
                          _selectedDeviceId, // Pass the active state based on the selected device ID
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: _FloatingActionButton(context),
    );
  }

  FloatingActionButton _FloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: const Color.fromARGB(255, 202, 202, 202),
      onPressed: () => _googleMapController.animateCamera(
        _info != null
            ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
            : CameraUpdate.newCameraPosition(_initialCameraPosition),
      ),
      child: const Icon(Icons.center_focus_strong),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar _AppBar() {
    return AppBar(
      centerTitle: false,
      title: const Text(
        "FindSafe",
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
      ),
      actions: [
        if (_origin != null)
          TextButton(
            onPressed: () => _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _origin!.position,
                  zoom: 14.5,
                  tilt: 50.0,
                ),
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('ORIGIN'),
          ),
        if (_destination != null)
          TextButton(
            onPressed: () => _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _destination!.position,
                  zoom: 14.5,
                  tilt: 50.0,
                ),
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('DEST'),
          )
      ],
      elevation: 0.0,
    );
  }

Future<void> _setOriginAndDestinationMarkers() async {
   // Get current location
   Position currentPosition = await Geolocator.getCurrentPosition();
   print('Current location: $currentPosition');

   LatLng currentLatLng =
       LatLng(currentPosition.latitude, currentPosition.longitude);

   // Set origin to current location
   setState(() {
     _origin = Marker(
       markerId: const MarkerId('origin'),
       infoWindow: const InfoWindow(title: 'Origin'),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
       position: currentLatLng,
     );
   });

   // Set destination marker based on the latest location from the API
   LatLng destinationCoordinates = await _getDestinationCoordinatesFromAPI();
   print('destinationCoordinates" $destinationCoordinates');
   setState(() {
     _destination = Marker(
       markerId: const MarkerId('destination'),
       infoWindow: const InfoWindow(title: 'Destination'),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
       position: destinationCoordinates,
     );
   });

   // Get directions
   final directions = await DirectionsRepository().getDirections(
     origin: _origin!.position,
     destination: destinationCoordinates,
   );
   setState(() => _info = directions);
 }

 Future<LatLng> _getDestinationCoordinatesFromAPI() async {
   final locationHistory = await fetchLocationHistory();

   if (locationHistory.isNotEmpty) {
     final latestLocation = locationHistory[0];
     return LatLng(latestLocation['latitude'], latestLocation['longitude']);
   } else {
     // Return default coordinates or handle the case when location history is empty
     return const LatLng(0, 0);
   }
 }

 Future<void> fetchMobileDevices() async {
   final dio = Dio();

   try {
     final userData = await getUserDataFromLocalStorage();
     final userId = userData['userId'] as String?;

     final response = await dio.get('$APIURL/mobiledevices/$userId');
     print('Response: $response');

     if (response.statusCode == 200) {
       // Access the 'mobileDevices' property from the response data
       final List<dynamic> mobileDevicesData = response.data['mobileDevices'];
       // Map over the mobile devices data and convert them into Phone objects
       final List<Phone> phonesList =
           mobileDevicesData.map((item) => Phone.fromJson(item)).toList();

       setState(() {
         phones = phonesList;
       });
       print('error occured here');
     } else {
       throw Exception('Failed to load mobile devices');
     }
   } catch (e) {
     throw Exception('Failed to make API call: $e');
   }
 }

 Future<List<dynamic>> fetchLocationHistory() async {
   final dio = Dio();

   try {
     final deviceData = await SharedPreferences.getInstance();
     final deviceId = deviceData.getString('deviceId');
     final response =
         await dio.get('$APIURL/mobiledevices/$deviceId/locations');
     print('Resloc: $response');
     if (response.statusCode == 200) {
       return response.data;
     } else {
       throw Exception('Failed to fetch location history');
     }
   } catch (e) {
     throw Exception('Failed to make API call: $e');
   }
 }

 Future<LatLng?> fetchLatestLocation(String deviceId) async {
   final dio = Dio();
   final apiUrl = '$APIURL/mobiledevices/$deviceId/locations';

   try {
     final response = await dio.get(apiUrl);

     if (response.statusCode == 200 && response.data.isNotEmpty) {
       final latestLocation = response.data[0];
       return LatLng(latestLocation['latitude'], latestLocation['longitude']);
     } else {
       return null;
     }
   } catch (e) {
     print('Failed to fetch latest location: $e');
     return null;
   }
 }
}
