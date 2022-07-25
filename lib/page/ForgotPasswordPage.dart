// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, missing_return, avoid_print
import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/SecurityOTPPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //
  final TextEditingController _mobileController = new TextEditingController();
  //
  String number, requestResult, responseResult;
  String deviceId = PrefManager.getKeyDeviceId();
  //
  ScaffoldMessengerState scaffoldMessenger;
  //
  bool hasConnection = false;
  //
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;

      setState(() => this.hasConnection = hasConnection);
    });
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    double cHeight = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
        backgroundColor: colors.off_white,
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    S.of(context).findYourAccount,
                    style: TextStyle(
                        color: colors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: cHeight,
                      margin: new EdgeInsets.all(10),
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
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          _title(),
                          SizedBox(
                            height: 10,
                          ),
                          _textField(),
                          SizedBox(
                            height: 10,
                          ),
                          _button(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ));
  }

  //app bar
  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: colors.primaryColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  //title
  Widget _title() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: cWidth,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Text(
              S.of(context).pleaseEnterYourMobileNumberToSearchForYourAccount,
              style: TextStyle(
                  color: colors.primaryColor,
                  fontSize: 16,
                  fontFamily: 'Source Sans Pro'),
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  //textField
  Widget _textField() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      height: 50,
      width: cWidth,
      margin: new EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
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
      child: TextField(
        controller: _mobileController,
        onSubmitted: (val) {
          number = val;
        },
        expands: false,
        maxLength: 10,
        maxLines: 1,
        style: TextStyle(fontSize: 18.0, color: colors.primaryColor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          prefixIcon: Icon(
            Icons.phone_android,
            color: colors.primaryColor,
          ),
          prefixText: "+91",
          prefixStyle: TextStyle(color: colors.primaryColor, fontSize: 18.0),
          hintText: S.of(context).mobileNumber,
          hintStyle: TextStyle(color: Colors.grey),
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  //button
  Widget _button() {
    return Container(
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
        onPressed: () async {
          hasConnection = await InternetConnectionChecker().hasConnection;
          FocusScope.of(context).unfocus();
          if (_mobileController.text.isEmpty) {
            _showSnackBar(context, S.of(context).invalidNumber);
          } else if (hasConnection) {
            getOTP(number);
          } else {
            _showSnackBar(context, S.of(context).noNetworkConnection);
          }
        },
        child: Text(
          S.of(context).mcontinue,
          style: TextStyle(
              color: colors.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //get OTP
  getOTP(String number) async {
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
            builder: (context) => SecurityOTPPage(
                txtmobile: number, txtrequest: request.toString())));
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
