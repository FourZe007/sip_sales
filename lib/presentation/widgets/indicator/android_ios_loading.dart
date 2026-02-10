import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class AndroidIosLoading extends StatelessWidget {
  const AndroidIosLoading({
    this.indicatorOnly = true,
    this.indicatorWidth = 100,
    this.indicatorHeight = 100,
    this.indicatorColor = Colors.black,
    super.key,
  });

  final bool indicatorOnly;
  final double indicatorWidth;
  final double indicatorHeight;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    if (indicatorOnly) {
      return Builder(
        builder: (context) {
          if (Platform.isIOS) {
            return CupertinoActivityIndicator(
              radius: 12.5,
              color: indicatorColor,
            );
          } else {
            return AndroidLoading(
              warna: indicatorColor,
              strokeWidth: 3,
            );
          }
        },
      );
    } else {
      return Builder(
        builder: (context) {
          if (Platform.isIOS) {
            return Container(
              width: indicatorWidth,
              height: indicatorHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: CupertinoActivityIndicator(
                radius: 12.5,
                color: indicatorColor,
              ),
            );
          } else {
            return Container(
              width: indicatorWidth,
              height: indicatorHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: AndroidLoading(
                warna: indicatorColor,
                strokeWidth: 3,
              ),
            );
          }
        },
      );
    }
  }
}
