import 'package:flutter/material.dart';

class GlobalVar {
  static bool isLoading = false;
  static bool isDisabled = false;

  // static List<ModelUser> userAccountList = [];
  static String? nip = '';
  static String? password = '';
}

class GlobalFunction {
  static tampilkanDialog(
      BuildContext context, bool isDismissible, Widget widget) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.blue.shade50,
          elevation: 16,
          child: widget,
        );
      },
    );
  }

  static displayProminentDisclosure(
    BuildContext context,
    Widget widget, {
    bool isDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.blue.shade50,
          elevation: 16,
          child: widget,
        );
      },
    );
  }
}

class GlobalFontFamily {
  static String fontCeraGR = 'CeraGR';
  static String fontCourier = 'Courier';
  static String fontRubik = 'Rubik';
  static String fontMontserrat = 'Montserrat';
}

class GlobalSize {
  static double smallfont = 10;
  static double mediumfont = 12;
  static double mediumbigfont = 14;
  static double bigfont = 16;
  static double mediumgiantfont = 18;
  static double giantfont = 20;
  static double mediumgigafont1 = 24;
  static double mediumgigafont2 = 26;
  static double gigafont = 28;
  static double terafont = 30;
  static double petafont = 32;
  static double peta2xfont = 50;
  static double titleMenuFont1 = 32;
  static double titleMenuFont2 = 36;
  static double dateFont1 = 40;
  static double dateFont2 = 45;
}

class GlobalFont {
  // Courier
  static TextStyle mediumfontC = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumfontCWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bigfontC = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontCBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontCWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontCWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumgiantfontCBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgiantfontCWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontCBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontCWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontCBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleLoginFontW2Bold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.titleMenuFont1,
    fontWeight: FontWeight.bold,
  );

  // Montserrat
  static TextStyle mediumfontM = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumbigfontMBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumbigfontMbuttonRedBoldItalic = TextStyle(
    color: Colors.red[700],
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );

  static TextStyle mediumbigfontM = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumbigfontMWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumbigfontMWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumbigfontMItalic = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontStyle: FontStyle.italic,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontMBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontMWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontM = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumgiantfontM = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontMBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontM = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.giantfont,
  );

  static TextStyle giantfontMBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontCMhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontMBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontMBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle gigafontMBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.gigafont,
    fontWeight: FontWeight.bold,
  );

  // Rubik
  static TextStyle smallfontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.smallfont,
  );

  static TextStyle mediumfontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumfont,
  );

  static TextStyle mediumfontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumfontRWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumbigfontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumbigfontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
  );

  static TextStyle mediumbigfontRWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
  );
  static TextStyle mediumbigfontRGrey = TextStyle(
    color: Colors.grey,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
  );

  static TextStyle mediumBigfontRUnderlinedBoldBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    backgroundColor: Colors.transparent,
    decoration: TextDecoration.underline,
  );

  static TextStyle mediumBigfontRUnderlinedBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    backgroundColor: Colors.transparent,
    decoration: TextDecoration.underline,
  );

  static TextStyle bigfontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontRWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontRGrey = TextStyle(
    color: Colors.grey,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
  );

  static TextStyle bigfontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontRUnderlinedBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
    decoration: TextDecoration.underline,
  );

  static TextStyle bigfontRUnderlinedBoldBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
    decoration: TextDecoration.underline,
  );

  static TextStyle mediumgiantfontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontRWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontRRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontRGrey = TextStyle(
    color: Colors.grey,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontRBlueUnderlined = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
    decoration: TextDecoration.underline,
  );

  static TextStyle mediumgiantfontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgiantfontRBoldRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgiantfontRBoldBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgiantfontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
  );

  static TextStyle giantfontRWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
  );

  static TextStyle giantfontRRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
  );

  static TextStyle giantfontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontRBoldRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle datefont1 = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.dateFont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgigafont1,
  );

  static TextStyle mediumgigafontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontRBoldRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle gigafontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.gigafont,
  );

  static TextStyle gigafontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.gigafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle gigafontRBoldRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.gigafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle gigafontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.gigafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle terafontR = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.terafont,
  );

  static TextStyle terafontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.terafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle terafontRBoldRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.terafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle petafontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.petafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleLoginFontR2Bold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.titleMenuFont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle datefont2 = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.dateFont2,
    fontWeight: FontWeight.bold,
  );

  static TextStyle peta2xfontRBold = TextStyle(
    color: Colors.black,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.peta2xfont,
    fontWeight: FontWeight.bold,
  );
}
