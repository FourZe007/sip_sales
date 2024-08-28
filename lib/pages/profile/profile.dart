// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/button/colored_button.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  bool isLoggedOut = false;
  PanelController panelController = PanelController();
  bool isFake = false;
  bool isLocationEnabled = false;

  void logout(Function resetLocationIndex) async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    setState(() {
      isLoading = false;
    });
    resetLocationIndex(0);

    Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
  }

  void toggleLogOutPage() {
    print('Toggle LogOut Page pressed!!');
    setState(() {
      isLoggedOut = !isLoggedOut;
      if (isLoggedOut == true) {
        panelController.open();
      } else {
        panelController.close();
      }
    });
  }

  Future<double> getDeviceWidth() async {
    return MediaQuery.of(context).size.width;
  }

  void toggleLocationSwitch(bool value) {
    setState(() {
      isLocationEnabled = !isLocationEnabled;
    });
  }

  void launchLink(BuildContext context) async {
    Uri url =
        Uri.parse('https://yamaha-jatim.co.id/PrivacyPolicySIPSales.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Custom Alert Dialog for Android and iOS
      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Unable to open the link. Please check the URL and try again.',
          () => Navigator.pop(context),
          'Dismiss',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oops!',
          'Unable to open the link. Please check the URL and try again.',
          () => Navigator.pop(context),
          'Dismiss',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // State Mangement
    final profileState = Provider.of<SipSalesState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        toolbarHeight: (MediaQuery.of(context).size.width < 800)
            ? MediaQuery.of(context).size.height * 0.075
            : MediaQuery.of(context).size.height * 0.075,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Profile',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Profile',
                style: GlobalFont.terafontRBold,
              ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
            color: Colors.black,
          ),
        ),
      ),
      body: SlidingUpPanel(
        renderPanelSheet: false,
        backdropEnabled: true,
        minHeight: 0.0,
        maxHeight: (MediaQuery.of(context).size.width < 800)
            ? MediaQuery.of(context).size.height * 0.4
            : MediaQuery.of(context).size.height * 0.35,
        controller: panelController,
        panel: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    topLeft: Radius.circular(25.0),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: IconButton(
                          onPressed: toggleLogOutPage,
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.08,
                      ),
                      child: Wrap(
                        children: [
                          Text(
                            'Apakah anda ingin keluar dari akun ini?',
                            style: GlobalFont.mediumgigafontRBold,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Text(
                            'Pastikan anda mengingat username dan password anda.',
                            style: GlobalFont.bigfontR,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.075,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ColoredButton(
                                toggleLogOutPage,
                                'Cancel',
                              ),
                              ColoredButton(
                                () => logout(profileState.setLocationIndex),
                                'LOG OUT',
                                isCancel: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.2,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    topLeft: Radius.circular(25.0),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: IconButton(
                          onPressed: toggleLogOutPage,
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Apakah anda ingin keluar dari akun ini?',
                            style: GlobalFont.petafontRBold,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            'Pastikan anda mengingat username dan password anda.',
                            style: GlobalFont.mediumgigafontR,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ColoredButton(
                                toggleLogOutPage,
                                'Cancel',
                                isIpad: true,
                              ),
                              ColoredButton(
                                logout,
                                'LOG OUT',
                                isCancel: true,
                                isIpad: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
        body: ListView(
          children: [
            UnconstrainedBox(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.15,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(2.0, 4.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.025,
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.016,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Circle Icon of Person
                    Expanded(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.01,
                          vertical: MediaQuery.of(context).size.height * 0.005,
                        ),
                        child: Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.width * 0.1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // User Data, which contains of name and employee ID
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            GlobalVar.userAccountList[0].employeeName,
                            style: GlobalFont.terafontRBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            GlobalVar.userAccountList[0].employeeID,
                            style: GlobalFont.mediumgiantfontRBold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.025,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height * 0.02,
                          0.0,
                          MediaQuery.of(context).size.height * 0.005,
                          0.0,
                        ),
                        child: Text(
                          'Profile',
                          style: GlobalFont.mediumgiantfontRBold,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.075,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height * 0.02,
                          0.0,
                          MediaQuery.of(context).size.height * 0.005,
                          0.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.work, size: 30.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kantor',
                                  style: GlobalFont.bigfontR,
                                ),
                                Text(
                                  GlobalVar.userAccountList[0].bsName,
                                  style: GlobalFont.giantfontR,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.075,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height * 0.02,
                          0.0,
                          MediaQuery.of(context).size.height * 0.005,
                          0.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.garage, size: 30.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tipe Kantor',
                                  style: GlobalFont.bigfontR,
                                ),
                                Text(
                                  GlobalVar.userAccountList[0].locationName,
                                  style: GlobalFont.giantfontR,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.025,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height * 0.02,
                          0.0,
                          MediaQuery.of(context).size.height * 0.005,
                          0.0,
                        ),
                        child: Text(
                          'Pengaturan',
                          style: GlobalFont.mediumgiantfontRBold,
                        ),
                      ),
                      // Background Location Service Switch Button
                      // Container(
                      //   height: MediaQuery.of(context).size.height * 0.05,
                      //   alignment: Alignment.centerLeft,
                      //   margin: EdgeInsets.only(
                      //     top: MediaQuery.of(context).size.height * 0.01,
                      //     bottom: MediaQuery.of(context).size.height * 0.005,
                      //   ),
                      //   padding: EdgeInsets.fromLTRB(
                      //     MediaQuery.of(context).size.height * 0.02,
                      //     0.0,
                      //     MediaQuery.of(context).size.height * 0.005,
                      //     0.0,
                      //   ),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       const Icon(Icons.location_on, size: 30.0),
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.height * 0.04,
                      //       ),
                      //       Text(
                      //         'Background Location',
                      //         style: GlobalFont.mediumgiantfontR,
                      //       ),
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.2,
                      //       ),
                      //       Switch(
                      //         value: isLocationEnabled,
                      //         onChanged: toggleLocationSwitch,
                      //         activeColor: Colors.blue,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.075,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height * 0.02,
                          0.0,
                          MediaQuery.of(context).size.height * 0.005,
                          0.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_rounded, size: 30.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.04,
                            ),
                            InkWell(
                              onTap: () => launchLink(context),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kebijakan Privasi',
                                      style: GlobalFont.giantfontR,
                                    ),
                                    Text(
                                      'Ketuk untuk membuka',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: Text(
                      'Version 1.0.3',
                      style: GlobalFont.bigfontR,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.015,
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: ElevatedButton(
                      onPressed: toggleLogOutPage,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.95,
                          MediaQuery.of(context).size.height * 0.04,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: Colors.blue[300],
                      ),
                      child: isLoading == true
                          ? Platform.isIOS
                              ? const CupertinoActivityIndicator(
                                  radius: 17.5,
                                  color: Colors.white,
                                )
                              : const CircleLoading(warna: Colors.white)
                          : Text(
                              'LOG OUT',
                              style: GlobalFont.giantfontR,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
