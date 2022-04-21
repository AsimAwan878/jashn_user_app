
import 'package:flutter/material.dart';

import 'colors.dart';

class MyStrings{
  static String landingPageUrl="https://play.google.com/store/apps/details?id=com.facebook.katana";
  static String googlePrivacyUrl="https://policies.google.com/privacy?hl=en-US";
  static String googleAnalyticsUrl="https://policies.google.com/privacy?hl=en-US";
  static String firebaseUrl="https://policies.google.com/privacy?hl=en-US";
  static String facebookUrl="https://www.facebook.com/about/privacy";

}

TextTheme textTheme() {
final double scaleFactor =1.1;
  return TextTheme(
    bodyText1: TextStyle(
        color: Constants.textColour1,
        fontFamily: "Segoe UI",
        fontSize: 28 * scaleFactor,
        fontWeight: FontWeight.normal),
    bodyText2: TextStyle(color: Constants.textColour1,
        fontFamily: "Segoe UI",
        fontSize: 14 * scaleFactor,
        fontWeight: FontWeight.normal),
    button: TextStyle(color: Constants.textColour3,
        fontFamily: "Segoe UI",
        fontSize: 16 * scaleFactor,
        fontWeight: FontWeight.w500),
    subtitle1: TextStyle(color: Constants.textColour1,
        fontFamily: "Segoe UI",
        fontSize: 16 * scaleFactor,
        fontWeight: FontWeight.w500),
    subtitle2: TextStyle(color: Constants.textColour1,
        fontFamily: "Segoe UI",
        fontSize: 12 * scaleFactor,
        fontWeight: FontWeight.w500),
  );
}

TextTheme homeTextTheme() {
  final double scaleFactor =1.1;
  return TextTheme(
    subtitle1: TextStyle(color: Constants.textColour1,
        fontFamily: "Segoe UI",
        fontSize: 12 * scaleFactor,
        fontWeight: FontWeight.normal),
    subtitle2: TextStyle(
        color: Constants.textColour3,
        fontFamily: "Segoe UI",
        fontSize: 26 * scaleFactor,
        fontWeight: FontWeight.bold
    ),
    bodyText1: TextStyle(
      color: Constants.textColour1,
      fontFamily: "Segoe UI",
      fontSize: 26 * scaleFactor,
      fontWeight: FontWeight.bold
  ),
    bodyText2: TextStyle(
        color: Constants.textColour3,
        fontFamily: "Segoe UI",
        fontSize: 18 * scaleFactor,
        fontWeight: FontWeight.w600),
    button: TextStyle(
        color: Constants.textColour4,
        fontFamily: "Segoe UI",
        fontSize: 12 * scaleFactor,
        fontWeight: FontWeight.w600),

  );
}