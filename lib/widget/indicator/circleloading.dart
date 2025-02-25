import 'package:flutter/material.dart';

class CircleLoading extends StatelessWidget {
  const CircleLoading({
    this.warna = Colors.black,
    this.customizedWidth = 0,
    this.customizedHeight = 0,
    super.key,
  });

  final Color warna;
  final double customizedWidth;
  final double customizedHeight;

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
            strokeWidth: 5,
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
            strokeWidth: 5,
            color: warna,
          ),
        ),
      );
    }
  }
}
