import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Placemark> getPlace(LatLng latLng) async {
  final placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
  final placemark = placemarks.first;
  return placemark;
}