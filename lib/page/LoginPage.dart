// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/Localization/language_constants.dart';
import 'package:doorstep_banking_flutter/Model/language/LanguageModel.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart';

import '../Model/language/LanguageModel.dart';
import '../main.dart';
import 'ForgotPasswordPage.dart';
import 'HomePage.dart';
import 'MobileRegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String mobile, password, token, tokenId;
  String deviceId, requestResult, responseResult, userDataResult;
  ScaffoldMessengerState scaffoldMessenger;
  bool hasConnection = false;
  TextEditingController OTPTextEditController = new TextEditingController();
  bool loading = false;

  //encryption and decryption custom platform channel-java
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  LatLng currentPosition;
  String otpCode;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // _getUserLocation();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;

      setState(() => this.hasConnection = hasConnection);
    });
  }

  //getting device id
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

  //changing language
  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
    PrefManager.saveSelectedLanguageKey(language.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    // double cHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: colors.off_white,
        body: Stack(alignment: Alignment.center, children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: [
                _languageIcon(),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _appIcon(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: _loginCard(),
                          ),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    _signUp(),
                    _forgotBtn(),
                  ],
                )
              ]),
            ),
          ),
          ClipRRect(
              child: Visibility(
                  visible: loading == true ? true : false,
                  child: loadingWidget(context))),
        ]));
  }

  //language button
  Widget _languageIcon() {
    return Positioned(
      top: 25,
      right: 10,
      child: DropdownButton<Language>(
        underline: const SizedBox(),
        icon: Image.asset(
          "assets/icons/ic_language.png",
          height: 35,
          width: 45,
        ),
        onChanged: (Language language) {
          _changeLanguage(language);
        },
        items: Language.languageList()
            .map<DropdownMenuItem<Language>>(
              (e) => DropdownMenuItem<Language>(value: e, child: Text(e.name)),
            )
            .toList(),
      ),
    );
  }

  //app icon and title
  Widget _appIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              //setting image over image
              Container(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: Container(
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
                            ],
                          ),
                          height: 110,
                          width: 135),
                    ),
                    ClipRRect(
                      child: Image.asset('assets/icons/atm_bharath_logo.png',
                          height: 86, width: 70),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //setting doorstep title
              Container(
                  child: Text(
                S.of(context).doorStepBanking,
                style: const TextStyle(
                  color: colors.primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 2.0,
                      color: colors.white,
                    ),
                    Shadow(
                      offset: Offset(-1.5, -1.5),
                      blurRadius: 2.0,
                      color: colors.white,
                    ),
                  ],
                ),
              ))
            ])),
      ],
    );
  }

  //login main card
  Widget _loginCard() {
    return Container(
      // height: 300,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 10),
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
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //login mobile textfield
          _mobileField(),
          const SizedBox(
            height: 10,
          ),
          //login password textfield
          _passwordField(),
          const SizedBox(
            height: 20,
          ),
          //login button
          _loginBtn(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  //sign up button
  Widget _signUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          S.of(context).dontHaveAnAccount,
          style: const TextStyle(
              color: colors.primaryColor,
              fontSize: 16,
              fontFamily: 'Source Sans Pro'),
        ),
        Container(
          height: 33,
          width: 70,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MobileRegisterPage())),
            child: const Text(
              'Sign up',
              style: TextStyle(color: colors.colorPrimaryDark),
            ),
          ),
        ),
      ],
    );
  }

  //forgot password button
  Widget _forgotBtn() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: cWidth,
          child: Center(
              child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage())),
                  child: Text(
                    S.of(context).forgotPassword,
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: colors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Source Sans Pro'),
                  ))),
        ),
      ],
    );
  }

  //mobile text field
  Widget _mobileField() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      height: 45,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      width: cWidth,
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
          mobile = val;
        },
        controller: _mobileController,
        expands: false,
        maxLength: 10,
        maxLines: 1,
        minLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 18.0, color: colors.primaryColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.phone_android,
                  color: colors.primaryColor,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "+91",
                  style: TextStyle(color: colors.primaryColor, fontSize: 18.0),
                )
              ],
            ),
          ),
          counterText: "",
          // prefixText: "+91",
          // prefixStyle: TextStyle(color: colors.primaryColor, fontSize: 18.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  //password text field
  Widget _passwordField() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      height: 45,
      width: cWidth,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
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
        controller: _passwordController,
        expands: false,
        maxLength: 6,
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 18.0, color: colors.primaryColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12.0),
          prefixIcon: const Icon(
            Icons.vpn_key,
            color: colors.primaryColor,
          ),
          counterText: "",
          hintText: S.of(context).password,
          hintStyle: const TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  //login button
  Widget _loginBtn() {
    return Container(
      height: 45,
      width: 160,
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
          hasConnection = await InternetConnectionChecker().hasConnection;
          FocusScope.of(context).unfocus();
          // Navigator.push(context, MaterialPageRoute(builder: (context)
          // => HomePage()));
          if (_mobileController.text.isEmpty) {
            _showSnackBar(context, S.of(context).invalidNumber);
          } else if (_passwordController.text.isEmpty) {
            _showSnackBar(context, S.of(context).invalidPassword);
          } else if (hasConnection) {
            // getLogin(mobile, password, token);
            String mobile = _mobileController.text.toString();
            String password = _passwordController.text.toString();
            log('mobile:$mobile, Password:$password');
            loading = true;
            getDeviceToken(_mobileController.text.toString(),
                _passwordController.text.toString());
          } else {
            _showSnackBar(context, S.of(context).noNetworkConnection);
          }
        },
        child: Text(
          S.of(context).signIn.toUpperCase(),
          style: const TextStyle(
              color: colors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
    );
  }

  // Login
  getLogin(number, password, token) async {
    var headers;
    var body;
    try {
      //retrofit body
      body = {'mobile': number, 'password': password, 'token': token};

      //converting body in to json format
      final jsonbody = json.encode(body);

      //request encryption
      if (io.Platform.isAndroid) {
        headers = {
          'DeviceID': deviceId,
          'Content-Type': 'application/json; charset=utf-8',
        };
        try {
          print(deviceId);
          requestResult = await platform.invokeMethod(
              'RequestEncrypt', <String, String>{
            'request': jsonbody.toString(),
            'DeviceId': deviceId
          });
          log("request: $requestResult");
        } on PlatformException catch (e) {
          print(e);
        }
      } else {
        headers = {
          'DeviceID': deviceId,
          'NOTENCR': '',
          'Content-Type': 'application/json; charset=utf-8',
        };
        requestResult = jsonbody;
      }

      //retrofit request
      var request = Request('POST', Uri.parse(Apis.BASE_URL + Apis.LOGIN_USER));
      request.body = '''{"request_encrypted":"$requestResult"}''';
      request.headers.addAll(headers);

      //retrofit response
      StreamedResponse response = await request.send();

      //retrofit response success
      if (response.statusCode == 200) {
        String body = await response.stream.bytesToString();
        String responseBody = body.replaceAll('{"response_encrypted":"', '');
        responseBody = responseBody.replaceAll('"}', "");
        if (io.Platform.isAndroid) {
          try {
            log("response: $responseBody");
            responseResult = await platform.invokeMethod(
                'ResponseDecrypt', <String, String>{
              'response': responseBody,
              'DeviceId': deviceId
            });
            log('loginResponse:$responseResult');
          } on PlatformException catch (e) {
            // Unable to open the browser
            print(e);
          }
        } else {
          responseResult = responseBody;
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'].toString();
        if (valueMap['status']) {
          setState(() {
            loading = false;
          });
          Map<String, dynamic> user = valueMap['data'];
          String username = user['user_name'].toString();
          String email = user['email'].toString();
          String mobile = user['mobile'].toString();
          String gender = user['gender'].toString();
          String image = user['image'].toString();
          _userDataEncrypt('email', email, deviceId);
          _userDataEncrypt('mobile', mobile, email);
          _userDataEncrypt('password', password, email);
          PrefManager.saveUsername(username);
          PrefManager.saveEmail(email);
          PrefManager.saveMobile(mobile);
          PrefManager.savePassword(password);
          PrefManager.saveProfile(image);
          PrefManager.saveGender(gender);
          PrefManager.saveToken(token);
          PrefManager.saveKeyDevice("1");
          PrefManager.saveLogin(true);
          PrefManager.saveKeyDeviceId(deviceId);
          PrefManager.saveLoginFlag(true);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          setState(() {
            loading = false;
          });
          _showSnackBar(context, message);
        }
      }

      //retrofit response failed
      else {
        loading = false;
        _showSnackBar(context, S.of(context).noNetworkConnection);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //showing snackbar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: colors.primaryColor,
      content: Text(message),
    );
    scaffoldMessenger.showSnackBar(snackBar);
  }

  //encrypting user details from login response
  _userDataEncrypt(String type, String request, String deviceId) async {
    try {
      userDataResult = await platform.invokeMethod('RequestEncrypt',
          <String, String>{'request': request, 'DeviceId': deviceId});
      log("request: $userDataResult");
      if (type == 'email') {
        PrefManager.saveEncryptedEmail(userDataResult);
        log("email: $userDataResult");
      } else if (type == 'mobile') {
        PrefManager.saveEncryptedMobileNumber(userDataResult);
        log("mobile: $userDataResult");
      } else if (type == 'password') {
        PrefManager.saveEncryptedPassword(userDataResult);
        log("password: $userDataResult");
      }
      return userDataResult;
    } on PlatformException catch (e) {
      // Unable to open the browser
      print(e);
    }
  }

  //getting device token
  getDeviceToken(String number, String password) async {
    try {
      await FirebaseMessaging.instance.getToken().then((value) {
        token = value;
      });
      log('Token:$token');
      getLogin(number, password, token);
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
