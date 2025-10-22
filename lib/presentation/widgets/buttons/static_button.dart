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
        // width: MediaQuery.of(context).size.width * 0.35,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              logo,
              color: Colors.blue,
              size: 26,
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Rubik',
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
