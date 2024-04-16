// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lost_mode_app/utils/directions_model.dart';
import 'package:lost_mode_app/utils/directions_repository.dart';
import 'package:lost_mode_app/utils/phoneCard.dart';
import 'package:lost_mode_app/utils/phone_model.dart';

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
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  List<Phone> phones = [
    Phone(
        name: 'Samsung Galaxy S24',
        imageUrl:
            'https://cdn.tmobile.com/content/dam/t-mobile/en-p/cell-phones/samsung/Samsung-Galaxy-S24/Amber-Yellow/Samsung-Galaxy-S24-Amber-Yellow-thumbnail.png'),
    Phone(
        name: 'iPhone 15 Pro',
        imageUrl:
            'https://cdn.tmobile.com/content/dam/t-mobile/en-p/cell-phones/apple/Apple-iPhone-15-Pro/Blue-Titanium/Apple-iPhone-15-Pro-Blue-Titanium-thumbnail.png'),
    Phone(
        name: 'galaxy z flip5',
        imageUrl:
            'https://cdn.tmobile.com/content/dam/t-mobile/en-p/cell-phones/samsung/Samsung-Galaxy-Z-Flip5/Graphite/Samsung-Galaxy-Z-Flip5-Graphite-thumbnail.png'),
 Phone(
        name: 'Galaxy S22 Ultra',
        imageUrl:
            'https://cdn.tmobile.com/content/dam/t-mobile/en-p/cell-phones/samsung/Samsung-Galaxy-S22-Ultra/Phantom-Black/Samsung-Galaxy-S22-Ultra-Phantom-Black-frontimage.png'),
        
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  myLocationButtonEnabled: false,
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
              Container(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
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
}
