// ignore_for_file: file_names, use_key_in_widget_constructors, sized_box_for_whitespace, import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'ManageAddressPage.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPage createState() => _AddAddressPage();
}

class _AddAddressPage extends State<AddAddressPage> {
  @override
  void initState() {
    super.initState();
    //animation timer
    Timer(
        const Duration(milliseconds: 1010),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ManageAddressPage(
                      btnVisibility: false,
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.off_white,
      body: Container(
        alignment: Alignment.center,
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_animation(), _titleText(), _text()],
        )),
      ),
    );
  }

  //lottie animation
  Widget _animation() {
    return Lottie.asset(
      'assets/animations/add_location.json',
      height: 250,
      width: 250,
    );
  }

  //title text
  Widget _titleText() {
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: cWidth,
          child: Center(
            child: Text(
              S.of(context).knockKnockWhosThere,
              style: const TextStyle(
                  color: colors.gray_dark,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Source Sans Pro',
                  fontSize: 20.0),
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  //sub text
  Widget _text() {
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: cWidth,
          child: Center(
            child: Text(
              S
                  .of(context)
                  .youDontHaveAnyAddressesSavedSavingAddressHelpsYouCheckoutFaster,
              style: const TextStyle(
                  color: colors.gray_dark,
                  fontFamily: 'Source Sans Pro',
                  fontSize: 16.0),
              maxLines: 2,
              softWrap: false,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
