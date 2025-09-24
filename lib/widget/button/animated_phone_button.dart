// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

class AnimatedPhoneButton extends StatefulWidget {
  const AnimatedPhoneButton(this.namaButton, this.handle,
      {this.isIcon = false,
      this.icon = Icons.no_accounts_rounded,
      this.color = Colors.black,
      this.isLarge = false,
      this.lebar = 75,
      this.tinggi = 40,
      this.isDisabled = false,
      this.isAttendance = true,
      super.key});

  final String namaButton;
  final Function handle;
  final bool isIcon;
  final IconData icon;
  final Color color;
  final bool isLarge;
  final double lebar;
  final double tinggi;
  final bool isDisabled;
  final bool isAttendance;

  @override
  State<AnimatedPhoneButton> createState() => AnimatedPhoneButtonState();
}

class AnimatedPhoneButtonState extends State<AnimatedPhoneButton> {
  int mode = 1;

  @override
  void initState() {
    super.initState();

    log('Animated Phone Button');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isIcon == true) {
      return InkWell(
        onTap: () => widget.handle(),
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: widget.lebar,
          height: widget.tinggi,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isDisabled || !widget.isAttendance
                  ? Colors.black
                  : Colors.grey,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            color: widget.isDisabled || !widget.isAttendance
                ? widget.color
                : Colors.grey,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.025,
              ),
              Builder(
                builder: (context) {
                  if (!widget.isAttendance) {
                    return Text(
                      widget.namaButton,
                      style: GlobalFont.bigfontRWhite,
                    );
                  } else {
                    return Text(
                      widget.namaButton,
                      style: !widget.isDisabled
                          ? GlobalFont.bigfontR
                          : GlobalFont.bigfontRWhite,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () => widget.handle(),
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: widget.lebar,
          height: widget.tinggi,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isDisabled || !widget.isAttendance
                  ? Colors.black
                  : Colors.grey,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            color: widget.isDisabled || !widget.isAttendance
                ? widget.color
                : Colors.grey,
          ),
          alignment: Alignment.center,
          child: Builder(
            builder: (context) {
              if (!widget.isAttendance) {
                return Text(
                  widget.namaButton,
                  style: GlobalFont.bigfontRWhite,
                );
              } else {
                return Text(
                  widget.namaButton,
                  style: !widget.isDisabled
                      ? GlobalFont.bigfontR
                      : GlobalFont.bigfontRWhite,
                );
              }
            },
          ),
        ),
      );
    }
  }
}
