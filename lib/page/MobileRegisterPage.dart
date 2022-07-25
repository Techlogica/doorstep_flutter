// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'OTPVerificationPage.dart';

class MobileRegisterPage extends StatefulWidget {
  const MobileRegisterPage({Key key}) : super(key: key);

  @override
  _MobileRegisterPageState createState() => _MobileRegisterPageState();
}

class _MobileRegisterPageState extends State<MobileRegisterPage> {
  final TextEditingController _mobileController = TextEditingController();
  String number, requestResult, responseResult;
  String deviceId;
  ScaffoldMessengerState scaffoldMessenger;
  bool hasConnection = false;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    initPlatformState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;

      setState(() => this.hasConnection = hasConnection);
    });
  }

  Future<void> initPlatformState() async {
    String udid;
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }

    if (!mounted) return;

    setState(() {
      deviceId = udid;
    });
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        backgroundColor: colors.off_white,
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  Positioned(
                    top: 20,
                    left: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: colors.primaryColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 100.0,
                                        width: 120.0,
                                        margin: new EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: colors.off_white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: const [
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
                                      ),
                                      ClipRRect(
                                        child: Image.asset(
                                            'assets/icons/atm_bharath_logo.png',
                                            height: 86,
                                            width: 70),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Text(
                                    S.of(context).registration,
                                    style: TextStyle(
                                        color: colors.primaryColor,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ])),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _mobileCard(),
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).alreadyYouHaveAnAccount,
                            style: TextStyle(
                                color: colors.primaryColor,
                                fontSize: 16,
                                fontFamily: 'Source Sans Pro'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _signInBtn(),
                    ],
                  )
                ]))));
  }

  //mobile card
  Widget _mobileCard(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.38,
      margin: new EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: colors.off_white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
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
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_android,
                color: colors.primaryColor,
              ),
              Text(
                S.of(context).enterYourMobileNumber,
                style: TextStyle(
                    color: colors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          _mobileField(),
          const SizedBox(
            height: 30,
          ),
          _otpBtn(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  //sign in button
  Widget _signInBtn(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 40,
          width: 140,
          decoration: BoxDecoration(
              color: colors.off_white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              S.of(context).signIn,
              style: TextStyle(
                  color: colors.colorPrimaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  //get otp button
  Widget _otpBtn(){
    return Container(
      height: 45,
      width: 180,
      decoration: BoxDecoration(
          color: colors.off_white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
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
        onPressed: () async {
          hasConnection =
          await InternetConnectionChecker()
              .hasConnection;
          FocusScope.of(context).unfocus();
          if (_mobileController.text.isEmpty) {
            _showSnackBar(context,
                S.of(context).invalidNumber);
          } else if (hasConnection) {
            getOTP(_mobileController.text);
          } else {
            _showSnackBar(
                context,
                S
                    .of(context)
                    .noNetworkConnection);
          }
        },
        child: Text(
          S.of(context).getOtp,
          style: TextStyle(
              color: colors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
    );
  }

  //mobile number text field
  Widget _mobileField(){
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      height: 50,
      width: cWidth,
      margin: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 5,
          bottom: 15),
      decoration: BoxDecoration(
          color: colors.off_white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
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
      child: TextField(
        onSubmitted: (val) {
          number = val;
        },
        controller: _mobileController,
        expands: false,
        maxLength: 13,
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ],
        style: TextStyle(
            fontSize: 18.0,
            color: colors.primaryColor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          prefixIcon: Icon(
            Icons.flag,
            color: colors.primaryColor,
          ),
          counterText: "",
          hintText: S.of(context).mobileNumber,
          hintStyle:
          const TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.white),
            borderRadius:
            BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.white),
            borderRadius:
            BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  //get Otp
  getOTP(String number) async {
    try {
      var body = {
        'mobile': number,
      };
      var headers = {'DeviceID': deviceId, 'Content-Type': 'application/json'};
      final jsonbody = json.encode(body);
      try {
        requestResult = await platform.invokeMethod(
            'RequestEncrypt', <String, String>{
          'request': jsonbody.toString(),
          'DeviceId': deviceId
        });
        log("request: $requestResult");
      } on PlatformException catch (e) {
        print(e);
      }
      var request = Request('POST', Uri.parse(Apis.BASE_URL + Apis.GET_OTP));
      request.body = '''{"request_encrypted":"$requestResult"}''';
      // String requestBody = request.body.toString();
      // log("requestBody: $requestBody");
      request.headers.addAll(headers);

      StreamedResponse response = await request.send();
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String body = await response.stream.bytesToString();
        String responseBody = body.replaceAll('{"response_encrypted":"', '');
        responseBody = responseBody.replaceAll('"}', "");
        try {
          responseResult = await platform.invokeMethod('ResponseDecrypt',
              <String, String>{'response': responseBody, 'DeviceId': deviceId});
          log('MobRegResponse:$responseResult');
        } on PlatformException catch (e) {
          // Unable to open the browser
          print(e);
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'].toString();
        if (valueMap['status']) {
        } else {
          _showSnackBar(context, message);
        }
      } else {
        _showSnackBar(context, S.of(context).noNetworkConnection);
      }
      PrefManager.saveKeyDeviceId(deviceId);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                  txtmobile: number, txtrequest: responseResult)));
    } on Exception catch (e) {
      print(e);
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
}
