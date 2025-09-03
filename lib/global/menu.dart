// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/dashboard_slidingup_cubit.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_bloc.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_event.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_state.dart';
import 'package:sip_sales/pages/activity/manager_activity.dart';
import 'package:sip_sales/pages/attendance/attendance.dart';
import 'package:sip_sales/pages/location/manager_new_activity.dart';
import 'package:sip_sales/pages/profile/profile.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  // int _selectedIndex = 0;
  String title = '';
  String displayDate = ''; // date for UI/UX display
  String date = ''; // date for store in database

  bool isInserted = false;

  final PanelController slidingPanelController = PanelController();

  // final List<Widget> salesWidgetOptions = <Widget>[
  //   const AttendancePage(),
  //   // const AttendanceHistoryPage(),
  //   // const ActivityRoutePage(),
  //   // const SalesNewActivityPage(),
  //   // const SalesActivityPage(),
  // ];

  // Note -> keep this for future use, but temporarily disable it
  final List<Widget> managerWidgetOptions = <Widget>[
    const ManagerNewActivityPage(),
    ManagerActivityPage(),
  ];

  // void onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  Future<double> getDeviceWidth() async {
    return MediaQuery.of(context).size.width;
  }

  Future<int> getIsManager(SipSalesState state) async {
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getInt('isManager')!;
    return state.getUserAccountList[0].code;
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

    return FutureBuilder(
      future: getIsManager(state),
      builder: (context, snapshot) {
        // ~:Shop Head:~
        if (snapshot.data == 0) {
          log('Shop Head');
          return PopScope(
            canPop: false,
            child: SafeArea(
              top: false,
              bottom: false,
              maintainBottomViewPadding: true,
              child: SlidingUpPanel(
                controller: slidingPanelController,
                backdropEnabled: true,
                backdropColor: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20.0),
                minHeight: 0.0,
                maxHeight: 150,
                defaultPanelState: PanelState.CLOSED,
                onPanelClosed: () =>
                    context.read<DashboardSlidingUpCubit>().closePanel(),
                panel: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ~:Header:~
                        Column(
                          spacing: 8,
                          children: [
                            // ~:Title:~
                            Text(
                              'Peringatan!',
                              style: GlobalFont.bigfontR.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            // ~:Description:~
                            Text(
                              'Apakah anda yakin ingin menghapus aktivitas ini?',
                              style: GlobalFont.bigfontR.copyWith(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        // ~:Buttons:~
                        Row(
                          spacing: 12,
                          children: [
                            // ~:Cancel Button:~
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => slidingPanelController.close(),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: Colors.blue,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Batal',
                                  style: GlobalFont.bigfontR,
                                ),
                              ),
                            ),

                            // ~:Delete Button:~
                            Expanded(
                              child: BlocConsumer<SMActivitiesDashboardBloc,
                                  SMActivitiesDashboardState>(
                                listener: (context, state) {
                                  if (state is SMActivitiesDashboardDeleted) {
                                    log('Deleted');
                                    context
                                        .read<DashboardSlidingUpCubit>()
                                        .closePanel();

                                    Fluttertoast.showToast(
                                      msg: 'Laporan berhasil dihapus!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey[300],
                                      textColor: Colors.black,
                                      fontSize: 16.0,
                                    );
                                  } else if (state
                                      is SMActivitiesDashboardDeletedFailed) {
                                    log('Failed');
                                    Fluttertoast.showToast(
                                      msg: state.message,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey[300],
                                      textColor: Colors.black,
                                      fontSize: 16.0,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is SMActivitiesDashboardSaved) {
                                    return ElevatedButton(
                                      onPressed: () => context
                                          .read<SMActivitiesDashboardBloc>()
                                          .add(
                                            DeleteSMActivitiesDashboard(
                                              employeeID: state.employeeID,
                                              activityID: state.activityID,
                                              date: DateTime.now()
                                                  .toIso8601String()
                                                  .split('T')[0],
                                            ),
                                          ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: state
                                              is SMActivitiesDashboardLoading
                                          ? Platform.isIOS
                                              ? CupertinoActivityIndicator(
                                                  radius: 8,
                                                  color: Colors.black,
                                                )
                                              : const CircleLoading(
                                                  warna: Colors.black,
                                                  strokeWidth: 4,
                                                )
                                          : Text(
                                              'Hapus',
                                              style: GlobalFont.bigfontRWhite,
                                            ),
                                    );
                                  }
                                  return ElevatedButton(
                                    onPressed: () => context
                                        .read<SMActivitiesDashboardBloc>()
                                        .add(
                                          DeleteSMActivitiesDashboard(
                                            employeeID: '',
                                            activityID: '',
                                            date: '',
                                          ),
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: state is SMActivitiesDashboardLoading
                                        ? Platform.isIOS
                                            ? const CupertinoActivityIndicator(
                                                radius: 12.5,
                                                color: Colors.black,
                                              )
                                            : const CircleLoading(
                                                warna: Colors.black,
                                              )
                                        : Text(
                                            'Hapus',
                                            style: GlobalFont.bigfontRWhite,
                                          ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                body: BlocListener<DashboardSlidingUpCubit,
                    DashboardSlidingUpState>(
                  listener: (context, state) {
                    if (state.type ==
                        DashboardSlidingUpType.deleteManagerActivity) {
                      log('Opening Sliding Up Panel - State: $state');
                      slidingPanelController.open();
                    } else {
                      log('Closing Sliding Up Panel - State: $state');
                      slidingPanelController.close();
                    }
                  },
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.blue,
                      toolbarHeight: MediaQuery.of(context).size.height * 0.01,
                      elevation: 0.0,
                      scrolledUnderElevation: 0.0,
                      shadowColor: Colors.blue,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        isInserted = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ManagerNewActivityPage(),
                              ),
                            ) ??
                            false;
                      },
                      backgroundColor: Colors.blue[200],
                      child: const Icon(
                        Icons.add_rounded,
                        size: 30.0,
                        color: Colors.black,
                      ),
                    ),
                    body: Container(
                      color: Colors.blue,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          // ~:Header Section:~
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 98,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.025,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.025,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: InkWell(
                                onTap: openProfile,
                                child: Row(
                                  spacing: 20,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // ~:Avatar Section:~
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundColor: Colors.white,
                                      child: Builder(
                                        builder: (context) {
                                          if (state.getProfilePicture != '') {
                                            return ClipOval(
                                              child: SizedBox.fromSize(
                                                size: Size.fromRadius(28),
                                                child: Image.memory(
                                                  base64Decode(
                                                    state.getProfilePicture,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const Icon(
                                              Icons.person,
                                              size: 25.0,
                                              color: Colors.black,
                                            );
                                          }
                                        },
                                      ),
                                    ),

                                    // ~:Profile Section:~
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              if (state.getUserAccountList
                                                  .isNotEmpty) {
                                                return Text(
                                                  state.getUserAccountList[0]
                                                      .employeeName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GlobalFont
                                                      .mediumgigafontRBold,
                                                );
                                              } else {
                                                return Text(
                                                  'GUEST',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GlobalFont
                                                      .mediumgigafontRBold,
                                                );
                                              }
                                            },
                                          ),
                                          Builder(
                                            builder: (context) {
                                              if (state.getUserAccountList
                                                  .isNotEmpty) {
                                                return Text(
                                                  state.getUserAccountList[0]
                                                      .employeeID,
                                                  style: GlobalFont.bigfontR,
                                                );
                                              } else {
                                                return Text(
                                                  'XXXXX/XXXXXX',
                                                  style: GlobalFont.bigfontR,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // ~:Body Section:~
                          ManagerActivityPage(isInserted: isInserted),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // ~:Sales:~
        else {
          log('Sales');
          return PopScope(
            canPop: false,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue,
                toolbarHeight: MediaQuery.of(context).size.height * 0.01,
                elevation: 0.0,
                scrolledUnderElevation: 0.0,
                shadowColor: Colors.blue,
              ),
              body: SafeArea(
                maintainBottomViewPadding: true,
                child: Container(
                  color: Colors.blue,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      // ~:Header Section:~
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.025,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.025,
                        ),
                        child: InkWell(
                          onTap: openProfile,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ~:Profile Icon:~
                              CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.white,
                                child: Builder(
                                  builder: (context) {
                                    if (state.getProfilePicture.isNotEmpty &&
                                        state.getProfilePicturePreview
                                            .isNotEmpty) {
                                      return ClipOval(
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(28),
                                          child: Image.memory(
                                            base64Decode(
                                              state.getProfilePicturePreview,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.person,
                                        size: 25.0,
                                        color: Colors.black,
                                      );
                                    }
                                  },
                                ),
                              ),
                              // ~:Devider:~
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              // ~:User Config:~
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (state
                                            .getUserAccountList.isNotEmpty) {
                                          return Text(
                                            state.getUserAccountList[0]
                                                .employeeName,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                GlobalFont.mediumgigafontRBold,
                                          );
                                        } else {
                                          return Text(
                                            'GUEST',
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                GlobalFont.mediumgigafontRBold,
                                          );
                                        }
                                      },
                                    ),
                                    Builder(
                                      builder: (context) {
                                        if (state
                                            .getUserAccountList.isNotEmpty) {
                                          return Text(
                                            state.getUserAccountList[0]
                                                .employeeID,
                                            style: GlobalFont.bigfontR,
                                          );
                                        } else {
                                          return Text(
                                            'XXXXX/XXXXXX',
                                            style: GlobalFont.bigfontR,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ~:Body Section:~
                      Expanded(
                        child: AttendancePage(),
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
  }
}
