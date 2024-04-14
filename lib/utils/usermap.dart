import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationMap extends StatefulWidget {
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng _initialCameraPosition = LatLng(0.0, 0.0); // Default position

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

 void _getCurrentLocation() async {
  LocationData? currentLocation;
  try {
    currentLocation = await location.getLocation();
  } catch (e) {
    print("Error getting location: $e");
  }
  if (currentLocation != null) {
    setState(() {
       _initialCameraPosition = LatLng(currentLocation!.latitude ?? 0.0, currentLocation.longitude ?? 0.0);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialCameraPosition,
        zoom: 14.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      markers: {
        Marker(
          markerId: const MarkerId('current_location'),
          position: _initialCameraPosition,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      },
    );
  }
}
