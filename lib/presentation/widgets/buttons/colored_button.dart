// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class ColoredButton extends StatefulWidget {
  const ColoredButton(
    this.handle,
    this.buttonName, {
    this.isCancel = false,
    this.isIpad = false,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback handle;
  final String buttonName;
  final bool isCancel;
  final bool isIpad;
  final bool isLoading;

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
          onPressed: widget.handle,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
              side: BorderSide(
                color: Colors.blue[300]!,
                width: 3.0,
              ),
            ),
            backgroundColor: widget.isCancel == false
                ? Colors.white
                : Colors.blue[300],
          ),
          child: Builder(
            builder: (context) {
              if (widget.isLoading) {
                return BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LogoutFailed) {
                      Functions.customFlutterToast(state.message);
                    } else if (state is LogoutSuccess) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LogoutLoading) {
                      if (Platform.isIOS) {
                        return const CupertinoActivityIndicator(
                          radius: 10.0,
                          color: Colors.black,
                        );
                      } else {
                        return const AndroidLoading(
                          warna: Colors.black,
                          customizedHeight: 20.0,
                          customizedWidth: 20.0,
                          strokeWidth: 3,
                        );
                      }
                    } else {
                      return Text(
                        widget.buttonName,
                        style: TextThemes.normal.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.clip,
                      );
                    }
                  },
                );
              } else {
                return Text(
                  widget.buttonName,
                  style: TextThemes.normal.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip,
                );
              }
            },
          ),
        ),
      );
    } else {
      return Container(
        width: 160,
        height: 70,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015,
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
        child: ElevatedButton(
          onPressed: () => widget.handle(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
              side: BorderSide(
                color: Colors.blue[300]!,
                width: 3.0,
              ),
            ),
            backgroundColor: widget.isCancel == false
                ? Colors.white
                : Colors.blue[300],
          ),
          child: Builder(
            builder: (context) {
              if (widget.isLoading) {
                return BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LogoutFailed) {
                      Functions.customFlutterToast(state.message);
                    } else if (state is LogoutSuccess) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LogoutLoading) {
                      if (Platform.isIOS) {
                        return const CupertinoActivityIndicator(
                          radius: 10.0,
                          color: Colors.black,
                        );
                      } else {
                        return const AndroidLoading(
                          warna: Colors.black,
                          customizedHeight: 20.0,
                          customizedWidth: 20.0,
                          strokeWidth: 3,
                        );
                      }
                    } else {
                      return Text(
                        widget.buttonName,
                        style: TextThemes.normal.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.clip,
                      );
                    }
                  },
                );
              } else {
                return Text(
                  widget.buttonName,
                  style: TextThemes.normal.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip,
                );
              }
            },
          ),
        ),
      );
    }
  }
}
