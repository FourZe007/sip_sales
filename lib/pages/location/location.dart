// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import "dart:async";
import 'package:app_settings/app_settings.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/popup/kotak_pesan.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool isFake = false;
  double? longitude = 0;
  double? latitude = 0;
  Location location = Location();
  bool? attendanceStatus = false;
  bool locationPermission = false;

  bool isUserGranted = false;

  Future<bool> requestPermission(SipSalesState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    state.setIsLocationGranted(prefs.getBool('isLocationGranted')!);

    if (!state.getIsLocationGranted) {
      PermissionStatus permissionStatus;

      permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.deniedForever) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus == PermissionStatus.denied ||
            permissionStatus == PermissionStatus.deniedForever) {
          await prefs.setBool('isLocationGranted', false);
          return false;
        }
      }

      await prefs.setBool('isLocationGranted', true);
      return true;
    } else {
      await prefs.setBool('isLocationGranted', true);
      return true;
    }
  }

  Future<bool> serviceRequest() async {
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    return true;
  }

  void checkPermission(
    SipSalesState state,
    bool isAllowed,
  ) async {
    if (isAllowed) {
      if (await serviceRequest()) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        GlobalVar.nip = prefs.getString('nip');
        GlobalVar.password = prefs.getString('password');
        attendanceStatus = prefs.getBool('attendanceStatus');
        state.setIsManager(prefs.getInt('isManager'));

        if (GlobalVar.nip != '' && GlobalVar.password != '') {
          GlobalVar.userAccountList = await GlobalAPI.fetchUserAccount(
            GlobalVar.nip!,
            GlobalVar.password!,
          );
        }

        if (prefs.getInt('isManager') == 0) {
          // Note -> get Activity Insertation dropdown for Manager
          await state.fetchManagerActivityData();
        } else {
          // Note -> get Activity Insertation dropdown for Sales
          await state.fetchSalesActivityData();
        }

        state.setIsDisable(true);

        Navigator.pushReplacementNamed(context, '/menu');
      } else {
        // do nothing
        // let the user press the button until
        // the user enable the location service
      }
    } else {
      if (await requestPermission(state)) {
        if (await serviceRequest()) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          GlobalVar.nip = prefs.getString('nip');
          GlobalVar.password = prefs.getString('password');
          attendanceStatus = prefs.getBool('attendanceStatus');
          state.setIsManager(prefs.getInt('isManager')!);

          if (GlobalVar.nip != '' && GlobalVar.password != '') {
            GlobalVar.userAccountList = await GlobalAPI.fetchUserAccount(
              GlobalVar.nip!,
              GlobalVar.password!,
            );
          }

          // Note -> get Activity Insertation dropdown for Sales
          // write here for sales
          // Note -> get Activity Insertation dropdown for Manager
          state.fetchManagerActivityData();

          Navigator.pushReplacementNamed(context, '/menu');
        } else {
          // do nothing
          // let the user press the button until
          // the user enable the location service
        }
      } else {
        GlobalFunction.tampilkanDialog(
          context,
          false,
          KotakPesan(
            'WARNING',
            'Please update your permission',
            tinggi: MediaQuery.of(context).size.height * 0.2,
            text: 'Update Settings',
            function: () async {
              await AppSettings.openAppSettings();
              Navigator.pop(context);
            },
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = Provider.of<SipSalesState>(context);

    return FutureBuilder(
      future: requestPermission(locationState),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                  child: Scaffold(
                    body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.03,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              size: 80.0,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),
                            child: Text(
                              'Where are you?',
                              style: GlobalFont.mediumgigafontMBold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),
                            child: Text(
                              'Your location need to be turned on in order for this to work.',
                              style: GlobalFont.bigfontM,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          InkWell(
                            onTap: () => checkPermission(
                              locationState,
                              snapshot.data!,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: const [
                                  BoxShadow(
                                    // Adjust shadow color as needed
                                    color: Colors.grey,
                                    // Adjust shadow offset
                                    offset: Offset(2.0, 4.0),
                                    // Adjust shadow blur radius
                                    blurRadius: 5.0,
                                    // Adjust shadow spread radius
                                    spreadRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                'CONTINUE',
                                style: GlobalFont.mediumbigfontMWhiteBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                  child: Scaffold(
                    body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.03,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              size: 130.0,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),
                            child: Text(
                              'Where are you?',
                              style: GlobalFont.petafontRBold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),
                            child: Text(
                              'Your location need to be turned on in order for this to work.',
                              style: GlobalFont.gigafontR,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          InkWell(
                            onTap: () => checkPermission(
                              locationState,
                              snapshot.data!,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: const [
                                  BoxShadow(
                                    // Adjust shadow color as needed
                                    color: Colors.grey,
                                    // Adjust shadow offset
                                    offset: Offset(2.0, 4.0),
                                    // Adjust shadow blur radius
                                    blurRadius: 5.0,
                                    // Adjust shadow spread radius
                                    spreadRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                'CONTINUE',
                                style: GlobalFont.mediumgigafontRBoldWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          );
        }
      },
    );
  }
}
