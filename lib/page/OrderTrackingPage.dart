// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, avoid_print, avoid_function_literals_in_foreach_calls, prefer_collection_literals, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key key}) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  LatLng agentLocation;

  String userLatitude = PrefManager.getUserOrderLatitude();
  String userLongitude = PrefManager.getUserOrderLongitude();
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobileNumber = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String userEmail = PrefManager.getEmail();
  bool locFlag = false;
  bool serverlocation = true;
  bool mapVisibility = false;
  ScaffoldMessengerState scaffoldMessenger;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  BitmapDescriptor _agentIcon, _userIcon;

  BitmapDescriptor get agentIcon => _agentIcon;

  BitmapDescriptor get userIcon => _userIcon;
  LatLng userLocation;
  bool isLoading = false;
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _marker = Set<Marker>();

  final Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  // final _locationController = StreamController<LatLng>();

  LocationData agentCurrentLocation;
  LocationData userOrderLocation;
  Location location;

  Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    location = Location();
    polylinePoints = PolylinePoints();
    userLocation =
        LatLng(double.tryParse(userLatitude), double.tryParse(userLongitude));
    getAgentLocation();
    //send agent location request after every 20s
    timer = Timer.periodic(
        const Duration(seconds: 20), (Timer t) => getAgentLocation());
    // setInitialLocation();
    // updatePinsOnMap();
  }

  //setting the location
  void setInitialLocation() async {
    // agentCurrentLocation = await location.getLocation();
    agentCurrentLocation = LocationData.fromMap({
      'latitude': agentLocation.latitude,
      'longitude': agentLocation.longitude
    });
    userOrderLocation = LocationData.fromMap({
      'latitude': userLocation.latitude,
      'longitude': userLocation.longitude,
    });
  }

  //setting the custom marker
  setCustomMapPin() async {
    _agentIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)),
        'assets/icons/marker.png');

    _userIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/round.png');
  }

  //setting marker in map
  void showLocationPins() async {
    var sourceposition = LatLng(agentCurrentLocation?.latitude ?? 0.0,
        agentCurrentLocation?.longitude ?? 0.0);

    var destinationPosition =
        LatLng(userLocation.latitude, userLocation.longitude);

    print('locationPins:');
    _marker.add(Marker(
      markerId: MarkerId('agentPosition'),
      position: sourceposition,
      draggable: true,
    ));

    _marker.add(Marker(
      markerId: MarkerId('userPosition'),
      position: destinationPosition,
      draggable: true,
    ));
    setPolylinesInMap();
  }

  //updating the location in map
  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 18,
      target: LatLng(agentCurrentLocation?.latitude ?? 0.0,
          agentCurrentLocation?.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(agentCurrentLocation?.latitude ?? 0.0,
        agentCurrentLocation?.longitude ?? 0.0);

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'agentPosition');

      _marker.add(Marker(
        markerId: MarkerId('agentPosition'),
        position: sourcePosition,
        draggable: true,
      ));
    });
    setPolylinesInMap();
    // updatePolylinesInMap();
    // showLocationPins();
  }

  //setting location route
  void setPolylinesInMap() async {
    polylineCoordinates.clear();
    var result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCj9eUrJ-Sg2aplTGY5rQ2Cy7weS2frt80',
        PointLatLng(agentCurrentLocation?.latitude ?? 0.0,
            agentCurrentLocation?.longitude ?? 0.0),
        PointLatLng(userLocation.latitude, userLocation.longitude),
        travelMode: TravelMode.transit);
    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    print('setPolyLines');
    setState(() {
      // _polylines
      //     .removeWhere((polyline) => polyline.polylineId.value == 'polyline');
      _polylines.add(Polyline(
        polylineId: PolylineId('polyline'),
        width: 3,
        color: colors.primaryColor,
        points: polylineCoordinates,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        body: Stack(children: [
      Visibility(
        child: Container(
          child: loadingWidget(context),
        ),
        visible: mapVisibility == true ? false : true,
      ),
      Visibility(visible: mapVisibility, child: _map()),
    ]));
  }

  //map
  Widget _map() {
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(agentCurrentLocation?.latitude ?? 0.0,
          agentCurrentLocation?.longitude ?? 0.0),
      zoom: 18,
    );
    return GoogleMap(
      markers: _marker,
      polylines: _polylines,
      mapType: MapType.normal,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        print('polylines');
        showLocationPins();
      },
    );
  }

  // get nearest agents location
  getAgentLocation() async {
    String requestResult, responseResult;
    try {
      var body = {'latitude': userLatitude, 'longitude': userLongitude};
      var headers = {
        'DeviceID': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobileNumber,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      final jsonbody = json.encode(body);
      try {
        requestResult = await platform.invokeMethod(
            'RequestEncrypt', <String, String>{
          'request': jsonbody.toString(),
          'DeviceId': userEmail
        });
        log("request: $requestResult");
      } on PlatformException catch (e) {
        print(e);
      }
      log("body: $jsonbody");
      var request =
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.GET_LOCATIONS));
      request.body = '''{"request_encrypted":'$requestResult'}''';
      request.headers.addAll(headers);

      StreamedResponse response = await request.send();
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String body = await response.stream.bytesToString();
        String responseBody = body.replaceAll('{"response_encrypted":"', '');
        responseBody = responseBody.replaceAll('"}', "");
        try {
          responseResult = await platform.invokeMethod(
              'ResponseDecrypt', <String, String>{
            'response': responseBody,
            'DeviceId': userEmail
          });
          log('OTPVerResponse:$responseResult');
        } on PlatformException catch (e) {
          // Unable to open the browser
          print(e);
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'].toString();
        if (valueMap['status']) {
          locFlag = true;
          serverlocation = false;
          Map<String, dynamic> order = valueMap['data'];
          String orderStatus = order['order_status'];
          String orderId = order['order_id'].toString();
          print('orderStatus:' + orderStatus);
          print('orderId' + orderId);
          if (orderStatus != "") {
            DSDatabase.instance
                .updateorderStatus(int.tryParse(orderId), orderStatus);
          }
          String agentLat = order['agent_lat'].toString();
          String agentLong = order['agent_long'].toString();
          // String userLat = order['user_lat'].toString();
          // String userLong = order['user_long'].toString();
          setState(() {
            agentLocation =
                LatLng(double.tryParse(agentLat), double.tryParse(agentLong));
            agentCurrentLocation = LocationData.fromMap({
              'latitude': double.tryParse(agentLat),
              'longitude': double.tryParse(agentLong),
            });
            mapVisibility = true;
            setCustomMapPin();
            updatePinsOnMap();
            userOrderLocation = LocationData.fromMap({
              'latitude': double.tryParse(userLatitude),
              'longitude': double.tryParse(userLongitude),
            });
          });
          log('latitude:$agentLat');
          log('longitude:$agentLong');
        } else {
          serverlocation = false;
          _showSnackBar(context, message);
        }
      } else {
        serverlocation = false;
        _showSnackBar(context, S.of(context).noNetworkConnection);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //snackbar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: colors.primaryColor,
      content: Text(message),
    );
    scaffoldMessenger.showSnackBar(snackBar);
  }

  //loading widget
  loadingWidget(BuildContext context) {
    return Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/icons/loading_animation.gif',
          width: 60,
          height: 60,
        ));
  }
}
