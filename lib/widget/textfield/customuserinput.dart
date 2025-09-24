// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_sales/global/global.dart';

class CustomUserInput extends StatefulWidget {
  CustomUserInput(
    this.handle,
    this.input, {
    this.isDataAvailable = false,
    this.isCapital = false,
    this.isNumber = false,
    this.mode = 1,
    this.hint = '',
    this.isPass = false,
    this.icon = Icons.question_mark_rounded,
    this.isIcon = false,
    this.prefixText = '',
    this.autoFocus = false,
    super.key,
  });

  bool isDataAvailable;
  bool isCapital;
  bool isNumber;
  final int mode;
  final Function handle;
  final String input;
  bool isPass;
  String hint;
  IconData icon;
  bool isIcon;
  String prefixText;
  bool autoFocus;

  @override
  State<CustomUserInput> createState() => _CustomUserInputState();
}

class _CustomUserInputState extends State<CustomUserInput>
    with AutomaticKeepAliveClientMixin<CustomUserInput> {
  TextEditingController userInputController = TextEditingController();
  TextEditingController passInputController = TextEditingController();
  bool hidePassword = true;

  void showHidePasword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isPass == false) {
      return Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          autofocus: widget.autoFocus,
          inputFormatters: [
            widget.isCapital == true
                ? UpperCaseText()
                : widget.isNumber == true
                    ? FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9.]*'))
                    : FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9.@]'),
                      ),
          ],
          controller: (widget.isDataAvailable == false)
              ? userInputController
              : TextEditingController(text: widget.input),
          enabled: widget.mode == 0 ? true : false,
          style: GlobalFont.mediumbigfontM,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.mode == 0 ? Colors.white54 : Colors.grey[400],
            contentPadding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
            ),
            hintStyle: GlobalFont.mediumbigfontM,
            hintText: 'Masukkan ${widget.hint}',
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Either the icon or text based on condition
                (widget.isIcon == false)
                    ? Text(
                        widget.prefixText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : Icon(
                        widget.icon,
                        color: Colors.black,
                      ),
              ],
            ),
          ),
          onChanged: (newValues) => widget.handle(newValues),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          autofocus: widget.autoFocus,
          controller: (widget.isDataAvailable == false)
              ? passInputController
              : TextEditingController(text: widget.input),
          obscureText: hidePassword,
          style: GlobalFont.mediumbigfontM,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white54,
            contentPadding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
            ),
            hintText: 'Masukkan ${widget.hint}',
            hintStyle: GlobalFont.mediumbigfontM,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            prefixIcon: Icon(
              widget.icon,
              size: 20,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              padding: const EdgeInsets.only(bottom: 5.0),
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.black,
              ),
              color: Theme.of(context).primaryColorDark,
              onPressed: () => showHidePasword(),
            ),
          ),
          onChanged: (newValues) => widget.handle(newValues),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class UpperCaseText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LowerCaseText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
