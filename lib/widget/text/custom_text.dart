import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  CustomText(this.text,
      {this.color = Colors.black,
      this.fontFamily = 'Rubik',
      this.fontSize = 20,
      this.isBold = false,
      this.align = TextAlign.center,
      this.bgColor = Colors.transparent,
      this.decor = TextDecoration.none,
      super.key});

  String text;
  Color color;
  String fontFamily;
  double fontSize;
  bool isBold;
  TextAlign align;
  Color bgColor;
  TextDecoration decor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        backgroundColor: bgColor,
        decoration: decor,
      ),
    );

    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //   double scaledFontSize = fontSize * (constraints.maxWidth / 400);
    //
    //   bool isTablet = scaledFontSize >= 24.0;
    //
    //   if (isTablet) {
    //     // Code for tablet
    //     // ...
    //   } else {
    //     // Code for mobile phone
    //     double deviceWidth = MediaQuery.of(context).size.width;
    //     bool isSmallDevice = deviceWidth < 375;
    //     bool isMediumDevice = deviceWidth >= 375 && deviceWidth < 414;
    //     bool isLargeDevice = deviceWidth >= 414;
    //
    //     if (isSmallDevice) {
    //       // Code for small devices
    //       // ...
    //     } else if (isMediumDevice) {
    //       // Code for medium devices
    //       // ...
    //     } else if (isLargeDevice) {
    //       // Code for large devices
    //       // ...
    //     }
    //     // ...
    //   }
    //
    //   return Text(
    //     text,
    //     textAlign: align,
    //     style: TextStyle(
    //     color: color,
    //     fontFamily: fontFamily,
    //     fontSize: scaledFontSize,
    //     fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    //     backgroundColor: bgColor,
    //     decoration: decor,
    //     ),
    //   );
    //   },
    // );
  }
}
