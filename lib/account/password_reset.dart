import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sip_sales/widget/status/failure_animation.dart';
import 'package:sip_sales/widget/status/success_animation.dart';
import 'package:sip_sales/widget/status/warning_animation.dart';
import 'package:sip_sales/widget/textfield/customuserinput2.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  bool isLoading = false;
  String id = '';

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void setId(String value) {
    setState(() {
      id = value;
    });
  }

  Future<void> createPasswordReset(
    SipSalesState state,
    String id,
  ) async {
    if (id.isEmpty) {
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Peringatan!',
        'NIP anda kosong, pastikan NIP terisi.',
        () => Navigator.pop(context),
        'Tutup',
        isIOS: Platform.isIOS ? true : false,
      );
    } else {
      try {
        setIsLoading();
        // ~:API communication:~
        await state.passwordResetProcess(id).then((res) {
          setIsLoading();
          if (res == 'success') {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuccessAnimationPage(),
                ),
              );
            }
          } else if (res == 'warn') {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WarningAnimationPage(),
                ),
              );
            }
          } else if (res == 'failed') {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FailureAnimationPage(),
                ),
              );
            }
          } else if (res == 'error') {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FailureAnimationPage(),
                ),
              );
            }
          } else {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WarningAnimationPage(),
                ),
              );
            }
          }
        });
      } catch (e) {
        print('Error: $e');
        state.setDisplayDescription(e.toString());
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FailureAnimationPage(),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Password Reset',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Password Reset',
                style: GlobalFont.terafontRBold,
              ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            (Platform.isIOS)
                ? Icons.arrow_back_ios_new_rounded
                : Icons.arrow_back_rounded,
            size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.blue),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.075,
              MediaQuery.of(context).size.height * 0.04,
              MediaQuery.of(context).size.width * 0.075,
              MediaQuery.of(context).size.height * 0.0125,
            ),
            child: Column(
              children: [
                // ~:Body:~
                Expanded(
                  child: Wrap(
                    runSpacing: 25,
                    children: [
                      // ~:Page Title:~
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Pengajuan',
                            style: GlobalFont.giantfontRBold,
                          ),
                          Text(
                            'Masukkan informasi lengkap terkait reset password.',
                            style: GlobalFont.bigfontR,
                          ),
                        ],
                      ),

                      Wrap(
                        runSpacing: 10,
                        children: [
                          // ~:Page Content:~
                          CustomUserInput2(
                            setId,
                            id,
                            mode: 0,
                            isIcon: true,
                            icon: Icons.phone_rounded,
                            label: 'NIP karyawan',
                            isCapital: true,
                          ),

                          // ~:Additional Note:~
                          Text(
                            'Note: pastikan NIP yang diinputkan sesuai dengan NIP yang terdaftar di SIP.',
                            style: GlobalFont.bigfontRGrey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ~:Footer:~
                // Submit Button
                ElevatedButton(
                  onPressed: () => createPasswordReset(state, id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      if (isLoading) {
                        if (Platform.isIOS) {
                          return CupertinoActivityIndicator(
                            radius: 12.5,
                            color: Colors.black,
                          );
                        } else {
                          return const CircleLoading(
                            warna: Colors.black,
                          );
                        }
                      } else {
                        return Text(
                          'Kirim',
                          style: GlobalFont.mediumgiantfontR,
                        );
                      }
                    },
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
