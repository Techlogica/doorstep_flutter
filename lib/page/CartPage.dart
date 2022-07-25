// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, avoid_print, list_remove_unrelated_type, sized_box_for_whitespace, prefer_const_constructors
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
import 'package:doorstep_banking_flutter/page/AddAddressPage.dart';
import 'package:doorstep_banking_flutter/page/SelectAddressPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';

import 'CheckOutPage.dart';
import 'HomePage.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartProductList = [];
  List<Cart> productList = [];
  List<Address> addressList = [];
  List<Cart> cartModelList = [];
  List<String> cartIdList = [];

  //------------------------------------------
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobile = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String userEmail = PrefManager.getEmail();
  String userId = PrefManager.getMobile();
  String userPassword = PrefManager.getPassword();
  String customNote = PrefManager.getCartNote();
  String tvDeliveryCharge = PrefManager.getDeliveryFee();

  //------------------------------------------------------------
  String addressId = '',
      note = '',
      editAmount = '',
      fullAddress = '',
      saveAs = '',
      buildingType = '',
      landmark = '',
      location = '',
      locationType = '';
  double latitude, longitude;
  String customerFullAddress = '', customerAddressType = '';
  String lat = PrefManager.getUserLatitude();
  String long = PrefManager.getUserLongitude();
  ScaffoldMessengerState scaffoldMessenger;
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final _cartListController = StreamController<List<Cart>>.broadcast();
  final _addressController = StreamController<String>.broadcast();
  final _chargeController = StreamController<String>.broadcast();
  final _addressTypeController = StreamController<String>.broadcast();
  bool loading = false;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    _chargeController.sink.add(tvDeliveryCharge);
    loadCartData();
    loadSavedLocations();
  }

  @override
  void dispose() {
    _cartListController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    double cWidth = MediaQuery.of(context).size.width;
    const Color background = colors.primaryColor;
    const Color fill = colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 0.00; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: colors.off_white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: productList.isNotEmpty
                  ? Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(flex: 1, child: _cartItemList(context)),
                        Expanded(
                          flex: 0,
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: colors.white),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        child: Row(children: [
                                          Text(
                                            S.of(context).addCustomNote,
                                            style: const TextStyle(
                                                color: colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Source Sans Pro'),
                                          ),
                                          const Icon(
                                            Icons.notes,
                                            color: colors.black,
                                          ),
                                        ]),
                                        onPressed: () =>
                                            showAlertDialog(context),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    // padding:
                                    //     EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: colors.gray_light,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Expanded(
                                                flex: 1,
                                                child: StreamBuilder(
                                                  initialData: tvDeliveryCharge,
                                                  stream:
                                                      _chargeController.stream,
                                                  builder: (context, snapshot) {
                                                    return Container(
                                                        width: 180,
                                                        child: Text(
                                                          S
                                                                  .of(context)
                                                                  .estimatedDeliveryCharge +
                                                              tvDeliveryCharge,
                                                          style: const TextStyle(
                                                              color:
                                                                  colors.black,
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ));
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 5.0),
                                              child: Expanded(
                                                flex: 1,
                                                child: TextButton(
                                                  onPressed: () {
                                                    getDeliveryCharge();
                                                  },
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .deliveryCharge,
                                                    style: const TextStyle(
                                                        color: colors.black,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                            // padding: EdgeInsets.symmetric(
                                            //     vertical: 5.0,
                                            //     horizontal: 10.0),
                                            decoration: BoxDecoration(
                                              color: colors.gray,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 5.0),
                                                      child: Icon(
                                                        Icons.location_pin,
                                                        color: colors.black,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 280,
                                                      margin: EdgeInsets.only(
                                                          right: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          StreamBuilder(
                                                              stream:
                                                                  _addressTypeController
                                                                      .stream,
                                                              builder: (context,
                                                                  snapshot) {
                                                                return Text(
                                                                  locationType ==
                                                                          ''
                                                                      ? S
                                                                          .of(context)
                                                                          .youSeemToBeInANewLocation
                                                                      : locationType,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          'Source Sans Pro',
                                                                      color: colors
                                                                          .black,
                                                                      fontSize:
                                                                          18.0),
                                                                );
                                                              }),
                                                          StreamBuilder(
                                                              stream:
                                                                  _addressController
                                                                      .stream,
                                                              builder: (context,
                                                                  snapshot) {
                                                                return Text(
                                                                  location,
                                                                  softWrap:
                                                                      false,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      color: colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0),
                                                                );
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15.0)),
                                                    gradient: LinearGradient(
                                                      colors: gradient,
                                                      stops: stops,
                                                      end: Alignment.center,
                                                      begin:
                                                          Alignment.centerLeft,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: TextButton(
                                                            onPressed: () => Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const SelectAddressPage())),
                                                            child: Text(
                                                              S
                                                                  .of(context)
                                                                  .changeAddress
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: fullAddress !=
                                                                  ''
                                                              ? TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    loading =
                                                                        true;
                                                                    uploadToCartData();
                                                                  },
                                                                  child: Text(
                                                                    S
                                                                        .of(context)
                                                                        .orderConform
                                                                        .toUpperCase(),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: colors
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ))
                                                              : TextButton(
                                                                  onPressed: () => Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              AddAddressPage())),
                                                                  child: Text(
                                                                    S
                                                                        .of(context)
                                                                        .addAddress
                                                                        .toUpperCase(),
                                                                    style: const TextStyle(
                                                                        color: colors
                                                                            .primaryColor,
                                                                        fontSize:
                                                                            16),
                                                                  ))),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/no_data_found.json',
                            height: 100,
                            width: 150,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(children: [
                                Text(
                                  S.of(context).oops,
                                  style: const TextStyle(
                                      color: colors.gray_dark,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Source Sans Pro',
                                      fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  S.of(context).noDataFound,
                                  style: const TextStyle(
                                      color: colors.gray_dark,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Source Sans Pro',
                                      fontSize: 16.0),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                            ],
                          ),
                        ],
                      )),
                    ),
            ),
            Visibility(visible: loading, child: loadingWidget(context)),
          ],
        ));
  }

  //app bar
  Widget _appBar() {
    const double circleRadius = 50.0;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          S.of(context).myCart.toUpperCase(),
          style: const TextStyle(
              color: colors.primaryColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        width: circleRadius,
        height: circleRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primaryColor,
          border: Border.all(color: colors.white, width: 4),
        ),
        child: IconButton(
          padding: const EdgeInsets.only(left: 7.0),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage())),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
          width: 30,
          decoration: BoxDecoration(
            color: colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(color: colors.gray),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: IconButton(
              padding: const EdgeInsets.only(right: 0.0),
              onPressed: () {},
              icon: const Icon(
                Icons.favorite,
                color: colors.gray_dark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //cart item list
  Widget _cartItemList(BuildContext context) {
    const Color background = colors.primaryColor;
    const Color fill = colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 70.00; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return StreamBuilder(
        initialData: productList,
        stream: _cartListController.stream,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 100,

                  ///setting two colors to the container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: gradient,
                      stops: stops,
                      end: Alignment.center,
                      begin: Alignment.centerLeft,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(
                                flex: 1,

                                ///setting image over image side by side
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.center,
                                        height: 100,
                                        child: Image.asset(
                                            'assets/icons/' +
                                                productList[index].image +
                                                '.png',
                                            height: 70,
                                            width: 70)),
                                  ],
                                )),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(productList[index].item_name,
                                            style: const TextStyle(
                                                color: colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    productList[index].amount == '0'
                                        ? Row(
                                            children: const [],
                                          )
                                        : Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            color: colors
                                                                .off_white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: colors
                                                                    .gray)),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              editAmount =
                                                                  productList[
                                                                          index]
                                                                      .amount;
                                                            });
                                                          },
                                                          child: TextField(
                                                            expands: false,
                                                            maxLength: 20,
                                                            maxLines: 1,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
                                                                fontSize: 16.0,
                                                                color: colors
                                                                    .primaryColor),
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5.0,
                                                                      bottom:
                                                                          12),
                                                              counterText: "",
                                                              hintText:
                                                                  productList[
                                                                          index]
                                                                      .amount,
                                                              hintStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            32.0),
                                                              ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            32.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: colors.primaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          removeProductFromCart(
                                              productList[index].product_id);
                                          setState(() {
                                            productList.remove(
                                                productList[index].product_id);
                                          });
                                        },
                                        child: Center(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colors.primaryColor,
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: colors.colorPrimaryText,
                                            ),

                                            /// replace your image with the Icon
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  //alert dialog
  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).addCustomNote,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colors.black),
          ),
          const Icon(Icons.copy),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 180.0,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.symmetric(vertical: 0),
            color: colors.off_white,
            child: TextField(
              maxLines: 10,
              controller: noteController,
              decoration: const InputDecoration(border: InputBorder.none),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            height: 45,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryColor,
              borderRadius: BorderRadius.circular(20),
              // shape: BoxShape.circle,
              border: Border.all(color: colors.white, width: 3.0),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).submit.toUpperCase(),
                style: const TextStyle(
                  color: colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //edit cart items
  editCart(BuildContext context, String amount) {
    // set up the buttons
    // Widget cancelButton = TextButton(
    //   child: Text("Cancel"),
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    // );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            S.of(context).atmWithdrawal,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colors.black),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card,
                color: colors.black,
              ),
              Text(
                S.of(context).atmService,
                style: const TextStyle(color: colors.black),
              ),
            ],
          ),
          CustomPaint(
              size: const Size(400, double.infinity),
              painter: DashedLineHorizontalPainter()),
          Row(
            children: [
              Text(
                S.of(context).cashWithdrawal,
                style: const TextStyle(color: colors.black),
              ),
              TextFormField(
                controller: amountController,
                initialValue: amount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: colors.white,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    S.of(context).cancel,
                    style: const TextStyle(color: colors.primaryColor),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: colors.primaryColor,
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      editAmount = amountController.text;
                    });
                  },
                  child: Text(
                    S.of(context).addCart,
                    style: const TextStyle(color: colors.white),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 45,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryColor,
              borderRadius: BorderRadius.circular(20),
              // shape: BoxShape.circle,
              border: Border.all(color: colors.white, width: 3.0),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).submit.toUpperCase(),
                style: const TextStyle(
                  color: colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //show delivery charge
  showDeliverCharge(BuildContext context, String deliveryCharge) {
    Widget okButton = TextButton(
      child: const Text(
        "OK",
        style: TextStyle(color: colors.light_color),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: colors.black,
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).deliverycharge + deliveryCharge,
              style: TextStyle(color: colors.white),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              S.of(context).deliverychargeDescription,
              style: TextStyle(color: colors.white),
            )
          ]),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //load cart data
  loadCartData() async {
    try {
      productList.clear();
      productList = await DSDatabase.instance.getCartProducts();
      _cartListController.sink.add(productList);

      log('productList Size: $productList');
    } on Exception catch (e) {
      print(e);
    }
  }

  //remove item from cart
  removeProductFromCart(int productId) async {
    await DSDatabase.instance.deleteProductFromCart(productId);
    await DSDatabase.instance.updateHomeProductsCart(productId, 'false');
    productList.clear();
    productList = await DSDatabase.instance.getCartProducts();
    _cartListController.sink.add(productList);
  }

  //load saved address from database
  loadSavedLocations() async {
    try {
      addressList.clear();
      addressList = await DSDatabase.instance.getaddress();

      if (addressList.isEmpty) {
        setState(() {
          location = PrefManager.getDeviceLocationAddress();
          location ??= '';
        });
      } else {
        addressList.clear();
        addressList = await DSDatabase.instance.getDefaultAddress();
        if (addressList.isNotEmpty) {
          for (int i = 0; i < addressList.length; i++) {
            setState(() {
              addressId = addressList.elementAt(i).address_id.toString();
              fullAddress = addressList.elementAt(i).full_address;
              saveAs = addressList.elementAt(i).save_as;
              buildingType = addressList.elementAt(i).flat;
              landmark = addressList.elementAt(i).landmark;
              latitude = double.tryParse(addressList.elementAt(i).latitude);
              longitude = double.tryParse(addressList.elementAt(i).longitude);
            });
          }
          if (fullAddress != '') {
            setState(() {
              location = fullAddress;
              locationType = saveAs;
            });
          }
        } else {
          addressList.clear();
          addressList = await DSDatabase.instance.getaddress();

          String currentLatitude = PrefManager.getUserLatitude();
          String currentLongitude = PrefManager.getUserLongitude();

          if (currentLatitude != "" && currentLongitude != "") {
            double curLati = double.tryParse(currentLatitude);
            double curLongi = double.tryParse(currentLongitude);

            for (int i = 0; i < addressList.length; i++) {
              setState(() {
                addressId = addressList.elementAt(i).address_id.toString();
                fullAddress = addressList.elementAt(i).full_address;
                saveAs = addressList.elementAt(i).save_as;
                buildingType = addressList.elementAt(i).flat;
                landmark = addressList.elementAt(i).landmark;
                latitude = double.tryParse(addressList.elementAt(i).latitude);
                longitude = double.tryParse(addressList.elementAt(i).longitude);
              });

              /// calculate the distance between two points using latlong2 plugin
              const Distance distance = const Distance();
              // final double km = distance.as(
              //     LengthUnit.Kilometer,
              //     new LatLng(curLati, curLongi),
              //     new LatLng(latitude, longitude));
              // double totalDistanceInKm = km;
              final double meter = distance(new LatLng(curLati, curLongi),
                  new LatLng(latitude, longitude));
              double totalDistanceInMeters = meter;
              if (totalDistanceInMeters < 5) {
                setState(() {
                  location = fullAddress;
                  locationType = saveAs;
                });
              }
            }
          } else {
            location = PrefManager.getDeviceLocationAddress();
          }
        }
      }
      _addressController.sink.add(location);
      _addressTypeController.sink.add(locationType);
    } on Exception catch (e) {
      print(e);
    }
  }

// add to cart
  uploadToCartData() async {
    setState(() {
      loading = true;
    });
    cartProductList.clear();
    cartProductList = await DSDatabase.instance.getCartProducts();
    String requestResult, responseResult;
    try {
      for (int i = 0; i < cartProductList.length; i++) {
        try {
          String productId = cartProductList.elementAt(i).product_id.toString();
          String productName = cartProductList.elementAt(i).item_name;
          String productAmount = cartProductList.elementAt(i).amount;
          String productImage = cartProductList.elementAt(i).image;
          var body = {
            'product_id': productId,
            'product_name': productName,
            'amount': productAmount,
            'image_name': productImage
          };
          var headers = {
            'DeviceId': deviceId,
            'Email': encryptEmail,
            'Mobile': encryptMobile,
            'Password': encryptPassword,
            'Content-Type': 'application/json'
          };
          final jsonbody = json.encode(body);
          print('UploadCartBody:' + jsonbody.toString());
          try {
            requestResult = await platform.invokeMethod(
                'RequestEncrypt', <String, String>{
              'request': jsonbody.toString(),
              'DeviceId': userEmail
            });
            log('RegRequest:$requestResult');
          } on PlatformException catch (e) {
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
            String responseBody =
                body.replaceAll('{"response_encrypted":"', '');
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
            if (valueMap['status']) {
              if (valueMap['data'] != null || valueMap['data'] != '') {
                Map<String, dynamic> data = valueMap['data'];
                String cartId = data['cart_id'].toString();
                cartIdList.add(cartId);
                print('cartSize:' + cartIdList.length.toString());
              }
              print('response:' + responseResult);
            } else {
              _showSnackBar(context, message);
            }
          } else {
            _showSnackBar(context, S.of(context).noNetworkConnection);
          }
        } on Exception catch (e) {
          print(e);
        }
      }
    } on Exception catch (e) {
      print(e);
    }
    getSubmitedOrder();
  }

// get submit orders
  getSubmitedOrder() async {
    String requestResult, responseResult;
    try {
      var body = {'address_id': addressId, 'custom_notes': noteController.text};
      var headers = {
        'DeviceId': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobile,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      final jsonbody = json.encode(body);
      print('cartOrder::' + jsonbody.toString());
      try {
        requestResult = await platform.invokeMethod(
            'RequestEncrypt', <String, String>{
          'request': jsonbody.toString(),
          'DeviceId': userEmail
        });
        log('RegRequest:$requestResult');
      } on PlatformException catch (e) {
        print(e);
      }
      var request =
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.SUBMIT_ORDER));
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
        if (valueMap['status']) {
          setState(() {
            loading = false;
          });
          Map<String, dynamic> order = valueMap['data'];
          String orderId = order['order_id'];
          String orderNo = order['order_number'];
          String orderOtp = order['otp'];
          String deliveryCharge = order['delivery_charge'].toString();
          String orderDate = order['order_date'];
          int totalPages = order['page_count'];
          int orderCount = await DSDatabase.instance.countOrders();
          Orders orders;
          if (orderCount < 5) {
            orders = new Orders(
                order_id: int.tryParse(orderId),
                order_number: orderNo,
                order_status: "Submitted",
                order_address_id: addressId,
                order_full_address: fullAddress,
                order_address_type: saveAs,
                order_flat: buildingType,
                order_landmark: landmark,
                order_latitude: latitude.toString(),
                order_longitude: longitude.toString(),
                order_otp: orderOtp,
                order_custom_note: customNote,
                order_delivery_charge: deliveryCharge,
                order_rating: '0.0',
                order_review: '',
                order_date: orderDate,
                order_total_pages: totalPages.toString());
            await DSDatabase.instance.insertToOrder(orders);
          } else {
            int firstAddedOrderId = await DSDatabase.instance.getfirstOrderId();

            await DSDatabase.instance
                .deleteFirstOrder(firstAddedOrderId.toString());

            orders = new Orders(
                order_id: int.tryParse(orderId),
                order_number: orderNo,
                order_status: "Submitted",
                order_address_id: addressId,
                order_full_address: fullAddress,
                order_address_type: saveAs,
                order_flat: buildingType,
                order_landmark: landmark,
                order_latitude: latitude.toString(),
                order_longitude: longitude.toString(),
                order_otp: orderOtp,
                order_custom_note: customNote,
                order_delivery_charge: deliveryCharge,
                order_rating: '0.0',
                order_review: '',
                order_date: orderDate,
                order_total_pages: totalPages.toString());
            await DSDatabase.instance.insertToOrder(orders);
          }

          await DSDatabase.instance
              .updateOrdersTotalPages(totalPages.toString());

          productList.clear();
          productList = await DSDatabase.instance.getCartProducts();
          OrderProduct orderProduct;
          for (int i = 0; i < productList.length; i++) {
            String productId = productList.elementAt(i).product_id.toString();
            String productName = productList.elementAt(i).item_name;
            String productImage = productList.elementAt(i).image;
            String productAmount = productList.elementAt(i).amount;
            String productCartid = cartIdList.elementAt(i).toString();

            orderProduct = new OrderProduct(
                order_cart_id: int.tryParse(productCartid),
                order_product_id: productId,
                order_id: orderId,
                order_product_name: productName,
                order_product_amount: productAmount,
                order_product_image: productImage);
            await DSDatabase.instance.insertToOrderProduct(orderProduct);
          }
          await DSDatabase.instance.clearCart();

          PrefManager.saveCartNote("");
          customNote = "";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CheckOutPage(orderNumber: orderNo, orderOTP: orderOtp)));
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

// check delivery charge
  getDeliveryCharge() async {
    setState(() {
      loading = true;
    });
    String requestResult, responseResult;
    log('latitude:$lat,$long');
    try {
      var body = {'latitude': lat, 'longitude': long};
      var headers = {
        'DeviceID': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobile,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      final jsonbody = json.encode(body);
      print('user Location:' + lat + ',' + long);
      print('body:::' + jsonbody.toString());
      try {
        requestResult = await platform.invokeMethod(
            'RequestEncrypt', <String, String>{
          'request': jsonbody.toString(),
          'DeviceId': userEmail
        });
        log('RegRequest:$requestResult');
      } on PlatformException catch (e) {
        print(e);
      }
      var request =
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.GET_DELIVERY_CHARGE));
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
          print(e);
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'].toString();
        if (valueMap['status']) {
          setState(() {
            loading = false;
          });
          Map<String, dynamic> charge = valueMap['data'];
          String deliveryCharge = charge['delivery_charge'];
          showDeliverCharge(context, deliveryCharge);
          PrefManager.saveDeliveryFee(deliveryCharge);
          if (deliveryCharge == '') {
            setState(() {
              tvDeliveryCharge = "";
            });
          } else {
            tvDeliveryCharge = deliveryCharge;
          }
          _chargeController.sink.add(tvDeliveryCharge);
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

//dashed divider
class DashedLineHorizontalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
