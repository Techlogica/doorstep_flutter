// @dart=2.9
// ignore_for_file: file_names, unnecessary_const, unnecessary_new, non_constant_identifier_names, sized_box_for_whitespace, avoid_print, avoid_unnecessary_containers, prefer_const_constructors
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:doorstep_banking_flutter/Helper/PrefManager.dart';
import 'package:doorstep_banking_flutter/Helper/retrofit/Apis.dart';
import 'package:doorstep_banking_flutter/color.dart';
import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  ScaffoldMessengerState scaffoldMessenger;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  //---------------------------------------------------------------------//
  String deviceId = PrefManager.getKeyDeviceId();
  String encryptEmail = PrefManager.getEncryptedEmail();
  String encryptPassword = PrefManager.getEncryptedPassword();
  String encryptMobile = PrefManager.getEncryptedMobileNumber();
  String user_email = PrefManager.getEmail();
  String mobile = PrefManager.getMobile();
  String password = PrefManager.getPassword();
  String user_name = PrefManager.getUsername();
  //
  String email, username;
  bool isuserNameEditing = false;
  bool isEmailEditing = false;
  File _image;
  final picker = ImagePicker();
  bool hasConnection = false;
  //-----------------------------------------------------------------//
  static const platform =
      const MethodChannel('flutter.native/Encryptionhelper');

  //camera image picking
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

  //Gallery image picking
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

  //image picker
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

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: user_name);
    username = user_name;
    _emailController = TextEditingController(text: user_email);
    email = user_email;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        backgroundColor: colors.off_white,
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Container(
            height: 600,
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              _imageEdit(),
              _editProfile(),
              _saveButton(),
              SizedBox(
                height: 30,
              )
            ]),
          ),
        ));
  }

  //app bar
  Widget _appBar(){
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Center(
        child: Text(
          S.of(context).account.toUpperCase(),
          style: const TextStyle(
              color: colors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      centerTitle: true,
      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        width: 60.0,
        height: 60.0,
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

  //image edit
  Widget _imageEdit(){
    return Expanded(
      flex: 0,
      child: Container(
        height: 198,
        width: 198,
        child: Stack(children: [
          Container(
            alignment: Alignment.center,
            height: 180,
            width: 180,
            margin: const EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border:
              Border.all(color: colors.primaryColor, width: 4),
            ),
            child: _image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(180),
              child: Image.file(
                _image,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(180),
              child: Image.network(
                PrefManager.getProfile(),
                height: 180,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: colors.white, width: 3),
                      color: colors.primaryColor,
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.camera_alt,
                    color: colors.gray_dark,
                  ),
                )),
          ),
        ]),
      ),
    );
  }

  //edit user details
  Widget _editProfile(){
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(flex: 0, child: Icon(Icons.person)),
                const SizedBox(
                  width: 20,
                ),

                ///edit username
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).name,
                          style: const TextStyle(
                              color: colors.gray,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            height: 35,
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: PrefManager.getUsername(),
                                hintStyle: const TextStyle(
                                    color: colors.gray_dark,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    )),
                const Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.edit,
                      color: colors.primaryColor,
                    ))
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            color: colors.gray_dark,
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(flex: 0, child: Icon(Icons.email)),
                const SizedBox(
                  width: 20,
                ),

                ///edit email
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).email,
                          style: const TextStyle(
                              color: colors.gray,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            height: 35,
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: PrefManager.getEmail(),
                                hintStyle: const TextStyle(
                                    color: colors.gray_dark,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    )),
                const Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.edit,
                      color: colors.primaryColor,
                    ))
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            color: colors.gray_dark,
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.phone,
                      color: colors.black,
                    )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).mobileNumber,
                          style: const TextStyle(
                              color: colors.gray,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          PrefManager.getMobile(),
                          style: const TextStyle(
                              color: colors.gray_dark,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //save btn
  Widget _saveButton(){
    return Expanded(
      flex: 0,
      child: Container(
        height: 40,
        width: 160,
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
            String username = _usernameController.text;
            String email = _emailController.text;

            if (username.isEmpty) {
              _showSnackBar(context, S.of(context).invalidUsername);
            } else if (email.isEmpty) {
              _showSnackBar(context, S.of(context).invalidEmail);
            } else if (isEmail(_emailController.text) == false) {
              _showSnackBar(context, S.of(context).wrongEmail);
            } else {
              if (_image.path.isNotEmpty) {
                EditProfilePic(_image, mobile);
              }
              EditProfileDetails(
                  _usernameController.text, _emailController.text);
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
      ),
    );
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

  // edit profile
  EditProfileDetails(username, email) async {
    String requestResult, responseResult;
    try {
      var body = {'username': username, 'email': email};
      var headers = {
        'DeviceID': deviceId,
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
          'DeviceId': user_email
        });
        log("request: $requestResult");
      } on PlatformException catch (e) {
        print(e);
      }
      var request =
          Request('POST', Uri.parse(Apis.BASE_URL + Apis.EDIT_USER_PROFILE));
      request.body = '''{"request_encrypted":"$requestResult"}''';
      request.headers.addAll(headers);

      StreamedResponse response = await request.send();
      int statusCode = response.statusCode;
      try {
        if (statusCode == 200) {
          String body = await response.stream.bytesToString();
          String responseBody = body.replaceAll('{"response_encrypted":"', '');
          responseBody = responseBody.replaceAll('"}', "");
          try {
            responseResult = await platform.invokeMethod(
                'ResponseDecrypt', <String, String>{
              'response': responseBody,
              'DeviceId': user_email
            });
            log('MobRegResponse:$responseResult');
          } on PlatformException catch (e) {
            // Unable to open the browser
            print(e);
          }
          Map<String, dynamic> valueMap = jsonDecode(responseResult);
          String message = valueMap['message'].toString();
          String data = valueMap['data'].toString();
          if (valueMap['status']) {
            _showSnackBar(context, data);
            PrefManager.saveEmail(email);
            PrefManager.saveUsername(username);
          } else {
            _showSnackBar(context, message);
          }
        } else {
          _showSnackBar(context, S.of(context).noNetworkConnection);
        }
      } on Exception catch (e) {
        print(e);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //edit image
  EditProfilePic(imageFile, number) async {
    String responseResult, requestResult;
    try {
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
      try {
        if (statusCode == 200) {
          String body = await response.stream.bytesToString();
          String responseBody = body.replaceAll('{"response_encrypted":"', '');
          responseBody = responseBody.replaceAll('"}', "");
          try {
            responseResult = await platform.invokeMethod(
                'ResponseDecrypt', <String, String>{
              'response': responseBody,
              'DeviceId': deviceId
            });
            log('RegResponse:$responseResult');
          } on PlatformException catch (e) {
            // Unable to open the browser
            print(e);
          }
          Map<String, dynamic> valueMap = jsonDecode(responseResult);
          String message = valueMap['message'].toString();
          String data = valueMap['data'].toString();
          if (valueMap['status']) {
            Map<String, dynamic> image = valueMap['data'];
            String imageUrl = image['image_url'];
            PrefManager.saveProfile(imageUrl);
            _showSnackBar(context, data);
          } else {
            _showSnackBar(context, message);
          }
        } else {
          _showSnackBar(context, S.of(context).noNetworkConnection);
        }
      } on Exception catch (e) {
        print(e);
      }
    } on Exception catch (e) {
      print(e);
    }
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

  //email pattern
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
}
