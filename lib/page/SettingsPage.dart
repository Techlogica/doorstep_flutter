// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/AppInfoPage.dart';
import 'package:doorstep_banking_flutter/page/ChangePasswordPage.dart';
import 'package:doorstep_banking_flutter/page/EditProfilePage.dart';
import 'package:doorstep_banking_flutter/page/LanguagePage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String profilePic;

  @override
  void initState() {
    super.initState();
    if (PrefManager.getProfile() == null || PrefManager.getProfile() == '') {
      profilePic = null;
    } else {
      profilePic = PrefManager.getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    // double c_width = MediaQuery.of(context).size.width * 0.8;
    // double c_height = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: colors.off_white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _editProfile(),
            _listItems(),
            Divider(
              height: 2,
              thickness: 2,
              color: colors.gray_dark,
            ),
            _invite(),
            _title(),
          ],
        ),
      ),
    );
  }

  //app bar
  Widget _appBar() {
    const double circleRadius = 100.0;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          S.of(context).settings.toUpperCase(),
          style: TextStyle(
              color: colors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.white,
          ),
        ),
      ),
    );
  }

  //edit profile details
  Widget _editProfile() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.off_white,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              },
              child: Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(left: 15.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: colors.primaryColor, width: 4),
                ),
                child: profilePic != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: Image.network(
                          profilePic,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: Image.asset(
                          'assets/icons/ic_profile.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),

                        /// replace your image with the Icon
                      ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(PrefManager.getUsername()),
                Text(PrefManager.getEmail()),
                Text(PrefManager.getMobile())
              ],
            ),
          ))
        ],
      ),
    );
  }

  //setting list items
  Widget _listItems() {
    return Container(
      decoration: BoxDecoration(
        color: colors.off_white,
      ),
      child: Column(
        children: [
          Container(
            height: 70,
            child: GestureDetector(
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.lock,
                        color: colors.gray_dark,
                      )),
                  Expanded(
                      flex: 4,
                      child: Text(S.of(context).changePassword,
                          style: TextStyle(
                              color: colors.gray_dark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordPage()));
              },
            ),
          ),
          Container(
            height: 70,
            child: GestureDetector(
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Image.asset(
                        "assets/icons/ic_language.png",
                        color: colors.gray_dark,
                        height: 20,
                        width: 20,
                      )),
                  Expanded(
                      flex: 4,
                      child: Text(S.of(context).changeLanguage,
                          style: TextStyle(
                              color: colors.gray_dark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LanguagePage()));
              },
            ),
          ),
          Container(
            height: 70,
            child: GestureDetector(
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.help_outline,
                        color: colors.gray_dark,
                      )),
                  Expanded(
                      flex: 4,
                      child: Text(S.of(context).helpLine,
                          style: TextStyle(
                              color: colors.gray_dark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              onTap: () {},
            ),
          ),
          Container(
            height: 70,
            child: GestureDetector(
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.info_outlined,
                        color: colors.gray_dark,
                      )),
                  Expanded(
                      flex: 4,
                      child: Text(S.of(context).appInfo,
                          style: TextStyle(
                              color: colors.gray_dark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppInfoPage()));
              },
            ),
          ),
        ],
      ),
    );
  }

  //invite a friend
  Widget _invite() {
    return Container(
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Icon(
                Icons.people_alt_outlined,
                color: colors.gray_dark,
              )),
          Expanded(
              flex: 4,
              child: Text(S.of(context).inviteAFriend,
                  style: TextStyle(
                      color: colors.gray_dark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  //organization name
  Widget _title() {
    return Container(
      height: 60,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).from,
                style: TextStyle(color: colors.gray_dark, fontSize: 18),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).atmBharath,
                style: TextStyle(
                    color: colors.gray_dark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
