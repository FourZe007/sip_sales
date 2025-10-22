import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/constant/colors.dart';

class TextFontFamily {
  static const String poppins = 'Poppins';
  static const String montserrat = 'Montserrat';
  static const String roboto = 'Roboto';
  static const String inter = 'Inter';
  static const String rubik = 'Rubik';
}

class TextThemes {
  static const TextStyle logoutButton = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 16,
    color: ConstantColors.closeColor,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title1 = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: ConstantColors.primaryColor3,
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 20,
    color: ConstantColors.primaryColor3,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 16,
    color: ConstantColors.primaryColor3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: ConstantColors.primaryColor3,
  );

  static const TextStyle textfieldPlaceholder = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 16,
    color: Colors.black,
  );

  static TextStyle normal = const TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 14,
    color: ConstantColors.primaryColor3,
  );

  static const TextStyle normalWhite = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 14,
    color: ConstantColors.primaryColor2,
  );

  static const TextStyle styledTextButton = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 14,
    color: ConstantColors.textButtonCollor,
    decoration: TextDecoration.underline,
  );

  static const TextStyle normalTextButton = TextStyle(
    fontFamily: TextFontFamily.roboto,
    fontSize: 14,
    color: ConstantColors.primaryColor3,
  );
}
