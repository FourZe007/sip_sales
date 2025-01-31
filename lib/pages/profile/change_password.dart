import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/status/loading_animation.dart';
import 'package:sip_sales/widget/textfield/customuserinput2.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  void setCurrentPassword(String value) {
    setState(() {
      currentPassword = value;
    });
  }

  void setNewPassword(String value) {
    setState(() {
      newPassword = value;
    });
  }

  void setConfirmPassword(String value) {
    setState(() {
      confirmPassword = value;
    });
  }

  void changePassword(
    SipSalesState state,
    String currentPass,
    String newPass,
  ) async {
    print('Change Password');
    state.setCurrentPassword(currentPass);
    state.setNewPassword(newPass);

    await state
        .fetchChangeUserPassword(state.getCurrentPassword, state.getNewPassword)
        .then((res) async {
      if (mounted) {
        state.changePasswordList.clear();
        if (res['status'] == 'success') {
          state.changePasswordList.addAll(res['data']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoadingAnimationPage(
                false,
                false,
                false,
                false,
                false,
                true,
                stateMessage: res['status'],
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoadingAnimationPage(
                false,
                false,
                false,
                false,
                false,
                true,
                stateMessage: res['status'],
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        toolbarHeight: (MediaQuery.of(context).size.width < 800)
            ? MediaQuery.of(context).size.height * 0.075
            : MediaQuery.of(context).size.height * 0.075,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Ubah Sandi',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Ubah Sandi',
                style: GlobalFont.terafontRBold,
              ),
        leading: Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            } else {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
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
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Column(
              children: [
                // ~:Header:~
                Expanded(
                  child: Wrap(
                    runSpacing: 20,
                    children: [
                      // ~:Title Section:~
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ~:Page Title:~
                          Text(
                            'Kata Sandi Baru',
                            style: GlobalFont.giantfontRBold,
                          ),

                          // ~:Page Subtitle:~
                          Builder(
                            builder: (context) {
                              if (state.getEmployeeID.isEmpty) {
                                return Text(
                                  'Buat kata sandi baru untuk akun anda.',
                                  style: GlobalFont.bigfontR,
                                );
                              } else {
                                return Text(
                                  'Buat kata sandi baru untuk akun dengan ID ${state.getEmployeeID}',
                                  style: GlobalFont.bigfontR,
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      // ~:Body Section:~
                      Wrap(
                        runSpacing: 5,
                        children: [
                          // ~:Current Password Form:~
                          CustomUserInput2(
                            setCurrentPassword,
                            currentPassword,
                            mode: 0,
                            isPass: true,
                            isIcon: true,
                            useHint: false,
                            icon: Icons.lock,
                            label: 'Kata Sandi Lama',
                            useValidator: true,
                            passDiscriminator: currentPassword,
                          ),

                          // ~:New Password Form:~
                          CustomUserInput2(
                            setNewPassword,
                            newPassword,
                            mode: 0,
                            isPass: true,
                            isIcon: true,
                            useHint: false,
                            icon: Icons.lock,
                            label: 'Kata Sandi Baru',
                            useValidator: true,
                            passDiscriminator: confirmPassword,
                          ),

                          // ~:New Password Form:~
                          CustomUserInput2(
                            setConfirmPassword,
                            confirmPassword,
                            mode: 0,
                            isPass: true,
                            isIcon: true,
                            useHint: false,
                            icon: Icons.lock,
                            label: 'Ketik Ulang Kata Sandi Baru',
                            useValidator: true,
                            passDiscriminator: newPassword,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ~:Footer - 'Ubah' Button:~
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () => changePassword(
                      state,
                      currentPassword,
                      newPassword,
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.95,
                        MediaQuery.of(context).size.height * 0.04,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.blue[300],
                    ),
                    child: Text(
                      'Ubah',
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
