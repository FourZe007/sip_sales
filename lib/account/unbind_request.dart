import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sip_sales/widget/status/failure_animation.dart';
import 'package:sip_sales/widget/status/success_animation.dart';
import 'package:sip_sales/widget/status/warning_animation.dart';
import 'package:sip_sales/widget/textfield/adjustabledescbox.dart';
import 'package:sip_sales/widget/textfield/customuserinput2.dart';

class UnbindRequestPage extends StatefulWidget {
  const UnbindRequestPage({super.key});

  @override
  State<UnbindRequestPage> createState() => _UnbindRequestPageState();
}

class _UnbindRequestPageState extends State<UnbindRequestPage> {
  String eId = '';
  bool isLoading = false;

  void setEmployeeId(String value) {
    setState(() {
      eId = value;
    });
  }

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> createUnbindRequest(
    BuildContext context,
    SipSalesState state,
    String eId,
  ) async {
    if (state.getUnbindReqTextController.text.isEmpty && eId.isEmpty) {
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Peringatan!',
        'Mohon periksa kembali input anda.',
        () => Navigator.pop(context),
        'Tutup',
        isIOS: Platform.isIOS ? true : false,
      );
    } else {
      setIsLoading();
      // ~:API communication:~
      await state.processUnbindRequest(eId).then((res) async {
        setIsLoading();
        if (res == 'success') {
          state.setIsAccLocked(false);
          if (context.mounted) {
            // ~:Navigate to animation page:~
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessAnimationPage(),
              ),
            );
          }
        } else if (res == 'warn') {
          state.setIsAccLocked(true);
          if (context.mounted) {
            // ~:Navigate to animation page:~
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WarningAnimationPage(),
              ),
            );
          }
        } else {
          state.setIsAccLocked(true);
          if (context.mounted) {
            // ~:Navigate to animation page:~
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FailureAnimationPage(),
              ),
            );
          }
        }
      });
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
                'Unbind Request',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Unbind Request',
                style: GlobalFont.terafontRBold,
              ),
        leading: Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            } else {
              return IconButton(
                onPressed: () => Navigator.pop(context),
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
                            'Detail Request',
                            style: GlobalFont.giantfontRBold,
                          ),
                          Text(
                            'Masukkan informasi terkait request unbind dengan lengkap.',
                            style: GlobalFont.bigfontR,
                          ),
                        ],
                      ),

                      // ~:Page Content:~
                      Wrap(
                        runSpacing: 15,
                        children: [
                          // ~:Employee ID:~
                          CustomUserInput2(
                            setEmployeeId,
                            eId,
                            mode: 0,
                            isIcon: true,
                            icon: Icons.person,
                            label: 'NIP Karyawan',
                            isCapital: true,
                            // autoFocus: true,
                          ),

                          // ~:Reason why user need to unbind their acc:~
                          AdjustableDescBox(
                            state.unbindReqTextController,
                            isPrefixUsed: true,
                            prefixIcon: Icons.description_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ~:Footer:~
                // Submit Button
                ElevatedButton(
                  onPressed: () => createUnbindRequest(context, state, eId),
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
                          'Buat',
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
