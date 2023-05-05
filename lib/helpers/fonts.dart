import 'package:flutter/material.dart';

class CustomFontStyle {
  static paraSRegular(Color color) => TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, height: 1.3, color: color);
  static paraSMedium(Color color) => TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, height: 1.3, color: color);
  static paraMRegular(Color color) => TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, height: 1.3, color: color);
  static paraMSemi(Color color) => TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, height: 1.3, color: color);
  static h3Semi(Color color) => TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w600,
      height: 1.01,
      color: color,
      letterSpacing: 2);
}
