// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/database/Database.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/AddAddressPage.dart';
import 'package:doorstep_banking_flutter/page/EditProfilePage.dart';
import 'package:doorstep_banking_flutter/page/OrderPage.dart';
import 'package:doorstep_banking_flutter/page/SelectAddressPage.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'LoginPage.dart';
import 'SettingsPage.dart';
import 'WishlistPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profilePic;
  int addressCount;
  String userName = PrefManager.getUsername();
  ScaffoldMessengerState scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    if (PrefManager.getProfile() == null || PrefManager.getProfile() == '') {
      profilePic = null;
    } else {
      profilePic = PrefManager.getProfile();
    }
  }

  //getting address table count
  getAddressCount() async {
    addressCount = await DSDatabase.instance.countAddress();
    if (addressCount != 0) {
    } else {
      addressCount = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        backgroundColor: colors.off_white,
        body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
          SizedBox(
            height: 40,
          ),
          _profileCard(),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _address(),
              _order(),
              _complaintReport(),
              _settings(),
              _logout(),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  S.of(context).doorStepBanking,
                  style: TextStyle(
                      color: colors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              )
            ],
          ),
        ])));
  }

  //profile image and name
  Widget _profileCard(){
    const Color background = colors.primaryColor;
    final Color fill = colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 45.00; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    double c_width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      height: 250,
      child: Stack(children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 230,
          width: c_width,
          margin: new EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              color: colors.primaryColor,
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                colors: gradient,
                stops: stops,
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(4, 4),
                  blurRadius: 10,
                  spreadRadius: 1.0,
                ),
                BoxShadow(
                  color: Colors.white24,
                  offset: Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1.0,
                ),
              ]),
          child: Row(children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: colors.white, width: 2),
              ),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border:
                  Border.all(color: colors.primaryColor, width: 3),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()));
                  },
                  child: profilePic != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.network(
                      profilePic,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.asset(
                      'assets/icons/ic_profile.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              userName,
              style: TextStyle(
                  color: colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            )
          ]),
        ),
        _buttons(),
      ]),
    );
  }

  //home and favourites
  Widget _buttons(){
    double c_width = MediaQuery.of(context).size.width * 0.9;
    return Positioned(
      bottom: 0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        width: c_width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.off_white,
                  border: Border.all(color: colors.white, width: 5),
                ),
                child: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage()));
                  },
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.off_white,
                border: Border.all(color: colors.white, width: 5),
              ),
              child: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WishlistPage())),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //manage address card
  Widget _address(){
    double c_width = MediaQuery.of(context).size.width * 0.9;
    return GestureDetector(child:Container(
      height: 50,
      width: c_width,
      margin: const EdgeInsets.only(left: 20, right: 15, bottom: 10),
      decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Icon(
                Icons.add_location_alt_rounded,
                color: colors.gray_dark,
              )),
          Expanded(
              flex: 5,
              child: Text(S.of(context).manageAddress,
                  style: TextStyle(
                    color: colors.gray_dark,
                  ))),
          Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () => Navigator.push(
                    context,
                    addressCount == null
                        ? MaterialPageRoute(
                        builder: (context) => AddAddressPage())
                        : MaterialPageRoute(
                        builder: (context) =>
                            SelectAddressPage())),
                icon: const Icon(Icons.arrow_forward_ios),
              )),
        ],
      ),
    ), onTap: () => Navigator.push(
        context,
        addressCount == null
            ? MaterialPageRoute(
            builder: (context) => AddAddressPage())
            : MaterialPageRoute(
            builder: (context) =>
                SelectAddressPage())),);
  }

  //my orders card
  Widget _order(){
    double c_width = MediaQuery.of(context).size.width * 0.9;
    return GestureDetector(child: Container(
      height: 50,
      width: c_width,
      decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Icon(
                Icons.shopping_cart,
                color: colors.gray_dark,
              )),
          Expanded(
              flex: 5,
              child: Text(S.of(context).myOrders,
                  style: TextStyle(
                    color: colors.gray_dark,
                  ))),
          Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrdersPage())),
                icon: const Icon(Icons.arrow_forward_ios),
              )),
        ],
      ),
    ), onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrdersPage())),);
  }

  //complaint report card
  Widget _complaintReport(){
    double c_width = MediaQuery.of(context).size.width * 0.9;
    return GestureDetector(child: Container(
      height: 50,
      width: c_width,
      decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Icon(
                Icons.comment_sharp,
                color: colors.gray_dark,
              )),
          Expanded(
              flex: 5,
              child: Text(S.of(context).complaintReport,
                  style: TextStyle(
                    color: colors.gray_dark,
                  ))),
          Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  _showSnackBar(
                      context, S.of(context).forFuturePurpose);
                },
                icon: const Icon(Icons.arrow_forward_ios),
              )),
        ],
      ),
    ),onTap: () {
      _showSnackBar(
          context, S.of(context).forFuturePurpose);
    },);
  }

  //settings card
  Widget _settings(){
    double c_width = MediaQuery.of(context).size.width * 0.9;
    return GestureDetector(child: Container(
      height: 50,
      width: c_width,
      decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Icon(
                Icons.settings,
                color: colors.gray_dark,
              )),
          Expanded(
              flex: 5,
              child: Text(S.of(context).settings,
                  style: TextStyle(
                    color: colors.gray_dark,
                  ))),
          Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage())),
                icon: Icon(Icons.arrow_forward_ios),
              )),
        ],
      ),
    ),onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsPage())),);
  }

  //logout card
  Widget _logout(){
    double c_width = MediaQuery.of(context).size.width * 0.9;
    return GestureDetector(child: Container(
      height: 50,
      width: c_width,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(S.of(context).logout,
                  style: TextStyle(
                    color: colors.gray_dark,
                  ))),
          Center(
              child: IconButton(
                onPressed: () {
                  showAlertDialog(context);
                },
                icon: Icon(
                  Icons.power_settings_new_sharp,
                  color: colors.gray_dark,
                ),
              )),
        ],
      ),
    ),onTap: () {
      showAlertDialog(context);
    },);
  }

  //alert dialog
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        Navigator.pop(context);
        PrefManager.savePassword('');
        PrefManager.saveProfile('');
        PrefManager.saveUsername('');
        PrefManager.saveEmail('');
        PrefManager.saveGender('');
        PrefManager.saveMobile('');
        PrefManager.saveLoginFlag(false);
        PrefManager.saveLogin(false);
        await DSDatabase.instance.clearProducts();
        await DSDatabase.instance.clearCart();
        await DSDatabase.instance.clearOrderProduct();
        await DSDatabase.instance.clearagentLocation();
        await DSDatabase.instance.clearAddress();
        await DSDatabase.instance.clearFavourites();
        await DSDatabase.instance.clearOrders();
        await DSDatabase.instance.clearProducts();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
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
}
