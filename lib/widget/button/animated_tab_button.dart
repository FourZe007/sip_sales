// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

class AnimatedTabButton extends StatefulWidget {
  const AnimatedTabButton(this.namaButton, this.handle,
      {this.isIcon = false,
      this.icon = Icons.no_accounts_rounded,
      this.color = Colors.black,
      this.isCustom = false,
      this.textStyle = const TextStyle(),
      this.disable = false,
      this.lebar = 75,
      this.tinggi = 40,
      super.key});

  final String namaButton;
  final Function handle;
  final bool isIcon;
  final IconData icon;
  final Color color;
  final bool isCustom;
  final TextStyle textStyle;
  final bool disable;
  final double lebar;
  final double tinggi;

  @override
  State<AnimatedTabButton> createState() => AnimatedTabButtonState();
}

class AnimatedTabButtonState extends State<AnimatedTabButton> {
  int mode = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('Animated Tab Button');
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
            color: widget.color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 42.5,
                color: Colors.white,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.025,
              ),
              Text(
                widget.namaButton,
                style: widget.isCustom == true
                    ? widget.textStyle
                    : GlobalFont.gigafontRBoldWhite,
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
            color: widget.color,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.namaButton,
            style: widget.isCustom == true
                ? widget.textStyle
                : GlobalFont.gigafontRBoldWhite,
          ),
        ),
      );
    }
  }
}
