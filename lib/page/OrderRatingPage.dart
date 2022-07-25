// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, no_logic_in_create_state, must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';

class OrderRatingPage extends StatefulWidget {
  String orderId, orderCode;
  OrderRatingPage({Key key, this.orderId, this.orderCode}) : super(key: key);

  @override
  _OrderRatingPageState createState() =>
      _OrderRatingPageState(orderId, orderCode);
}

class _OrderRatingPageState extends State<OrderRatingPage> {
  _OrderRatingPageState(this.orderId, this.orderCode);

  final TextEditingController _reviewController = TextEditingController();
  String review;
  ScaffoldMessengerState scaffoldMessenger;
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptMobileNumber = PrefManager.getEncryptedMobileNumber();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String userEmail = PrefManager.getEmail();
  String orderId, orderCode;
  double rating = 0.0;
  bool loading = false;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: colors.off_white,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/icons/img_delivery_man_review.png",
                    height: 250,
                    width: 250,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).rateYourDeliveryAgent,
                        style: TextStyle(color: colors.black, fontSize: 18.0),
                      )
                    ],
                  ),
                  Container(
                    height: 5,
                    width: 100,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: colors.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        orderCode,
                        style: TextStyle(
                            color: colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ],
                  ),
                  _rating(),
                  SizedBox(
                    height: 15,
                  ),
                  _reviewField(),
                  SizedBox(
                    height: 15,
                  ),
                  _rateOrderBtn(),
                ],
              ),
            ),
          ),
          Visibility(
            child: loadingWidget(context),
            visible: loading,
          )
        ],
      ),
    );
  }

  //app bar
  Widget _appBar() {
    const double circleRadius = 50.0;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          S.of(context).rateOrder.toUpperCase(),
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

  //rating bar
  Widget _rating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingBar.builder(
          minRating: 0,
          maxRating: 5,
          itemSize: 40,
          unratedColor: colors.gray,
          initialRating: 0,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: colors.primaryColor,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              this.rating = rating;
            });
          },
        ),
      ],
    );
  }

  // review text field
  Widget _reviewField() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      height: 50,
      width: cWidth,
      decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: colors.gray)),
      child: TextField(
        controller: _reviewController,
        onSubmitted: (value) {
          review = value;
        },
        expands: false,
        style: TextStyle(fontSize: 18.0, color: colors.gray_dark),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          // suffixIcon: Icon(
          //   Icons.remove_red_eye,
          //   color: values.primaryColor,
          // ),
          hintText: S.of(context).review,
          hintStyle: TextStyle(color: colors.gray),
          counterText: "",
          focusColor: colors.primaryColor,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  //rate order button
  Widget _rateOrderBtn() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      height: 50,
      width: cWidth,
      decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: colors.primaryColor, width: 4)),
      child: TextButton(
          onPressed: () {
            String review = _reviewController.text;

            if (rating.toString() == '' || rating.toString == '0.0') {
              _showSnackBar(context, "Please enter the rating");
            } else {
              log("rating=" + rating.toString());
              setState(() {
                loading = true;
              });
              getRating(rating.toString(), review, orderId);
            }
          },
          child: Text(
            S.of(context).rateOrder,
            style: TextStyle(
                color: colors.primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          )),
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

  // give agent rating and review
  getRating(String rating, String review, String orderId) async {
    String requestResult, responseResult;
    try {
      var body = {'rating': rating, 'review': review, 'order_id': orderId};
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
      var request =
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.CUSTOMER_REVIEW));
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
          print(e);
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'].toString();
        if (valueMap['status']) {
          setState(() {
            loading = false;
          });
          //database function
          await DSDatabase.instance
              .updateorderStatus(int.tryParse(orderId), "Completed");

          await DSDatabase.instance.updateorderRatingAndReview(
              int.tryParse(orderId), rating, review);
          Navigator.pop(context);
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
