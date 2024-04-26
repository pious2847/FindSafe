// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lost_mode_app/constants/NavBar.dart';
import 'package:lost_mode_app/utils/directions_model.dart';
import 'package:lost_mode_app/utils/directions_repository.dart';
import 'package:lost_mode_app/utils/phonecard.dart';
import 'package:lost_mode_app/utils/phone_model.dart';
import 'package:dio/dio.dart';
// import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;
  late Location _location;

  void _getLocation() async {
    LocationData currentLocation = await _location.getLocation();
    setState(() {
      _initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 12.5,
      );
    });
  }

  late CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 12.5,
  );

  @override
  void initState() {
    super.initState();
    _location = Location();
    _getLocation();
    fetchMobileDevices();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  List<Phone> phones = [];

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
                  onLongPress: _addMarker,
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
                height: MediaQuery.of(context).size.height *
                    0.2, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: phones.length,
                  itemBuilder: (context, index) {
                    return PhoneListCard(phone: phones[index]);
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
      backgroundColor: Colors.white,
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

  void _addMarker(LatLng pos) async {
    // Get current location
    LocationData currentLocation = await Location.instance.getLocation();
    LatLng currentLatLng =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);

    // Set origin to current location
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: currentLatLng,
      );
    });

    // Set destination marker if it's null
    if (_destination == null) {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
      LatLng destinationCoordinates = await _getDestinationCoordinatesFromAPI();

      // Get directions
      final directions = await DirectionsRepository().getDirections(
          origin: _origin!.position, destination: destinationCoordinates);
      setState(() => _info = directions);
    }
  }

  Future<LatLng> _getDestinationCoordinatesFromAPI() async {
    // Make API call to get destination coordinates
    // For demonstration purposes, let's assume the API returns a fixed set of coordinates
    return const LatLng(37.7749, -122.4194);
  }


Future<void> fetchMobileDevices() async {
  final dio = Dio();
  try {
    final response = await dio.get('http://localhost:8080/api/mobiledevices');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      setState(() {
        phones = data.map((item) => Phone.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load mobile devices');
    }
  } catch (e) {
    throw Exception('Failed to make API call: $e');
  }
}
}
