// ignore_for_file: use_key_in_widget_constructors, file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables
// @dart=2.9

import 'dart:async';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/HomePage.dart';
import 'package:doorstep_banking_flutter/page/LoginPage.dart';
import 'package:doorstep_banking_flutter/page/MobileRegisterPage.dart';
import 'package:flutter/material.dart';

class LockerPage extends StatefulWidget {
  @override
  _LockerPageState createState() => _LockerPageState();
}

class _LockerPageState extends State<LockerPage> {
  String pinNumber = "";
  // List<String> pinList = [];
  final TextEditingController _pinEditingController = TextEditingController();
  ScaffoldMessengerState scaffoldMessenger;
  String profilePic = PrefManager.getProfile();
  String userName = PrefManager.getUsername();
  final _pinController = StreamController<String>.broadcast();

  @override
  void dispose() {
    _pinController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: colors.off_white,
      body: Stack(children: [
        Container(
            margin: EdgeInsets.only(top: 30),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 80.0,
                                      width: 100.0,
                                      margin: EdgeInsets.all(10),
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
                                          height: 76,
                                          width: 60),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Container(
                                child: Text(
                                  S.of(context).doorStepBanking,
                                  style: TextStyle(
                                      color: colors.primaryColor,
                                      fontSize: 18.0,
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
                          _lockerCard(),
                        ]),
                    _signUpBtn(),
                  ]),
            )),
        _backBtn(),
      ]),
    );
  }

  //back button
  Widget _backBtn() {
    return Positioned(
      top: 15,
      left: 5,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: colors.primaryColor,
        ),
        onPressed: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage())),
      ),
    );
  }

  //sign up button
  Widget _signUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          S.of(context).dontHaveAnAccount,
          style: TextStyle(
              color: colors.primaryColor,
              fontSize: 16,
              fontFamily: 'Source Sans Pro'),
        ),
        TextButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => MobileRegisterPage())),
          child: Text(
            'Sign up',
            style: TextStyle(
                color: colors.colorPrimaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ),
      ],
    );
  }

  //locker card
  Widget _lockerCard() {
    return Container(
      height: 425,
      margin: const EdgeInsets.all(10),
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
            height: 15,
          ),
          _profile(),
          const SizedBox(
            height: 10,
          ),
          _loginPin(),
          _numberPad(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  //profile image and username
  Widget _profile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: colors.primaryColor, width: 2),
            ),
            child: profilePic != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      profilePic,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/icons/ic_profile.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),

          // replace your image with the Icon
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          userName != null || userName != '' ? userName : "UserName",
          style: TextStyle(color: colors.primaryColor, fontSize: 16.0),
        )
      ],
    );
  }

  //login pin
  Widget _loginPin() {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
        height: 40,
        width: cWidth,
        margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
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
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 1,
                child: StreamBuilder(
                  initialData: S.of(context).enterYourPin,
                  stream: _pinController.stream,
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data,
                      style: TextStyle(color: colors.gray),
                    );
                  },
                )),
            Expanded(
                flex: 0,
                child: Icon(
                  Icons.vpn_key,
                  color: colors.primaryColor,
                )),
            SizedBox(
              width: 10,
            )
          ],
        ));
  }

  //number pad
  Widget _numberPad() {
    return Container(
      height: 280,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '1';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
                      // pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "1",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '2';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
                      // pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "2",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '3';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
                      // pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "3",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ]),
          Row(children: [
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '4';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
// pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "4",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '5';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
// pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "5",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '6';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
// pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "6",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ]),
          Row(children: [
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '7';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
// pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "7",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '8';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
// pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "8",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '9';
                    // _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
// pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "9",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ]),
          Row(children: [
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: IconButton(
                onPressed: () {
                  if (pinNumber != null && pinNumber.isNotEmpty) {
                    pinNumber =
                        pinNumber.substring(0, pinNumber.length - 1).trim();
                  }
                  // _pinEditingController.text = pinNumber;
                  if (pinNumber.length <= 4) {
// pinList.add(pinNumber);
                    _pinController.sink.add(pinNumber);
                  }
                },
                icon: Icon(
                  Icons.backspace,
                  color: colors.black,
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/ic_base_roundbutton.png')),
                // border:
                //     Border.all(color: colors.white, width: 4),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pinNumber = pinNumber + '0';
                    _pinEditingController.text = pinNumber;
                    if (pinNumber.length <= 4) {
// pinList.add(pinNumber);
                      _pinController.sink.add(pinNumber);
                    }
                  });
                },
                child: Text(
                  "0",
                  style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
                width: 50,
                height: 50,
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/icons/ic_base_roundbutton.png')),
                  // border:
                  //     Border.all(color: colors.white, width: 4),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: colors.black,
                  ),
                  onPressed: () {
                    String loginpin = pinNumber.trim();

                    if (loginpin.isEmpty || loginpin == "") {
                      _showSnackBar(context, S.of(context).invalidPin);
                    } else {
                      String password = PrefManager.getPassword();
                      if (password == loginpin) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      } else {
                        _showSnackBar(context, S.of(context).invalidPin);
                      }
                    }
                  },
                )),
          ]),
        ],
      ),
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
}
