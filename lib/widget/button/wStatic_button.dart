import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaticButton extends StatelessWidget {
  const StaticButton(
    this.func,
    this.logo,
    this.name, {
    super.key,
  });

  final Function func;
  final IconData logo;
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        width: 180,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              logo,
              color: Colors.blue,
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}
