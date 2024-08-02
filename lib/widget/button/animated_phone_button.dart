// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

class AnimatedPhoneButton extends StatefulWidget {
  const AnimatedPhoneButton(this.namaButton, this.handle,
      {this.isIcon = false,
      this.icon = Icons.no_accounts_rounded,
      this.color = Colors.black,
      this.isLarge = false,
      this.disable = false,
      this.lebar = 75,
      this.tinggi = 40,
      super.key});

  final String namaButton;
  final Function handle;
  final bool isIcon;
  final IconData icon;
  final Color color;
  final bool isLarge;
  final bool disable;
  final double lebar;
  final double tinggi;

  @override
  State<AnimatedPhoneButton> createState() => AnimatedPhoneButtonState();
}

class AnimatedPhoneButtonState extends State<AnimatedPhoneButton> {
  // bool disable = false;
  int mode = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('Animated Phone Button');
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
              color: widget.disable == false ? Colors.black : Colors.grey,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(
                  3.0,
                  3.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            color: widget.disable == false ? widget.color : Colors.grey,
            // color: Colors.black,
          ),
          // alignment: Alignment.center,
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
              Text(
                widget.namaButton,
                style: widget.disable == true
                    ? GlobalFont.bigfontR
                    : GlobalFont.bigfontRWhite,
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
              color: widget.disable == false ? Colors.black : Colors.grey,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(
                  3.0,
                  3.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            color: widget.disable == false ? widget.color : Colors.grey,
            // color: Colors.black,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.namaButton,
            style: widget.disable == true
                ? GlobalFont.bigfontR
                : GlobalFont.bigfontRWhite,
          ),
        ),
      );
    }
  }
}
