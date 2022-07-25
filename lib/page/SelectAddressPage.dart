// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, avoid_print, sized_box_for_whitespace, prefer_const_constructors, list_remove_unrelated_type, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/Model/Address.dart';
import 'package:doorstep_banking_flutter/Model/Cart.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/ManageAddressPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'CheckOutPage.dart';

class SelectAddressPage extends StatefulWidget {
  const SelectAddressPage({Key key}) : super(key: key);

  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  List<Address> addressList = [];
  List<Address> addressModelList = [];
  List<Cart> cartProductList = [];
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobile = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String userEmail = PrefManager.getEmail();
  final addressListController = StreamController<List<Address>>.broadcast();
  String addressId, customNote;
  bool confirmBtnVisibility = false;
  bool loading = true;
  int addressCount, cartCount;
  Color activeColor = colors.gray_dark;
  ScaffoldMessengerState scaffoldMessenger;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    confirmButtonVisibility();
    loadAddressData();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        backgroundColor: colors.off_white,
        appBar: _appBar(),
        body: Stack(children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: _addressList(context),
                ),
                Expanded(
                  flex: 0,
                  child: _bottomBar(context),
                ),
              ],
            ),
          ),
          Visibility(
            child: loadingWidget(context),
            visible: loading,
          )
        ]));
  }

  //app bar
  Widget _appBar() {
    return AppBar(
      backgroundColor: colors.off_white,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        S.of(context).selectAddress.toUpperCase(),
        style: const TextStyle(color: colors.primaryColor),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primaryColor,
          border: Border.all(color: colors.white, width: 4),
        ),
        child: IconButton(
          padding: const EdgeInsets.only(left: 7.0),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  //address list
  Widget _addressList(BuildContext context) {
    return Container(
        child: StreamBuilder(
      initialData: addressModelList,
      stream: addressListController.stream,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: addressModelList.length,
            itemBuilder: (BuildContext context, int index) {
              print('AddressList' + addressModelList.toString());
              return InkWell(
                child: Container(
                  color: colors.off_white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            padding: EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.off_white,
                              border: Border.all(
                                  color: addressModelList[index].default_flag ==
                                          '1'
                                      ? colors.primaryColor
                                      : colors.gray_dark,
                                  width: 2),
                            ),
                            child: Icon(
                              Icons.circle,
                              color: addressModelList[index].default_flag == '1'
                                  ? colors.primaryColor
                                  : colors.gray_dark,
                              size: 16,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 35,
                              width: 40,
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 130,
                              ),
                              decoration: BoxDecoration(
                                  color: colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: colors.gray_light,
                                      offset: Offset(4, 4),
                                      blurRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-4, -4),
                                      blurRadius: 2,
                                    ),
                                  ]),
                              child: TextButton(
                                onPressed: () {},
                                child: addressModelList[index].save_as == 'home'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.home_outlined,
                                              color: colors.gray_dark),
                                          Padding(
                                            padding: EdgeInsets.only(top: 0.0),
                                            child: Text(
                                              S.of(context).home.toLowerCase(),
                                              style: TextStyle(
                                                  color: colors.gray_dark,
                                                  fontSize: 18.0),
                                            ),
                                          )
                                        ],
                                      )
                                    : addressModelList[index].save_as == 'work'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.work_outline,
                                                color: colors.gray_dark,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                child: Text(
                                                  S
                                                      .of(context)
                                                      .work
                                                      .toLowerCase(),
                                                  style: TextStyle(
                                                      color: colors.gray_dark,
                                                      fontSize: 18.0),
                                                ),
                                              )
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.location_on_outlined,
                                                  color: colors.gray_dark),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0.0),
                                                child: Text(
                                                  S
                                                      .of(context)
                                                      .other
                                                      .toLowerCase(),
                                                  style: TextStyle(
                                                      color: colors.gray_dark,
                                                      fontSize: 18.0),
                                                ),
                                              )
                                            ],
                                          ),
                                style: TextButton.styleFrom(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 5, left: 5),
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.off_white,
                                    border: Border.all(
                                        color: colors.primaryColor, width: 2),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: colors.primaryColor,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManageAddressPage(
                                                    addressId:
                                                        addressModelList[index]
                                                            .address_id
                                                            .toString(),
                                                    currentLat:
                                                        addressModelList[index]
                                                            .latitude,
                                                    currentLng:
                                                        addressModelList[index]
                                                            .longitude,
                                                    fullAddress:
                                                        addressModelList[index]
                                                            .full_address,
                                                    saveAs:
                                                        addressModelList[index]
                                                            .save_as,
                                                    buildingType:
                                                        addressModelList[index]
                                                            .flat,
                                                    landmark:
                                                        addressModelList[index]
                                                            .landmark,
                                                  )));
                                    },
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 5, left: 5),
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.off_white,
                                    border: Border.all(
                                        color: colors.primaryColor, width: 2),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: colors.primaryColor,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      removeAddress(addressModelList[index]
                                          .address_id
                                          .toString());
                                      await DSDatabase.instance.deleteAddress(
                                          addressModelList[index].address_id);
                                      setState(() {
                                        addressModelList.remove(index);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          Text(
                            addressModelList[index].flat.toUpperCase() ??
                                S.of(context).homeFlatBlockNo.toUpperCase(),
                            maxLines: 2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Text(
                              addressModelList[index].landmark.toUpperCase() ??
                                  S.of(context).landmark.toUpperCase(),
                              maxLines: 2,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          Container(
                            width: 280,
                            child: Text(
                              addressModelList[index]
                                      .full_address
                                      .toUpperCase() ??
                                  S.of(context).fullAddress.toUpperCase(),
                              maxLines: 3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  await DSDatabase.instance.updateDefaultFlag();
                  await DSDatabase.instance
                      .setDefaultFlag(addressModelList[index].address_id, '1');
                  addressModelList.clear();
                  addressModelList = await DSDatabase.instance.getaddress();
                  addressListController.sink.add(addressModelList);
                },
              );
            });
      },
    ));
  }

  //bottom bar
  Widget _bottomBar(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 5;
    return Container(
      color: colors.off_white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 5.0),
                  child: Text(S.of(context).doYouNeedToSelectAnotherAddress),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  height: 45,
                  decoration: BoxDecoration(
                    color: colors.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageAddressPage(
                                    btnVisibility: false,
                                  )));
                    },
                    child: Text(
                      S.of(context).addAddress.toUpperCase(),
                      style: const TextStyle(color: colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 3,
            color: colors.gray_dark,
          ),
          Visibility(
            visible: confirmBtnVisibility,
            child: Container(
              height: 50,
              width: c_width,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: colors.white,
                border: Border.all(color: colors.primaryColor, width: 3),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  S.of(context).orderConform,
                  style: const TextStyle(
                      color: colors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  //confirm button
  void confirmButtonVisibility() async {
    addressCount = await DSDatabase.instance.countAddress();
    cartCount = await DSDatabase.instance.countCart();
    setState(() {
      if (addressCount != 0 && cartCount != 0) {
        confirmBtnVisibility = true;
      } else {
        confirmBtnVisibility = false;
      }
    });
  }

  //load address data
  void loadAddressData() async {
    try {
      addressList.clear();
      addressList = await DSDatabase.instance.getaddress();

      if (addressList.isEmpty) {
        loadServerData();
      } else {
        loadLocalData(addressList);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //load local address data
  void loadLocalData(List<Address> addressLists) {
    if (addressLists.isNotEmpty) {
      for (int i = 0; i < addressLists.length; i++) {
        String address_id = addressLists.elementAt(i).address_id.toString();
        String full_address = addressLists.elementAt(i).full_address;
        String flat = addressLists.elementAt(i).flat;
        String landmark = addressLists.elementAt(i).landmark;
        String save_as = addressLists.elementAt(i).save_as;
        String default_flag = addressLists.elementAt(i).default_flag;
        double latitude =
            double.tryParse(addressLists.elementAt(i).latitude.trim());
        double longitude =
            double.tryParse(addressLists.elementAt(i).longitude.trim());

        Address address = new Address(
            address_id: int.tryParse(address_id),
            full_address: full_address,
            flat: flat,
            landmark: landmark,
            save_as: save_as,
            latitude: latitude.toString(),
            longitude: longitude.toString(),
            default_flag: default_flag);
        addressModelList.add(address);
      }
      confirmButtonVisibility();
    }
    setState(() {
      loading = false;
    });
  }

// add to cart
  uploadCartData() async {
    String requestResult, responseResult;
    cartProductList = await DSDatabase.instance.getCartProducts();
    for (var i = 0; i < cartProductList.length; i++) {
      String productId = cartProductList.elementAt(i).product_id.toString();
      String productName = cartProductList.elementAt(i).item_name;
      String productAmount = cartProductList.elementAt(i).amount;
      String productImage = cartProductList.elementAt(i).image;
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
        _showSnackBar(context, S.of(context).noNetworkConnection);
      }
    }
    loadSubmitOrder();
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
      // String data = valueMap['data'].toString();
      if (valueMap['status']) {
        Map<String, dynamic> order = valueMap['data'];
        // String orderId = order['order_id'];
        String orderNo = order['order_number'];
        String orderOtp = order['otp'];
        // String deliveryCharge = order['delivery_charge'];
        // String orderDate = order['order_date'];
        // int totalPages = order['page_count'];

        //database functions
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

  //get Address from server
  loadServerData() async {
    try {
      String responseResult;
      var headers = {
        'DeviceId': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobile,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      var request =
          Request('GET', Uri.parse(Apis.BASE_URL + Apis.FETCH_ADDRESS));
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
        // String data = valueMap['data'].toString();
        if (valueMap['status']) {
          setState(() {
            loading = false;
          });
          List<dynamic> address = valueMap['data'];
          for (int i = 0; i < address.length; i++) {
            String addressId = address[i]["address_id"];
            double latitude = address[i]["lat"];
            double longitude = address[i]["long"];
            String saveAs = address[i]["address_type"];
            String fullAddress = address[i]["full_address"];
            String landmark = address[i]["landmark"];
            String flat = address[i]["building_type"];

            Address addressModel = new Address(
                address_id: int.tryParse(addressId),
                full_address: fullAddress,
                flat: flat,
                landmark: landmark,
                save_as: saveAs,
                latitude: latitude.toString(),
                longitude: longitude.toString(),
                default_flag: '0');
            await DSDatabase.instance.insertToAddress(addressModel);
            addressModelList.add(addressModel);
          }
          print('addressList' + addressModelList.length.toString());
        } else {
          setState(() {
            loading = false;
          });
          _showSnackBar(context, message);
        }
      } else {
        setState(() {
          loading = false;
        });
        _showSnackBar(context, S.of(context).noNetworkConnection);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //remove addresss
  removeAddress(String addressId) async {
    setState(() {
      loading = true;
    });
    String requestResult, responseResult;
    var headers = {
      'DeviceId': deviceId,
      'Email': encryptEmail,
      'Mobile': encryptMobile,
      'Password': encryptPassword,
      'Content-Type': 'application/json'
    };
    var body = {'address_id': addressId};
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
        Request('POST', Uri.parse(Apis.BASE_URL + Apis.REMOVE_ADDRESS));
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
        print(e);
      }
      Map<String, dynamic> valueMap = jsonDecode(responseResult);
      String message = valueMap['message'].toString();
      // String data = valueMap['data'].toString();
      if (valueMap['status']) {
        setState(() {
          loading = false;
        });
        await DSDatabase.instance.deleteAddress(int.tryParse(addressId));
        addressModelList.clear();
        addressModelList = await DSDatabase.instance.getaddress();
        addressListController.sink.add(addressModelList);
        log('response:$responseResult');
        _showSnackBar(context, message);
      } else {
        setState(() {
          loading = false;
        });
        _showSnackBar(context, S.of(context).noNetworkConnection);
      }
    } else {
      setState(() {
        loading = false;
      });
      _showSnackBar(context, S.of(context).noNetworkConnection);
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
