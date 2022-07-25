// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //editText controller
  final TextEditingController _oldPasswordController =
      new TextEditingController();
  final TextEditingController _newPasswordController =
      new TextEditingController();
  final TextEditingController _confirmPasswordController =
      new TextEditingController();
  //
  String deviceId, oldPassword, newPassword, confirmPassword;
  //
  ScaffoldMessengerState scaffoldMessenger;
  //
  String userEmail = PrefManager.getEmail();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String encryptMobile = PrefManager.getEncryptedMobileNumber();
  //custom platform method
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  @override
  void initState() {
    super.initState();
    deviceId = PrefManager.getKeyDeviceId() ?? '';
    log('deviceId: $deviceId');
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: colors.off_white,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              _oldPassword(),
              _newPassword(),
              _confirmPassword(),
              _confirmButton(),
            ],
          ),
        ),
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
          S.of(context).changePassword,
          style: const TextStyle(
              color: colors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0),
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

  //old password text field
  Widget _oldPassword() {
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 50,
      width: cWidth,
      color: colors.white,
      child: TextField(
        onSubmitted: (value) {
          oldPassword = value;
        },
        controller: _oldPasswordController,
        expands: false,
        maxLength: 6,
        maxLines: 1,
        style: const TextStyle(fontSize: 18.0, color: colors.primaryColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12.0),
          suffixIcon: const Icon(
            Icons.remove_red_eye,
            color: colors.primaryColor,
          ),
          hintText: S.of(context).oldPassword,
          hintStyle: const TextStyle(color: colors.gray),
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  // new password text field
  Widget _newPassword() {
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 50,
      width: cWidth,
      color: colors.white,
      child: TextField(
        onSubmitted: (value) {
          newPassword = value;
        },
        controller: _newPasswordController,
        expands: false,
        maxLength: 10,
        maxLines: 1,
        style: const TextStyle(fontSize: 18.0, color: colors.primaryColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12.0),
          suffixIcon: const Icon(
            Icons.remove_red_eye,
            color: colors.primaryColor,
          ),
          hintText: S.of(context).newPassword,
          hintStyle: const TextStyle(color: colors.gray),
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  // confirm password field
  Widget _confirmPassword() {
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    return Container(
      height: 50,
      width: cWidth,
      color: colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        onSubmitted: (value) {
          confirmPassword = value;
        },
        controller: _confirmPasswordController,
        expands: false,
        maxLength: 6,
        maxLines: 1,
        style: const TextStyle(fontSize: 18.0, color: colors.primaryColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12.0),
          suffixIcon: const Icon(
            Icons.remove_red_eye,
            color: colors.primaryColor,
          ),
          hintText: S.of(context).confirmPassword,
          hintStyle: const TextStyle(color: colors.gray),
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  // confirm button
  Widget _confirmButton() {
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    return Container(
      height: 40,
      width: 160,
      margin: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
          color: colors.off_white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
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
      child: TextButton(
        onPressed: () {
          if (_oldPasswordController.text.isEmpty) {
            _showSnackBar(context, S.of(context).invalidOldPassword);
          } else if (_newPasswordController.text.isEmpty) {
            _showSnackBar(context, S.of(context).setNewpassword);
          } else if (_confirmPasswordController.text.isEmpty) {
            _showSnackBar(context, S.of(context).setConfirmPassword);
          } else if (_newPasswordController.text !=
              _confirmPasswordController.text) {
            _showSnackBar(context, S.of(context).checkPassword);
          } else {
            ChangePassword(
                _newPasswordController.text, _confirmPasswordController.text);
          }
        },
        child: Text(
          S.of(context).save,
          style: const TextStyle(
              color: colors.primaryColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // change password
  ChangePassword(newPassword, confirmPassword) async {
    String requestResult, responseResult;
    var body = {'new_password': '$newPassword'};
    var headers = {
      'DeviceId': deviceId,
      'Email': encryptEmail,
      'Mobile': encryptMobile,
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
      log('RegRequest:$requestResult');
    } on PlatformException catch (e) {
      // Unable to open the browser
      print(e);
    }
    var request =
        Request('POST', Uri.parse(Apis.BASE_URL + Apis.CHANGE_PASSWORD));
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
            <String, String>{'response': responseBody, 'DeviceId': userEmail});
        log('RegResponse:$responseResult');
      } on PlatformException catch (e) {
        // Unable to open the browser
        print(e);
      }
      Map<String, dynamic> valueMap = jsonDecode(responseResult);
      String message = valueMap['message'].toString();
      String data = valueMap['data'].toString();
      if (valueMap['status']) {
        PrefManager.savePassword(confirmPassword);
        _showSnackBar(context, data);
      } else {
        _showSnackBar(context, message);
      }
    } else {
      _showSnackBar(context, S.of(context).noNetworkConnection);
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
