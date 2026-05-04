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
    this.customizedWidth = 0,
    this.customizedHeight = 0,
    this.strokeWidth = 3,
    this.iosRadius = 8,
    super.key,
  });

  final bool indicatorOnly;
  final double indicatorWidth;
  final double indicatorHeight;
  final Color indicatorColor;
  final double customizedWidth;
  final double customizedHeight;
  final double strokeWidth;
  final double iosRadius;

  @override
  Widget build(BuildContext context) {
    if (indicatorOnly) {
      if (Platform.isIOS) {
        final hasCustomSize = customizedWidth != 0 || customizedHeight != 0;
        // final radius = customizedHeight != 0 ? customizedHeight / 2 : 12.5;
        final indicator = CupertinoActivityIndicator(
          radius: iosRadius,
          color: indicatorColor,
        );
        if (hasCustomSize) {
          return Center(
            heightFactor: 1,
            widthFactor: 1,
            child: SizedBox(
              width: customizedWidth != 0 ? customizedWidth : null,
              height: customizedHeight != 0 ? customizedHeight : null,
              child: indicator,
            ),
          );
        }
        return indicator;
      } else {
        return AndroidLoading(
          warna: indicatorColor,
          strokeWidth: strokeWidth,
          customizedWidth: customizedWidth,
          customizedHeight: customizedHeight,
        );
      }
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
                radius: iosRadius,
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
                strokeWidth: strokeWidth,
              ),
            );
          }
        },
      );
    }
  }
}
