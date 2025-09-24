// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/text/custom_text.dart';

class CustomUserInput2 extends StatefulWidget {
  CustomUserInput2(
    this.handle,
    this.input, {
    this.isExpandable = false,
    this.isDataAvailable = false,
    this.isCapital = false,
    this.isNumber = false,
    this.mode = 1,
    this.label = '',
    this.useHint = true,
    this.isPass = false,
    this.icon = Icons.question_mark_rounded,
    this.isIcon = false,
    this.prefixText = '',
    this.autoFocus = false,
    this.useValidator = false,
    this.passDiscriminator = '',
    super.key,
  });

  bool isExpandable;
  bool isDataAvailable;
  bool isCapital;
  bool isNumber;
  final int mode;
  final Function handle;
  final String input;
  bool isPass;
  String label;
  bool useHint;
  IconData icon;
  bool isIcon;
  String prefixText;
  bool autoFocus;
  bool useValidator;
  String passDiscriminator;

  @override
  State<CustomUserInput2> createState() => _CustomUserInput2State();
}

class _CustomUserInput2State extends State<CustomUserInput2>
    with AutomaticKeepAliveClientMixin<CustomUserInput2> {
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
    if (!widget.isPass) {
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005,
        ),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          maxLines: widget.isExpandable == true ? null : 1,
          autofocus: widget.autoFocus,
          inputFormatters: widget.isCapital
              // ? UpperCaseText()
              ? [
                  UpperCaseText(),
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9/-]'),
                  ),
                ]
              : widget.isNumber
                  ? [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?[0-9.]*'),
                      ),
                    ]
                  : [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9./@]*'),
                      ),
                    ],
          textCapitalization: widget.isCapital
              ? TextCapitalization.characters
              : TextCapitalization.none,
          controller: (widget.isDataAvailable == false)
              ? userInputController
              : TextEditingController(text: widget.input),
          enabled: widget.mode == 0 ? true : false,
          style: TextStyle(
            color: Colors.black,
            fontFamily: GlobalFontFamily.fontMontserrat,
            fontSize: MediaQuery.of(context).size.width * 0.0315,
            backgroundColor: Colors.transparent,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.mode == 0 ? Colors.white54 : Colors.grey[400],
            contentPadding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
            ),
            hintStyle: TextStyle(
              color: Colors.black,
              fontFamily: GlobalFontFamily.fontMontserrat,
              fontSize: MediaQuery.of(context).size.width * 0.0315,
              backgroundColor: Colors.transparent,
            ),
            hintText: 'Masukkan ${widget.label}',
            labelText: widget.label,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Either the icon or text based on condition
                (widget.isIcon == false)
                    ? CustomText(
                        widget.prefixText,
                        align: TextAlign.center,
                        isBold: true,
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
      if (widget.useValidator) {
        return Container(
          height: 80,
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.005,
          ),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.length < 6) {
                return 'Kata sandi harus lebih dari 6 karakter.';
              } else if (value != widget.passDiscriminator) {
                return 'Kata sandi berbeda.';
              }
              return '';
            },
            maxLines: widget.isExpandable == true ? null : 1,
            autofocus: widget.autoFocus,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9./@]*'),
              ),
            ],
            controller: (widget.isDataAvailable == false)
                ? passInputController
                : TextEditingController(text: widget.input),
            obscureText: hidePassword,
            style: TextStyle(
              color: Colors.black,
              fontFamily: GlobalFontFamily.fontMontserrat,
              fontSize: MediaQuery.of(context).size.width * 0.0315,
              backgroundColor: Colors.transparent,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white54,
              contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
              ),
              hintText: (widget.useHint) ? 'Masukkan ${widget.label}' : '',
              labelText: widget.label,
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: GlobalFontFamily.fontMontserrat,
                fontSize: MediaQuery.of(context).size.width * 0.0315,
                backgroundColor: Colors.transparent,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Either the icon or text based on condition
                  Builder(
                    builder: (context) {
                      if (widget.isIcon) {
                        return Icon(
                          widget.icon,
                          color: Colors.black,
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(bottom: 5.0),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: Colors.grey,
                ),
                color: Theme.of(context).primaryColorDark,
                onPressed: () => showHidePasword(),
              ),
            ),
            onChanged: (newValues) => widget.handle(newValues),
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.005,
          ),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            maxLines: widget.isExpandable == true ? null : 1,
            autofocus: widget.autoFocus,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9./@]*'),
              ),
            ],
            controller: (widget.isDataAvailable == false)
                ? passInputController
                : TextEditingController(text: widget.input),
            obscureText: hidePassword,
            style: TextStyle(
              color: Colors.black,
              fontFamily: GlobalFontFamily.fontMontserrat,
              fontSize: MediaQuery.of(context).size.width * 0.0315,
              backgroundColor: Colors.transparent,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white54,
              contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
              ),
              hintText: (widget.useHint) ? 'Masukkan ${widget.label}' : '',
              labelText: widget.label,
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: GlobalFontFamily.fontMontserrat,
                fontSize: MediaQuery.of(context).size.width * 0.0315,
                backgroundColor: Colors.transparent,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Either the icon or text based on condition
                  Builder(
                    builder: (context) {
                      if (widget.isIcon) {
                        return Icon(
                          widget.icon,
                          color: Colors.black,
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(bottom: 5.0),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: Colors.grey,
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
