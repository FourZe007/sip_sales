// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/activity/manager_activity.dart';
import 'package:sip_sales/pages/attendance/attendance.dart';
import 'package:sip_sales/pages/location/manager_new_activity.dart';
import 'package:sip_sales/pages/profile/profile.dart';
import 'package:upgrader/upgrader.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;
  String title = '';
  String displayDate = ''; // date for UI/UX display
  String date = ''; // date for store in database

  bool isInserted = false;

  final List<Widget> salesWidgetOptions = <Widget>[
    const AttendancePage(),
    // const AttendanceHistoryPage(),
    // const ActivityRoutePage(),
    // const SalesNewActivityPage(),
    // const SalesActivityPage(),
  ];

  // Note -> keep this for future use, but temporarily disable it
  final List<Widget> managerWidgetOptions = <Widget>[
    const ManagerNewActivityPage(),
    ManagerActivityPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  Future<int> getIsManager() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('isManager')!;
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
      future: getIsManager(),
      builder: (context, snapshot) {
        if (snapshot.data == 0) {
          print('isManager: true');
          return UpgradeAlert(
            showIgnore: false,
            showLater: false,
            dialogStyle: (Platform.isIOS)
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            child: PopScope(
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
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.025,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.025,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: InkWell(
                                onTap: openProfile,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 20.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Column(
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
                                                overflow: TextOverflow.ellipsis,
                                                style: GlobalFont
                                                    .mediumgigafontRBold,
                                              );
                                            } else {
                                              return Text(
                                                'GUEST',
                                                overflow: TextOverflow.ellipsis,
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ManagerActivityPage(isInserted: isInserted),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          print('isManager: false');
          return ShowCaseWidget(
            onFinish: () async {
              // final SharedPreferences prefs = await SharedPreferences.getInstance();
              // await prefs.setBool('isShowCaseCompleted', false);
            },
            builder: (context) {
              // ~:For Future Development:~
              // WidgetsBinding.instance.addPostFrameCallback((_) async {
              //   final SharedPreferences prefs =
              //       await SharedPreferences.getInstance();
              //   if (prefs.getBool('isShowCaseCompleted') ?? false) {
              //     ShowCaseWidget.of(context).startShowCase([
              //       menuState.profileShowcaseKey,
              //       menuState.dateTimeShowcaseKey,
              //       menuState.absentShowcaseKey,
              //       menuState.logShowcaseKey,
              //       menuState.latestLogShowcaseKey,
              //     ]);
              //   }
              // });

              return UpgradeAlert(
                showIgnore: false,
                showLater: false,
                dialogStyle: (Platform.isIOS)
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
                child: PopScope(
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
                    body: Container(
                      color: Colors.blue,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          // ~:Header Section:~
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.025,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.025,
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
                                  // ~:Devider:~
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  // ~:User Config:~
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
                                                overflow: TextOverflow.ellipsis,
                                                style: GlobalFont
                                                    .mediumgigafontRBold,
                                              );
                                            } else {
                                              return Text(
                                                'GUEST',
                                                overflow: TextOverflow.ellipsis,
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

                          // ~:Body Section:~
                          salesWidgetOptions[_selectedIndex],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
