import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/textfield/customuserinput2.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = '';
  String password = '';
  String confirmation = '';

  void setUsername(String value) {
    username = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void setConfirmation(String value) {
    confirmation = value;
  }

  void createDummyAccount() {
    if (username != '' && password != '' && confirmation != '') {
      if (password != confirmation) {
        // Custom Alert Dialog for Android and iOS
        if (Platform.isIOS) {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Oops!',
            'Please check and review your input and try again.',
            () => Navigator.pop(context),
            'Dismiss',
            isIOS: true,
          );
        } else {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Oops!',
            'Please check and review your input and try again.',
            () => Navigator.pop(context),
            'Dismiss',
          );
        }
      } else {
        // Custom Alert Dialog for Android and iOS
        if (Platform.isIOS) {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'You did it!',
            'Account successfully registered, Please wait for the account creation approval.',
            () => Navigator.pop(context),
            'Dismiss',
            isIOS: true,
          );
        } else {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'You did it!',
            'Account successfully registered, Please wait for the account creation approval.',
            () => Navigator.pop(context),
            'Dismiss',
          );
        }

        Future.delayed(const Duration(seconds: 1)).then((value) {
          Navigator.pop(context);
        });
      }
    } else {
      // Custom Alert Dialog for Android and iOS
      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oops!',
          'Please check and review your input and try again.',
          () => Navigator.pop(context),
          'Dismiss',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oops!',
          'Please check and review your input and try again.',
          () => Navigator.pop(context),
          'Dismiss',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Create Account',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Create Account',
                style: GlobalFont.terafontRBold,
              ),
        leading: Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            } else {
              return IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.025,
            ),
            child: const SizedBox(),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: CustomUserInput2(
              setUsername,
              username,
              mode: 0,
              isIcon: true,
              icon: Icons.person,
              label: 'Username',
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: CustomUserInput2(
              setPassword,
              password,
              mode: 0,
              isPass: true,
              isIcon: true,
              icon: Icons.lock,
              label: 'Password',
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: CustomUserInput2(
              setConfirmation,
              confirmation,
              mode: 0,
              isPass: true,
              isIcon: true,
              icon: Icons.lock,
              label: 'Password Konfirmasi',
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
          ),
          GestureDetector(
            onTap: createDummyAccount,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.04,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // Adjust shadow color as needed
                    offset: Offset(2.0, 4.0), // Adjust shadow offset
                    blurRadius: 5.0, // Adjust shadow blur radius
                    spreadRadius: 1.0, // Adjust shadow spread radius
                  ),
                ],
              ),
              child: Text(
                'REGISTER',
                style: GlobalFont.bigfontMWhiteBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
