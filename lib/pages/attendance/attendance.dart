import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/attendance/attendance_history.dart';
import 'package:sip_sales/pages/attendance/event.dart';
import 'package:sip_sales/pages/map/map.dart';
import 'package:sip_sales/widget/data/sales_dashboard.dart';
import 'package:sip_sales/widget/date/custom_digital_clock.dart';
import 'package:sip_sales/widget/dropdown/common_dropdown.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sip_sales/widget/list/absent.dart';
import 'package:sip_sales/widget/status/loading_animation.dart';
import 'package:sip_sales/widget/status/warning_animation.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool isRefresh = false;
  String displayDate = '';

  void setIsRefresh() {
    setState(() {
      isRefresh = !isRefresh;
    });
  }

  void setDisplayDate(String value) {
    displayDate = value;
  }

  Future<bool> serviceRequest() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Is location service enabled: $serviceEnabled');
    if (!serviceEnabled) {
      final permissionType = await Geolocator.requestPermission();
      print('Permission Type: $permissionType');
      if (permissionType == LocationPermission.denied ||
          permissionType == LocationPermission.deniedForever ||
          permissionType == LocationPermission.unableToDetermine) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  void userAbsent({bool isClockIn = false}) async {
    final state = Provider.of<SipSalesState>(context, listen: false);
    state.clearState();

    bool isLocationEnabled = await serviceRequest();
    if (isLocationEnabled) {
      if (mounted) {
        if (isClockIn) {
          if (state.getAbsentType != 'EVENT') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoadingAnimationPage(
                    false, true, false, false, false, false),
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
    } else {
      state.setDisplayDescription(
        'Akses lokasi diperlukan untuk fitur ini. Silakan aktifkan layanan lokasi dan berikan izin di pengaturan aplikasi Anda.',
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WarningAnimationPage(),
          ),
        );
      }
    }
  }

  Future<void> getUserAttendanceHistory(
    SipSalesState state, {
    String startDate = '',
    String endDate = '',
    bool isRefresh = false,
  }) async {
    print('Fetch Attendance History');
    if (isRefresh) {
      setIsRefresh();
    } else {
      state.setIsAppFlowLoading();
    }

    try {
      List<ModelAttendanceHistory> temp = [];
      temp.clear();
      temp.addAll(await GlobalAPI.fetchAttendanceHistory(
        await state.readAndWriteUserId(),
        startDate,
        endDate,
      ));

      print('Absent History list length: ${temp.length}');

      setState(() {
        state.absentHistoryList = temp;
      });
    } catch (e) {
      print('Fetch Attendance History failed: ${e.toString()}');
    }

    if (isRefresh) {
      setIsRefresh();
    } else {
      state.setIsAppFlowLoading();
    }
  }

  Future<void> getUserLatestData(SipSalesState state) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await GlobalAPI.fetchUserAccount(
        await state.readAndWriteUserId(),
        await state.readAndWriteUserPass(),
        await state.generateUuid(),
      ).then((res) {
        state.setUserAccountList(res);
      });

      if (state.getUserAccountList.isNotEmpty &&
          state.getProfilePicture.isEmpty &&
          state.getProfilePicturePreview.isEmpty) {
        state.setProfilePicture(state.getUserAccountList[0].profilePicture);
        await GlobalAPI.fetchShowImage(state.getUserAccountList[0].employeeID)
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
      }
    } catch (e) {
      print('Fetch User Latest Data failed: ${e.toString()}');
      state.setProfilePicturePreview('');
      await prefs.setString('highResImage', '');
    }
  }

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
  //       state.setSalesDashboardList(res);
  //     });
  //   } catch (e) {
  //     print('Error: ${e.toString()}');
  //   }
  // }

  Future<void> refreshPage(SipSalesState state) async {
    print('Refresh page');
    try {
      await getUserLatestData(state);
      await getUserAttendanceHistory(state);
      await state.getSalesDashboard();
    } catch (e) {
      print('Refresh Page error: ${e.toString()}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Terjadi kesalahan, mohon coba lagi.',
              style: GlobalFont.bigfontRWhite,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.025,
              vertical: MediaQuery.of(context).size.height * 0.015,
            ),
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

  Widget attendanceBody(SipSalesState state) {
    return Column(
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
                          state.getUserAccountList[0].locationName,
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

        // ~:Sales Dashboard:~
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.22,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.015,
            bottom: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ~:Dashboard Title:~
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Dashboard',
                  style: GlobalFont.giantfontR,
                ),
              ),

              // ~:Divider:~
              SizedBox(height: 10),

              // ~:Dashboard Body:~
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ~:SPK:~
                      SalesDashboard(
                        title: 'SPK',
                        data1: state.getSalesDashboardList[0].qtyLM.toString(),
                        data2: state.getSalesDashboardList[0].qtyTM.toString(),
                        percentage:
                            state.getSalesDashboardList[0].spk.toString(),
                        trendIcon: state.getSalesDashboardList[0].qtyLM <=
                                state.getSalesDashboardList[0].qtyTM
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        trendColor: state.getSalesDashboardList[0].qtyLM <=
                                state.getSalesDashboardList[0].qtyTM
                            ? Colors.green[700]!
                            : Colors.red,
                      ),

                      // ~:Delivery:~
                      SalesDashboard(
                        title: 'Pengiriman',
                        data1:
                            state.getSalesDashboardList[0].qtySJLM.toString(),
                        data2:
                            state.getSalesDashboardList[0].qtySJTM.toString(),
                        percentage:
                            state.getSalesDashboardList[0].delivery.toString(),
                        trendIcon: state.getSalesDashboardList[0].qtySJLM <=
                                state.getSalesDashboardList[0].qtySJTM
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        trendColor: state.getSalesDashboardList[0].qtySJLM <=
                                state.getSalesDashboardList[0].qtySJTM
                            ? Colors.green[700]!
                            : Colors.red,
                      ),

                      // ~:Prospect:~
                      SalesDashboard(
                        title: 'Prospek',
                        data1: state.getSalesDashboardList[0].qtyLTM.toString(),
                        data2: state.getSalesDashboardList[0].qtyPTM.toString(),
                        percentage:
                            state.getSalesDashboardList[0].prospect.toString(),
                        trendIcon: state.getSalesDashboardList[0].qtyLTM <=
                                state.getSalesDashboardList[0].qtyPTM
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        trendColor: state.getSalesDashboardList[0].qtyLTM <=
                                state.getSalesDashboardList[0].qtyPTM
                            ? Colors.green[700]!
                            : Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ~:Attendance List:~
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.015,
            bottom: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            children: [
              // ~:Attendance List Header:~
              SizedBox(
                height: 30,
                child: Row(
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
                          color: Colors.grey,
                          fontFamily: GlobalFontFamily.fontRubik,
                          fontSize: GlobalSize.mediumgiantfont,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ~:Attendance List Content:~
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: state.getUserAccountList.isEmpty
                      ? Alignment.center
                      : Alignment.topCenter,
                  child: Builder(
                    builder: (context) {
                      if (state.getAbsentHistoryList.isEmpty) {
                        return Column(
                          children: [
                            Text('No data available'),
                          ],
                        );
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children:
                              state.getAbsentHistoryList.asMap().entries.map(
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
                                            color: Colors.grey,
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
                      // Note: attendance listview with shimmer loading animation
                      // if (state.getIsAppFlowLoading || isRefresh) {
                      //   return Shimmer.fromColors(
                      //     baseColor: Colors.grey[300]!,
                      //     highlightColor: Colors.white,
                      //     period: const Duration(milliseconds: 1000),
                      //     child: ListView.builder(
                      //       itemCount: 3,
                      //       itemBuilder: (context, index) {
                      //         return Container(
                      //           width: MediaQuery.of(context).size.width,
                      //           height:
                      //               MediaQuery.of(context).size.height * 0.083,
                      //           alignment: Alignment.center,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10.0),
                      //             boxShadow: const [
                      //               BoxShadow(
                      //                 // Adjust shadow color as needed
                      //                 color: Colors.grey,
                      //                 // No shadow offset
                      //                 // Adjust shadow blur radius
                      //                 blurRadius: 5.0,
                      //                 // Adjust shadow spread radius
                      //                 spreadRadius: 1.0,
                      //               ),
                      //             ],
                      //           ),
                      //           margin: EdgeInsets.symmetric(
                      //             vertical: MediaQuery.of(context).size.height *
                      //                 0.005,
                      //             horizontal:
                      //                 MediaQuery.of(context).size.width * 0.01,
                      //           ),
                      //           padding: EdgeInsets.symmetric(
                      //             vertical: MediaQuery.of(context).size.height *
                      //                 0.008,
                      //             horizontal:
                      //                 MediaQuery.of(context).size.width * 0.01,
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   );
                      // } else {

                      // }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
      child: Builder(
        builder: (context) {
          if (Platform.isIOS) {
            return CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () => refreshPage(state),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, _) => attendanceBody(state),
                    childCount: 1,
                  ),
                ),
              ],
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => refreshPage(state),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: attendanceBody(state),
              ),
            );
          }
        },
      ),
    );
  }
}
