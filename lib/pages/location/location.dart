// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import "dart:async";
import 'package:sip_sales/global/state_management.dart';

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

  void checkPermission(
    BuildContext context,
    SipSalesState state,
  ) async {
    // Note -> this is how to open app settings
    // await AppSettings.openAppSettings();

    if (await serviceRequest()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      GlobalVar.nip = prefs.getString('nip');
      GlobalVar.password = prefs.getString('password');
      attendanceStatus = prefs.getBool('attendanceStatus');
      state.setIsManager(prefs.getInt('isManager'));

      if (GlobalVar.nip != '' && GlobalVar.password != '') {
        GlobalVar.userAccountList.clear();
        GlobalVar.userAccountList.addAll(await GlobalAPI.fetchUserAccount(
          GlobalVar.nip!,
          GlobalVar.password!,
          state.getUUID,
        ));

        if (GlobalVar.userAccountList.isNotEmpty &&
            state.getProfilePicture.isEmpty &&
            state.getProfilePicturePreview.isEmpty) {
          state.setProfilePicture(GlobalVar.userAccountList[0].profilePicture);
          try {
            await GlobalAPI.fetchShowImage(
                    GlobalVar.userAccountList[0].employeeID)
                .then((String highResImg) async {
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
        }
      }

      // Note -> Load Manager and Sales Dropdown value moved to splash screen

      state.setIsDisable(true);
      state.clearState();

      Navigator.pushReplacementNamed(context, '/menu');
    } else {
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
                            onTap: () => checkPermission(
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
                            onTap: () => checkPermission(
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
