// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/state/login/login_bloc.dart';
import 'package:sip_sales/global/state/login/login_event.dart';
import 'package:sip_sales/global/state/login/login_state.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSignedIn = false;
  int accessCode = 0;

  Future<void> initializeApp(
    BuildContext context,
    SipSalesState state,
  ) async {
    // state.saveCheckInStatus(true);
    // state.saveCheckOutStatus(false);
    try {
      // await loadUserData(context, state);

      if (isSignedIn) {
        log('Access Code: $accessCode');
        if (accessCode == 2) {
          Navigator.pushReplacementNamed(context, '/menu');
        } else {
          await initializeAppData(context, state);
          Navigator.pushReplacementNamed(context, '/location');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      log('App Initialization Error: $e');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      FlutterSecureStorage().deleteAll();
      Navigator.pushReplacementNamed(context, '/login');
    }

    // await Future.delayed(const Duration(seconds: 3)).then((_) {
    //   if (isSignedIn) {
    //     Navigator.pushReplacementNamed(context, '/location');
    //   } else {
    //     Navigator.pushReplacementNamed(context, '/login');
    //   }
    // });
  }

  Future<void> loadUserData(
    BuildContext context,
    SipSalesState state,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getBool('isLoggedIn') ?? false;
    accessCode = prefs.getInt('accessCode') ?? 0;

    if (isSignedIn) {
      context.read<LoginBloc>().add(
            LoginEvent(
              context: context,
              appState: context.read<SipSalesState>(),
              id: await state.readAndWriteUserId(),
              pass: await state.readAndWriteUserPass(),
            ),
          );

      // await GlobalAPI.fetchUserAccount(
      //   await state.readAndWriteUserId(),
      //   await state.readAndWriteUserPass(),
      //   await state.generateUuid(),
      //   await state.readAndWriteDeviceConfig(),
      // ).then((res) {
      //   if (res[0].flag == 2 &&
      //       res[0].memo ==
      //           'Login by new device, please contact admin to unbind the old device') {
      //     isSignedIn = false;
      //     accessCode = res[0].code;
      //     prefs.setBool('isLoggedIn', false);
      //     log('User signed out');
      //   } else {
      //     state.setUserAccountList(res);
      //   }
      // });

      // log('User info: ${state.getUserAccountList.length}');
      // log('Load Employee Id: ${state.getUserAccountList[0].employeeID}');
    } else {
      log('User signed out');
      Navigator.pushReplacementNamed(context, '/login');
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
      log("It's Manager");
      // Note -> get Activity Insertation dropdown for Manager
      await state.fetchManagerActivityData().then((value) {
        log('Manager Activity fetch process finished');
      });
      await state.fetchManagerActivities().then((res) {
        state.setManagerActivities(res);
        log(
          'Manager activities list length: ${state.getManagerActivitiesList.length}',
        );
      });
    } else {
      log("It's Sales");
      // ~:Sales Old Activity Insertation:~
      // Note -> get Activity Insertation dropdown for Sales
      // await Provider.of<SipSalesState>(context, listen: false)
      //     .fetchSalesActivityData();

      // ~:Sales New Activity Insertation:~
      await state.getUserAttendanceHistory();
      await state.getSalesDashboard();

      // ~:Reset dropdown default value to User's placement:~
      // state.setAbsentType(state.getUserAccountList[0].locationName);

      log('User Account List: ${state.getUserAccountList.length}');
      log('Profile Picture: ${state.getProfilePicture}');
      log('Profile Picture Preview: ${state.getProfilePicturePreview}');

      if (state.getUserAccountList.isNotEmpty &&
          state.getProfilePicture.isEmpty &&
          state.getProfilePicturePreview.isEmpty) {
        log('Retrieve profile picture');
        state.setProfilePicture(state.getUserAccountList[0].profilePicture);
        try {
          await GlobalAPI.fetchShowImage(state.getUserAccountList[0].employeeID)
              .then((String highResImg) async {
            log('High Res Image state: $highResImg');
            if (highResImg == 'not available' ||
                highResImg == 'failed' ||
                highResImg == 'error') {
              state.setProfilePicturePreview('');
              await prefs.setString('highResImage', '');
              log('High Res Image is not available.');
            } else {
              state.setProfilePicturePreview(highResImg);
              await prefs.setString('highResImage', highResImg);
              log('High Res Image successfully loaded.');
              log('High Res Image: $highResImg');
            }
          });
        } catch (e) {
          log('Show HD Image Error: $e');
          state.setProfilePicturePreview('');
          await prefs.setString('highResImage', '');
        }
      } else {
        log('Skip profile picture retrieval');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // initializeApp(
    //   context,
    //   Provider.of<SipSalesState>(context, listen: false),
    // );
    loadUserData(context, Provider.of<SipSalesState>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              Provider.of<SipSalesState>(context, listen: false)
                  .setUserAccountList(state.user);
              await initializeApp(
                context,
                Provider.of<SipSalesState>(context, listen: false),
              );
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ~:Logo:~
                Image(
                  image: const AssetImage('assets/SIP.png'),
                  width: MediaQuery.of(context).size.width * 0.55,
                  fit: BoxFit.cover,
                ),

                // ~:Loading Indicator:~
                Builder(
                  builder: (context) {
                    if (Platform.isIOS) {
                      return const CupertinoActivityIndicator(
                        radius: 12,
                      );
                    } else {
                      return const CircleLoading(
                        strokeWidth: 3,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
