// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';

class SuccessAnimationPage extends StatefulWidget {
  const SuccessAnimationPage({super.key});

  @override
  State<SuccessAnimationPage> createState() => _SuccessAnimationPageState();
}

class _SuccessAnimationPageState extends State<SuccessAnimationPage> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (canPop, _) {
        // First Approach return to Menu page
        Future.delayed(Duration.zero, () {
          Navigator.popAndPushNamed(context, state.getReturnPage);
        });

        // Second Approach return to Menu page
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   Navigator.popAndPushNamed(context, '/menu');
        // });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          toolbarHeight: 0.0,
        ),
        body: SafeArea(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.015,
              ),
              child: Column(
                children: [
                  // ~:Return Button:~
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) {
                        if (Platform.isIOS) {
                          return IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () => Navigator.popAndPushNamed(
                              context,
                              state.getReturnPage,
                            ),
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.popAndPushNamed(
                              context,
                              state.getReturnPage,
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ~:Success Animation:~
                        Lottie.asset(
                          'assets/animations/anim_success_v1.json',
                          repeat: true,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.25,
                          fit: BoxFit.contain,
                          animate: true,
                          frameRate: FrameRate.composition,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text('Error: $error'),
                            );
                          },
                        ),

                        // ~:Success Header Message:~
                        Text(
                          'Sukses!',
                          style: GlobalFont.terafontRBold,
                        ),

                        // ~:Success Description Message:~
                        Builder(
                          builder: (context) {
                            if (state.getdDisplayDescription.isNotEmpty) {
                              return Text(
                                state.getdDisplayDescription,
                                textAlign: TextAlign.center,
                                style: GlobalFont.giantfontR,
                              );
                            } else {
                              return Text(
                                '',
                                textAlign: TextAlign.center,
                                style: GlobalFont.giantfontR,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
