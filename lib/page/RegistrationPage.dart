// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, must_be_immutable, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:doorstep_banking_flutter/page/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class RegistrationPage extends StatefulWidget {
  String txtmobile;
  RegistrationPage({Key key, this.txtmobile}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState(txtmobile);
}

class _RegistrationPageState extends State<RegistrationPage> {
  _RegistrationPageState(this.mobile);

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmpwdController =
      new TextEditingController();
  // final TextEditingController _genderController = new TextEditingController();
  String email, username, password, confirnpwd, gender, mobile;
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptPassword = PrefManager.getEncryptedPassword();
  ScaffoldMessengerState scaffoldMessenger;
  File _image;
  bool _passwordVisible;
  bool _confirmPasswordVisible;
  final picker = ImagePicker();
  bool hasConnection = false;
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  Future _imgFromCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('image: $_image');
      }
    });
  }

  Future _imgFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('image: $_image');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String _radioValue; //Initial definition of radio button value
  String choice;

  // ------ [add the next block] ------
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    //checking internet connection available or not
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;

      setState(() => this.hasConnection = hasConnection);
    });
  }

  // ------ end: [add the next block] ------

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      log('radio:$_radioValue');
    });
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    Color color = Color.fromRGBO(236, 239, 244, 1);
    double c_width = MediaQuery.of(context).size.width * 0.8;
    double height = MediaQuery.of(context).size.height * 0.75;
    return Scaffold(
        backgroundColor: color,
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: height,
                        margin: new EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: color,
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
                              height: 10.0,
                            ),
                            Container(
                              height: 100,
                              width: c_width,
                              child: Row(
                                children: <Widget>[
                                  _profile(),
                                  _radioBtn(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            _usernameField(),
                            SizedBox(
                              height: 10,
                            ),
                            _emailField(),
                            SizedBox(
                              height: 10,
                            ),
                            _passwordField(),
                            SizedBox(
                              height: 10,
                            ),
                            _confirmPasswordField(),
                            SizedBox(
                              height: 10,
                            ),
                            _registerBtn(),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ]),
              ]),
        ));
  }

  //app bar
  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          S.of(context).registration,
          textAlign: TextAlign.center,
          style: TextStyle(
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
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: colors.primaryColor,
        ),
      ),
    );
  }

  //profile image picker
  Widget _profile() {
    return Expanded(
      flex: 2,
      child: Container(
        height: 70,
        width: 70,
        child: GestureDetector(
          onTap: () {
            _showPicker(context);
          },
          child: CircleAvatar(
            radius: 70,
            backgroundColor: colors.off_white,
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.file(
                      _image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border:
                            Border.all(color: colors.primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(70)),
                    child: Icon(
                      Icons.person,
                      color: colors.gray_dark,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  //gender radio button
  Widget _radioBtn() {
    return Expanded(
      flex: 4,
      child: Container(
        height: 100,
        child: Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: colors.primaryColor,
              disabledColor: Colors.blue),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 0.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    activeColor: colors.primaryColor,
                    value: 'Male',
                    groupValue: _radioValue,
                    onChanged: radioButtonChanges,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    S.of(context).male,
                    style: TextStyle(
                        color: colors.primaryColor,
                        fontSize: 18.0,
                        fontFamily: 'Source Sans Pro'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    activeColor: colors.primaryColor,
                    value: 'Female',
                    groupValue: _radioValue,
                    onChanged: radioButtonChanges,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    S.of(context).female,
                    style: TextStyle(
                        color: colors.primaryColor,
                        fontSize: 18.0,
                        fontFamily: 'Source Sans Pro'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //username text field
  Widget _usernameField() {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      margin: new EdgeInsets.all(15),
      padding: EdgeInsets.only(top: 10.0),
      height: 60,
      width: c_width,
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
        controller: _usernameController,
        onSubmitted: (val) {
          username = val;
        },
        expands: false,
        maxLines: 1,
        style: TextStyle(fontSize: 18.0, color: Colors.black54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          suffixIcon: Icon(
            Icons.person,
            color: colors.primaryColor,
          ),
          labelText: S.of(context).username,
          labelStyle: TextStyle(color: colors.primaryColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.off_white),
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.off_white),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  //email text field
  Widget _emailField() {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      margin: new EdgeInsets.only(left: 15, right: 15, bottom: 15),
      height: 60,
      padding: EdgeInsets.only(top: 10.0),
      width: c_width,
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
        controller: _emailController,
        onSubmitted: (val) {
          email = val;
        },
        expands: false,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 18.0, color: Colors.black54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          suffixIcon: Icon(
            Icons.email_outlined,
            color: colors.primaryColor,
          ),
          labelText: S.of(context).email,
          labelStyle: TextStyle(color: colors.primaryColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.off_white),
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.off_white),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  //password text field
  Widget _passwordField() {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      margin: new EdgeInsets.only(left: 15, right: 15, bottom: 15),
      padding: EdgeInsets.only(top: 10),
      height: 60,
      width: c_width,
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
        controller: _passwordController,
        onSubmitted: (val) {
          password = val;
        },
        expands: false,
        maxLines: 1,
        maxLength: 6,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: 18.0, color: Colors.black54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          // Here is key idea
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: colors.primaryColor,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          labelStyle: TextStyle(color: colors.primaryColor),
          labelText: S.of(context).password,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.off_white),
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.off_white),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  //confirm password field
  Widget _confirmPasswordField() {
    Color color = Color.fromRGBO(236, 239, 244, 1);
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      margin: new EdgeInsets.only(left: 15, right: 15, bottom: 15),
      padding: EdgeInsets.only(top: 10.0),
      height: 60,
      width: c_width,
      decoration: BoxDecoration(
          color: color,
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
          confirnpwd = val;
        },
        expands: false,
        maxLines: 1,
        maxLength: 6,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: 18.0, color: Colors.black54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          // Here is key idea
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: colors.primaryColor,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            },
          ),
          labelText: S.of(context).confirmPassword,
          labelStyle: TextStyle(color: colors.primaryColor),
          hintStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.off_white),
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.off_white),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  //register button
  Widget _registerBtn() {
    EdgeInsets edgeInsets = const EdgeInsets.only(left: 10, right: 10);
    Color color = Color.fromRGBO(236, 239, 244, 1);
    return Container(
      margin: edgeInsets,
      height: 40,
      width: 200,
      decoration: BoxDecoration(
          color: color,
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
      child: MaterialButton(
        onPressed: () {
          if (_usernameController.text.isEmpty) {
            _showSnackBar(context, S.of(context).invalidUsername);
          } else if (_emailController.text.isEmpty) {
            _showSnackBar(context, S.of(context).invalidEmail);
          } else if (isEmail(_emailController.text) == false) {
            _showSnackBar(context, S.of(context).wrongEmail);
          } else if (_passwordController.text.isEmpty ||
              _confirmpwdController.text.isEmpty) {
            _showSnackBar(context, S.of(context).invalidPassword);
          } else if (_passwordController.text != _confirmpwdController.text) {
            _showSnackBar(context, S.of(context).wrongPassword);
          } else {
            getRegister(_usernameController.text, _emailController.text,
                _passwordController.text, _radioValue.toString());
          }
        },
        child: Text(S.of(context).register,
            style: TextStyle(color: colors.primaryColor)),
      ),
    );
  }

  // registration without image
  getRegister(username, email, password, gender) async {
    String responseResult, requestResult;
    try {
      var body = {
        'mobile': mobile,
        'username': username,
        'email': email,
        'password': password,
        'gender': gender
      };
      var headers = {'DeviceID': deviceId, 'Content-Type': 'application/json'};
      final jsonbody = json.encode(body);
      try {
        requestResult = await platform.invokeMethod(
            'RequestEncrypt', <String, String>{
          'request': jsonbody.toString(),
          'DeviceId': deviceId
        });
        log('RegRequest:$requestResult');
      } on PlatformException catch (e) {
        // Unable to open the browser
        print(e);
      }
      var request =
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.REGISTER_USER));
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
          log('RegResponse:$responseResult');
        } on PlatformException catch (e) {
          // Unable to open the browser
          print(e);
        }
        Map<String, dynamic> valueMap = jsonDecode(responseResult);
        String message = valueMap['message'].toString();
        String data = valueMap['data'].toString();
        if (valueMap['status']) {
          if (_image.path.isEmpty) {
            _showSnackBar(context, data);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else {
            RegisterWithProfile(_image, mobile);
          }
        } else {
          _showSnackBar(context, message);
        }
      } else {
        _showSnackBar(context, S.of(context).noNetworkConnection);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //register with profile image
  RegisterWithProfile(imageFile, number) async {
    String responseResult, requestResult;
    var header = {
      'DeviceID': deviceId,
      'Password': encryptPassword,
    };
    try {
      requestResult = await platform.invokeMethod('RequestEncrypt',
          <String, String>{'request': mobile, 'DeviceId': password});
      log('RegRequest:$requestResult');
    } on PlatformException catch (e) {
      // Unable to open the browser
      print(e);
    }
    var request = MultipartRequest(
        'POST', Uri.parse(Apis.BASE_URL + Apis.REGISTER_USER_WITH_IMAGE));
    var multipart =
        await MultipartFile.fromPath('profile_image', imageFile.path);
    request.files.add(multipart);
    request.fields['mobile'] = requestResult;
    request.headers.addAll(header);

    StreamedResponse response = await request.send();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = await response.stream.bytesToString();
      String responseBody = body.replaceAll('{"response_encrypted":"', '');
      responseBody = responseBody.replaceAll('"}', "");
      try {
        responseResult = await platform.invokeMethod('ResponseDecrypt',
            <String, String>{'response': responseBody, 'DeviceId': deviceId});
        log('RegResponse:$responseResult');
      } on PlatformException catch (e) {
        // Unable to open the browser
        print(e);
      }
      Map<String, dynamic> valueMap = jsonDecode(responseResult);
      String message = valueMap['message'].toString();
      String data = valueMap['data'].toString();
      if (valueMap['status']) {
        _showSnackBar(context, data);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        _showSnackBar(context, message);
      }
    } else {
      _showSnackBar(context, S.of(context).noNetworkConnection);
    }
  }

  //email pattern
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
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
