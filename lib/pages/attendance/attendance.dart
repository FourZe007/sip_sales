import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/attendance/attendance_history.dart';
import 'package:sip_sales/pages/attendance/event.dart';
import 'package:sip_sales/pages/map/map.dart';
import 'package:sip_sales/widget/date/custom_digital_clock.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sip_sales/widget/dropdown/common_dropdown.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sip_sales/widget/list/absent.dart';
import 'package:sip_sales/widget/status/loading_animation.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool isRefresh = false;
  String displayDate = '';
  String absentType = '';

  void setIsRefresh() {
    setState(() {
      isRefresh = !isRefresh;
    });
  }

  void setDisplayDate(String value) {
    displayDate = value;
  }

  void setAbsentType(String value) {
    setState(() {
      absentType = value;
    });
  }

  void userAbsent({bool isClockIn = false}) {
    final state = Provider.of<SipSalesState>(context, listen: false);
    state.clearState();

    if (isClockIn) {
      if (state.getAbsentType != 'EVENT') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LoadingAnimationPage(false, true, false, false, false, false),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDescPage(),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoadingAnimationPage(false, false, true, false, false, false),
        ),
      );
    }
  }

  Future<void> getHistory(
    SipSalesState state, {
    String startDate = '',
    String endDate = '',
    bool isRefresh = false,
  }) async {
    print('Refresh');
    if (isRefresh) {
      setIsRefresh();
    } else {
      state.setIsAppFlowLoading();
    }

    List<ModelAttendanceHistory> temp = [];
    temp.clear();
    temp.addAll(await GlobalAPI.fetchAttendanceHistory(
      state.getUserAccountList[0].employeeID,
      startDate,
      endDate,
    ));

    print('Absent History list length: ${temp.length}');

    setState(() {
      state.absentHistoryList = temp;
    });

    if (isRefresh) {
      setIsRefresh();
    } else {
      state.setIsAppFlowLoading();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getHistory(
      Provider.of<SipSalesState>(context, listen: false),
      isRefresh: true,
    );
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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.12,
      ),
      child: Column(
        children: [
          // ~:Date and Time:~
          CustomDigitalClock(
            displayDate,
            setDisplayDate,
            false,
            isIpad: (MediaQuery.of(context).size.width < 800) ? false : true,
          ),

          // ~:Attendance Frame:~
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  // Adjust shadow color as needed
                  color: Colors.grey,
                  // No shadow offset
                  // Adjust shadow blur radius
                  blurRadius: 5.0,
                  // Adjust shadow spread radius
                  spreadRadius: 1.0,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.0225,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ~:Attendance Title:~
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  alignment: Alignment.center,
                  child: Text(
                    'Absensi',
                    style: GlobalFont.mediumgigafontRBold,
                  ),
                ),

                // ~:Clock In and Out Section:~
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                    vertical: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: Row(
                    children: [
                      // ~:Absent Type:~
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: CommonDropdown(
                            state.absentType,
                            defaultValue:
                                state.getUserAccountList[0].locationName,
                          ),
                        ),
                      ),

                      // ~:Devider:~
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025,
                      ),

                      // ~:Clock In Button:~
                      Expanded(
                        child: GestureDetector(
                          onTap: () => userAbsent(isClockIn: true),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  // Adjust shadow color as needed
                                  color: Colors.grey,
                                  // No shadow offset
                                  // Adjust shadow blur radius
                                  blurRadius: 5.0,
                                  // Adjust shadow spread radius
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Text(
                              'Clock In',
                              style: GlobalFont.bigfontR,
                            ),
                          ),
                        ),
                      ),
                      // // ~:Devider:~
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.025,
                      // ),
                      // // ~:Clock Out Button:~
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: () => userAbsent(),
                      //     child: Container(
                      //       height:
                      //           MediaQuery.of(context).size.height * 0.05,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(20),
                      //         boxShadow: const [
                      //           BoxShadow(
                      //             // Adjust shadow color as needed
                      //             color: Colors.grey,
                      //             // No shadow offset
                      //             // Adjust shadow blur radius
                      //             blurRadius: 5.0,
                      //             // Adjust shadow spread radius
                      //             spreadRadius: 1.0,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Text(
                      //         'Clock Out',
                      //         style: GlobalFont.bigfontR,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // ~:Current Location Button:~
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                    vertical: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      state.setIsAppFlowLoading();
                      state.openMap(context);
                      state.setIsAppFlowLoading();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            // Adjust shadow color as needed
                            color: Colors.grey,
                            // No shadow offset
                            // Adjust shadow blur radius
                            blurRadius: 5.0,
                            // Adjust shadow spread radius
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Builder(
                        builder: (context) {
                          if (state.getIsAppFlowLoading) {
                            if (Platform.isIOS) {
                              return const CupertinoActivityIndicator(
                                radius: 12.5,
                                color: Colors.black,
                              );
                            } else {
                              return const CircleLoading(
                                warna: Colors.black,
                              );
                            }
                          } else {
                            return Text(
                              'Lokasi Anda',
                              style: GlobalFont.bigfontR,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ~:Attendance List:~
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.365,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Column(
              children: [
                // ~:Attendance List Header:~
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daftar Absensi',
                      style: GlobalFont.giantfontR,
                    ),
                    GestureDetector(
                      onTap: () {
                        state.clearState();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AttendanceHistoryPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Lihat log',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.65),
                          fontFamily: GlobalFontFamily.fontRubik,
                          fontSize: GlobalSize.mediumgiantfont,
                        ),
                      ),
                    ),
                  ],
                ),

                // ~:Devider:~
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.007,
                ),

                // ~:Attendance List Content:~
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: state.getUserAccountList.isEmpty
                        ? Alignment.center
                        : Alignment.topCenter,
                    child: RefreshIndicator(
                      onRefresh: () => getHistory(state),
                      child: Builder(
                        builder: (context) {
                          if (state.getIsAppFlowLoading || isRefresh) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.white,
                              period: const Duration(milliseconds: 1000),
                              child: ListView.builder(
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.083,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          // Adjust shadow color as needed
                                          color: Colors.grey,
                                          // No shadow offset
                                          // Adjust shadow blur radius
                                          blurRadius: 5.0,
                                          // Adjust shadow spread radius
                                          spreadRadius: 1.0,
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.008,
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            if (state.getAbsentHistoryList.isEmpty) {
                              return SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    Text('No data available'),
                                  ],
                                ),
                              );
                            } else {
                              return ListView(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                children: state.getAbsentHistoryList
                                    .asMap()
                                    .entries
                                    .map(
                                  (e) {
                                    final index = e.key;
                                    final data = e.value;

                                    if (index < 3) {
                                      return Column(
                                        children: [
                                          AbsentList.type4(
                                            context,
                                            state,
                                            data.checkIn,
                                            data.date,
                                          ),
                                          Builder(
                                            builder: (context) {
                                              if (index != 2) {
                                                return Divider(
                                                  color: Colors.black
                                                      .withOpacity(0.65),
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ).toList(),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
