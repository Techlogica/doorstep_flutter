// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, must_be_immutable, no_logic_in_create_state, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

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
import 'package:lottie/lottie.dart';

class ResetPasswordPage extends StatefulWidget {
  String txtmobile;
  ResetPasswordPage({Key key, this.txtmobile}) : super(key: key);
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState(txtmobile);
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  _ResetPasswordPageState(this.number);
  final TextEditingController _newpwdController = new TextEditingController();
  final TextEditingController _confirmpwdController =
      new TextEditingController();
  String newpwd, confirmpwd, number;
  String deviceId = PrefManager.getKeyDeviceId();
  ScaffoldMessengerState scaffoldMessenger;
  bool hasConnection = false;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    //checking internet connection available or not
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;

      setState(() => this.hasConnection = hasConnection);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.off_white,
        appBar: _appBar(),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).resetPassword,
                  style: TextStyle(
                      color: colors.primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _resetPasswordCard(),
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

  //reset password card
  Widget _resetPasswordCard() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    double cHeight = MediaQuery.of(context).size.width * 0.7;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
        // height: cHeight,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: cWidth,
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    S.of(context).createANewPassword,
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(color: colors.primaryColor, fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            _newPasswordField(),
            SizedBox(
              height: 5,
            ),
            _confirmPasswordField(),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 15,
            ),
            _continueBtn(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ]);
  }

  // new password text field
  Widget _newPasswordField() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: cWidth,
          margin: new EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
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
            controller: _newpwdController,
            onSubmitted: (val) {
              newpwd = val;
            },
            expands: false,
            maxLength: 6,
            maxLines: 1,
            style: TextStyle(fontSize: 20.0, color: colors.primaryColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12.0),
              suffixIcon: Icon(
                Icons.remove_red_eye_rounded,
                color: colors.primaryColor,
              ),
              counterText: "",
              hintText: S.of(context).newPassword,
              hintStyle: TextStyle(color: Colors.grey),
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
        ),
      ],
    );
  }

  //confirm password text field
  Widget _confirmPasswordField() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: cWidth,
          margin: new EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
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
            controller: _confirmpwdController,
            onSubmitted: (val) {
              confirmpwd = val;
            },
            expands: false,
            maxLength: 6,
            maxLines: 1,
            style: TextStyle(fontSize: 20.0, color: colors.primaryColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12.0),
              suffixIcon: Icon(
                Icons.remove_red_eye_rounded,
                color: colors.primaryColor,
              ),
              counterText: "",
              hintText: S.of(context).confirmPassword,
              hintStyle: TextStyle(color: Colors.grey),
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
        ),
      ],
    );
  }

  //continue button
  Widget _continueBtn() {
    return Container(
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
          // showDialog();
          hasConnection = await InternetConnectionChecker().hasConnection;
          if (_newpwdController.text.isEmpty) {
            _showSnackBar(context, S.of(context).newPassword);
          } else if (_confirmpwdController.text.isEmpty) {
            _showSnackBar(context, S.of(context).setConfirmPassword);
          } else if (_newpwdController.text == _confirmpwdController.text) {
            _showSnackBar(context, S.of(context).checkPassword);
          } else if (hasConnection) {
            getForgotPassword(_confirmpwdController.text);
          } else {
            _showSnackBar(context, S.of(context).newPassword);
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
    );
  }

// forgot password
  getForgotPassword(confirmPassword) async {
    String requestResult, responseResult;
    var body = {'mobile': number, 'new_password': confirmPassword};
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
    var request =
        Request('POST', Uri.parse(Apis.BASE_URL + Apis.REGISTER_USER));
    request.body = '''{"request_encrypted":"$requestResult"}''';
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    int statusCode = response.statusCode;
    // final resbody = json.decode(response.b);
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
        //alertdialog box
        // showDialog();
        showAlertDialog(context);
      } else {
        _showSnackBar(context, message);
      }
    } else {
      _showSnackBar(context, S.of(context).noNetworkConnection);
    }
  }

  //password reset alert
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = Container(
      height: 40,
      child: TextButton(
        child: Text(
          S.of(context).ok,
          style: TextStyle(color: colors.white),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: colors.primaryColor,
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Center(
          child: Lottie.asset(
        'assets/animations/password_reset.json',
        height: 150,
        width: 150,
      )),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              S.of(context).passwordUpdated,
              style: TextStyle(
                  color: colors.green,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              S
                  .of(context)
                  .yourPasswordHasBeenChangedSuccessfullyUseYourNewPasswordToLogin,
              style: TextStyle(
                  color: colors.gray_dark,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ]),
      actions: [
        Center(
          child: cancelButton,
        ),
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

  //snackbar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
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
