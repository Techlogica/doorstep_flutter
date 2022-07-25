// ignore_for_file: use_key_in_widget_constructors, file_names, avoid_unnecessary_containers
// @dart=2.9

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  BitmapDescriptor _sourceIcon;
  BitmapDescriptor get sourseIcon => _sourceIcon;
  Map<MarkerId, Marker> _markers;
  Map<MarkerId, Marker> get markers => _markers;
  // Set<Marker> _marker = Set<Marker>();

  final MarkerId markerId = MarkerId('1');
  final MarkerId mapmarkerId = MarkerId('2');
  Location _location;

  Location get location => _location;
  LatLng _locationPosition;

  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
  }

  initalization() async {
    await getUserLocation();
    await setCustomMapPin();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers = <MarkerId, Marker>{};
      Marker marker = Marker(
          markerId: markerId,
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          icon: sourseIcon,
          draggable: true,
          onDragEnd: ((newPosition) {
            _locationPosition =
                LatLng(newPosition.latitude, newPosition.longitude);
          }));
      _markers[markerId] = marker;
      notifyListeners();
    });
  }

  setCustomMapPin() async {
    _sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(20, 20)), 'assets/icons/marker.png');
  }
}
