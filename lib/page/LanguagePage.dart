// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables
// @dart=2.9

import 'dart:developer';

import 'package:doorstep_banking_flutter/Localization/language_constants.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String btnText = "";
  String _radioValue = ''; //Initial definition of radio button value
  String choice = '';

  //changing language
  void _changeLanguage(String language) async {
    Locale _locale = await setLocale(language);
    MyApp.setLocale(context, _locale);
  }

  //radio button changes value
  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      _changeLanguage(_radioValue);
      log('radio:$_radioValue');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.off_white,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(S.of(context).chooseYourPreferredLanguage,
                style: TextStyle(color: colors.gray_dark, fontSize: 18),
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.ellipsis),
            SizedBox(
              height: 20,
            ),
            _radioBtnCard(),
            _continueBtn(),
          ]),
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
          S.of(context).changeLanguage,
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  //radio button card
  Widget _radioBtnCard() {
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    return Container(
      margin: EdgeInsets.all(15),
      height: 300,
      width: cWidth,
      decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: Colors.white24,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1.0,
            ),
          ]),
      child: Theme(
        data: Theme.of(context).copyWith(
            unselectedWidgetColor: colors.primaryColor,
            disabledColor: Colors.blue),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20.0,
            ),
            _english(),
            _hindi(),
            _malayalam(),
            _marathi(),
            _tamil(),
          ],
        ),
      ),
    );
  }

  //radio button english
  Widget _english() {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: colors.primaryColor,
          value: 'en',
          groupValue: _radioValue,
          onChanged: radioButtonChanges,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          "English",
          style: TextStyle(
              color: colors.primaryColor,
              fontSize: 18.0,
              fontFamily: 'Source Sans Pro'),
        ),
      ],
    );
  }

  //radio button hindi
  Widget _hindi() {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: colors.primaryColor,
          value: 'hi',
          groupValue: _radioValue,
          onChanged: radioButtonChanges,
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          "हिंदी",
          style: TextStyle(
              color: colors.primaryColor,
              fontSize: 18.0,
              fontFamily: 'Source Sans Pro'),
        ),
      ],
    );
  }

  //radio button malayalam
  Widget _malayalam() {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: colors.primaryColor,
          value: 'ml',
          groupValue: _radioValue,
          onChanged: radioButtonChanges,
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          "മലയാളം",
          style: TextStyle(
              color: colors.primaryColor,
              fontSize: 18.0,
              fontFamily: 'Source Sans Pro'),
        ),
      ],
    );
  }

  //radio button malayalam
  Widget _marathi() {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: colors.primaryColor,
          value: 'mr',
          groupValue: _radioValue,
          onChanged: radioButtonChanges,
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          "मराठी",
          style: TextStyle(
              color: colors.primaryColor,
              fontSize: 18.0,
              fontFamily: 'Source Sans Pro'),
        ),
      ],
    );
  }

  //radio button tamil
  Widget _tamil() {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: colors.primaryColor,
          value: 'ta',
          groupValue: _radioValue,
          onChanged: radioButtonChanges,
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          "தமிழ்",
          style: TextStyle(
              color: colors.primaryColor,
              fontSize: 18.0,
              fontFamily: 'Source Sans Pro'),
        ),
      ],
    );
  }

  Widget _continueBtn() {
    double cWidth = MediaQuery.of(context).size.width * 0.9;
    return Container(
      height: 50,
      width: cWidth,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: colors.white,
        border: Border.all(color: colors.primaryColor, width: 3),
      ),
      child: TextButton(
        onPressed: () => Navigator.pop(context),
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
}
