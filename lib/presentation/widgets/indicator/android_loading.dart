import 'package:flutter/material.dart';

class AndroidLoading extends StatelessWidget {
  const AndroidLoading({
    this.warna = Colors.black,
    this.customizedWidth = 0,
    this.customizedHeight = 0,
    this.strokeWidth = 5,
    super.key,
  });

  final Color warna;
  final double customizedWidth;
  final double customizedHeight;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    if (customizedWidth != 0 && customizedHeight != 0) {
      return Center(
        heightFactor: 1,
        widthFactor: 1,
        child: SizedBox(
          height: customizedHeight,
          width: customizedWidth,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: warna,
          ),
        ),
      );
    } else {
      return Center(
        heightFactor: 1,
        widthFactor: 1,
        child: SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: warna,
          ),
        ),
      );
    }
  }
}
