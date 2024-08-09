// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
// import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import "dart:async";
import 'package:app_settings/app_settings.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/popup/kotak_pesan.dart';

// import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // Function -> State variable to track foreground service
  // bool isForegroundServiceActive = false;

  // bool isAllow = false;
  bool isFake = false;
  double? longitude = 0;
  double? latitude = 0;
  // late Position currentPosition;
  Location location = Location();
  bool? attendanceStatus = false;
  bool locationPermission = false;

  bool isUserGranted = false;

  // Delete -> remove later
  // void openAppSettings() async {
  //   await AppSettings.openAppSettings();
  // }
  // void checkUser(SipSalesState state) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   GlobalVar.nip = prefs.getString('nip');
  //   GlobalVar.password = prefs.getString('password');
  //   attendanceStatus = prefs.getBool('attendanceStatus');
  //   state.setIsManager(true);
  //
  //   // Delete -> remove this source code if it's not used
  //   // Later -> move to the correct position
  //   // await prefs.setBool('isForegroundServiceActive', true);
  //
  //   if (GlobalVar.nip != '' && GlobalVar.password != '') {
  //     GlobalVar.userAccountList = await GlobalAPI.fetchUserAccount(
  //       GlobalVar.nip!,
  //       GlobalVar.password!,
  //     );
  //   }
  //
  //   if (attendanceStatus == true) {
  //     Navigator.pushReplacementNamed(context, '/menu');
  //   }
  // }
  // void onLocation() async {
  //   Position locationCoordinate = await Geolocator.getCurrentPosition();
  //   longitude = locationCoordinate.longitude;
  //   latitude = locationCoordinate.latitude;
  //
  //   // Process the location data here (e.g., store in a database, send to server)
  //   print("Received location in background: $latitude, $longitude");
  // }
  // Future<void> configureBackgroundGeolocation() async {
  //   background_location.BackgroundGeolocation.ready(background_location.Config(
  //     desiredAccuracy: background_location.Config.DESIRED_ACCURACY_HIGH,
  //     stationaryRadius: 50.0,
  //     distanceFilter: 10.0,
  //     stopOnTerminate: false, // keep tracking in background
  //     startOnBoot: true,
  //     logLevel: background_location.Config.LOG_LEVEL_VERBOSE,
  //   )).then((background_location.State state) {
  //     // if (!state.enabled) {}
  //     background_location.BackgroundGeolocation.start();
  //   });
  // }

  Future<bool> requestPermission(SipSalesState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    state.setIsLocationGranted(prefs.getBool('isLocationGranted')!);

    if (!state.getIsLocationGranted) {
      // Delete -> remove later
      // bool serviceEnabled;
      PermissionStatus permissionStatus;

      // Delete -> remove later
      // bool? permission = prefs.getBool('locationPermission');

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

      // Delete -> remove later
      // serviceEnabled = await location.serviceEnabled();
      // if (!serviceEnabled) {
      //   serviceEnabled = await location.requestService();
      //   if (!serviceEnabled) {
      //     return false;
      //   }
      // }

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

  // void prominentDisclosure(bool value, SipSalesState state) async {
  //   isUserGranted = value;
  //
  //   if (!isUserGranted) {
  //     Navigator.of(context).pop();
  //
  //     GlobalFunction.tampilkanDialog(
  //       context,
  //       true,
  //       Container(
  //         height: MediaQuery.of(context).size.height * 0.25,
  //         padding: EdgeInsets.symmetric(
  //           horizontal: MediaQuery.of(context).size.width * 0.01,
  //           vertical: MediaQuery.of(context).size.height * 0.01,
  //         ),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20.0),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               'SIP Sales Location Care',
  //               style: GlobalFont.giantfontRBold,
  //             ),
  //             const SizedBox(height: 20),
  //             Text(
  //               'Please make sure you accept the Location Care in order to maximize the App Performance',
  //               style: GlobalFont.mediumgiantfontR,
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: 30),
  //             Text(
  //               'Tap anywhere to dismiss.',
  //               style: GlobalFont.mediumbigfontR,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   } else {
  //     Navigator.of(context).pop();
  //
  //     if (await serviceRequest()) {
  //       final SharedPreferences prefs = await SharedPreferences.getInstance();
  //       GlobalVar.nip = prefs.getString('nip');
  //       GlobalVar.password = prefs.getString('password');
  //       attendanceStatus = prefs.getBool('attendanceStatus');
  //       state.setIsManager(prefs.getInt('isManager'));
  //
  //       if (GlobalVar.nip != '' && GlobalVar.password != '') {
  //         GlobalVar.userAccountList = await GlobalAPI.fetchUserAccount(
  //           GlobalVar.nip!,
  //           GlobalVar.password!,
  //         );
  //       }
  //
  //       if (prefs.getInt('isManager') == 0) {
  //         // Note -> get Activity Insertation dropdown for Manager
  //         print('fetch manager activity data');
  //         await state.fetchManagerActivityData();
  //       } else {
  //         // Note -> get Activity Insertation dropdown for Sales
  //         print('fetch sales activity data');
  //         await state.fetchSalesActivityData();
  //       }
  //
  //       Navigator.pushReplacementNamed(context, '/menu');
  //     } else {
  //       // do nothing
  //       // let the user press the button until
  //       // the user enable the location service
  //     }
  //   }
  // }

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
          // print('fetch manager activity data');
          await state.fetchManagerActivityData();
        } else {
          // Note -> get Activity Insertation dropdown for Sales
          // print('fetch sales activity data');
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
    // checkUser();
    // WidgetsBinding.instance.addObserver(this);
    // configureBackgroundGeolocation();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (state == AppLifecycleState.paused) {
  //     print('Entering Background');
  //     // App entering background
  //     setState(() {
  //       isForegroundServiceActive = false;
  //     });
  //     await prefs.setBool('isForegroundServiceActive', false);
  //
  //     // setState(() async {
  //     //   // App entering background
  //     //   isForegroundServiceActive = false;
  //     //   await prefs.setBool('isForegroundServiceActive', false);
  //     //
  //     //   // await GlobalAPI.fetchSendOTP(
  //     //   //   '6281338518880',
  //     //   //   'isForegroundServiceActive: $isForegroundServiceActive',
  //     //   //   'realme-tab',
  //     //   //   'text',
  //     //   // );
  //     // });
  //   } else if (state == AppLifecycleState.resumed) {
  //     print('Entering Foreground');
  //     // App returning to foreground
  //     setState(() {
  //       isForegroundServiceActive = true;
  //     });
  //     await prefs.setBool('isForegroundServiceActive', true);
  //
  //     // setState(() async {
  //     //   // App returning to foreground
  //     //   isForegroundServiceActive = true;
  //     //   await prefs.setBool('isForegroundServiceActive', true);
  //     //
  //     //   // await GlobalAPI.fetchSendOTP(
  //     //   //   '6281338518880',
  //     //   //   'isBackgroundServiceActive: $isForegroundServiceActive',
  //     //   //   'realme-tab',
  //     //   //   'text',
  //     //   // );
  //     // });
  //   }
  // }

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
                                // 'ENABLE LOCATION',
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
                                // 'ENABLE LOCATION',
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
