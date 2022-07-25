// @dart=2.9
// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  //Shared Preferences
  static SharedPreferences pref;

  // Shared preference file name
  static const PREF_NAME = "DOORSTEPBANKING";

  //All Shared Preference Keys
  static const KEY_IS_SYNCED = "isSynced";
  static const KEY_LOGIN = "login";
  static const KEY_DEVICE = 'device';
  static const KEY_DEVICE_KEY = "device_key";
  static const KEY_EDIT_FLAG = "edit_flag";
  static const KEY_EDIT_VALUE = "edit_value";
  static const KEY_TIME = "time";
  static const DELIVERY_FEE = "delivery_fee";
  static const DEVICE_LOCATION_ADDRESS = "device_location_address";
  static const USER_LATITUDE = "latitude";
  static const USER_LONGITUDE = "longitude";
  static const CART_NOTE = "note";
  static const SELECTED_LANGUAGE_KEY = "selected_language_key";
  static const LOGIN_FLAG = "login_flag";

  static const KEY_USER_USERNAME = "username";
  static const KEY_USER_ID = "id"; // mobile number
  static const KEY_USER_EMAIL = "email";
  static const KEY_USER_PASSWORD = "password";
  static const KEY_USER_GENDER = "gender";
  static const KEY_USER_PROFILE = "profile";
  static const KEY_USER_FCM_TOKEN = "fcm_token";

  static const ENCRYPTED_EMAIL = "encrypted_email";
  static const ENCRYPTED_MOBILE_NUMBER = "encrypted_mobile_number";
  static const ENCRYPTED_PASSWORD = "encrypted_password";
  static const USER_ORDER_LATITUDE = "user_order_latitude";
  static const USER_ORDER_LONGITUDE = "user_order_longitude";

  static Future init() async => pref = await SharedPreferences.getInstance();

  static Future saveKeyDeviceId(String deviceKey) async =>
      await pref.setString(KEY_DEVICE_KEY, deviceKey);

  static Future saveKeyDevice(String Key) async =>
      await pref.setString(KEY_DEVICE, Key);

  static String getKeyDeviceId() => pref.getString(KEY_DEVICE_KEY);

  static Future saveDeviceLocationAddress(String deviceLocationAddress) async =>
      await pref.setString(DEVICE_LOCATION_ADDRESS, deviceLocationAddress);

  static String getDeviceLocationAddress() =>
      pref.getString(DEVICE_LOCATION_ADDRESS);

  static Future saveDeliveryFee(String deliveryFee) async =>
      await pref.setString(DELIVERY_FEE, deliveryFee);

  static String getDeliveryFee() => pref.getString(DELIVERY_FEE);

  static Future saveLogin(bool isLoggedIn) async =>
      await pref.setBool(KEY_LOGIN, isLoggedIn);

  static bool getisLoggedIn() => pref.getBool(KEY_LOGIN);

  static Future saveLoginFlag(bool loginFlag) async =>
      await pref.setBool(LOGIN_FLAG, loginFlag);

  static bool getisLoginFlag() => pref.getBool(LOGIN_FLAG);

  static Future saveUserLatitude(String latitude) async =>
      await pref.setString(USER_LATITUDE, latitude);

  static String getUserLatitude() => pref.getString(USER_LATITUDE);

  static Future saveUserLongitude(String longitude) async =>
      await pref.setString(USER_LONGITUDE, longitude);

  static String getUserLongitude() => pref.getString(USER_LONGITUDE);

  static Future saveUsername(String username) async =>
      await pref.setString(KEY_USER_USERNAME, username);

  static String getUsername() => pref.getString(KEY_USER_USERNAME);

  static Future saveEmail(String email) async =>
      await pref.setString(KEY_USER_EMAIL, email);

  static String getGender() => pref.getString(KEY_USER_GENDER);

  static Future saveGender(String gender) async =>
      await pref.setString(KEY_USER_GENDER, gender);

  static String getEmail() => pref.getString(KEY_USER_EMAIL);

  static Future saveMobile(String mobile) async =>
      await pref.setString(KEY_USER_ID, mobile);

  static String getMobile() => pref.getString(KEY_USER_ID);

  static Future savePassword(String password) async =>
      await pref.setString(KEY_USER_PASSWORD, password);

  static String getPassword() => pref.getString(KEY_USER_PASSWORD);

  static Future saveProfile(String profile) async =>
      await pref.setString(KEY_USER_PROFILE, profile);

  static String getProfile() => pref.getString(KEY_USER_PROFILE);

  static Future saveToken(String token) async =>
      await pref.setString(KEY_USER_FCM_TOKEN, token);

  static String getToken() => pref.getString(KEY_USER_FCM_TOKEN);

  static Future saveEncryptedEmail(String email) async =>
      await pref.setString(ENCRYPTED_EMAIL, email);

  static String getEncryptedEmail() => pref.getString(ENCRYPTED_EMAIL);

  static Future saveEncryptedMobileNumber(String mobileNumber) async =>
      await pref.setString(ENCRYPTED_MOBILE_NUMBER, mobileNumber);

  static String getEncryptedMobileNumber() =>
      pref.getString(ENCRYPTED_MOBILE_NUMBER);

  static Future saveEncryptedPassword(String password) async =>
      await pref.setString(ENCRYPTED_PASSWORD, password);

  static String getEncryptedPassword() => pref.getString(ENCRYPTED_PASSWORD);

  static Future saveCartNote(String cartNote) async =>
      await pref.setString(CART_NOTE, cartNote);

  static String getCartNote() => pref.getString(CART_NOTE);

  static Future saveSelectedLanguageKey(String selectedLanguage) async =>
      await pref.setString(SELECTED_LANGUAGE_KEY, selectedLanguage);

  static String getSelectedLanguageKey() =>
      pref.getString(SELECTED_LANGUAGE_KEY);

  static Future saveUserOrderLatitude(String userOrderLatitude) async =>
      await pref.setString(USER_ORDER_LATITUDE, userOrderLatitude);

  static String getUserOrderLatitude() => pref.getString(USER_ORDER_LATITUDE);

  static Future saveUserOrderLongitude(String userOrderLongitude) async =>
      await pref.setString(USER_ORDER_LONGITUDE, userOrderLongitude);

  static String getUserOrderLongitude() => pref.getString(USER_ORDER_LONGITUDE);
}
