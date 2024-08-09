// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

class ColoredButton extends StatefulWidget {
  ColoredButton(this.handle, this.buttonName,
      {this.isCancel = false, this.isIpad = false, super.key});

  Function handle;
  String buttonName;
  bool isCancel;
  bool isIpad;

  @override
  State<ColoredButton> createState() => _ColoredButtonState();
}

class _ColoredButtonState extends State<ColoredButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.isIpad == true) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.075,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015,
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
        child: ElevatedButton(
          onPressed: () => widget.handle(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: Colors.blue[300]!,
                width: 3.0,
              ),
            ),
            backgroundColor:
                widget.isCancel == false ? Colors.white : Colors.blue[300],
          ),
          child: Text(
            widget.buttonName,
            style: GlobalFont.mediumgigafontMBold,
            overflow: TextOverflow.clip,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015,
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
        child: ElevatedButton(
          onPressed: () => widget.handle(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: Colors.blue[300]!,
                width: 3.0,
              ),
            ),
            backgroundColor:
                widget.isCancel == false ? Colors.white : Colors.blue[300],
          ),
          child: Text(
            widget.buttonName,
            style: GlobalFont.mediumgiantfontRBold,
            overflow: TextOverflow.clip,
          ),
        ),
      );
    }
  }
}
