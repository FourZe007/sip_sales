// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/button/animated_phone_button.dart';
import 'package:sip_sales/widget/text/label_static.dart';

class KotakPesan extends StatelessWidget {
  const KotakPesan(this.header, this.detail,
      {this.tinggi = 0,
      this.detail2 = '',
      this.function,
      this.text = 'OK',
      super.key});

  final String header;
  final String detail;
  final String? detail2;
  final double tinggi;
  final Function? function;
  final String text;

  @override
  Widget build(BuildContext context) {
    void submit() {
      Navigator.pop(context);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: tinggi == 0 ? MediaQuery.of(context).size.height / 4 : tinggi,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [LabelStatic(header, GlobalFont.mediumfontM)],
          ),
          const Divider(
            color: Colors.black,
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            flex: 1,
            child: LabelStatic(detail, GlobalFont.mediumfontM),
          ),
          detail2 != ''
              ? Expanded(
                  flex: 1,
                  child: LabelStatic(detail2!, GlobalFont.mediumfontM),
                )
              : const SizedBox(),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedPhoneButton(
                  text,
                  function ?? submit,
                  lebar: text != 'OK'
                      ? MediaQuery.of(context).size.width * 0.4
                      : 50,
                  tinggi: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
