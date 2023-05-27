// ignore_for_file: prefer_collection_literals, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:susha/views/show_error_dialog.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _initialLocation;
  LatLng? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  final GeocodingPlatform _geocodingPlatform = GeocodingPlatform.instance;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    await Permission.location.request();
    log("here");
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
      });
    } on Exception {
      await showErrorDialog(
        context,
        "Something Went Wrong!",
      );
    }
    log("now here");
  }

  void _onMapCreated(GoogleMapController controller) {
    // Use the controller to set the initial camera position
    if (_initialLocation != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _initialLocation!,
        zoom: 12,
      )));
    }
    _controller.complete(controller);
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _onSearch() async {
    String query = _searchController.text;
    List<Location> locations = await _geocodingPlatform.locationFromAddress(query);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      setState(() {
        _selectedLocation = LatLng(location.latitude, location.longitude);
      });
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _selectedLocation!,
        zoom: 12,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onSubmitted: (_) => _onSearch(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearch,
          ),
        ],
      ),
      body: _initialLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onTap,
              initialCameraPosition:
                  CameraPosition(target: _initialLocation!, zoom: 12),
              markers: _selectedLocation == null
                  ? Set<Marker>()
                  : Set.from([
                      Marker(
                        markerId: const MarkerId('selectedLocation'),
                        position: _selectedLocation!,
                      ),
                    ]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
