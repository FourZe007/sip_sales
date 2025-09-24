import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.borderRadius = 0.0,
    this.borderColor = Colors.black,
    this.isIcon = false,
  });

  final Image? image;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color borderColor;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    if (isIcon == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02325,
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.03,
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: image ?? const Icon(Icons.add_circle_outline_rounded),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.04,
          ),
          width: width,
          child: image ?? const Icon(Icons.add_circle_outline_rounded),
        ),
      );
    }
  }
}
