// ignore_for_file: file_names, avoid_unnecessary_containers, import_of_legacy_library_into_null_safe, prefer_const_constructors

import 'dart:async';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/page/LockerPage.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (PrefManager.getisLoggedIn() == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LockerPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.off_white,
        body: Container(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
              flex: 6,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: colors.off_white,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          child: Image.asset('assets/icons/logo_rectangle.png',
                              height: 200, width: 200),
                        ),
                        ClipRRect(
                          child: Image.asset(
                              'assets/icons/atm_bharath_logo.png',
                              height: 106,
                              width: 90),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Image.asset('assets/icons/doorstepbanking_title.png',
                        height: 25, width: 220),
                  ),
                ],
              )),

          // const SizedBox(
          //   height: 100,
          // ),
          const Expanded(
            flex: 0,
            child: Text(
              "Version",
              style: TextStyle(fontSize: 14, fontFamily: 'Source Sans Pro'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ])));
  }
}
