import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  CustomText(
    this.text, {
    this.color = Colors.black,
    this.fontFamily = 'Rubik',
    this.fontSize = 20,
    this.isBold = false,
    this.align = TextAlign.center,
    this.bgColor = Colors.transparent,
    this.decor = TextDecoration.none,
    super.key,
  });

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
  }
}
