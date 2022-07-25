// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, prefer_const_constructors, no_logic_in_create_state, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckOutPage extends StatefulWidget {
  String orderNumber;
  String orderOTP;

  CheckOutPage({Key key, this.orderNumber, this.orderOTP}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState(orderNumber, orderOTP);
}

class _CheckOutPageState extends State<CheckOutPage> {
  _CheckOutPageState(this.orderNo, this.orderOtp);

  String orderNo;
  String orderOtp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: colors.off_white,
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _title(),
                        _qrCode(),
                        _text(),
                        _subText(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          S.of(context).checkout,
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
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  //title
  Widget _title() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: cWidth,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Center(
            child: Text(
              S
                  .of(context)
                  .pleaseProviderThisQrCodeToOurAgentToCompleteYourOrder,
              style: TextStyle(color: colors.gray_dark, fontSize: 18.0),
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  //qr code card
  Widget _qrCode() {
    return Container(
      margin: new EdgeInsets.all(15),
      height: 300,
      width: 300,
      decoration: BoxDecoration(
          color: colors.off_white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(4, 4),
              // blurRadius: 15,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              // blurRadius: 15,
              // spreadRadius: 1.0,
            ),
          ]),
      child: Center(
        child: QrImage(
          //plce where the QR Image will be shown
          data: orderOtp,
          size: 200,
        ),
      ),
    );
  }

  //text
  Widget _text() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(S.of(context).otp + orderOtp)],
    );
  }

  //subtext
  Widget _subText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(S.of(context).orderNumber + orderNo)],
    );
  }
}
