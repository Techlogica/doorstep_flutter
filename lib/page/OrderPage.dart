// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, non_constant_identifier_names, prefer_const_constructors, missing_required_param

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/Model/Cart.dart';
import 'package:doorstep_banking_flutter/Model/OrderProducts.dart';
import 'package:doorstep_banking_flutter/Model/Orders.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/CartPage.dart';
import 'package:doorstep_banking_flutter/page/OrderDetilsPage.dart';
import 'package:doorstep_banking_flutter/page/OrderRatingPage.dart';
import 'package:doorstep_banking_flutter/utils/DateTimeFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'HomePage.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Orders> orderList = [];
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  List<Orders> orderModelList = [];
  List<OrderProduct> orderProductList = [];
  List<OrderProduct> orderedProductInfoList = [];
  ScaffoldMessengerState scaffoldMessenger;
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobileNumber = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String userEmail = PrefManager.getEmail();
  int currentPages = 1;
  String addressId;
  int TOTAL_PAGE;
  bool loading = false;
  final _orderController = StreamController<List<Orders>>.broadcast();
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    loadOrderData();
  }

  @override
  void dispose() {
    super.dispose();
    _orderController.close();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        backgroundColor: colors.off_white,
        appBar: _appBar(),
        body: Stack(children: [
          _createListRow(),
          Visibility(
            child: loadingWidget(context),
            visible: loading,
          )
        ]));
  }

  //app bar
  Widget _appBar() {
    const double circleRadius = 50.0;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          S.of(context).orders.toUpperCase(),
          style: TextStyle(
              color: colors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      leading: Container(
        margin: EdgeInsets.only(left: 10),
        width: circleRadius,
        height: circleRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primaryColor,
          border: Border.all(color: colors.white, width: 4),
        ),
        child: IconButton(
          padding: EdgeInsets.only(left: 7.0),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage())),
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  Widget _createListRow() {
    // double cWidth = MediaQuery.of(context).size.width * 0.9;
    // double cHeight = MediaQuery.of(context).size.width * 0.55;
    const Color background = colors.primaryColor;
    const Color fill = colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 85.00; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return Container(
        child: StreamBuilder(
      initialData: orderModelList,
      stream: _orderController.stream,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: orderModelList.length,
            itemBuilder: (context, index) {
              return Stack(children: [
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),

                    //setting two colors to the container
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                                width: 20,
                              ),
                              Expanded(
                                  flex: 0,

                                  //setting image over image side by side
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.center,
                                          height: 100,
                                          child: Image.asset(
                                              'assets/icons/atm_withdrawal_light.png',
                                              height: 70,
                                              width: 70)),
                                    ],
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              orderedProductInfoList[index]
                                                  .order_product_name,
                                              style: TextStyle(
                                                  color: colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 0),
                                              child: Text(
                                                DateTimeFormat()
                                                    .parseServerDateTime(
                                                        orderModelList[index]
                                                            .order_date),
                                                style: const TextStyle(
                                                    color: colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 2,
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ],
                                      )
                                    ],
                                  )),
                              Expanded(
                                  flex: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            orderModelList[index].order_status,
                                            style: const TextStyle(
                                                color: colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Visibility(
                                              visible: true,
                                              child: orderModelList[index]
                                                          .order_status ==
                                                      'Completed'
                                                  ? Image.asset(
                                                      "assets/icons/check.png",
                                                      height: 20,
                                                      width: 20,
                                                    )
                                                  : orderModelList[index]
                                                              .order_status ==
                                                          'Cancelled'
                                                      ? Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 20,
                                                          width: 20,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: const Icon(
                                                            Icons.clear,
                                                            color: colors.white,
                                                            size: 15,
                                                          ),
                                                        )
                                                      : const Icon(
                                                          Icons.access_time,
                                                          color: Colors.grey,
                                                        )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Visibility(
                                        visible: orderModelList[index]
                                                    .order_status ==
                                                'Submitted'
                                            ? true
                                            : false,
                                        child: Container(
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: colors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              showAlertDialog(
                                                  context,
                                                  orderModelList[index]
                                                      .order_id);
                                            },
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .cancel
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  color: colors.white,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: orderModelList[index].order_status ==
                                    'Delivered'
                                ? true
                                : orderModelList[index].order_status ==
                                        'Completed'
                                    ? true
                                    : false,
                            child: Column(
                              children: [
                                Container(
                                    height: 10,
                                    margin: const EdgeInsets.only(left: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // SizedBox(
                                        //   width: 30,
                                        // ),
                                        CustomPaint(
                                            size: Size(280, double.infinity),
                                            painter:
                                                DashedLineHorizontalPainter())
                                      ],
                                    )),
                                Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      margin: const EdgeInsets.only(
                                          left: 30.0,
                                          right: 10.0,
                                          top: 10.0,
                                          bottom: 25.0),
                                      child: Image.asset(
                                        "assets/icons/img_delivery_man_review.png",
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '#DSBORD' +
                                              orderModelList[index]
                                                  .order_id
                                                  .toString(),
                                          style: const TextStyle(
                                              color: colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(children: [
                                          RatingBar.builder(
                                            minRating: 0,
                                            maxRating: 5,
                                            itemSize: 20,
                                            unratedColor: colors.gray,
                                            initialRating: double.tryParse(
                                                orderModelList[index]
                                                    .order_rating),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: colors.primaryColor,
                                            ),
                                          ),
                                          Text(orderModelList[index]
                                              .order_rating)
                                        ]),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderDetailsPage(
                                orderId: orderModelList[index].order_id)));
                  },
                ),
                Visibility(
                  visible: orderModelList[index].order_status == 'Delivered'
                      ? true
                      : orderModelList[index].order_status == 'Completed'
                          ? true
                          : orderModelList[index].order_status == 'Cancelled'
                              ? true
                              : false,
                  child: Positioned(
                    bottom: 0,
                    right: 15,
                    //give the values according to your requirement
                    child: Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                        color: colors.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: () {
                          orderModelList[index].order_status == 'Delivered'
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderRatingPage(
                                            orderId: orderModelList[index]
                                                .order_id
                                                .toString(),
                                            orderCode: orderModelList[index]
                                                .order_number,
                                          )))
                              : reorderAlertDialog(
                                  orderModelList[index].order_id);
                        },
                        child: Text(
                          orderModelList[index].order_status == 'Delivered'
                              ? S.of(context).rateOrder.toUpperCase()
                              : S.of(context).reorder.toUpperCase(),
                          style: TextStyle(
                            color: colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]);
            });
      },
    ));
  }

  //loading local data
  void loadLocalData(List<Orders> orderlist) async {
    if (orderlist.isNotEmpty) {
      // lyout_no_data_msg.setVisibility(View.GONE);
      for (int i = 0; i < orderlist.length; i++) {
        String orderStatus = orderlist.elementAt(i).order_status;
        String addressType = orderlist.elementAt(i).order_address_type;
        String orderNumber = orderlist.elementAt(i).order_number;
        double latitude =
            double.tryParse(orderlist.elementAt(i).order_latitude);
        String fullAddress = orderlist.elementAt(i).order_full_address;
        String landmark = orderlist.elementAt(i).order_landmark;
        int orderId = orderlist.elementAt(i).order_id;
        String buildingType = orderlist.elementAt(i).order_flat;
        double longitude =
            double.tryParse(orderlist.elementAt(i).order_longitude);
        double rating = double.tryParse(orderlist.elementAt(i).order_rating);
        String otp = orderlist.elementAt(i).order_otp;
        String note = orderlist.elementAt(i).order_custom_note;
        String deliverycharge = orderlist.elementAt(i).order_delivery_charge;
        String review = orderlist.elementAt(i).order_review;
        String orderDate = orderlist.elementAt(i).order_date;
        TOTAL_PAGE = int.tryParse(orderlist.elementAt(i).order_total_pages);

        orderProductList.clear();

        orderProductList =
            await DSDatabase.instance.getOrderedProductInfo(orderId);

        String productName = orderProductList.elementAt(0).order_product_name;
        double productAmount =
            double.tryParse(orderProductList.elementAt(0).order_product_amount);
        int cartId = orderProductList.elementAt(0).order_cart_id;
        String productImage = orderProductList.elementAt(0).order_product_image;
        String productId = orderProductList.elementAt(0).order_product_id;

        OrderProduct orderProduct = new OrderProduct(
            order_cart_id: cartId,
            order_product_id: productId,
            order_id: orderId.toString(),
            order_product_name: productName,
            order_product_amount: productAmount.toString(),
            order_product_image: productImage);

        // OrderModel addressModel = new OrderModel(orderStatus,addressType,orderNumber,latitude,fullAddress,
        //     landmark,orderId,buildingType,longitude,productImage,productName,productAmount,rating,
        //     otp,note,deliverycharge,review,orderDate,productId);

        Orders orders = new Orders(
            order_id: orderId,
            order_number: orderNumber,
            order_status: orderStatus,
            order_address_id: addressId,
            order_full_address: fullAddress,
            order_address_type: addressType,
            order_flat: buildingType,
            order_landmark: landmark,
            order_latitude: latitude.toString(),
            order_longitude: longitude.toString(),
            order_otp: otp,
            order_custom_note: note,
            order_delivery_charge: deliverycharge,
            order_rating: rating.toString(),
            order_review: review,
            order_date: orderDate,
            order_total_pages: TOTAL_PAGE.toString());
        orderModelList.add(orders);
        _orderController.sink.add(orderModelList);
        orderedProductInfoList.add(orderProduct);
      }
    }
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

// order data
  getOrders() async {}

// cancel order
  cancelOrder(String orderId) async {
    String requestResult, responseResult;
    setState(() {
      loading = true;
    });
    try {
      var headers = {
        'DeviceID': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobileNumber,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      var body = {
        'order_id': orderId,
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
      var request =
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.CANCEL_ORDER));
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
          log('OTPVerResponse:$responseResult');
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
          await DSDatabase.instance
              .updateorderStatus(int.tryParse(orderId), 'Cancelled');
          //stream
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

  // load order data
  void loadOrderData() async {
    currentPages = 1;
    try {
      orderList = await DSDatabase.instance.getOrders();

      if (orderList.isEmpty) {
        loadServerData(currentPages);
      } else {
        loadLocalData(orderList);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //load order server data
  loadServerData(int currentPage) async {
    setState(() {
      loading = true;
    });
    try {
      String requestResult, responseResult;
      var headers = {
        'DeviceID': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobileNumber,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      var body = {
        'page_no': '1',
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
      var request = Request('POST', Uri.parse(Apis.BASE_URL + Apis.LIST_ORDER));
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
          log('Response:$responseResult');
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
          // print('orderList:' + listOrder.length.toString());
          // print('orderList:::' + listOrder.toString());
          // List<dynamic> listCart = listOrder[0]['product'];
          // print('cartList:::' + listCart.toString());
          List<dynamic> listOrder = valueMap['data'];
          Orders orders;
          OrderProduct orderProduct;
          if (listOrder.isNotEmpty) {
            for (int i = 0; i < listOrder.length; i++) {
              String orderStatus = listOrder[i]['order_status'];
              String addressType = listOrder[i]['address_type'];
              double address_id = listOrder[i]['address_id'];
              String orderNumber = listOrder[i]['order_number'];
              double latitude = listOrder[i]['latitude'];
              double longitude = listOrder[i]['longitude'];
              String fullAddress = listOrder[i]['full_address'];
              String landmark = listOrder[i]['landmark'];
              double orderId = listOrder[i]['order_id'];
              String buildingType = listOrder[i]['building_type'];
              String note = listOrder[i]['custom_notes'];
              String deliveryCharge = listOrder[i]['delivery_charge'];
              String review = listOrder[i]['review'];
              String orderDate = listOrder[i]['order_date'];
              double rating = listOrder[i]['rating'];
              String otp = listOrder[i]['otp'];
              int totalPages = listOrder[i]['page_count'];
              orders = new Orders(
                  order_id: orderId.toInt(),
                  order_number: orderNumber,
                  order_status: orderStatus,
                  order_address_id: address_id.toString(),
                  order_full_address: fullAddress,
                  order_address_type: addressType,
                  order_flat: buildingType,
                  order_landmark: landmark,
                  order_latitude: latitude.toString(),
                  order_longitude: longitude.toString(),
                  order_otp: otp,
                  order_custom_note: note,
                  order_delivery_charge: deliveryCharge,
                  order_rating: rating.toString(),
                  order_review: review,
                  order_date: orderDate,
                  order_total_pages: totalPages.toString());
              await DSDatabase.instance.insertToOrder(orders);
              int order_id = orderId.toInt();
              List<dynamic> listproduct = listOrder[i]['product'];
              for (int j = 0; j < listproduct.length; j++) {
                String cartId = listproduct[j]['cart_id'].toString();
                String productId = listproduct[j]['product_id'];
                String productName = listproduct[j]['product_name'];
                String productAmount = listproduct[j]['product_name'];
                String productImage = listproduct[j]['image_name'];
                orderProduct = new OrderProduct(
                    order_cart_id: int.tryParse(cartId),
                    order_product_id: productId,
                    order_id: order_id.toString(),
                    order_product_name: productName,
                    order_product_amount: productAmount,
                    order_product_image: productImage);
                await DSDatabase.instance.insertToOrderProduct(orderProduct);
              }
              OrderProduct orderProducts = new OrderProduct(
                  order_cart_id: listproduct[0]['cart_id'],
                  order_product_id: listproduct[0]['product_id'],
                  order_id: orderId.toString(),
                  order_product_name: listproduct[0]['product_name'],
                  order_product_amount: listproduct[0]['product_name'],
                  order_product_image: listproduct[0]['image_name']);
              orderedProductInfoList.add(orderProducts);
              orderModelList.add(orders);
              _orderController.sink.add(orderModelList);
            }
          }
          // if (PrefManager.getisLoginFlag()) {
          //   PrefManager.saveLoginFlag(false);
          // }
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

  //cancel alert dialog
  showAlertDialog(BuildContext context, int orderId) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        cancelOrder(orderId.toString());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).cancelConfirmation),
      content: Text(S.of(context).deleteOrderAlert),
      actions: [
        cancelButton,
        continueButton,
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

  //reorder alert dialog
  reorderAlertDialog(int orderId) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () async {
        await DSDatabase.instance.clearCart();

        Cart cart;

        orderProductList.clear();
        orderProductList =
            await DSDatabase.instance.getOrderedProductInfo(orderId);

        for (int j = 0; j < orderProductList.length; j++) {
          String product_id = orderProductList.elementAt(j).order_product_id;
          String product_name =
              orderProductList.elementAt(j).order_product_name;
          String product_image =
              orderProductList.elementAt(j).order_product_image;
          String product_amount =
              orderProductList.elementAt(j).order_product_amount;

          cart = new Cart(
              item_name: product_name,
              product_id: int.tryParse(product_id),
              image: product_image,
              amount: product_amount);
          await DSDatabase.instance.addTocart(cart);
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CartPage()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).alert),
      content: Text(S.of(context).reorderAlert),
      actions: [
        continueButton,
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
