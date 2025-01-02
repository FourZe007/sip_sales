// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/button/animated_phone_button.dart';
import 'package:sip_sales/widget/button/animated_tab_button.dart';
import 'package:sip_sales/widget/date/custom_analog_clock.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:intl/intl.dart';

class OldAttendancePage extends StatefulWidget {
  const OldAttendancePage({super.key});

  @override
  State<OldAttendancePage> createState() => _OldAttendancePageState();
}

class _OldAttendancePageState extends State<OldAttendancePage> {
  // Note -> moved to state management
  // GPS Location Detector
  Location location = Location();
  bool locationPermission = false;
  bool isLocationEnable = false;
  double longitude = 0;
  double latitude = 0;

  // Difference Variables with value 2 coordinates and time
  List<ModelWithinRadius> differences = [];
  DateFormat format = DateFormat('HH:mm:ss');

  String displayDate = ''; // date for UI/UX display
  String date = ''; // date for store in database
  String time = '';
  List<ModelResultMessage> checkInList = [];
  List<ModelResultMessage> checkOutList = [];
  bool onProgress = false;
  double radiusInMeters = 10.0;
  bool isWithinRadius = false;

  bool? attendanceStatus = false;

  void backToLocation() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/location');
  }

  Future<bool> requestPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      // print('Permission Denied or Permission Denied Forever');
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted ||
          permissionGranted != PermissionStatus.grantedLimited) {
        // print('Permission Denied');
        return false;
      }
    }

    return true;
  }

  void setDisplayDate(String value) {
    displayDate = value;
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
    // State Management
    final state = Provider.of<SipSalesState>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.12,
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          CustomAnalogClock(
            displayDate,
            setDisplayDate,
            false,
            isIpad: (MediaQuery.of(context).size.width < 800) ? false : true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ~:Check In Button:~
              Builder(
                builder: (context) {
                  if (MediaQuery.of(context).size.width < 800) {
                    return AnimatedPhoneButton(
                      'Check In',
                      () => state.checkIn(context),
                      lebar: MediaQuery.of(context).size.width * 0.3,
                      tinggi: MediaQuery.of(context).size.height * 0.05,
                    );
                  } else {
                    return AnimatedTabButton(
                      'Check In',
                      () => state.checkIn(context),
                      lebar: MediaQuery.of(context).size.width * 0.3,
                      tinggi: MediaQuery.of(context).size.height * 0.05,
                    );
                  }
                },
              ),
              // Devider
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              // ~:Check Out Button:~
              Builder(
                builder: (context) {
                  if (MediaQuery.of(context).size.width < 800) {
                    return AnimatedPhoneButton(
                      'Check Out',
                      () => state.checkOut(context),
                      lebar: MediaQuery.of(context).size.width * 0.3,
                      tinggi: MediaQuery.of(context).size.height * 0.05,
                    );
                  } else {
                    return AnimatedTabButton(
                      'Check Out',
                      () => state.checkOut(context),
                      lebar: MediaQuery.of(context).size.width * 0.3,
                      tinggi: MediaQuery.of(context).size.height * 0.05,
                    );
                  }
                },
              ),
            ],
          ),
          // Devider
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          // ~:Location:~
          Builder(
            builder: (context) {
              if (MediaQuery.of(context).size.width < 800) {
                return AnimatedPhoneButton(
                  'Your Location',
                  () => state.openMap(context),
                  isIcon: true,
                  icon: Icons.location_pin,
                  lebar: MediaQuery.of(context).size.width * 0.5,
                  tinggi: MediaQuery.of(context).size.height * 0.05,
                  isAttendance: false,
                );
              } else {
                return AnimatedTabButton(
                  'Your Location',
                  () => state.openMap(context),
                  isIcon: true,
                  icon: Icons.location_pin,
                  lebar: MediaQuery.of(context).size.width * 0.5,
                  tinggi: MediaQuery.of(context).size.height * 0.05,
                  isAttendance: false,
                );
              }
            },
          ),
          // Devider
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          // ~: Loading Indicator:~
          Builder(
            builder: (context) {
              if (!state.getIsLoadingProgress) {
                return const SizedBox();
              } else {
                return Center(
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          if (Platform.isIOS) {
                            return CupertinoActivityIndicator(
                              radius: 12.5,
                              color: Colors.black,
                            );
                          } else {
                            return const CircleLoading();
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        'Please Wait...',
                        style: GlobalFont.bigfontR,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
