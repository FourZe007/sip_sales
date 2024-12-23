// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sip_sales/global/global.dart';
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
                  elevation: 0.025,
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
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.025,
                        ),
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
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
                                        Text(
                                          GlobalVar.userAccountList.isNotEmpty
                                              ? GlobalVar.userAccountList[0]
                                                  .employeeName
                                              : 'GUEST',
                                          style: GlobalFont.mediumgigafontRBold,
                                        ),
                                        Text(
                                          GlobalVar.userAccountList.isNotEmpty
                                              ? GlobalVar
                                                  .userAccountList[0].employeeID
                                              : 'XXXXX/XXXXXX',
                                          style: GlobalFont.bigfontR,
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
                      elevation: 0.025,
                      shadowColor: Colors.blue,
                    ),
                    // floatingActionButton: Builder(
                    //   builder: (context) {
                    //     return FloatingActionButton(
                    //       onPressed: () {
                    //         Scaffold.of(context).openDrawer();
                    //       },
                    //       backgroundColor: Colors.blue[200],
                    //       child: const Icon(
                    //         Icons.menu_rounded,
                    //         size: 30.0,
                    //         color: Colors.black,
                    //       ),
                    //     );
                    //   },
                    // ),
                    // drawer: AnnotatedRegion<SystemUiOverlayStyle>(
                    //   value: const SystemUiOverlayStyle(
                    //     statusBarColor: Colors.transparent,
                    //   ),
                    //   child: Drawer(
                    //     width: MediaQuery.of(context).size.width * 0.8,
                    //     shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.only(
                    //         topRight: Radius.circular(20.0),
                    //         bottomRight: Radius.circular(20.0),
                    //       ),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Theme(
                    //           data: Theme.of(context).copyWith(
                    //             dividerTheme: const DividerThemeData(
                    //               color: Colors.transparent,
                    //             ),
                    //           ),
                    //           child: DrawerHeader(
                    //             decoration: BoxDecoration(
                    //               borderRadius: const BorderRadius.only(
                    //                 bottomLeft: Radius.circular(20.0),
                    //                 bottomRight: Radius.circular(20.0),
                    //               ),
                    //               color: Colors.blue[300],
                    //             ),
                    //             padding: EdgeInsets.symmetric(
                    //               horizontal: MediaQuery.of(context).size.width * 0.025,
                    //             ),
                    //             child: SizedBox(
                    //               width: MediaQuery.of(context).size.width,
                    //               child: Column(
                    //                 children: [
                    //                   Align(
                    //                     alignment: Alignment.centerRight,
                    //                     child: IconButton(
                    //                       onPressed: () => Navigator.pop(context),
                    //                       icon: const Icon(
                    //                         Icons.close_rounded,
                    //                         size: 30.0,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Text(
                    //                     'SIP Sales',
                    //                     style: GlobalFont.gigafontRBold,
                    //                   ),
                    //                   Text(
                    //                     'Drawer',
                    //                     style: GlobalFont.giantfontR,
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         Container(
                    //           margin: EdgeInsets.symmetric(
                    //             horizontal: MediaQuery.of(context).size.width * 0.075,
                    //             vertical: MediaQuery.of(context).size.height * 0.025,
                    //           ),
                    //           child: Wrap(
                    //             children: [
                    //               // Disable for a while to prevent error
                    //               Column(
                    //                 children: [
                    //                   InkWell(
                    //                     onTap: () {
                    //                       // Update the state of the app
                    //                       _onItemTapped(0);
                    //
                    //                       menuState.clearState();
                    //
                    //                       // Then close the drawer
                    //                       Navigator.pop(context);
                    //                     },
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Text(
                    //                           'Attendance',
                    //                           style: GlobalFont.mediumgiantfontM,
                    //                           textAlign: TextAlign.start,
                    //                         ),
                    //                         const Icon(
                    //                           Icons.qr_code_rounded,
                    //                           size: 30,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                         MediaQuery.of(context).size.height * 0.019,
                    //                   ),
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   InkWell(
                    //                     onTap: () {
                    //                       // Update the state of the app
                    //                       _onItemTapped(0);
                    //
                    //                       menuState.clearState();
                    //
                    //                       // Then close the drawer
                    //                       Navigator.pop(context);
                    //                     },
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Text(
                    //                           'Attendance History',
                    //                           style: GlobalFont.mediumgiantfontM,
                    //                           textAlign: TextAlign.start,
                    //                         ),
                    //                         const Icon(
                    //                           Icons.list_alt_rounded,
                    //                           size: 30,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                         MediaQuery.of(context).size.height * 0.019,
                    //                   ),
                    //                 ],
                    //               ),
                    //               // Disable menu for awhile
                    //               // Column(
                    //               //   children: [
                    //               //     InkWell(
                    //               //       onTap: () {
                    //               //         // Update the state of the app
                    //               //         _onItemTapped(1);
                    //               //
                    //               //         menuState.clearState();
                    //               //
                    //               //         // Then close the drawer
                    //               //         Navigator.pop(context);
                    //               //       },
                    //               //       child: Row(
                    //               //         mainAxisAlignment:
                    //               //             MainAxisAlignment.spaceBetween,
                    //               //         children: [
                    //               //           Text(
                    //               //             'Activity Route',
                    //               //             style: GlobalFont.mediumgiantfontM,
                    //               //             textAlign: TextAlign.start,
                    //               //           ),
                    //               //           const Icon(
                    //               //             Icons.alt_route_rounded,
                    //               //             size: 30,
                    //               //           ),
                    //               //         ],
                    //               //       ),
                    //               //     ),
                    //               //     SizedBox(
                    //               //       height:
                    //               //           MediaQuery.of(context).size.height * 0.019,
                    //               //     ),
                    //               //   ],
                    //               // ),
                    //               // Column(
                    //               //   children: [
                    //               //     InkWell(
                    //               //       onTap: () {
                    //               //         // Update the state of the app
                    //               //         _onItemTapped(2);
                    //               //
                    //               //         menuState.clearState();
                    //               //
                    //               //         // Then close the drawer
                    //               //         Navigator.pop(context);
                    //               //       },
                    //               //       child: Row(
                    //               //         mainAxisAlignment:
                    //               //             MainAxisAlignment.spaceBetween,
                    //               //         children: [
                    //               //           Text(
                    //               //             'Insert Activity',
                    //               //             style: GlobalFont.mediumgiantfontM,
                    //               //             textAlign: TextAlign.start,
                    //               //           ),
                    //               //           const Icon(
                    //               //             // Icons.event_note_rounded,
                    //               //             Icons.people_alt_rounded,
                    //               //             size: 30,
                    //               //           ),
                    //               //         ],
                    //               //       ),
                    //               //     ),
                    //               //     SizedBox(
                    //               //       height:
                    //               //            MediaQuery.of(context).size.height * 0.019,
                    //               //     ),
                    //               //   ],
                    //               // ),
                    //               // Column(
                    //               //   children: [
                    //               //     InkWell(
                    //               //       onTap: () {
                    //               //         // Update the state of the app
                    //               //         _onItemTapped(3);
                    //               //
                    //               //         menuState.clearState();
                    //               //
                    //               //         // Then close the drawer
                    //               //         Navigator.pop(context);
                    //               //       },
                    //               //       child: Row(
                    //               //         mainAxisAlignment:
                    //               //             MainAxisAlignment.spaceBetween,
                    //               //         children: [
                    //               //           Text(
                    //               //             'View Activities',
                    //               //             style: GlobalFont.mediumgiantfontM,
                    //               //             textAlign: TextAlign.start,
                    //               //           ),
                    //               //           const Icon(
                    //               //             Icons.event_note_rounded,
                    //               //             size: 30,
                    //               //           ),
                    //               //         ],
                    //               //       ),
                    //               //     ),
                    //               //     SizedBox(
                    //               //       height:
                    //               //           MediaQuery.of(context).size.height * 0.019,
                    //               //     ),
                    //               //   ],
                    //               // ),
                    //               // Manager Drawer
                    //               // (menuState.getIsManager == 0)
                    //               //     ? Column(
                    //               //         children: [
                    //               //           InkWell(
                    //               //             onTap: () {
                    //               //               // Update the state of the app
                    //               //               _onItemTapped(0);
                    //               //
                    //               //               menuState.clearState();
                    //               //
                    //               //               // Then close the drawer
                    //               //               Navigator.pop(context);
                    //               //             },
                    //               //             child: Row(
                    //               //               mainAxisAlignment:
                    //               //                   MainAxisAlignment.spaceBetween,
                    //               //               children: [
                    //               //                 Text(
                    //               //                   'Insert Activity',
                    //               //                   style: GlobalFont.mediumgiantfontM,
                    //               //                   textAlign: TextAlign.start,
                    //               //                 ),
                    //               //                 const Icon(
                    //               //                   Icons.person,
                    //               //                   size: 30,
                    //               //                 ),
                    //               //               ],
                    //               //             ),
                    //               //           ),
                    //               //           SizedBox(
                    //               //             height:
                    //               //                 MediaQuery.of(context).size.height *
                    //               //                     0.019,
                    //               //           ),
                    //               //         ],
                    //               //       )
                    //               //     : const SizedBox(),
                    //               // (menuState.getIsManager == 0)
                    //               //     ? Column(
                    //               //         children: [
                    //               //           InkWell(
                    //               //             onTap: () {
                    //               //               // Update the state of the app
                    //               //               _onItemTapped(1);
                    //               //
                    //               //               menuState.clearState();
                    //               //
                    //               //               // Then close the drawer
                    //               //               Navigator.pop(context);
                    //               //             },
                    //               //             child: Row(
                    //               //               mainAxisAlignment:
                    //               //                   MainAxisAlignment.spaceBetween,
                    //               //               children: [
                    //               //                 Text(
                    //               //                   'View Activities',
                    //               //                   style: GlobalFont.mediumgiantfontM,
                    //               //                   textAlign: TextAlign.start,
                    //               //                 ),
                    //               //                 const Icon(
                    //               //                   Icons.event_note_rounded,
                    //               //                   size: 30,
                    //               //                 ),
                    //               //               ],
                    //               //             ),
                    //               //           ),
                    //               //           SizedBox(
                    //               //             height:
                    //               //                 MediaQuery.of(context).size.height *
                    //               //                     0.019,
                    //               //           ),
                    //               //         ],
                    //               //       )
                    //               //     : const SizedBox(),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                                        if (GlobalVar.userAccountList[0]
                                            .profilePicture.isNotEmpty) {
                                          return ClipOval(
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(28),
                                              child: Image.memory(
                                                base64Decode(
                                                  GlobalVar.userAccountList[0]
                                                      .profilePicture,
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
                                            if (GlobalVar
                                                .userAccountList.isNotEmpty) {
                                              return Text(
                                                GlobalVar.userAccountList[0]
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
                                            if (GlobalVar
                                                .userAccountList.isNotEmpty) {
                                              return Text(
                                                GlobalVar.userAccountList[0]
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
