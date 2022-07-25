// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, avoid_init_to_null, prefer_const_declarations, no_logic_in_create_state, prefer_collection_literals, must_be_immutable, library_prefixes, prefer_const_constructors, avoid_print, sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/Model/Address.dart';
import 'package:doorstep_banking_flutter/Model/Cart.dart';
import 'package:doorstep_banking_flutter/Model/OrderProducts.dart';
import 'package:doorstep_banking_flutter/Model/Orders.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:location/location.dart' as Location;

import 'CheckOutPage.dart';

class ManageAddressPage extends StatefulWidget {
  String addressId,
      currentLat,
      currentLng,
      fullAddress,
      saveAs,
      buildingType,
      landmark;
  bool btnVisibility;
  ManageAddressPage(
      {Key key,
      this.addressId,
      this.currentLat,
      this.currentLng,
      this.fullAddress,
      this.saveAs,
      this.buildingType,
      this.landmark,
      this.btnVisibility})
      : super(key: key);
  @override
  _ManageAddressPageState createState() => _ManageAddressPageState(
      addressId,
      currentLat,
      currentLng,
      fullAddress,
      saveAs,
      buildingType,
      landmark,
      btnVisibility);
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  _ManageAddressPageState(
      this.addressId,
      this.latitude,
      this.longitude,
      this.fullAddress,
      this.saveAs,
      this.buildingType,
      this.landmark,
      this.confirmbtnVisibility);
  final TextEditingController _flatController = new TextEditingController();
  final TextEditingController _landmarkController = new TextEditingController();
  final TextEditingController _saveAsController = new TextEditingController();
  List<Cart> cartProductsList = [];
  List<Cart> productList;
  bool confirmbtnVisibility;
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobile = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String userEmail = PrefManager.getEmail();
  Colors home, homeLine, work, workLine, other, otherLine;
  int _selected = null;
  bool iconVisible = true;
  bool textVisible = false;
  LatLong.LatLng currentPosition;
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marker = Set<Marker>();
  StreamSubscription<Location.LocationData> subscription;
  Location.LocationData currentLocation;
  Location.Location location;
  BitmapDescriptor _sourceIcon;
  int cartCount;
  BitmapDescriptor get sourseIcon => _sourceIcon;
  String addressId,
      customNote,
      saveAs,
      fullAddress,
      buildingType,
      landmark,
      latitude,
      longitude,
      addressType;
  bool loading = false;
  ScaffoldMessengerState scaffoldMessenger;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    location = Location.Location();
    setCustomMapPin();
    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;
      updatePinsOnMap();
    });

    setInitialLocation();
  }

  //setting initial location
  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    var latlng = LatLng(
        currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0);
    getAddressFromMarker(latlng);
  }

  //getting address from marked location
  void getAddressFromMarker(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    String street = placemarks.elementAt(0).street;
    String subLocality = placemarks.elementAt(0).subLocality;
    String locality = placemarks.elementAt(0).locality;
    String district = placemarks.elementAt(0).subAdministrativeArea;
    String state = placemarks.elementAt(0).administrativeArea;
    String pinCode = placemarks.elementAt(0).postalCode;
    String country = placemarks.elementAt(0).country;
    fullAddress = street +
        ',' +
        subLocality +
        ',' +
        locality +
        ',' +
        district +
        ',' +
        state +
        ',' +
        pinCode +
        ',' +
        country;

    latitude = latLng.latitude.toString();
    longitude = latLng.longitude.toString();
    print('latitude:' + latitude + ',' + longitude);
  }

  //setting custom map marker
  setCustomMapPin() async {
    _sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)),
        'assets/icons/marker.png');
  }

  //setting map marker
  void showLocationPins() async {
    var sourceposition = LatLng(
        currentLocation?.latitude ?? 0.0, currentLocation?.longitude ?? 0.0);

    _marker.add(Marker(
        markerId: MarkerId('sourcePosition'),
        position: sourceposition,
        icon: _sourceIcon));
    getAddressFromMarker(sourceposition);
  }

  //update marker in map
  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 15,
      target: LatLng(
          currentLocation?.latitude ?? 0.0, currentLocation?.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(
        currentLocation?.latitude ?? 0.0, currentLocation?.longitude ?? 0.0);

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'sourcePosition');

      _marker.add(Marker(
          markerId: const MarkerId('sourcePosition'),
          position: sourcePosition,
          icon: _sourceIcon));
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        body: Stack(children: [
      Builder(
          builder: (context) => Stack(fit: StackFit.expand, children: [
                _googleMap(context),
                _bottomSheet(context),
                _backBtn(),
              ])),
      Visibility(
        child: loadingWidget(context),
        visible: loading == true ? true : false,
      )
    ]));
  }

  //bottom sheet
  Widget _bottomSheet(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 5;
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.45,
      builder: (context, controller) {
        return Container(
            height: 450,
            decoration: BoxDecoration(
              color: colors.off_white,
              border: Border.all(color: colors.white, width: 7),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0)),
            ),
            child: ListView(controller: controller, children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 0,
                          child: Icon(
                            Icons.location_pin,
                            color: colors.gray_dark,
                            size: 35,
                          )),
                      Expanded(
                          flex: 6,
                          child: Text(S.of(context).currentLocation,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          width: 300,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            fullAddress ?? S.of(context).currentLocation,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16.0,
                            ),
                            maxLines: 2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 40,
                        width: c_width,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: colors.gray)),
                        child: TextField(
                          expands: false,
                          controller: _flatController,
                          style: TextStyle(
                              fontSize: 18.0, color: colors.gray_dark),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            // suffixIcon: Icon(
                            //   Icons.remove_red_eye,
                            //   color: values.primaryColor,
                            // ),
                            hintText: S.of(context).homeFlatBlockNo,
                            hintStyle: TextStyle(color: colors.gray),
                            counterText: "",
                            focusColor: colors.primaryColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colors.gray),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colors.gray),
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: c_width,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        decoration: BoxDecoration(
                            color: colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: colors.gray)),
                        child: TextField(
                          expands: false,
                          controller: _landmarkController,
                          style: TextStyle(
                              fontSize: 18.0, color: colors.gray_dark),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            // suffixIcon: Icon(
                            //   Icons.remove_red_eye,
                            //   color: values.primaryColor,
                            // ),
                            hintText: S.of(context).landmark,
                            hintStyle: TextStyle(color: colors.gray),
                            counterText: "",
                            focusColor: colors.primaryColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colors.gray),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colors.gray),
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15.0,
                      ),
                      Icon(
                        Icons.drive_file_move,
                        color: colors.gray_dark,
                        size: 25,
                      ),
                      Text(S.of(context).saveAs.toUpperCase(),
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Visibility(
                    visible: iconVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _icon(0, "Home", Icons.home, Icons.home_outlined),
                        _icon(1, "Work", Icons.work, Icons.work_outline),
                        _icon(2, "Other", Icons.location_pin,
                            Icons.location_on_outlined),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: textVisible,
                      child: Row(
                        children: [_otherText()],
                      )),
                  Column(
                    children: [
                      Container(
                        height: 50,
                        width: c_width,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: colors.white,
                          border:
                              Border.all(color: colors.primaryColor, width: 3),
                        ),
                        child: TextButton(
                          onPressed: () {
                            loading == true;
                            SaveAddress(
                                _flatController.text, _landmarkController.text);
                          },
                          child: Text(
                            S.of(context).saveAddress,
                            style: TextStyle(
                                color: colors.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: confirmbtnVisibility,
                        child: Container(
                          height: 50,
                          width: c_width,
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: colors.white,
                            border: Border.all(
                                color: colors.primaryColor, width: 3),
                          ),
                          child: TextButton(
                            onPressed: () {
                              uploadCartData();
                              loadSubmitOrder();
                            },
                            child: Text(
                              S.of(context).orderConform,
                              style: TextStyle(
                                  color: colors.primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ]));
      },
    );
  }

  //map
  Widget _googleMap(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(
          currentLocation?.latitude ?? 0.0, currentLocation?.longitude ?? 0.0),
      zoom: 10,
    );
    return GoogleMap(
      markers: _marker,
      mapType: MapType.normal,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        showLocationPins();
      },
      onTap: (LatLng latlng) {
        print('marker LatLng:' +
            LatLng(latlng.latitude, latlng.longitude).toString());

        _marker.add(Marker(
          markerId: MarkerId('destinationPosition'),
          position: latlng,
          draggable: true,
        ));
        getAddressFromMarker(latlng);
      },
    );
  }

  //back button
  Widget _backBtn() {
    return Positioned(
      top: 30,
      child: Container(
        margin: EdgeInsets.only(left: 10),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primaryColor,
          border: Border.all(color: colors.white, width: 4),
        ),
        child: IconButton(
          padding: EdgeInsets.only(left: 7.0),
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  //snackbar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: colors.primaryColor,
      content: Text(message),
    );
    scaffoldMessenger.showSnackBar(snackBar);
  }

// add to cart
  uploadCartData() async {
    String requestResult, responseResult;
    cartProductsList = await DSDatabase.instance.getCartProducts();

    for (int i = 0; i < cartProductsList.length; ++i) {
      try {
        String productId = cartProductsList.elementAt(i).product_id.toString();
        String productName = cartProductsList.elementAt(i).item_name;
        String productImage = cartProductsList.elementAt(i).image;
        String productAmount = cartProductsList.elementAt(i).amount;
        var body = {
          'product_id': productId,
          'product_name': productName,
          'amount': productAmount,
          'product_image': productImage
        };
        var headers = {
          'DeviceId': deviceId,
          'Email': encryptEmail,
          'Mobile': encryptMobile,
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
          log('RegRequest:$requestResult');
        } on PlatformException catch (e) {
          // Unable to open the browser
          print(e);
        }
        var request =
            Request('POST', Uri.parse(Apis.BASE_URL + Apis.ADD_TO_CART));
        request.body = '''{"request_encrypted":"$requestResult"}''';
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
            log('RegResponse:$responseResult');
          } on PlatformException catch (e) {
            // Unable to open the browser
            print(e);
          }
          Map<String, dynamic> valueMap = jsonDecode(responseResult);
          String message = valueMap['message'].toString();
          String data = valueMap['data'].toString();
          if (valueMap['status']) {
            _showSnackBar(context, data);
          } else {
            _showSnackBar(context, message);
          }
        } else {
          _showSnackBar(context, "message");
        }
      } on Exception catch (e) {
        print(e);
      }
    }
  }

// get submit orders
  loadSubmitOrder() async {
    String requestResult, responseResult;
    var body = {'address_id': addressId, 'custom_notes': customNote};
    var headers = {
      'DeviceId': deviceId,
      'Email': encryptEmail,
      'Mobile': encryptMobile,
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
      log('RegRequest:$requestResult');
    } on PlatformException catch (e) {
      // Unable to open the browser
      print(e);
    }
    var request = Request('POST', Uri.parse(Apis.BASE_URL + Apis.SUBMIT_ORDER));
    request.body = '''{"request_encrypted":"$requestResult"}''';
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = await response.stream.bytesToString();
      String responseBody = body.replaceAll('{"response_encrypted":"', '');
      responseBody = responseBody.replaceAll('"}', "");
      try {
        responseResult = await platform.invokeMethod('ResponseDecrypt',
            <String, String>{'response': responseBody, 'DeviceId': userEmail});
        log('RegResponse:$responseResult');
      } on PlatformException catch (e) {
        // Unable to open the browser
        print(e);
      }
      Map<String, dynamic> valueMap = jsonDecode(responseResult);
      String message = valueMap['message'].toString();
      if (valueMap['status']) {
        Map<String, dynamic> order = valueMap['data'];
        String orderId = order['order_id'];
        String orderNo = order['order_number'];
        String orderOtp = order['otp'];
        String deliveryCharge = order['delivery_charge'];
        String orderDate = order['order_date'];
        int totalPages = order['page_count'];

        ///database functions
        int orderCount = await DSDatabase.instance.countOrders();
        Orders orders;
        orders = new Orders(
            order_id: int.tryParse(orderId),
            order_number: orderNo,
            order_status: 'Submitted',
            order_address_id: addressId,
            order_full_address: fullAddress,
            order_address_type: saveAs,
            order_flat: buildingType,
            order_landmark: landmark,
            order_latitude: latitude,
            order_longitude: longitude,
            order_otp: orderOtp,
            order_custom_note: customNote,
            order_delivery_charge: deliveryCharge,
            order_rating: '0.0',
            order_review: '',
            order_date: orderDate,
            order_total_pages: totalPages.toString());
        if (orderCount < 5) {
          await DSDatabase.instance.insertToOrder(orders);
        } else {
          int firstAddedOrderId = await DSDatabase.instance.getfirstOrderId();

          await DSDatabase.instance
              .deleteFirstOrder(firstAddedOrderId.toString());

          await DSDatabase.instance.insertToOrder(orders);
        }

        await DSDatabase.instance.updateOrdersTotalPages(totalPages.toString());

        productList.clear();
        productList = await DSDatabase.instance.getCartProducts();

        OrderProduct orderProducts;
        for (int i = 0; i < productList.length; i++) {
          String productId = productList.elementAt(i).product_id.toString();
          String productName = productList.elementAt(i).item_name;
          String productImage = productList.elementAt(i).image;
          String productAmount = productList.elementAt(i).amount;
          String productCartid = '';

          orderProducts = new OrderProduct(
              order_cart_id: int.tryParse(productCartid),
              order_product_id: productId,
              order_id: orderId,
              order_product_name: productName,
              order_product_amount: productAmount,
              order_product_image: productImage);
          await DSDatabase.instance.insertToOrderProduct(orderProducts);
        }

        await DSDatabase.instance.clearCart();

        PrefManager.saveCartNote('');
        customNote = "";

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CheckOutPage(orderNumber: orderNo, orderOTP: orderOtp)));
      } else {
        _showSnackBar(context, message);
      }
    } else {
      _showSnackBar(context, S.of(context).noNetworkConnection);
    }
  }

// get save address
  SaveAddress(String buildingType, String landmark) async {
    String requestResult, responseResult;
    Map<String, String> body = {
      'fulll_address': fullAddress,
      'building_type': buildingType,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'address_type': saveAs
    };
    var headers = {
      'DeviceID': deviceId,
      'Email': encryptEmail,
      'Mobile': encryptMobile,
      'Password': encryptPassword,
      'Content-Type': 'application/json'
    };
    final jsonbody = json.encode(body);
    print('request::' + jsonbody.toString());
    try {
      requestResult = await platform.invokeMethod(
          'RequestEncrypt', <String, String>{
        'request': jsonbody.toString(),
        'DeviceId': userEmail
      });
      log('RegRequest:$requestResult');
    } on PlatformException catch (e) {
      // Unable to open the browser
      print(e);
    }
    var request = Request('POST', Uri.parse(Apis.BASE_URL + Apis.SAVE_ADDRESS));
    request.body = '''{"request_encrypted":"$requestResult"}''';
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = await response.stream.bytesToString();
      String responseBody = body.replaceAll('{"response_encrypted":"', '');
      responseBody = responseBody.replaceAll('"}', "");
      try {
        responseResult = await platform.invokeMethod('ResponseDecrypt',
            <String, String>{'response': responseBody, 'DeviceId': userEmail});
        log('RegResponse:$responseResult');
      } on PlatformException catch (e) {
        // Unable to open the browser
        print(e);
      }
      Map<String, dynamic> valueMap = jsonDecode(responseResult);
      String message = valueMap['message'].toString();
      // String data = valueMap['data'].toString();
      if (valueMap['status']) {
        loading == false;
        Map<String, dynamic> address = valueMap['data'];
        String address_id = address['address_id'];
        setState(() {
          addressId = address_id;
        });
        int addressCount = await DSDatabase.instance.countAddress();
        Address addresses;
        if (addressCount != 0) {
          await DSDatabase.instance.updateDefaultFlag();
        }
        addresses = new Address(
            address_id: int.tryParse(addressId),
            full_address: fullAddress,
            flat: buildingType,
            landmark: landmark,
            save_as: saveAs,
            latitude: latitude,
            longitude: longitude,
            default_flag: "1");
        await DSDatabase.instance.insertToAddress(addresses);

        _showSnackBar(context, S.of(context).locationSuccess);

        int cartCount = await DSDatabase.instance.countCart();
        if (cartCount == 0) {
          setState(() {
            confirmbtnVisibility = false;
          });
        } else {
          setState(() {
            confirmbtnVisibility = true;
          });
        }
      } else {
        loading = false;
        _showSnackBar(context, message);
      }
    } else {
      loading = false;
      _showSnackBar(context, S.of(context).noNetworkConnection);
    }
  }

// update address
  getUpdateAddress(
      String fullAddress,
      String buildingType,
      String landmark,
      String latitude,
      String longitude,
      String addressType,
      String addressId) async {
    String requestResult, responseResult;
    var body = {
      'fulll_address': fullAddress,
      'building_type': buildingType,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'address_type': addressType,
      'address_id': addressId
    };
    var headers = {
      'DeviceID': deviceId,
      'Email': encryptEmail,
      'Mobile': encryptMobile,
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
      log('RegRequest:$requestResult');
    } on PlatformException catch (e) {
      // Unable to open the browser
      print(e);
    }
    var request = Request('POST', Uri.parse(Apis.BASE_URL + Apis.EDIT_ADDRESS));
    request.body = '''{"RequestEncrypted":"$requestResult"}''';
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = await response.stream.bytesToString();
      String responseBody = body.replaceAll('{"response_encrypted":"', '');
      responseBody = responseBody.replaceAll('"}', "");
      try {
        responseResult = await platform.invokeMethod('ResponseDecrypt',
            <String, String>{'response': responseBody, 'DeviceId': userEmail});
        log('RegResponse:$responseResult');
      } on PlatformException catch (e) {
        // Unable to open the browser
        print(e);
      }
      Map<String, dynamic> valueMap = jsonDecode(responseResult);
      String message = valueMap['message'].toString();
      if (valueMap['status']) {
        // Map<String, dynamic> address = valueMap['data'];
        // String address_id = addressId;
        int addressCount = await DSDatabase.instance.countAddress();
        if (addressCount != 0) {
          await DSDatabase.instance.updateDefaultFlag();
        }
        await DSDatabase.instance.updateAddress(
            int.tryParse(addressId),
            fullAddress,
            buildingType,
            landmark,
            saveAs,
            latitude,
            longitude,
            "1");

        _showSnackBar(context, S.of(context).locationSuccess);

        int cartCount = await DSDatabase.instance.countCart();
        if (cartCount < 0) {
          // save_button.setVisibility(View.INVISIBLE);
          // conform_button.setVisibility(View.GONE);
        } else {
          // save_button.setVisibility(View.INVISIBLE);
          // conform_button.setVisibility(View.VISIBLE);
        }
      } else {
        _showSnackBar(context, message);
      }
    } else {
      _showSnackBar(context, S.of(context).noNetworkConnection);
    }
  }

  //selected address type icon
  Widget _icon(int index, String text, IconData icon, IconData icon_outline) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkResponse(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      _selected == index ? icon : icon_outline,
                      color: colors.gray_dark,
                    ),
                    Text(text, style: TextStyle(color: colors.gray_dark)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 5,
                  width: 60,
                  color: _selected == index ? colors.primaryColor : colors.gray,
                ),
              ],
            ),
            onTap: () {
              setState(
                () {
                  _selected = index;
                  saveAs = text.toLowerCase();
                },
              );
              if (_selected == 2) {
                setState(() {
                  iconVisible = false;
                  textVisible = true;
                });
              } else {
                setState(() {
                  iconVisible = true;
                  textVisible = false;
                });
              }
            }));
  }

  //selected address type text
  Widget _otherText() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.location_pin,
          color: colors.gray_dark,
        ),
        Container(
          height: 45,
          width: 230,
          child: TextField(
            controller: _saveAsController,
            decoration: InputDecoration(
                hintText: S.of(context).egDadPlaceJohnsHome,
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.gray_dark)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.gray_dark))),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: colors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 10.0)),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: colors.white),
          ),
          onPressed: () {
            setState(() {
              textVisible = false;
              iconVisible = true;
            });
          },
        )
      ],
    );
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
