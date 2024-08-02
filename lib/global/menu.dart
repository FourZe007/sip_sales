import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/attendance/attendance.dart';
import 'package:sip_sales/pages/attendance/attendance_history.dart';
import 'package:sip_sales/pages/location/activity_route.dart';
import 'package:sip_sales/pages/location/sales_new_activity.dart';
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

  final List<Widget> _widgetOptions = <Widget>[
    // const AccountPage(),
    const AttendancePage(),
    const AttendanceHistoryPage(),
    const ActivityRoutePage(),
    const SalesNewActivityPage(),
    const ManagerNewActivityPage(),
    // const AccountPage(),
  ];

  void _onItemTapped(int index) {
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
    // Navigator.pushReplacementNamed(context, '/profile');
  }

  Future<double> getDeviceWidth() async {
    return MediaQuery.of(context).size.width;
  }

  // Stream<List<ModelUser>> checkUser() async* {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   GlobalVar.nip = prefs.getString('nip');
  //   GlobalVar.password = prefs.getString('password');
  //
  //   if (GlobalVar.nip != '' && GlobalVar.password != '') {
  //     GlobalVar.userAccountList = await GlobalAPI.fetchUserAccount(
  //       GlobalVar.nip!,
  //       GlobalVar.password!,
  //     );
  //
  //     // if (GlobalVar.userAccountList.isNotEmpty) {
  //     //   print('User Name: ${GlobalVar.userAccountList[0].bsName}');
  //     // } else {
  //     //   print('User Account is empty');
  //     // }
  //
  //     yield GlobalVar.userAccountList;
  //   } else {
  //     yield [];
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = Provider.of<SipSalesState>(context);

    return UpgradeAlert(
      showIgnore: false,
      showLater: false,
      dialogStyle: UpgradeDialogStyle.cupertino,
      child: PopScope(
        canPop: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.blue,
                  toolbarHeight: MediaQuery.of(context).size.height * 0.01,
                  elevation: 0.025,
                  shadowColor: Colors.blue,
                ),
                floatingActionButton: Builder(
                  builder: (context) {
                    return FloatingActionButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      backgroundColor: Colors.blue[200],
                      child: const Icon(
                        Icons.menu_rounded,
                        size: 30.0,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                drawer: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                  child: Drawer(
                    width: MediaQuery.of(context).size.width,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerTheme: const DividerThemeData(
                              color: Colors.transparent,
                            ),
                          ),
                          child: DrawerHeader(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              color: Colors.blue[300],
                            ),
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'SIP Sales',
                                    style: GlobalFont.gigafontRBold,
                                  ),
                                  Text(
                                    'Drawer',
                                    style: GlobalFont.giantfontM,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.075,
                            vertical:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                          child: Wrap(
                            children: [
                              InkWell(
                                onTap: () {
                                  // Update the state of the app
                                  _onItemTapped(0);

                                  menuState.clearState();

                                  // Then close the drawer
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Attendance',
                                      style: GlobalFont.mediumgiantfontM,
                                      textAlign: TextAlign.start,
                                    ),
                                    const Icon(
                                      Icons.qr_code_rounded,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              InkWell(
                                onTap: () {
                                  // Update the state of the app
                                  _onItemTapped(1);

                                  menuState.clearState();

                                  // Then close the drawer
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Attendance History',
                                      style: GlobalFont.mediumgiantfontM,
                                      textAlign: TextAlign.start,
                                    ),
                                    const Icon(
                                      Icons.list_alt_rounded,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              InkWell(
                                onTap: () {
                                  // Update the state of the app
                                  _onItemTapped(2);

                                  menuState.clearState();

                                  // Then close the drawer
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Activity Route',
                                      style: GlobalFont.mediumgiantfontM,
                                      textAlign: TextAlign.start,
                                    ),
                                    const Icon(
                                      Icons.alt_route_rounded,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              (menuState.getIsManager == 1)
                                  ? InkWell(
                                      onTap: () {
                                        // Update the state of the app
                                        _onItemTapped(3);

                                        menuState.clearState();

                                        // Then close the drawer
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Sales Activity',
                                            style: GlobalFont.mediumgiantfontM,
                                            textAlign: TextAlign.start,
                                          ),
                                          const Icon(
                                            // Icons.event_note_rounded,
                                            Icons.people_alt_rounded,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              (menuState.getIsManager == 0)
                                  ? InkWell(
                                      onTap: () {
                                        // Update the state of the app
                                        _onItemTapped(4);

                                        menuState.clearState();

                                        // Then close the drawer
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Shop Manager Activity',
                                            style: GlobalFont.mediumgiantfontM,
                                            textAlign: TextAlign.start,
                                          ),
                                          const Icon(
                                            Icons.person,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                      _widgetOptions[_selectedIndex],
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.blue,
                  toolbarHeight: MediaQuery.of(context).size.height * 0.01,
                  elevation: 0.025,
                  shadowColor: Colors.blue,
                ),
                floatingActionButton: Builder(
                  builder: (context) {
                    return FloatingActionButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      backgroundColor: Colors.blue[200],
                      child: const Icon(
                        Icons.menu_rounded,
                        size: 40.0,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                drawer: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                  child: Drawer(
                    width: MediaQuery.of(context).size.width,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerTheme: const DividerThemeData(
                              color: Colors.transparent,
                            ),
                          ),
                          child: DrawerHeader(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              color: Colors.blue[300],
                            ),
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'SIP Sales',
                                    style: GlobalFont.petafontRBold,
                                  ),
                                  Text(
                                    'Drawer',
                                    style: GlobalFont.terafontR,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.075,
                            vertical:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                          child: Wrap(
                            children: [
                              InkWell(
                                onTap: () {
                                  // Update the state of the app
                                  _onItemTapped(0);
                                  // Then close the drawer
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Attendance',
                                      style: GlobalFont.gigafontR,
                                      textAlign: TextAlign.start,
                                    ),
                                    const Icon(
                                      Icons.qr_code_rounded,
                                      size: 50,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              InkWell(
                                onTap: () {
                                  // Update the state of the app
                                  _onItemTapped(1);
                                  // Then close the drawer
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Attendance History',
                                      style: GlobalFont.gigafontR,
                                      textAlign: TextAlign.start,
                                    ),
                                    const Icon(
                                      Icons.list_alt_rounded,
                                      size: 50,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              InkWell(
                                onTap: () {
                                  // Update the state of the app
                                  _onItemTapped(3);

                                  // Then close the drawer
                                  Navigator.pop(context);

                                  // GlobalFunction.tampilkanDialog(
                                  //   context,
                                  //   true,
                                  //   Container(
                                  //     width: MediaQuery.of(context).size.width *
                                  //         0.5,
                                  //     height:
                                  //         MediaQuery.of(context).size.height *
                                  //             0.25,
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius:
                                  //           BorderRadius.circular(20.0),
                                  //     ),
                                  //     child: Text(
                                  //       'Feature still in development',
                                  //       style: GlobalFont.mediumgiantfontRBold,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Create Activity',
                                      style: GlobalFont.mediumgiantfontM,
                                      textAlign: TextAlign.start,
                                    ),
                                    const Icon(
                                      Icons.event_note_rounded,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
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
                                        size: 30.0,
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
                                          style: GlobalFont.terafontRBold,
                                        ),
                                        Text(
                                          GlobalVar.userAccountList.isNotEmpty
                                              ? GlobalVar
                                                  .userAccountList[0].employeeID
                                              : 'XXXXX/XXXXXX',
                                          style: GlobalFont.mediumgigafontR,
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
                      _widgetOptions[_selectedIndex],
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
