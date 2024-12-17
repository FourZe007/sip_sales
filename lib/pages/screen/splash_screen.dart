// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    state.saveCheckInStatus(true);
    state.saveCheckOutStatus(false);

    await Future.wait([
      loadUserData(),
      initializeAppData(context),
    ]);

    await Future.delayed(const Duration(seconds: 3)).then((_) {
      if (isSignedIn) {
        Navigator.pushReplacementNamed(context, '/location');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = (prefs.getInt('flag') ?? 0) == 1 ? true : false;
  }

  Future<void> initializeAppData(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getInt('isManager') ?? 0) == 0) {
      // Note -> get Activity Insertation dropdown for Manager
      await Provider.of<SipSalesState>(context, listen: false)
          .fetchManagerActivityData();
    } else {
      // Note -> get Activity Insertation dropdown for Sales
      await Provider.of<SipSalesState>(context, listen: false)
          .fetchSalesActivityData();
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
