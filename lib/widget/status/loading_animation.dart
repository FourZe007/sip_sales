// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';

class LoadingAnimationPage extends StatefulWidget {
  const LoadingAnimationPage(this.isWarning, this.isClockIn, {super.key});

  final bool isWarning;
  final bool isClockIn;

  @override
  State<LoadingAnimationPage> createState() => _LoadingAnimationPageState();
}

class _LoadingAnimationPageState extends State<LoadingAnimationPage> {
  Future<void> processing(BuildContext context) async {
    final state = Provider.of<SipSalesState>(context, listen: false);
    if (widget.isClockIn) {
      state.checkIn(context);
    } else {
      state.checkOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          toolbarHeight: 0.0,
        ),
        body: SafeArea(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.yellow,
            ),
            child: FutureBuilder(
              future: processing(context),
              builder: (context, snapshot) {
                return Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ~:Loading Animation:~
                      Lottie.asset(
                        'assets/animations/anim_loading_v1.json',
                        repeat: true,
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.contain,
                        animate: true,
                        frameRate: FrameRate.composition,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text('Error: $error'),
                          );
                        },
                      ),

                      // ~:Loading Message:~
                      Text(
                        'Loading...',
                        textAlign: TextAlign.center,
                        style: GlobalFont.giantfontR,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
