import 'package:flutter/material.dart';

class CircleLoading extends StatelessWidget {
  const CircleLoading({this.warna = Colors.black, super.key});
  final Color warna;

  @override
  Widget build(BuildContext context) {
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
