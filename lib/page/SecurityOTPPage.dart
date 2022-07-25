// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, must_be_immutable, no_logic_in_create_state, unnecessary_string_interpolations, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'ResetPassword.dart';

class SecurityOTPPage extends StatefulWidget {
  String txtmobile, txtrequest;
  SecurityOTPPage({Key key, this.txtmobile, this.txtrequest}) : super(key: key);
  @override
  _SecurityOTPPageState createState() =>
      _SecurityOTPPageState(txtmobile, txtrequest);
}

class _SecurityOTPPageState extends State<SecurityOTPPage>
    with CodeAutoFill, TickerProviderStateMixin {
  _SecurityOTPPageState(this.number, this.request);
  final TextEditingController _otp1Controller = new TextEditingController();
  final TextEditingController _otp2Controller = new TextEditingController();
  final TextEditingController _otp3Controller = new TextEditingController();
  final TextEditingController _otp4Controller = new TextEditingController();
  String number, request, otp1 = "", otp2 = "", otp3 = "", otp4 = "";
  String deviceId = PrefManager.getKeyDeviceId();
  ScaffoldMessengerState scaffoldMessenger;
  String otpCode;
  String appSignature;
  bool hasConnection = false;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  int levelClock = 20;
  String timerText = '';
  bool visibility = false;
  final _timerController = StreamController<bool>.broadcast();
  AnimationController _controller;
  bool isPlaying = false;

  //counter count text
  String get countText {
    Duration count = _controller.duration * _controller.value;
    return _controller.isDismissed
        ? '${(_controller.duration.inMinutes % 60).toString()}:${(_controller.duration.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inMinutes % 60).toString()}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    visibility = false;
    _timerController.sink.add(visibility);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );
    _controller.reverse(from: _controller.value == 0 ? 1.0 : _controller.value);
    setState(() {
      isPlaying = true;
    });
    _controller.addListener(() {
      if (_controller.isAnimating) {
        setState(() {
          visibility = false;
          _timerController.sink.add(visibility);
        });
      } else {
        setState(() {
          visibility = true;
          isPlaying = false;
          _timerController.sink.add(visibility);
        });
      }
    });
    //checking internet connection available or not
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;

      setState(() => this.hasConnection = hasConnection);
    });
    //sms auo fetch listener
    listenForCode();
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  //cancelling the sms auto fetch listener
  @override
  void dispose() {
    super.dispose();
    cancel();
    _controller.dispose();
    _timerController.close();
  }

  //setting the read otp to a string
  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
      if (otpCode != null) {
        List<String> splited = otpCode.split('');
        final splitMap = splited.asMap();
        otp1 = splitMap[0].toString();
        otp2 = splitMap[1].toString();
        otp3 = splitMap[2].toString();
        otp4 = splitMap[3].toString();
      }
      log('$otpCode');
    });
  }

  //otp countdown timer
  CountdownTimer() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                60) // gameData.levelClock is a user entered number elsewhere in the applciation
        );
    // _controller.reverse(from: _controller.value == 0 ? 1.0 : _controller.value);
    // setState(() {
    //   isPlaying = true;
    // });
    _controller.addListener(() {
      if (_controller.isAnimating) {
        setState(() {
          visibility = false;
          isPlaying = false;
          _timerController.sink.add(visibility);
        });
      } else {
        _controller.reverse(
            from: _controller.value == 0 ? 1.0 : _controller.value);
        setState(() {
          visibility = true;
          isPlaying = true;
          _timerController.sink.add(visibility);
        });
      }
    });

    // _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        backgroundColor: colors.off_white,
        appBar: _appBar(),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).enterTheSecurityCode,
                  style: TextStyle(
                      color: colors.primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _otpCard(),
            SizedBox(
              height: 30,
            ),
            _resendOtpBtn(),
          ],
        )));
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

  //otp card
  Widget _otpCard() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    double cHeight = MediaQuery.of(context).size.width * 0.7;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: cWidth,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(
                      S
                          .of(context)
                          .checkYourPhoneForATextMessageWithYourCodeYourCodeIs4Length,
                      style: TextStyle(
                          color: colors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 15.0),
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  S.of(context).weSentYourCodeTo,
                  style: TextStyle(
                      color: colors.primaryColor,
                      fontSize: 16.0,
                      fontFamily: 'Source Sans Pro'),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  number,
                  style:
                      TextStyle(color: colors.colorPrimaryDark, fontSize: 20.0),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_alarm,
                  color: colors.primaryColor,
                ),
                AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Text(
                          countText,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: colors.primaryColor,
                          ),
                        ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 60,
                alignment: Alignment.center,
                margin: new EdgeInsets.only(
                    left: 15, right: 10, top: 5, bottom: 10),
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
                child: Text(
                  otp1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: colors.primaryColor),
                ),
              ),
              Container(
                height: 50,
                width: 60,
                alignment: Alignment.center,
                margin: new EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 10),
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
                child: Text(
                  otp2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: colors.primaryColor),
                ),
              ),
              Container(
                height: 50,
                width: 60,
                alignment: Alignment.center,
                margin: new EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 10),
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
                child: Text(
                  otp3,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: colors.primaryColor),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 60,
                margin: new EdgeInsets.only(
                    left: 10, right: 15, top: 5, bottom: 10),
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
                child: Text(
                  otp4,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: colors.primaryColor),
                ),
              ),
            ]),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              width: 180,
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
                  hasConnection =
                      await InternetConnectionChecker().hasConnection;
                  if (otpCode.isEmpty || otpCode.length != 4) {
                    _showSnackBar(context, S.of(context).invalidOtp);
                  } else if (hasConnection) {
                    getOTPVerification(number);
                  } else {
                    _showSnackBar(context, S.of(context).noNetworkConnection);
                  }
                },
                child: Text(
                  S.of(context).mcontinue,
                  style: TextStyle(
                      color: colors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ]);
  }

  //resend otp button
  Widget _resendOtpBtn() {
    return StreamBuilder(
        stream: _timerController.stream,
        builder: (context, snapshot) {
          return Visibility(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    S.of(context).didntGetOtp,
                    style: TextStyle(
                        color: colors.primaryColor,
                        fontSize: 16,
                        fontFamily: 'Source Sans Pro'),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    height: 37,
                    width: 130,
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
                        _controller.reset();
                        CountdownTimer();
                        hasConnection =
                            await InternetConnectionChecker().hasConnection;
                        if (hasConnection) {
                          getOTP();
                        } else {
                          _showSnackBar(
                              context, S.of(context).noNetworkConnection);
                        }
                      },
                      child: Text(
                        S.of(context).resendOtp,
                        style: TextStyle(
                            color: colors.colorPrimaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            visible: visibility,
          );
        });
  }

  // resend otp
  getOTP() async {
    String responseResult;
    var headers = {'DeviceID': deviceId, 'Content-Type': 'application/json'};
    var request = Request('POST', Uri.parse(Apis.BASE_URL + Apis.GET_OTP));
    request.body = '''{"request_encrypted":"$request"}''';
    // String requestBody = request.body.toString();
    // // log("requestBody: $requestBody");
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
        log('OTPResponse:$responseResult');
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
      _showSnackBar(context, "message");
    }
  }

  // otp verification
  getOTPVerification(String number) async {
    String requestResult, responseResult;
    var body = {'mobile': number, 'otp': otpCode};
    var jsonbody = json.encode(body);
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
    var headers = {'DeviceID': deviceId, 'Content-Type': 'application/json'};
    var request =
        Request('POST', Uri.parse(Apis.BASE_URL + Apis.OTP_VERIFICATION));
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
            <String, String>{'response': responseBody, 'DeviceId': deviceId});
        log('OTPVerResponse:$responseResult');
      } on PlatformException catch (e) {
        // Unable to open the browser
        print(e);
      }
      Map<String, dynamic> valueMap = jsonDecode(responseResult);
      String message = valueMap['message'].toString();
      if (valueMap['status']) {
        _showSnackBar(context, message);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPasswordPage(txtmobile: number)));
      } else {
        _showSnackBar(context, message);
      }
    } else {
      _showSnackBar(context, "message");
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
