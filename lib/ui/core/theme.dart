import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';

class AppTheme {
  final commonTheme = ThemeData(
      fontFamily: "OpenSans",
      primaryColor: PrimaryColor,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: BackgroundColor);

  // static ThemeData commonAppTheme() {
  //   return ThemeData(
  //       fontFamily: "OpenSans",
  //       primaryColor: PrimaryColor,
  //       primarySwatch: Colors.grey,
  //       scaffoldBackgroundColor: BackgroundColor);
  // }

  static ThemeData light() {
    return ThemeData(
        fontFamily: "OpenSans",
        primaryColor: PrimaryColor,
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: BackgroundColor,
        backgroundColor: BackgroundColor);
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(backgroundColor: BackgroundColorDark);
  }
}
