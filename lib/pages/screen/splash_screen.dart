// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSignedIn = false;

  Future<void> initializeApp(SipSalesState state) async {
    // state.saveCheckInStatus(true);
    // state.saveCheckOutStatus(false);
    try {
      await loadUserData(state);
      await initializeAppData(context, state);

      if (isSignedIn) {
        Navigator.pushReplacementNamed(context, '/location');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Error: $e');
    }

    // await Future.delayed(const Duration(seconds: 3)).then((_) {
    //   if (isSignedIn) {
    //     Navigator.pushReplacementNamed(context, '/location');
    //   } else {
    //     Navigator.pushReplacementNamed(context, '/login');
    //   }
    // });
  }

  Future<void> loadUserData(SipSalesState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isSignedIn) {
      await GlobalAPI.fetchUserAccount(
        await state.readAndWriteUserId(),
        await state.readAndWriteUserPass(),
        await state.generateUuid(),
      ).then((res) {
        if (res[0].flag == 2 &&
            res[0].memo ==
                'Login by new device, please contact admin to unbind the old device') {
          isSignedIn = false;
          prefs.setBool('isLoggedIn', false);
          print('User signed out');
        } else {
          state.setUserAccountList(res);
        }
      });

      print('User info: ${state.getUserAccountList.length}');
    } else {
      print('User signed out');
    }

    // if (prefs.getString('highResImage') != null) {
    //   if (prefs.getString('highResImage')!.isNotEmpty) {
    //     print('highResImage is not empty');
    //     state.setProfilePicture(prefs.getString('highResImage')!);
    //   } else {
    //     print('highResImage is empty');
    //   }
    // }
  }

  Future<void> initializeAppData(
    BuildContext context,
    SipSalesState state,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await state.readAndWriteIsUserManager()) {
      print('Manager');
      // Note -> get Activity Insertation dropdown for Manager
      await Provider.of<SipSalesState>(context, listen: false)
          .fetchManagerActivityData();
    } else {
      print('Sales');
      // ~:Sales Old Activity Insertation:~
      // Note -> get Activity Insertation dropdown for Sales
      // await Provider.of<SipSalesState>(context, listen: false)
      //     .fetchSalesActivityData();

      // ~:Sales New Activity Insertation:~
      await state.getUserAttendanceHistory();
      await state.getSalesDashboard();

      // ~:Reset dropdown default value to User's placement:~
      // state.setAbsentType(state.getUserAccountList[0].locationName);

      print('User Account List: ${state.getUserAccountList.length}');
      print('Profile Picture: ${state.getProfilePicture}');
      print('Profile Picture Preview: ${state.getProfilePicturePreview}');

      if (state.getUserAccountList.isNotEmpty &&
          state.getProfilePicture.isEmpty &&
          state.getProfilePicturePreview.isEmpty) {
        print('Retrieve profile picture');
        state.setProfilePicture(state.getUserAccountList[0].profilePicture);
        try {
          await GlobalAPI.fetchShowImage(state.getUserAccountList[0].employeeID)
              .then((String highResImg) async {
            print('High Res Image state: $highResImg');
            if (highResImg == 'not available' ||
                highResImg == 'failed' ||
                highResImg == 'error') {
              state.setProfilePicturePreview('');
              await prefs.setString('highResImage', '');
              print('High Res Image is not available.');
            } else {
              state.setProfilePicturePreview(highResImg);
              await prefs.setString('highResImage', highResImg);
              print('High Res Image successfully loaded.');
              print('High Res Image: $highResImg');
            }
          });
        } catch (e) {
          print('Show HD Image Error: $e');
          state.setProfilePicturePreview('');
          await prefs.setString('highResImage', '');
        }
      } else {
        print('Skip profile picture retrieval');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    initializeApp(Provider.of<SipSalesState>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('assets/SIP.png'),
              width: MediaQuery.of(context).size.width * 0.55,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            (Platform.isIOS)
                ? const CupertinoActivityIndicator(
                    radius: 12.5,
                  )
                : const CircleLoading(),
          ],
        ),
      ),
    );
  }
}
