// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, missing_return, curly_braces_in_flow_control_structures, avoid_print, unused_local_variable, non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, unrelated_type_equality_checks, missing_required_param

import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/Model/Orders.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/OrderTrackingPage.dart';
import 'package:doorstep_banking_flutter/utils/DateTimeFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';

class ViewStatusPage extends StatefulWidget {
  const ViewStatusPage({Key key}) : super(key: key);

  @override
  _ViewStatusPageState createState() => _ViewStatusPageState();
}

class _ViewStatusPageState extends State<ViewStatusPage> {
  bool orderPlaced = true;
  bool orderConfirmed = false;
  bool orderProcessed = false;
  bool agentArrived = false;
  bool orderVerified = false;
  bool orderDelivered = false;
  bool orderCompleted = false;
  bool submitedTimeVisibility = false;
  bool confirmTimeVisibility = false;
  bool startTimeVisibility = false;
  bool reachedTimeVisibility = false;
  bool verifiedTimeVisibility = false;
  bool deliveredTimeVisibility = false;
  bool completedTimeVisibility = false;
  bool driverVisibility = false;
  bool trackOrderVisibility = false;
  bool trackbtn = false;
  String submittedTime,
      confirmTime,
      agentStart,
      agentReached,
      verifiedTime,
      deliveredTime,
      completedTime,
      driverName,
      totalDelivery,
      driverImage;
  double agentLat = 0.0;
  double agentLong = 0.0;
  List<Orders> orderList = [];
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobileNumber = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String userEmail = PrefManager.getEmail();
  double rating = 0;
  bool loading = true;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    const double circleRadius = 50.0;
    return Scaffold(
        backgroundColor: colors.off_white,
        appBar: _appBar(),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  _statusCard(),
                  Visibility(visible: driverVisibility, child: _driverCard()),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                      visible: trackOrderVisibility, child: _trackOrderBtn()),
                ],
              ),
            ),
            Visibility(
              child: loadingWidget(context),
              visible: loading,
            ),
          ],
        ));
  }

  //appbar
  Widget _appBar() {
    const double circleRadius = 50.0;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          S.of(context).orders.toUpperCase(),
          style: const TextStyle(
              color: colors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  //order status
  Widget _statusCard() {
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.only(left: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                _orderPlaced(),
                _orderConfirmed(),
                _orderProcessed(),
                _orderArrived(),
                _orderVerified(),
                _orderDelivered(),
                _orderCompleted(),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      ],
    );
  }

  //order placed
  Widget _orderPlaced() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  border: Border.all(color: Colors.green, width: 2)),
              child: const Icon(
                Icons.done,
                size: 15,
                color: Colors.white,
              ),
            ),
            Container(
              height: 40,
              width: 3,
              decoration: const BoxDecoration(color: Colors.green),
            ),
          ],
        ),
        const SizedBox(
          width: 40,
        ),
        Container(
          height: 60,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.of(context).orderPlaced,
                style: TextStyle(color: Colors.green, fontSize: 16.0),
              ),
              Visibility(
                child: Text(
                  submittedTime == '' || submittedTime == null
                      ? 'Submited time'
                      : DateTimeFormat().parseServerDateTime(submittedTime),
                  style: const TextStyle(color: Colors.green, fontSize: 14.0),
                ),
                visible: submitedTimeVisibility,
              ),
            ],
          ),
        )
      ],
    );
  }

  //agent accepted
  Widget _orderConfirmed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: orderConfirmed == true
                        ? Colors.green
                        : orderPlaced == true
                            ? Colors.orange
                            : Colors.white,
                    border: Border.all(
                        color: orderConfirmed == true
                            ? Colors.green
                            : orderPlaced == true
                                ? Colors.orange
                                : Colors.grey,
                        width: 2)),
                child: orderConfirmed == true
                    ? const Icon(
                        Icons.done,
                        size: 15,
                        color: Colors.white,
                      )
                    : const Text(
                        '!',
                        style: TextStyle(
                            color: colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      )),
            Visibility(
              visible: confirmTimeVisibility,
              child: Container(
                height: 40,
                width: 3,
                decoration: const BoxDecoration(color: Colors.green),
              ),
            ),
            Visibility(
                visible: confirmTimeVisibility == true ? false : true,
                child: CustomPaint(
                    size: const Size(0, 40),
                    painter: DashedLineHorizontalPainter())),
          ],
        ),
        const SizedBox(
          width: 40,
        ),
        Container(
          height: 60,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Text(
                S.of(context).orderConfirmed,
                style: const TextStyle(color: Colors.green, fontSize: 16.0),
              ),
              Visibility(
                child: Text(
                  confirmTime == '' || confirmTime == null
                      ? 'Confirm time'
                      : DateTimeFormat().parseServerDateTime(confirmTime),
                  style: const TextStyle(color: Colors.green, fontSize: 14.0),
                ),
                visible: confirmTimeVisibility,
              ),
            ],
          ),
        )
      ],
    );
  }

  //agent started
  Widget _orderProcessed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orderProcessed == true
                      ? Colors.green
                      : orderConfirmed == true
                          ? Colors.orange
                          : Colors.white,
                  border: Border.all(
                      color: orderProcessed == true
                          ? Colors.green
                          : orderConfirmed == true
                              ? Colors.orange
                              : Colors.grey,
                      width: 2)),
              child: orderProcessed == true
                  ? const Icon(
                      Icons.done,
                      size: 15,
                      color: Colors.white,
                    )
                  : orderConfirmed == true
                      ? const Text(
                          '!',
                          style: TextStyle(
                              color: colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        )
                      : const Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.grey,
                        ),
            ),
            Visibility(
              visible: startTimeVisibility,
              child: Container(
                height: 40,
                width: 3,
                decoration: const BoxDecoration(color: Colors.green),
              ),
            ),
            Visibility(
                visible: startTimeVisibility == true ? false : true,
                child: CustomPaint(
                    size: const Size(0, 40),
                    painter: DashedLineHorizontalPainter())),
          ],
        ),
        const SizedBox(
          width: 40,
        ),
        Container(
          height: 60,
          child: Column(
            children: [
              Text(
                S.of(context).orderProcessed,
                style: TextStyle(
                    color: orderProcessed == true ? Colors.green : Colors.grey,
                    fontSize: 16.0),
              ),
              Visibility(
                child: Text(
                  agentStart == '' || agentStart == null
                      ? 'Agent time'
                      : DateTimeFormat().parseServerDateTime(agentStart),
                  style: TextStyle(color: Colors.green, fontSize: 14.0),
                ),
                visible: startTimeVisibility,
              ),
            ],
          ),
        )
      ],
    );
  }

  //agent arrived
  Widget _orderArrived() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: agentArrived == true
                      ? Colors.green
                      : orderProcessed == true
                          ? Colors.orange
                          : Colors.white,
                  border: Border.all(
                      color: agentArrived == true
                          ? Colors.green
                          : orderProcessed == true
                              ? Colors.orange
                              : Colors.grey,
                      width: 2)),
              child: agentArrived == true
                  ? const Icon(
                      Icons.done,
                      size: 15,
                      color: Colors.white,
                    )
                  : orderProcessed == true
                      ? const Text(
                          '!',
                          style: TextStyle(
                              color: colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        )
                      : const Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.grey,
                        ),
            ),
            Visibility(
              visible: reachedTimeVisibility,
              child: Container(
                height: 40,
                width: 3,
                decoration: const BoxDecoration(color: Colors.green),
              ),
            ),
            Visibility(
                visible: reachedTimeVisibility == true ? false : true,
                child: CustomPaint(
                    size: const Size(0, 40),
                    painter: DashedLineHorizontalPainter())),
          ],
        ),
        const SizedBox(
          width: 40,
        ),
        Container(
          height: 60,
          child: Column(
            children: [
              Text(
                S.of(context).agentArrived,
                style: TextStyle(
                    color: agentArrived == true ? Colors.green : Colors.grey,
                    fontSize: 16.0),
              ),
              Visibility(
                child: Text(
                  agentReached == '' || agentReached == null
                      ? 'Agent Reached time'
                      : DateTimeFormat().parseServerDateTime(agentReached),
                  style: const TextStyle(color: Colors.green, fontSize: 14.0),
                ),
                visible: reachedTimeVisibility,
              ),
            ],
          ),
        )
      ],
    );
  }

  //order verified
  Widget _orderVerified() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orderVerified == true
                      ? Colors.green
                      : agentArrived == true
                          ? Colors.orange
                          : Colors.white,
                  border: Border.all(
                      color: orderVerified == true
                          ? Colors.green
                          : agentArrived == true
                              ? Colors.orange
                              : Colors.grey,
                      width: 2)),
              child: orderVerified == true
                  ? const Icon(
                      Icons.done,
                      size: 15,
                      color: Colors.white,
                    )
                  : agentArrived == true
                      ? const Text(
                          '!',
                          style: TextStyle(
                              color: colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        )
                      : const Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.grey,
                        ),
            ),
            Visibility(
              visible: verifiedTimeVisibility,
              child: Container(
                height: 40,
                width: 3,
                decoration: const BoxDecoration(color: Colors.grey),
              ),
            ),
            Visibility(
                visible: verifiedTimeVisibility == true ? false : true,
                child: CustomPaint(
                    size: const Size(0, 40),
                    painter: DashedLineHorizontalPainter())),
          ],
        ),
        const SizedBox(
          width: 40,
        ),
        Container(
          height: 60,
          child: Column(
            children: [
              Text(
                S.of(context).orderVerified,
                style: TextStyle(
                    color: orderVerified == true ? Colors.green : Colors.grey,
                    fontSize: 16.0),
              ),
              Visibility(
                child: Text(
                  verifiedTime == '' || verifiedTime == null
                      ? 'Verified time'
                      : DateTimeFormat().parseServerDateTime(verifiedTime),
                  style: TextStyle(color: Colors.green, fontSize: 14.0),
                ),
                visible: verifiedTimeVisibility,
              ),
            ],
          ),
        )
      ],
    );
  }

  //order delivered
  Widget _orderDelivered() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orderDelivered == true
                      ? Colors.green
                      : orderVerified == true
                          ? Colors.orange
                          : Colors.white,
                  border: Border.all(
                      color: orderDelivered == true
                          ? Colors.green
                          : orderVerified == true
                              ? Colors.orange
                              : Colors.grey,
                      width: 2)),
              child: orderDelivered == true
                  ? const Icon(
                      Icons.done,
                      size: 15,
                      color: Colors.white,
                    )
                  : orderVerified == true
                      ? const Text(
                          '!',
                          style: TextStyle(
                              color: colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        )
                      : const Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.grey,
                        ),
            ),
            Visibility(
              visible: deliveredTimeVisibility,
              child: Container(
                height: 40,
                width: 3,
                decoration: const BoxDecoration(color: Colors.grey),
              ),
            ),
            Visibility(
                visible: deliveredTimeVisibility == true ? false : true,
                child: CustomPaint(
                    size: const Size(0, 40),
                    painter: DashedLineHorizontalPainter())),
          ],
        ),
        const SizedBox(
          width: 40,
        ),
        Container(
          height: 60,
          child: Column(
            children: [
              Text(
                S.of(context).orderDelivered,
                style: TextStyle(
                    color: orderDelivered == true ? Colors.green : Colors.grey,
                    fontSize: 16.0),
              ),
              Visibility(
                child: Text(
                  deliveredTime == '' || deliveredTime == null
                      ? 'Delivered time'
                      : DateTimeFormat().parseServerDateTime(deliveredTime),
                  style: TextStyle(color: Colors.green, fontSize: 14.0),
                ),
                visible: deliveredTimeVisibility,
              ),
            ],
          ),
        )
      ],
    );
  }

  //order completed
  Widget _orderCompleted() {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orderCompleted == true
                      ? Colors.green
                      : orderDelivered == true
                          ? Colors.orange
                          : Colors.white,
                  border: Border.all(
                      color: orderCompleted == true
                          ? Colors.green
                          : orderDelivered == true
                              ? Colors.orange
                              : Colors.grey,
                      width: 2)),
              child: orderCompleted == true
                  ? const Icon(
                      Icons.done,
                      size: 15,
                      color: Colors.white,
                    )
                  : orderDelivered == true
                      ? const Text(
                          '!',
                          style: TextStyle(
                              color: colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        )
                      : const Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.grey,
                        ),
            ),
            Visibility(
              visible: completedTimeVisibility,
              child: Container(
                height: 40,
                width: 3,
                decoration: const BoxDecoration(color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 40,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).orderCompleted,
              style: TextStyle(
                  color: orderCompleted == true ? Colors.green : Colors.grey,
                  fontSize: 16.0),
            ),
            Visibility(
              child: Text(
                completedTime == '' || completedTime == null
                    ? 'Completed time'
                    : DateTimeFormat().parseServerDateTime(completedTime),
                style: TextStyle(color: Colors.green, fontSize: 14.0),
              ),
              visible: completedTimeVisibility,
            ),
          ],
        )
      ],
    );
  }

  //order accepted agent details
  Widget _driverCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: colors.light_color, width: 5),
            ),
            child: driverImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.network(
                      driverImage,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset(
                      'assets/icons/ic_profile.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            children: [
              Text(
                driverName == '' || driverName == null
                    ? 'driverName'
                    : driverName,
                style: TextStyle(
                    color: colors.gray_dark,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Center(
                  child: RatingBar.builder(
                minRating: 0,
                maxRating: 5,
                itemSize: 20,
                unratedColor: colors.gray,
                initialRating: rating == '' || rating == null ? 0 : rating,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: colors.primaryColor,
                ),
                // onRatingUpdate: (rating) => setState(() {
                //       this.rating = rating;
                //     })
              )),
              Text(
                totalDelivery == '' || totalDelivery == null
                    ? 'totalDelivery'
                    : totalDelivery,
                style: TextStyle(color: colors.gray_dark, fontSize: 13.0),
              )
            ],
          ),
        ],
      ),
    );
  }

  //order tracking
  Widget _trackOrderBtn() {
    return Container(
      height: 40,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: colors.white,
        border: Border.all(color: colors.primaryColor, width: 3),
      ),
      child: TextButton(
        child: const Text(
          'Track Order',
          style: TextStyle(color: colors.primaryColor),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrderTrackingPage()));
        },
      ),
    );
  }

  //load order status
  loadOrder() async {
    // setState(() {
    //   loading == true;
    // });
    int lastOrder;
    try {
      String requestResult, responseResult;
      int lastOrderId = await DSDatabase.instance.getLastOrderId();
      lastOrder = lastOrderId;
      var headers = {
        'DeviceID': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobileNumber,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      log("Header: $headers");
      var body = {'order_id': lastOrderId};
      final jsonbody = json.encode(body);
      log('Body: $jsonbody');
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
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.ORDER_PROCESS_TIME));
      request.body = '''{"request_encrypted":"$requestResult"}''';
      request.headers.addAll(headers);
      log('request: $request');

      StreamedResponse response = await request.send();
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String body = await response.stream.bytesToString();
        log('responseBody: $body');
        String responseBody = body.replaceAll('{"response_encrypted":"', '');
        responseBody = responseBody.replaceAll('"}', "");
        log('response: $responseBody');
        try {
          responseResult = await platform.invokeMethod(
              "ResponseDecrypt", <String, String>{
            'response': responseBody,
            'DeviceId': userEmail
          });
          log('Response:$responseResult');
        } on PlatformException catch (e) {
          // Unable to open the browser
          print(e);
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'];
        if (valueMap['status']) {
          setState(() {
            loading = false;
          });
          Map<String, dynamic> orderStatusList = valueMap['data'];
          String driverDeviceId = orderStatusList['device_id'];
          submittedTime = orderStatusList['submited_time'];
          submitedTimeVisibility = true;
          try {
            confirmTime = orderStatusList['confirm_time'];
            if (confirmTime != '' && confirmTime != null) {
              log("agentStart: $confirmTime");
              await DSDatabase.instance
                  .updateorderStatus(lastOrder, 'Accepted');
              setState(() {
                orderConfirmed = true;
                confirmTimeVisibility = true;
              });
            }
          } on Exception catch (e) {
            print(e);
          }

          try {
            agentStart = orderStatusList['agent_start'];
            if (agentStart != '' && agentStart != null) {
              log("agentStart: $agentStart");
              await DSDatabase.instance.updateorderStatus(lastOrder, 'Start');
              setState(() {
                orderProcessed = true;
                startTimeVisibility = true;
                trackOrderVisibility = true;
              });
            }
          } on Exception catch (e) {
            print(e);
          }

          try {
            agentReached = orderStatusList['agent_reached'];
            if (agentReached != '' && agentReached != null) {
              log("agentStart: $agentReached");
              await DSDatabase.instance.updateorderStatus(lastOrder, 'Reached');
              setState(() {
                agentArrived = true;
                reachedTimeVisibility = true;
                trackOrderVisibility = false;
              });
            }
          } on Exception catch (e) {
            print(e);
          }

          try {
            verifiedTime = orderStatusList['verified_time'];
            if (verifiedTime != '' && verifiedTime != null) {
              await DSDatabase.instance
                  .updateorderStatus(lastOrder, 'Verified');
              setState(() {
                orderVerified = true;
                verifiedTimeVisibility = true;
              });
            }
          } on Exception catch (e) {
            print(e);
          }

          try {
            deliveredTime = orderStatusList['delivered_time'];
            if (deliveredTime != '' && deliveredTime != null) {
              await DSDatabase.instance
                  .updateorderStatus(lastOrder, 'Delivered');
              setState(() {
                orderDelivered = true;
                deliveredTimeVisibility = true;
              });
            }
          } on Exception catch (e) {
            print(e);
          }

          try {
            completedTime = orderStatusList['completed_time'];
            if (completedTime != '' && completedTime != null) {
              await DSDatabase.instance
                  .updateorderStatus(lastOrder, 'Completed');
              setState(() {
                orderCompleted = true;
                completedTimeVisibility = true;
              });
            }
          } on Exception catch (e) {
            print(e);
          }

          if (driverDeviceId != '') {
            loadDriverData(driverDeviceId.trim());
          }

          int lastOrderId = await DSDatabase.instance.getLastOrderId();

          orderList.clear();
          orderList = await DSDatabase.instance.getOrderInfo(lastOrderId);

          String orderStatus = "";
          try {
            orderStatus = orderList.elementAt(0).order_status;
          } on Exception catch (e) {
            print(e);
          }

          // int trackNumber = 1;
          // if (orderStatus.equalsIgnoreCase("Accepted") ||
          //     orderStatus.equalsIgnoreCase("Pending")) {
          //   trackNumber = 2;
          // } else if (orderStatus.equalsIgnoreCase("Start") ||
          //     orderStatus.equalsIgnoreCase("Track Location")) {
          //   trackNumber = 3;
          // } else if (orderStatus.equalsIgnoreCase("Reached")) {
          //   trackNumber = 4;
          // } else if (orderStatus.equalsIgnoreCase("Verified")) {
          //   trackNumber = 5;
          // } else if (orderStatus.equalsIgnoreCase("Delivered")) {
          //   trackNumber = 6;
          // } else if (orderStatus.equalsIgnoreCase("Completed")) {
          //   trackNumber = 7;
          // }
        } else {
          setState(() {
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //loading driver data
  loadDriverData(String driverDeviceId) async {
    setState(() {
      loading = true;
    });
    int lastOrderId = await DSDatabase.instance.getLastOrderId();

    try {
      String requestResult, responseResult;
      var headers = {
        'DeviceID': deviceId,
        'Email': encryptEmail,
        'Mobile': encryptMobileNumber,
        'Password': encryptPassword,
        'Content-Type': 'application/json'
      };
      log("Header: $headers");
      var body = {'order_id': lastOrderId, 'device_id': driverDeviceId};
      final jsonbody = json.encode(body);
      log('Body: $jsonbody');
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
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.GET_DRIVER_DETAILS));
      request.body = '''{"request_encrypted":"$requestResult"}''';
      request.headers.addAll(headers);
      log('request: $request');

      StreamedResponse response = await request.send();
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String body = await response.stream.bytesToString();
        log('responseBody: $body');
        String responseBody = body.replaceAll('{"response_encrypted":"', '');
        responseBody = responseBody.replaceAll('"}', "");
        log('response: $responseBody');
        try {
          responseResult = await platform.invokeMethod(
              "ResponseDecrypt", <String, String>{
            'response': responseBody,
            'DeviceId': userEmail
          });
          log('Response:$responseResult');
        } on PlatformException catch (e) {
          // Unable to open the browser
          print(e);
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'];
        if (valueMap['status']) {
          setState(() {
            loading = false;
          });
          if (driverDeviceId != '' || driverDeviceId != null) {
            driverVisibility = true;
          } else {
            driverVisibility = false;
          }
          Map<String, dynamic> driverData = valueMap['data'];
          String driver_name = driverData['driver_name'];
          String mobile = driverData['mobile'];
          String driver_image = driverData['image'].toString().trim();
          String adhar = driverData['adhar'];
          String customer_code = driverData['customer_code'];
          double latitude = driverData['latitude'];
          double longitude = driverData['longitude'];

          String driver_rating = driverData['rating'];
          String total_delivery = driverData['total_delivery'];
          setState(() {
            if (driver_image == '' || driver_image == null) {
              driverImage == null;
            } else {
              driverImage = driver_image;
            }
            rating = double.tryParse(driver_rating);
            driverName = driver_name;
            totalDelivery = total_delivery;
          });
          // ratingBar.setRating(Float.parseFloat(rating));
        } else {
          setState(() {
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //load status
  loadData() async {
    //add Source
    // List<String> sources = new ArrayList<>();
    // sources.add(getString(R.string.order_placed) + "\n" + submited_time);
    // sources.add(getString(R.string.order_confirmed) + "\n" + confirm_time);
    // sources.add(getString(R.string.order_processed) + "\n" + agent_start);
    // sources.add(getString(R.string.agent_arrived) + "\n" + agent_reached);
    // sources.add(getString(R.string.order_verified) + "\n" + verified_time);
    // sources.add(getString(R.string.order_delivered) + "\n" + delivered_time);
    // sources.add(getString(R.string.order_completed) + "\n" + completed_time);

    int lastOrderId = await DSDatabase.instance.getLastOrderId();

    orderList.clear();
    orderList = await DSDatabase.instance.getOrderInfo(lastOrderId);

    String orderStatus = "";
    try {
      orderStatus = orderList.elementAt(0).order_status.trim();
    } on Exception catch (e) {
      print(e);
    }

    // int trackNumber = 1;
    // if (orderStatus.equalsIgnoreCase("Accepted") ||
    //     orderStatus.equalsIgnoreCase("Pending")) {
    //   trackNumber = 2;
    // } else if (orderStatus.equalsIgnoreCase("Start") ||
    //     orderStatus.equalsIgnoreCase("Track Location")) {
    //   trackNumber = 3;
    // } else if (orderStatus.equalsIgnoreCase("Reached")) {
    //   trackNumber = 4;
    // } else if (orderStatus.equalsIgnoreCase("Verified")) {
    //   trackNumber = 5;
    // } else if (orderStatus.equalsIgnoreCase("Delivered")) {
    //   trackNumber = 6;
    // } else if (orderStatus.equalsIgnoreCase("Completed")) {
    //   trackNumber = 7;
    // }
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

class DashedLineHorizontalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3, dashSpace = 4, startY = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
