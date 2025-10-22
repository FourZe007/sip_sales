import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

// ignore: must_be_immutable
class TextSwitch extends StatelessWidget {
  TextSwitch(
    this.number,
    this.text,
    this.value,
    this.function, {
    this.isLinkAvailable = false,
    this.link = '',
    this.linkFunction,
    super.key,
  });

  String number;
  String text;
  bool value;
  ValueSetter<bool> function;
  bool isLinkAvailable;
  String link;
  ValueSetter? linkFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        // ~:Consent Text:~
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: TextThemes.normalTextButton,
              ),
              Expanded(
                flex: 6,
                child: Builder(
                  builder: (context) {
                    if (isLinkAvailable) {
                      return Column(
                        children: [
                          Text(
                            text,
                            style: TextThemes.normalTextButton,
                          ),
                          InkWell(
                            onTap: () => linkFunction!(context),
                            child: Text(
                              link,
                              style: TextThemes.normalTextButton.copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(
                        text,
                        style: TextThemes.normalTextButton,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // ~:Switch:~
        Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return CupertinoSwitch(
                value: value,
                onChanged: function,
              );
            } else {
              return Switch(
                value: value,
                onChanged: function,
                activeTrackColor: Colors.blue[800],
              );
            }
          },
        ),
      ],
    );
  }
}
