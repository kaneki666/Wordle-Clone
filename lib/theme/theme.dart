import 'package:flutter/material.dart';

class WordleTheme {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  //borderradius
  static double borderRadiusS = 5;
  static double borderRadiusM = 10;
  static double borderRadiusL = 15;
  static double borderRadiusXL = 20;

  static double paddingS = 5;
  static double paddingM = 10;
  static double paddingL = 15;
  static double paddingXL = 20;

  //colors
  static Color bgDark = const Color(0xff000000);
  static Color bgSecondary = const Color(0xff191919);
  static Color greyColor = Colors.grey.withOpacity(0.8);
  static Color textColor = Colors.white.withOpacity(0.85);
  static Color blockDefault = Colors.white.withOpacity(0.1);
  static Color blockNoMatch = greyColor;
  static Color blockCorrect = const Color(0xff538d4e);
  static Color blockWrong = const Color(0xffb59f3b);
  static Color buttonColor = const Color(0xff818384);
  //texttheme
  static TextStyle headerText = TextStyle(color: textColor, fontSize: 30);
  static TextStyle wordText = TextStyle(
    fontSize: 30,
    color: textColor,
  );
  static TextStyle wordTextHowTo = TextStyle(
    fontSize: 20,
    color: textColor,
  );
  static TextStyle shareButton = TextStyle(
    fontSize: 18,
    color: textColor,
  );
  static TextStyle keybordText = TextStyle(
    fontSize: 13,
    color: textColor,
  );

  static TextStyle textInfo = TextStyle(
      fontSize: 16,
      color: textColor,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto");
  static TextStyle textInfoBold =
      TextStyle(fontSize: 16, color: textColor, fontFamily: "Rowdies");

  static TextStyle popupText = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);

  //stats

  static TextStyle statsNumber = TextStyle(
      fontSize: 32,
      color: textColor,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto");
  static TextStyle statsText = TextStyle(
      fontSize: 12,
      color: textColor,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto");

  static TextStyle guessKey = TextStyle(
      fontSize: 15,
      color: textColor,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto");
  static TextStyle guessNumber = TextStyle(
    fontSize: 15,
    color: textColor,
  );
  //darkTheme
  static ThemeData darkTheme() {
    return ThemeData(
      fontFamily: "Rowdies",
      scaffoldBackgroundColor: bgDark,
    );
  }
}
