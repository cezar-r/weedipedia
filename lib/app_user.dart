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
}
