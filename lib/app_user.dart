import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';

/// A class that represents a user's preferences
/// Has getter and setter methods for preferences such as theme color
class AppUser {

  /// the main theme color
  Color? themeColor = Colors.greenAccent[700];
  /// string representation of theme color
  String themeColorStr = '';

  static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  /// called to initialize the preferences
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  /// getter method that gets the color
  static Color? getColor() {
    String colorStr =  _prefsInstance?.getString('color') ?? 'greenAccent700';
    return Constants.colorHashMap[colorStr];
  }

  /// getter method that the string representation of the color
  static String getColorStr() {
    return _prefsInstance?.getString('color') ?? 'greenAccent700';
  }

  /// setter method that sets a new color
  static void setColor(String newColor) {
    _prefsInstance?.setString('color', newColor);
  }

  /// getter method that gets the list of saved strains
  static List getSaved() {
    String data = _prefsInstance?.getString('savedStrain') ?? '[]';
    return json.decode(data);
  }

  /// setter method that adds another strain to the saved list
  static void addSaved(Map strainName) {
    List saved = getSaved();
    saved.add(strainName);
    String strSaved = json.encode(saved);
    _prefsInstance?.setString('savedStrain', strSaved);
  }

  /// removes a strain from the saved list
  static void removeSaved(Map strainName) {
    List saved = getSaved();
    List newSaved = [];
    for (Map m in saved) {
      if (m['name'] != strainName['name']) {
        newSaved.add(m);
      }
    }
    String strSaved = json.encode(newSaved);
    _prefsInstance?.setString('savedStrain', strSaved);
  }

  /// checks if a strain exists
  static bool savedContains(Map data) {
    List saved = getSaved();
    for (Map m in saved) {
      if (m['name'] == data['name']) {
        return true;
      }
    }
    return false;
  }

  /// gets the recent strains searched
  static List getRecent() {
    String data = _prefsInstance?.getString('recent') ?? '[]';
    return json.decode(data);
  }

  /// adds strain to recent searches
  static void addRecent(String strainName) {
    List recent = getRecent();
    if (recent.contains(strainName)) {
      return;
    } else if (recent.length == 6) {
      recent.remove(recent[0]); // keeps recent to 6 most recent searches
    }
    recent.add(strainName);
    String strSaved = json.encode(recent);
    _prefsInstance?.setString('recent', strSaved);
  }

  /// returns the convert from metric
  static String getConvertFrom() {
    String convertFrom = _prefsInstance?.getString('convertFrom') ?? 'grams';
    return convertFrom;
  }

  /// sets the convert from metric
  static void setConvertFrom(String convertFrom) {
    _prefsInstance?.setString('convertFrom', convertFrom);
  }

  /// gets the convert to metric
  static String getConvertTo() {
    String convertFrom = _prefsInstance?.getString('convertTo') ?? 'ounces';
    return convertFrom;
  }

  /// sets the convert to metric
  static void setConvertTo(String convertTo) {
    _prefsInstance?.setString('convertTo', convertTo);
  }

  /// returns the amount of the convert from metric
  static String getOgAmount() {
    String ogAmount = _prefsInstance?.getString('ogAmount') ?? '28';
    return ogAmount;
  }

  /// sets the amount of the convert from metric
  static void setOgAmount(String ogAmount) {
    _prefsInstance?.setString('ogAmount', ogAmount);
  }

  /// gets the amount of the convert to metric
  static String getConvertedAmount() {
    String convertedAmount = _prefsInstance?.getString('convertedAmount') ?? '0.99';
    return convertedAmount;
  }

  /// sets the amount of the convert to metric
  static void setConvertedAmount(String convertedAmount) {
    _prefsInstance?.setString('convertedAmount', convertedAmount);
  }
}
