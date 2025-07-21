// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/widget/status/failure_animation.dart';
import 'package:sip_sales/widget/status/success_animation.dart';
import 'package:sip_sales/widget/status/warning_animation.dart';

class LoadingAnimationPage extends StatefulWidget {
  const LoadingAnimationPage(
    this.isEventPhotoUploaded,
    this.isClockIn,
    this.isClockOut,
    this.isEventClockIn,
    this.isProfileUploaded,
    this.isChangePassword, {
    this.stateMessage = '',
    super.key,
  });

  final bool isEventPhotoUploaded;
  final bool isClockIn;
  final bool isClockOut;
  final bool isEventClockIn;
  final bool isProfileUploaded;
  final bool isChangePassword;
  final String stateMessage;

  @override
  State<LoadingAnimationPage> createState() => _LoadingAnimationPageState();
}

class _LoadingAnimationPageState extends State<LoadingAnimationPage> {
  Future<void> processing(BuildContext context) async {
    print('Loading Animation Process');
    final state = Provider.of<SipSalesState>(context, listen: false);
    // ~:Event Photo:~
    if (widget.isEventPhotoUploaded) {
      await state.uploadImageFromCamera(context).then((isUploaded) {
        if (isUploaded) {
          state.setEventPhoto(state.getFilteredList[0]);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SuccessAnimationPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FailureAnimationPage(),
            ),
          );
        }
      });
    }

    // ~:Profile Picture:~
    if (widget.isProfileUploaded) {
      print('Upload Profile Picture Process');
      await state.uploadProfilePicture(context).then((status) {
        if (status == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SuccessAnimationPage(),
            ),
          );
        } else if (status == 'failed') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FailureAnimationPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WarningAnimationPage(),
            ),
          );
        }
      });
    } else {
      print('Skip Profile Picture Upload Process');
    }

    // ~:User Absent - Clock In:~
    if (widget.isClockIn) {
      print('Clock In Process');
      await state.checkIn(context).then((status) {
        if (status == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SuccessAnimationPage(),
            ),
          );
        } else if (status == 'warn') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WarningAnimationPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FailureAnimationPage(),
            ),
          );
        }
      });
    } else {
      print('Skip Clock In Process');
    }

    // ~:User Absent - Clock Out:~
    if (widget.isClockOut) {
      print('Clock Out Process');
      await state.checkOut(context).then((status) {
        if (status == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SuccessAnimationPage(),
            ),
          );
        } else if (status == 'warn') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WarningAnimationPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FailureAnimationPage(),
            ),
          );
        }
      });
    } else {
      print('Skip Clock Out Process');
    }

    // ~:Event Clock In:~
    if (widget.isEventClockIn) {
      await Future.delayed(Duration(seconds: 3)).then((_) {
        if (widget.stateMessage == 'success') {
          print('Event clock in succeed');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessAnimationPage(),
            ),
          );
        } else if (widget.stateMessage == 'failed') {
          print('Event clock in failed');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FailureAnimationPage(),
            ),
          );
        } else {
          print('Something wrong with event clock in');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WarningAnimationPage(),
            ),
          );
        }
      });
    } else {
      print('Skip Event Clock In Process');
    }

    // ~:Change Password:~
    if (widget.isChangePassword) {
      print('Change Password');
      await Future.delayed(Duration(seconds: 3)).then((_) {
        if (widget.stateMessage == 'success') {
          print('Change succeed');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessAnimationPage(),
            ),
          );
        } else if (widget.stateMessage == 'failed') {
          print('Change failed');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FailureAnimationPage(),
            ),
          );
        } else {
          print('Something wrong with Change');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WarningAnimationPage(),
            ),
          );
        }
      });
    } else {
      print('Skip Change Password Process');
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
