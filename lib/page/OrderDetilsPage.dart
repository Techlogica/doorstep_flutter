// ignore_for_file: file_names, prefer_const_constructors, no_logic_in_create_state, must_be_immutable, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_const_declarations, avoid_print
// @dart=2.9

import 'dart:async';

import 'package:doorstep_banking_flutter/Model/Cart.dart';
import 'package:doorstep_banking_flutter/Model/OrderProducts.dart';
import 'package:doorstep_banking_flutter/Model/Orders.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class OrderDetailsPage extends StatefulWidget {
  int orderId;
  OrderDetailsPage({Key key, this.orderId}) : super(key: key);
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState(orderId);
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  _OrderDetailsPageState(this.orderId);
  int orderId;

  final _orderProductController =
      StreamController<List<OrderProduct>>.broadcast();
  List<Orders> orderList = [];
  List<OrderProduct> orderProductList = [];
  List<Cart> cartList = [];
  String fullAddress = '',
      landmark = '',
      buildingType = '',
      orderNumber = '',
      orderOtp = '',
      orderStatus = '',
      customNote = '',
      deliveryCharge = '';

  @override
  void initState() {
    super.initState();
    loadOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.off_white,
      appBar: _appBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _addressText(),
            _noteDelivery(),
            _itemList(),
            SizedBox(
              height: 10,
            ),
            _getQrBtn(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  //app bar
  Widget _appBar(){
    const double circleRadius = 50.0;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          S.of(context).orderList,
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  //address text
  Widget _addressText(){
    return Expanded(
      flex: 0,
      child: Container(
        height: 120,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomLeft)
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 7,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Icon(
                    Icons.location_pin,
                    color: colors.black,
                  )),
            ),
            Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 280,
                          child: Text(
                              fullAddress ?? S.of(context).fullAddress,
                              style: TextStyle(
                                  color: colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(buildingType,
                            style: TextStyle(
                              color: colors.gray_dark,
                              fontSize: 16,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Text(landmark,
                            style: TextStyle(
                              color: colors.gray_dark,
                              fontSize: 16,
                            ))
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  //custom notes and delivery charge
  Widget _noteDelivery(){
    return Expanded(
      flex: 0,
      child: Container(
        height: 70,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomLeft)
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 7,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Icon(
                    Icons.notes,
                    color: colors.black,
                  )),
            ),
            Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(customNote,
                            style: TextStyle(
                                color: colors.gray_dark,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          S.of(context).deliverycharge + deliveryCharge,
                          style: TextStyle(
                              color: colors.gray_dark,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  //order items list
  Widget _itemList(){
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: _createListRow(),
      ),
    );
  }

  //qr code button
  Widget _getQrBtn(){
    return Expanded(
        flex: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 160,
              decoration: BoxDecoration(
                  color: colors.off_white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(4, 4),
                      blurRadius: 5,
                      spreadRadius: 2.5,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 5,
                      spreadRadius: 2.5,
                    ),
                  ]),
              child: TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage())),
                child: Text(
                  S.of(context).getQrCode,
                  style: TextStyle(
                      color: colors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ));
  }

  //item lists
  Widget _createListRow() {
    // double c_width = MediaQuery.of(context).size.width * 0.9;
    // double c_height = MediaQuery.of(context).size.width * 0.55;
    final Color background = colors.primaryColor;
    final Color fill = colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = 85.00; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
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
        child: ListView.builder(
            itemCount: orderProductList.length,
            itemBuilder: (context, index) {
              bool amountVisibility = false;
              if (orderProductList[index].order_product_name ==
                  'ATM Withdrawal') {
                amountVisibility = true;
              }
              return Column(
                children: [
                  Container(
                    height: 100,
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomLeft)
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 7,
                        ),
                        Expanded(
                            flex: 0,

                            ///setting image over image side by side
                            child: Image.asset(
                                'assets/icons/' +
                                    orderProductList[index]
                                        .order_product_image +
                                    '.png',
                                height: 70,
                                width: 70)),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        orderProductList[index]
                                            .order_product_name,
                                        style: TextStyle(
                                            color: colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Visibility(
                                  visible: amountVisibility,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: colors.off_white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border:
                                                Border.all(color: colors.gray)),
                                        child: TextField(
                                          expands: false,
                                          maxLength: 20,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: colors.primaryColor),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 5.0, bottom: 12),
                                            counterText: "",
                                            hintText: 'Item',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }

  //loading order data
  loadOrderData() async {
    try {
      orderList.clear();
      orderList = await DSDatabase.instance.getOrderInfo(orderId);

      orderProductList.clear();
      orderProductList =
          await DSDatabase.instance.getOrderedProductInfo(orderId);
      _orderProductController.sink.add(orderProductList);

      loadLocalData();
    } on Exception catch (e) {
      print(e);
    }
  }

  //loading local order data
  loadLocalData() async {
    setState(() {
      fullAddress = orderList.elementAt(0).order_full_address;
      landmark = orderList.elementAt(0).order_landmark;
      buildingType = orderList.elementAt(0).order_flat;
      orderNumber = orderList.elementAt(0).order_number;
      orderOtp = orderList.elementAt(0).order_otp;
      orderStatus = orderList.elementAt(0).order_status;
      customNote = orderList.elementAt(0).order_custom_note;
      deliveryCharge = orderList.elementAt(0).order_delivery_charge;
    });

    for (int i = 0; i < orderProductList.length; i++) {
      String productId = orderProductList.elementAt(i).order_product_id;
      String productName = orderProductList.elementAt(i).order_product_name;
      String productImage = orderProductList.elementAt(i).order_product_image;
      String productAmount = orderProductList.elementAt(i).order_product_amount;

      Cart cart = Cart(
          item_name: productName,
          product_id: int.tryParse(productId),
          image: productImage,
          amount: productAmount);
      cartList.add(cart);
    }
  }
}
