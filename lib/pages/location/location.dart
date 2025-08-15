// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/global.dart';
import "dart:async";
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

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
  bool locationPermission = false;

  bool isLoading = false;

  void setIsLoading() async {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<bool> requestPermission(SipSalesState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    state.setIsLocationGranted(prefs.getBool('isLocationGranted') ?? false);

    try {
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
    } catch (e) {
      await prefs.setBool('isLocationGranted', false);
      return false;
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

  // Future<void> getUserAttendanceHistory(
  //   SipSalesState state, {
  //   String startDate = '',
  //   String endDate = '',
  // }) async {
  //   try {
  //     List<ModelAttendanceHistory> temp = [];
  //     temp.clear();
  //     temp.addAll(await GlobalAPI.fetchAttendanceHistory(
  //       state.getUserAccountList[0].employeeID,
  //       startDate,
  //       endDate,
  //     ));

  //     print('Absent History list length: ${temp.length}');

  //     setState(() {
  //       state.absentHistoryList = temp;
  //     });
  //   } catch (e) {
  //     print('Fetch Attendance History failed: ${e.toString()}');
  //   }
  // }

  // Future<void> getSalesDashboard(
  //   SipSalesState state,
  // ) async {
  //   print('Get Sales Dashboard');
  //   try {
  //     print('Employee ID: ${state.getUserAccountList[0].employeeID}');
  //     print('Branch: ${state.getUserAccountList[0].branch}');
  //     print('Shop: ${state.getUserAccountList[0].shop}');
  //     await GlobalAPI.fetchSalesDashboard(
  //       state.getUserAccountList[0].employeeID,
  //       state.getUserAccountList[0].branch,
  //       state.getUserAccountList[0].shop,
  //     ).then((res) {
  //       print('Absent history: ${res.length}');
  //       state.setSalesDashboardList(res);
  //     });
  //   } catch (e) {
  //     print('Error: ${e.toString()}');
  //   }
  // }

  void checkLocationPermission(
    BuildContext context,
    SipSalesState state,
  ) async {
    // Note -> this is how to open app settings
    // await AppSettings.openAppSettings();
    setIsLoading();

    if (await serviceRequest()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // await state.generateUuid();

      // await GlobalAPI.fetchUserAccount(
      //   await state.readAndWriteUserId(),
      //   await state.readAndWriteUserPass(),
      //   await state.generateUuid(),
      // ).then((res) {
      //   state.setUserAccountList(res);
      // });

      // ~:Check is manager or sales:~
      // if (!await state.readAndWriteIsUserManager()) {
      // }

      if (prefs.getBool('isLoggedIn') ?? false) {
        // ~:Get user attendance history:~
        await state.getUserAttendanceHistory();

        // ~:Get sales dashboard:~
        await state.getSalesDashboard();
      }

      // ~:Reset all variables:~
      state.setIsDisable(true);
      state.clearState();
      setIsLoading();

      // ~:Go to home page:~
      Navigator.pushReplacementNamed(context, '/menu');
    } else {
      setIsLoading();
      // do nothing
      // let the user press the button until
      // the user enable the location service
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationState = Provider.of<SipSalesState>(context, listen: false);

    return FutureBuilder(
      future: requestPermission(locationState),
      builder: (context, snapshot) {
        if (snapshot.hasData == true) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.grey[300],
                    body: SafeArea(
                      maintainBottomViewPadding: true,
                      child: Container(
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
                                'Dimana kamu berada?',
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
                                'Lokasi Anda perlu diaktifkan agar aplikasi ini berfungsi.',
                                style: GlobalFont.bigfontM,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () => checkLocationPermission(
                                context,
                                locationState,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(25.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      // Adjust shadow color as needed
                                      color: Colors.grey,
                                      // Adjust shadow blur radius
                                      blurRadius: 5.0,
                                      // Adjust shadow spread radius
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                                child: Builder(
                                  builder: (context) {
                                    if (isLoading) {
                                      if (Platform.isIOS) {
                                        return const CupertinoActivityIndicator(
                                          radius: 10.0,
                                          color: Colors.white,
                                        );
                                      } else {
                                        return const CircleLoading(
                                          warna: Colors.white,
                                          customizedHeight: 20.0,
                                          customizedWidth: 20.0,
                                          strokeWidth: 3,
                                        );
                                      }
                                    } else {
                                      return Text(
                                        'CONTINUE',
                                        style:
                                            GlobalFont.mediumbigfontMWhiteBold,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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
                    backgroundColor: Colors.grey[300],
                    body: SafeArea(
                      maintainBottomViewPadding: true,
                      child: Container(
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
                                'Dimana kamu berada?',
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
                                'Lokasi Anda perlu diaktifkan agar aplikasi ini berfungsi.',
                                style: GlobalFont.gigafontR,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () => checkLocationPermission(
                                context,
                                locationState,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.015,
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
