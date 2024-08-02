import 'package:flutter/material.dart';

class CircleLoading extends StatelessWidget {
  const CircleLoading({this.warna = Colors.black, super.key});
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 30,
      child: Center(
        heightFactor: 1,
        widthFactor: 1,
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 5,
            color: warna,
          ),
        ),
      ),
    );
  }
}
