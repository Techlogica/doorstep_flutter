import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String MALAYALAM = 'ml';
const String HINDI = 'hi';
const String MARATHI = 'mr';
const String TAMIL = 'ta';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case MALAYALAM:
      return Locale(MALAYALAM, "IN");
    case HINDI:
      return Locale(HINDI, "IN");
    case MARATHI:
      return Locale(MARATHI, "IN");
    case TAMIL:
      return Locale(TAMIL, "IN");
    default:
      return Locale(ENGLISH, 'IN');
  }
}