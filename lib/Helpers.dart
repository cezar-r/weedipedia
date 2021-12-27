import 'package:flutter/material.dart';

/// method that is used to style text
///
/// attributes that are styled are color, font, font size, and font weight
TextStyle style({Color? color = Colors.white,
  double fontSize = 12,
  FontWeight? fontWeight = FontWeight.bold,
  String? fontFamily = 'SegoeBold'}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
  );
}